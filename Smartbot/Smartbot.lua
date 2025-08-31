-- Smartbot: A simple addon to evaluate gear upgrades based on user-defined stat weights.
-- The addon detects the player's specialization and lets users assign stat weights
-- per specialization. It can optionally auto-equip items considered upgrades
-- by scanning the player's bags periodically.

local Smartbot = {}
Smartbot.name = ...

-- API references with fallbacks for different game versions.
-- In Dragonflight (and later) most item API functions moved under C_Item.
-- Older clients still expose them as globals.  Using locals here avoids
-- repeatedly resolving globals and prevents errors when a function is absent.
local GetItemStatsFunc = C_Item and C_Item.GetItemStats or _G.GetItemStats

--
-- The list below mirrors the stat weighting options exposed by the Zygor
-- addon.  Each entry contains a display label, the token returned by
-- GetItemStats and an optional "primary" spec filter.  The filter may be a
-- single LE_UNIT_STAT_* constant or a table of constants if multiple primary
-- stats should see the value.  Domination sockets are intentionally omitted as
-- they're obsolete in modern content.
local STAT_LIST = {
    { label = "Strength",        key = "ITEM_MOD_STRENGTH_SHORT",       primary = LE_UNIT_STAT_STRENGTH },
    { label = "Agility",         key = "ITEM_MOD_AGILITY_SHORT",        primary = LE_UNIT_STAT_AGILITY },
    { label = "Intellect",       key = "ITEM_MOD_INTELLECT_SHORT",      primary = LE_UNIT_STAT_INTELLECT },
    { label = "Crit",            key = "ITEM_MOD_CRIT_RATING_SHORT" },
    { label = "Haste",           key = "ITEM_MOD_HASTE_RATING_SHORT" },
    { label = "Mastery",         key = "ITEM_MOD_MASTERY_RATING_SHORT" },
    { label = "Versatility",     key = "ITEM_MOD_VERSATILITY" },
    { label = "Stamina",         key = "ITEM_MOD_STAMINA_SHORT" },
    { label = "Armor",           key = "ITEM_MOD_ARMOR_SHORT" },
    { label = "Attack Power",    key = "ITEM_MOD_ATTACK_POWER_SHORT",  primary = {LE_UNIT_STAT_STRENGTH, LE_UNIT_STAT_AGILITY} },
    { label = "Spell Power",     key = "ITEM_MOD_SPELL_POWER_SHORT",   primary = LE_UNIT_STAT_INTELLECT },
    { label = "Life Steal",      key = "ITEM_MOD_LIFESTEAL_RATING_SHORT" },
    { label = "Socket",          key = "EMPTY_SOCKET_PRISMATIC" },
    -- Weapons expose a damage-per-second stat which is important for many
    -- classes.  Zygor allows weighting this so Smartbot offers the same.
    { label = "DPS",             key = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT", primary = {LE_UNIT_STAT_STRENGTH, LE_UNIT_STAT_AGILITY} },
}

-- Helper determining if a stat entry should be shown for the player's
-- current primary stat.  "infoPrimary" may be nil (always show), a single
-- LE_UNIT_STAT_* constant, or a table of such constants.
local function StatAppliesToPrimary(infoPrimary, primaryStat)
    if not infoPrimary or not primaryStat then return true end
    if type(infoPrimary) == "table" then
        for _, stat in ipairs(infoPrimary) do
            if stat == primaryStat then return true end
        end
        return false
    end
    return infoPrimary == primaryStat
end

-- Mapping from equip location to inventory slot IDs.
local INVTYPE_SLOTS = {
    INVTYPE_HEAD        = INVSLOT_HEAD,
    INVTYPE_NECK        = INVSLOT_NECK,
    INVTYPE_SHOULDER    = INVSLOT_SHOULDER,
    INVTYPE_CLOAK       = INVSLOT_BACK,
    INVTYPE_CHEST       = INVSLOT_CHEST,
    INVTYPE_ROBE        = INVSLOT_CHEST,
    INVTYPE_WRIST       = INVSLOT_WRIST,
    INVTYPE_HAND        = INVSLOT_HAND,
    INVTYPE_WAIST       = INVSLOT_WAIST,
    INVTYPE_LEGS        = INVSLOT_LEGS,
    INVTYPE_FEET        = INVSLOT_FEET,
    INVTYPE_FINGER      = {INVSLOT_FINGER1, INVSLOT_FINGER2}, -- multiple slots
    INVTYPE_TRINKET     = {INVSLOT_TRINKET1, INVSLOT_TRINKET2},
    INVTYPE_2HWEAPON    = INVSLOT_MAINHAND,
    INVTYPE_WEAPONMAINHAND = INVSLOT_MAINHAND,
    INVTYPE_WEAPON      = {INVSLOT_MAINHAND, INVSLOT_OFFHAND}, -- one-hand weapon fits either hand
    INVTYPE_WEAPONOFFHAND = INVSLOT_OFFHAND,
    INVTYPE_SHIELD      = INVSLOT_OFFHAND,
    INVTYPE_HOLDABLE    = INVSLOT_OFFHAND,
    INVTYPE_RANGED      = INVSLOT_MAINHAND,
    INVTYPE_RANGEDRIGHT = INVSLOT_MAINHAND,
    INVTYPE_THROWN      = INVSLOT_MAINHAND,
    INVTYPE_BODY        = INVSLOT_BODY,
    INVTYPE_TABARD      = INVSLOT_TABARD,
}

-- Initializes the SavedVariables table and ensures all defaults are set.
local function InitDB()
    SmartbotDB = SmartbotDB or {}
    SmartbotDB.weights = SmartbotDB.weights or {}
    SmartbotDB.autoEquip = SmartbotDB.autoEquip or false
    -- Whether auto-equip logic should consider trinkets.  Disabled by default
    -- because trinkets often have on-use/proc effects that can't be evaluated
    -- purely by stat weights.
    SmartbotDB.includeTrinkets = SmartbotDB.includeTrinkets or false
    -- When true the options panel shows all stats instead of those relevant to
    -- the player's current specialization.
    SmartbotDB.showAllStats = SmartbotDB.showAllStats or false
    -- Saved angle (in degrees) of the minimap button around the minimap's
    -- edge.  45 degrees puts it in the upper-right quadrant.
    SmartbotDB.minimapPos = SmartbotDB.minimapPos or 45
end

-- Returns the current player's specialization ID (nil if not available).
local function GetCurrentSpec()
    local specIndex = GetSpecialization()
    if not specIndex then return nil end
    local specID = GetSpecializationInfo(specIndex)
    return specID
end

-- Retrieves the weight table for the current spec, creating one if necessary.
local function GetCurrentWeights()
    local specID = GetCurrentSpec()
    if not specID then return {} end
    SmartbotDB.weights[specID] = SmartbotDB.weights[specID] or {}
    local weights = SmartbotDB.weights[specID]
    -- Ensure a value exists for every known stat so that tables are persisted
    -- in SavedVariables even if the user leaves some fields empty.
    for _, info in ipairs(STAT_LIST) do
        if weights[info.key] == nil then weights[info.key] = 0 end
    end
    return weights
end

-- Evaluates an item link and returns a score based on stat weights and item level.
function Smartbot:EvaluateItem(link)
    if not link or not GetItemStatsFunc then return 0 end
    local stats = GetItemStatsFunc(link)
    -- GetItemStats returns nil for some toys or invalid links; guard against it.
    if type(stats) ~= "table" then return 0 end
    local weights = GetCurrentWeights()
    local score = (select(4, GetItemInfo(link)) or 0) -- start with item level
    for stat, value in pairs(stats) do
        local weight = weights[stat]
        if weight then
            score = score + value * weight
        end
    end
    return score
end

-- Determines if the player can equip the provided item link.
function Smartbot:CanEquip(link)
    if not link then return false end
    local isEquippable = IsEquippableItem(link)
    if not isEquippable then return false end
    local level = UnitLevel("player")
    local reqLevel = select(5, GetItemInfo(link)) or 0
    if level < reqLevel then return false end
    local isUsable = IsUsableItem(link)
    return isUsable
end

-- Attempts to equip an item from the bags in the given bag and slot positions.
function Smartbot:EquipItem(bag, slot, targetSlot)
    -- Pick up the item and equip it into the target inventory slot.
    C_Container.PickupContainerItem(bag, slot)
    EquipCursorItem(targetSlot)
    -- If for some reason equipping fails the item may remain on the cursor.
    -- Clearing prevents accidental drops when subsequent code interacts with the cursor.
    if CursorHasItem() then ClearCursor() end
end

-- Scans the player's bags for potential upgrades based on stat weights.
function Smartbot:ScanBags()
    if not SmartbotDB.autoEquip or InCombatLockdown() then return end
    -- Even if all weights are zero we still evaluate based on item level so the
    -- addon can function out of the box without requiring manual weights.

    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemLink = C_Container.GetContainerItemLink(bag, slot)
            if itemLink and self:CanEquip(itemLink) then
                local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(itemLink)
                local slotInfo
                -- Optionally ignore trinkets unless the user explicitly allows them.
                if equipLoc == "INVTYPE_TRINKET" and not SmartbotDB.includeTrinkets then
                    slotInfo = nil
                else
                    slotInfo = INVTYPE_SLOTS[equipLoc]
                end
                if slotInfo then
                    local candidateScore = self:EvaluateItem(itemLink)
                    if type(slotInfo) == "table" then
                        -- Items that can go into multiple slots (rings/trinkets).
                        local bestSlot, bestScore = nil, 0
                        for _, invSlot in ipairs(slotInfo) do
                            local currentLink = GetInventoryItemLink("player", invSlot)
                            local currentScore = self:EvaluateItem(currentLink)
                            if candidateScore > currentScore and (not bestSlot or currentScore < bestScore) then
                                bestSlot, bestScore = invSlot, currentScore
                            end
                        end
                        if bestSlot then
                            self:EquipItem(bag, slot, bestSlot)
                            print("Smartbot equipped upgrade:", itemLink)
                            return -- A bag update will rescan remaining items
                        end
                    else
                        local currentLink = GetInventoryItemLink("player", slotInfo)
                        local currentScore = self:EvaluateItem(currentLink)
                        if candidateScore > currentScore then
                            self:EquipItem(bag, slot, slotInfo)
                            print("Smartbot equipped upgrade:", itemLink)
                            return -- stop scanning after equipping one item
                        end
                    end
                end
            end
        end
    end
end

-- Starts or stops the scanning ticker depending on the autoEquip setting.
function Smartbot:UpdateTicker()
    if self.ticker then
        self.ticker:Cancel()
        self.ticker = nil
    end
    if SmartbotDB.autoEquip then
        -- Scan bags once per second as a lightweight safety net. Most upgrades
        -- are caught via BAG_UPDATE events, but this ensures we don't miss any
        -- items the game fails to notify us about while still remaining fast.
        self.ticker = C_Timer.NewTicker(1, function() Smartbot:ScanBags() end)
    end
end

-- Creates a minimap button that opens the options panel when clicked.  The
-- button can be dragged around the minimap and its position is saved between
-- sessions.
function Smartbot:CreateMinimapButton()
    if self.minimapButton then
        -- Button already exists; just ensure it's in the right spot.
        self.minimapButton:UpdatePosition()
        return
    end

    local button = CreateFrame("Button", "SmartbotMinimapButton", Minimap)
    button:SetSize(32, 32)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)
    button:RegisterForClicks("LeftButtonUp")
    button:RegisterForDrag("LeftButton")
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    icon:SetSize(20, 20)
    icon:SetPoint("CENTER")

    button:SetScript("OnClick", function() Smartbot:OpenOptions() end)

    local RADIUS_ADJ = -5

    local function UpdatePosition()
        local angle = SmartbotDB.minimapPos or 45
        local minimap = Minimap
        local radius = (minimap:GetWidth() + button:GetWidth()) / 2 + RADIUS_ADJ
        local x = radius * math.cos(math.rad(angle))
        local y = radius * math.sin(math.rad(angle))
        button:SetPoint("CENTER", minimap, "CENTER", x, y)
    end
    button.UpdatePosition = UpdatePosition
    UpdatePosition()

    button:SetMovable(true)

    local function OnUpdate(self)
        if self:IsDragging() then
            local minimap = self:GetParent()
            local radius = (minimap:GetWidth() + self:GetWidth()) / 2
            local width = self:GetWidth()
            local x,y = minimap:GetCenter()
            local sc = minimap:GetEffectiveScale()
            local mx,my = GetCursorPosition()
            mx = mx/sc  my = my/sc
            local dx,dy = mx-x, my-y
            local dist = (dx*dx+dy*dy)^0.5

            local radmin = radius + RADIUS_ADJ
            local radsnap = radius + width*0.2
            local radpull = radius + width*0.7
            local radfre  = radius + width

            local radclamp
            if dist<=radsnap then self.snapped=true radclamp=radmin
            elseif dist<radpull and self.snapped then radclamp=radmin
            elseif dist<radfre and self.snapped then radclamp=radmin+(dist-radpull)/2
            else self.snapped=false
            end

            if radclamp then
                dx=dx/(dist/radclamp)
                dy=dy/(dist/radclamp)
            end

            self:ClearAllPoints()
            self:SetPoint("CENTER", minimap, "CENTER", dx, dy)

            SmartbotDB.minimapPos = (math.deg(math.atan2(dy, dx)) + 360) % 360
        end
    end
    button:SetScript("OnUpdate", OnUpdate)

    button:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    button:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        UpdatePosition()
    end)

    self.minimapButton = button
end

-- Creates the options panel with UI elements for stat weights and auto-equip toggle.
-- Creates an options panel and registers it with Blizzard's settings system.
-- Retail (Dragonflight+) replaced the old InterfaceOptions API with the new
-- Settings API.  To stay compatible with both versions we try the new API
-- first and fall back to the old calls if available.
function Smartbot:CreateOptions()
    -- Parent is nil so that the panel works with both InterfaceOptions and
    -- the new Settings panel.  A global name allows slash commands to open it.
    local panel = CreateFrame("Frame", "SmartbotOptionsPanel")
    panel.name = "Smartbot"

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Smartbot")

    local autoEquip = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    autoEquip:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
    autoEquip.Text:SetText("Auto equip upgrades")
    autoEquip:SetChecked(SmartbotDB.autoEquip)
    autoEquip:SetScript("OnClick", function(self)
        SmartbotDB.autoEquip = self:GetChecked()
        Smartbot:UpdateTicker()
    end)

    -- Optional checkbox to include trinkets in auto-equip logic.  Many trinkets
    -- have special effects that can't be evaluated from stats alone, so this
    -- is disabled by default and left to user discretion.
    local includeTrinkets = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    includeTrinkets:SetPoint("TOPLEFT", autoEquip, "BOTTOMLEFT", 0, -8)
    includeTrinkets.Text:SetText("Include trinkets")
    includeTrinkets:SetScript("OnClick", function(self)
        SmartbotDB.includeTrinkets = self:GetChecked()
    end)

    -- Checkbox to toggle displaying all stats.  When unchecked only stats
    -- relevant to the player's primary stat are shown, similar to Zygor's UI.
    local showAllStats = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    showAllStats:SetPoint("TOPLEFT", includeTrinkets, "BOTTOMLEFT", 0, -8)
    showAllStats.Text:SetText("Show all stats")
    showAllStats:SetScript("OnClick", function(self)
        SmartbotDB.showAllStats = self:GetChecked()
        panel.refresh()
    end)

    panel.labels = {}
    panel.editBoxes = {}

    -- Create controls for every stat up front.  Their visibility and positions
    -- will be adjusted in panel.refresh based on the player's current spec.
    for _, info in ipairs(STAT_LIST) do
        local label = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        label:SetText(info.label)
        panel.labels[info.key] = label

        local box = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
        box:SetAutoFocus(false)
        box:SetWidth(60)
        box:SetHeight(20)
        panel.editBoxes[info.key] = box

        box:SetScript("OnEnterPressed", function(self)
            local num = tonumber(self:GetText()) or 0
            local weights = GetCurrentWeights()
            weights[info.key] = num
            self:ClearFocus()
        end)
        box:SetScript("OnEditFocusLost", box:GetScript("OnEnterPressed"))
    end

    panel.refresh = function()
        -- Called when the panel is shown.  Populate values for current spec and
        -- hide stats that aren't relevant to the specialization's primary stat.
        -- When "Show all stats" is unchecked we mimic Zygor's behaviour by only
        -- showing stats that currently have a non-zero weight.  This prevents
        -- low priority stats such as Armor or Life Steal from appearing unless
        -- the user explicitly enables them.
        local weights = GetCurrentWeights()
        local specIndex = GetSpecialization()
        local primaryStat = specIndex and select(6, GetSpecializationInfo(specIndex)) or nil

        local last = showAllStats
        for _, info in ipairs(STAT_LIST) do
            local label = panel.labels[info.key]
            local box = panel.editBoxes[info.key]

            local show = SmartbotDB.showAllStats
            if not show then
                -- Only show stats relevant to the current specialization and
                -- with a positive weight.  This mirrors Zygor's options panel
                -- behaviour and prevents zero/negative entries from showing
                -- when "Show all stats" is unchecked.
                show = StatAppliesToPrimary(info.primary, primaryStat) and (weights[info.key] or 0) > 0
            end

            if show then
                label:Show()
                box:Show()
                label:ClearAllPoints()
                label:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -8)
                box:ClearAllPoints()
                box:SetPoint("LEFT", label, "RIGHT", 10, 0)
                last = label

                local val = weights[info.key] or 0
                box:SetText(tostring(val))
            else
                label:Hide()
                box:Hide()
            end
        end

        autoEquip:SetChecked(SmartbotDB.autoEquip)
        includeTrinkets:SetChecked(SmartbotDB.includeTrinkets)
        showAllStats:SetChecked(SmartbotDB.showAllStats)
    end
    panel:SetScript("OnShow", panel.refresh)

    -- Register panel with whichever options system is available.
    if Settings and Settings.RegisterCanvasLayoutCategory then
        local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
        Smartbot.optionsCategoryID = category:GetID()
        Settings.RegisterAddOnCategory(category)
    elseif InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(panel)
    else
        -- If neither API exists, still create the frame so slash commands can
        -- show it via :Show().  This shouldn't happen on Retail but guards
        -- against future API changes.
        panel:Hide()
    end
end

-- Opens the options panel using the appropriate API.
function Smartbot:OpenOptions()
    if self.optionsCategoryID and Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(self.optionsCategoryID)
    elseif InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory("Smartbot")
    elseif SmartbotOptionsPanel then
        -- As a last resort simply show the panel.
        SmartbotOptionsPanel:Show()
    end
end

-- Event handler frame to catch game events.
local eventFrame = CreateFrame("Frame")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and ... == Smartbot.name then
        InitDB()
        GetCurrentWeights() -- ensure tables exist for current spec
        Smartbot:CreateOptions()
        Smartbot:UpdateTicker()
        Smartbot:CreateMinimapButton()
        Smartbot:ScanBags()
    elseif event == "PLAYER_SPECIALIZATION_CHANGED" and ... == "player" then
        -- Refresh UI to show weights for new spec
        GetCurrentWeights()
        if SmartbotOptionsPanel and SmartbotOptionsPanel.refresh then
            SmartbotOptionsPanel.refresh()
        end
        Smartbot:ScanBags()
    elseif event == "PLAYER_EQUIPMENT_CHANGED" or event == "BAG_UPDATE_DELAYED" then
        -- Re-evaluate gear whenever bags or equipped items change.  This keeps
        -- upgrade detection responsive without relying solely on the periodic
        -- ticker.
        Smartbot:ScanBags()
    end
end)

-- Register events
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")

-- Expose slash commands for manual access
SLASH_SMARTBOT1 = "/smartbot"
SLASH_SMARTBOT2 = "/sb"

SlashCmdList["SMARTBOT"] = function(msg)
    msg = msg:lower()
    if msg == "scan" then
        Smartbot:ScanBags()
    elseif msg == "auto" then
        SmartbotDB.autoEquip = not SmartbotDB.autoEquip
        print("Smartbot auto equip:", SmartbotDB.autoEquip and "enabled" or "disabled")
        Smartbot:UpdateTicker()
    elseif msg == "options" or msg == "config" or msg == "" then
        Smartbot:OpenOptions()
    else
        print("Smartbot commands:")
        print("/sb scan - scan bags now")
        print("/sb auto - toggle auto equip")
        print("/sb options - open the options panel")
        print("Use the options panel to set stat weights per specialization.")
    end
end

return Smartbot
