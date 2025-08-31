-- Smartbot: A simple addon to evaluate gear upgrades based on user-defined stat weights.
-- The addon detects the player's specialization and lets users assign stat weights
-- per specialization. It can optionally auto-equip items considered upgrades
-- by scanning the player's bags periodically.

local Smartbot = {}
Smartbot.name = ...

-- Runtime state guarded by event-driven logic. Initialized on ADDON_LOADED.
Smartbot.isScanning = false
Smartbot.equipQueue = {}
Smartbot.equipInFlight = nil -- {slot=slotId, itemID=itemID, link=itemLink, timeout=timerObj}
Smartbot.rescanRequested = false
Smartbot.debounceHandle = nil
Smartbot.failedUpgrades = {}

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
    { label = "Crit",            key = "ITEM_MOD_CRIT_RATING_SHORT",    always = true },
    { label = "Haste",           key = "ITEM_MOD_HASTE_RATING_SHORT",   always = true },
    { label = "Mastery",         key = "ITEM_MOD_MASTERY_RATING_SHORT", always = true },
    { label = "Versatility",     key = "ITEM_MOD_VERSATILITY",          always = true },
    { label = "Stamina",         key = "ITEM_MOD_STAMINA_SHORT",        always = true },
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
    if not IsEquippableItem(link) then return false end

    -- Block too-low character levels
    local reqLevel = select(5, GetItemInfo(link)) or 0
    if UnitLevel("player") < reqLevel then return false end

    -- Must map to a valid equipment slot we handle
    local equipLoc = select(9, GetItemInfo(link))
    if not equipLoc or not INVTYPE_SLOTS[equipLoc] then return false end

    -- Do NOT call IsUsableItem here (it returns false for most gear without a "Use:" effect)
    return true
end

-- Adds Smartbot upgrade information to item tooltips.  When hovering an item the
-- addon compares it against currently equipped gear and appends a coloured line
-- indicating the percentage change in score.  Green means an upgrade, red a
-- downgrade and yellow indicates no change.
local function AddTooltipInfo(tooltip)
    if not tooltip or not tooltip.GetItem then return end
    local _, itemLink = tooltip:GetItem()
    if not itemLink or not Smartbot:CanEquip(itemLink) then return end

    local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(itemLink)
    local slotInfo = equipLoc and INVTYPE_SLOTS[equipLoc] or nil
    if not slotInfo then return end

    local candidateScore = Smartbot:EvaluateItem(itemLink)

    local function calculateChange(invSlot)
        local currentLink = GetInventoryItemLink("player", invSlot)
        local currentScore = Smartbot:EvaluateItem(currentLink)
        if currentScore <= 0 then
            return candidateScore > 0 and 100 or 0
        end
        return (candidateScore - currentScore) / currentScore * 100
    end

    local bestChange
    if type(slotInfo) == "table" then
        for _, invSlot in ipairs(slotInfo) do
            local change = calculateChange(invSlot)
            if not bestChange or change > bestChange then bestChange = change end
        end
    else
        bestChange = calculateChange(slotInfo)
    end

    if not bestChange then return end

    tooltip:AddLine(" ")
    if bestChange > 0 then
        tooltip:AddLine(string.format("|cff00ff00Smartbot: Upgrade (+%.1f%%)|r", bestChange))
    elseif bestChange < 0 then
        tooltip:AddLine(string.format("|cffff0000Smartbot: Downgrade (%.1f%%)|r", bestChange))
    else
        tooltip:AddLine("|cffffff00Smartbot: No change|r")
    end
    tooltip:Show()
end


function Smartbot:AddOrUpdateTooltip(tooltip, itemLink)
    if not tooltip or not itemLink then return end

    -- Ensure item info is cached; if not, repaint once it arrives
    local itemObj = Item:CreateFromItemLink(itemLink)
    if not itemObj:IsItemDataCached() then
        itemObj:ContinueOnItemLoad(function()
            -- Tooltip might have changed; bail if it's gone
            if tooltip and tooltip:IsShown() then
                Smartbot:AddOrUpdateTooltip(tooltip, itemLink)
            end
        end)
        return
    end

    local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(itemLink)
    local slotInfo = equipLoc and INVTYPE_SLOTS[equipLoc] or nil
    if not slotInfo then return end

    local candidateScore = Smartbot:EvaluateItem(itemLink)

    local function pctChange(invSlot)
        local currentLink = GetInventoryItemLink("player", invSlot)
        local currentScore = Smartbot:EvaluateItem(currentLink)
        if currentScore <= 0 then
            return candidateScore > 0 and 100 or 0
        end
        return (candidateScore - currentScore) / currentScore * 100
    end

    local bestChange
    if type(slotInfo) == "table" then
        for _, invSlot in ipairs(slotInfo) do
            local change = pctChange(invSlot)
            if not bestChange or change > bestChange then bestChange = change end
        end
    else
        bestChange = pctChange(slotInfo)
    end
    if not bestChange then return end

    tooltip:AddLine(" ")
    if bestChange > 0 then
        tooltip:AddLine(string.format("|cff00ff00Smartbot: Upgrade (+%.1f%%)|r", bestChange))
    elseif bestChange < 0 then
        tooltip:AddLine(string.format("|cffff0000Smartbot: Downgrade (%.1f%%)|r", bestChange))
    else
        tooltip:AddLine("|cffffff00Smartbot: No change|r")
    end
    tooltip:Show()
end


-- Initializes tooltip hooks in a version-safe manner. Retail removed the
-- OnTooltipSetItem script handler in Dragonflight, requiring TooltipDataProcessor
-- for item tooltips. Classic clients still use the legacy hook.  This function
-- ensures the hook is only added once and only if the relevant API exists.
function Smartbot:InitTooltipHooks()
    if self.tooltipHooked then return end

    if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
        -- Retail: hook via TooltipDataProcessor.
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
            -- Prefer the hyperlink from data, then ID->link, then tooltip:GetItem
            local link = (data and data.hyperlink)
                      or (data and data.id and select(2, GetItemInfo(data.id)))
                      or (tooltip and tooltip.GetItem and select(2, tooltip:GetItem()))
            if link then
                Smartbot:AddOrUpdateTooltip(tooltip, link)
            end
        end)
        self.tooltipHooked = true
    else
        -- Classic-era fallback: use legacy OnTooltipSetItem scripts only if they exist.
        if GameTooltip and GameTooltip.HookScript and GameTooltip.HasScript and GameTooltip:HasScript("OnTooltipSetItem") then
            GameTooltip:HookScript("OnTooltipSetItem", AddTooltipInfo)
        end
        if ItemRefTooltip and ItemRefTooltip.HookScript and ItemRefTooltip.HasScript and ItemRefTooltip:HasScript("OnTooltipSetItem") then
            ItemRefTooltip:HookScript("OnTooltipSetItem", AddTooltipInfo)
        end
        self.tooltipHooked = true
    end
end

-- Schedules a debounced bag scan. Multiple requests within the debounce window
-- coalesce into a single ScanBags call.  If an equip is currently in flight the
-- actual scan is deferred until it completes.
function Smartbot:RequestRescan()
    self.rescanRequested = true
    if not self.debounceHandle then
        self.debounceHandle = C_Timer.NewTimer(0.2, function()
            self.debounceHandle = nil
            if self.rescanRequested and not self.equipInFlight then
                self.rescanRequested = false
                self:ScanBags()
            end
        end)
    end
end

-- Processes the next queued upgrade, equipping one item at a time.  Equip
-- confirmation is handled via PLAYER_EQUIPMENT_CHANGED or a timeout.
function Smartbot:ProcessNextInQueue()
    if self.equipInFlight then return end

    local entry = table.remove(self.equipQueue, 1)
    if not entry then
        -- If more bag changes arrived while equipping, schedule a rescan now.
        if self.rescanRequested then
            self:RequestRescan()
        end
        return
    end

    EquipItemByName(entry.link, entry.targetSlot)

    self.equipInFlight = {
        slot = entry.targetSlot,
        itemID = select(1, GetItemInfoInstant(entry.link)),
        link = entry.link,
    }

    self.equipInFlight.timeout = C_Timer.NewTimer(1.0, function()
        if self.equipInFlight then
            self.failedUpgrades[self.equipInFlight.link] = true
            self.equipInFlight = nil
            self:ProcessNextInQueue()
        end
    end)
end

-- Scans the player's bags for potential upgrades based on stat weights.
function Smartbot:ScanBags(force)
    if (not force and not SmartbotDB.autoEquip)
        or InCombatLockdown()
        or self.isScanning
        or self.equipInFlight ~= nil then
        return
    end

    self.isScanning = true
    self.equipQueue = {}

    local bestBySlot = {}
    local ringCandidates = {}
    local trinketCandidates = {}
    local includeTrinkets = SmartbotDB.includeTrinkets
    local twoHandSelected = false

    self.pendingItemLoad = self.pendingItemLoad or {}

    -- Precompute current scores for ring and trinket slots.
    local currentScores = {}
    currentScores[INVSLOT_FINGER1] = self:EvaluateItem(GetInventoryItemLink("player", INVSLOT_FINGER1))
    currentScores[INVSLOT_FINGER2] = self:EvaluateItem(GetInventoryItemLink("player", INVSLOT_FINGER2))
    currentScores[INVSLOT_TRINKET1] = self:EvaluateItem(GetInventoryItemLink("player", INVSLOT_TRINKET1))
    currentScores[INVSLOT_TRINKET2] = self:EvaluateItem(GetInventoryItemLink("player", INVSLOT_TRINKET2))
    currentScores[INVSLOT_MAINHAND] = self:EvaluateItem(GetInventoryItemLink("player", INVSLOT_MAINHAND))
    currentScores[INVSLOT_OFFHAND] = self:EvaluateItem(GetInventoryItemLink("player", INVSLOT_OFFHAND))

    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemLink = C_Container.GetContainerItemLink(bag, slot)

            local skipItem = false
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.isLocked then
                skipItem = true
            end

            if itemLink then
                if self.failedUpgrades[itemLink] then
                    skipItem = true
                else
                    local name = GetItemInfo(itemLink)
                    if not name then
                        if not self.pendingItemLoad[itemLink] then
                            self.pendingItemLoad[itemLink] = true
                            local obj = Item:CreateFromItemLink(itemLink)
                            obj:ContinueOnItemLoad(function()
                                self.pendingItemLoad[itemLink] = nil
                                Smartbot:RequestRescan()
                            end)
                        end
                        skipItem = true
                    end
                end
            end

            if not skipItem and itemLink and self:CanEquip(itemLink) then
                local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(itemLink)
                local slotInfo = INVTYPE_SLOTS[equipLoc]
                if equipLoc == "INVTYPE_TRINKET" and not includeTrinkets then
                    slotInfo = nil
                end

                if slotInfo then
                    local candidateScore = self:EvaluateItem(itemLink)

                    if type(slotInfo) == "table" then
                        if equipLoc == "INVTYPE_FINGER" then
                            local delta1 = candidateScore - currentScores[INVSLOT_FINGER1]
                            local delta2 = candidateScore - currentScores[INVSLOT_FINGER2]
                            if ringCandidates[INVSLOT_FINGER1] and ringCandidates[INVSLOT_FINGER1].delta >= delta1 then
                                delta1 = -math.huge
                            end
                            if ringCandidates[INVSLOT_FINGER2] and ringCandidates[INVSLOT_FINGER2].delta >= delta2 then
                                delta2 = -math.huge
                            end
                            local targetSlot, delta
                            if delta1 >= delta2 then
                                targetSlot, delta = INVSLOT_FINGER1, delta1
                            else
                                targetSlot, delta = INVSLOT_FINGER2, delta2
                            end
                            if delta > 0 then
                                ringCandidates[targetSlot] = {bag=bag, slot=slot, targetSlot=targetSlot, link=itemLink, delta=delta}
                            end
                        elseif equipLoc == "INVTYPE_TRINKET" then
                            local delta1 = candidateScore - currentScores[INVSLOT_TRINKET1]
                            local delta2 = candidateScore - currentScores[INVSLOT_TRINKET2]
                            if trinketCandidates[INVSLOT_TRINKET1] and trinketCandidates[INVSLOT_TRINKET1].delta >= delta1 then
                                delta1 = -math.huge
                            end
                            if trinketCandidates[INVSLOT_TRINKET2] and trinketCandidates[INVSLOT_TRINKET2].delta >= delta2 then
                                delta2 = -math.huge
                            end
                            local targetSlot, delta
                            if delta1 >= delta2 then
                                targetSlot, delta = INVSLOT_TRINKET1, delta1
                            else
                                targetSlot, delta = INVSLOT_TRINKET2, delta2
                            end
                            if delta > 0 then
                                trinketCandidates[targetSlot] = {bag=bag, slot=slot, targetSlot=targetSlot, link=itemLink, delta=delta}
                            end
                        elseif equipLoc == "INVTYPE_WEAPON" then
                            if not twoHandSelected then
                                for _, invSlot in ipairs(slotInfo) do
                                    local delta = candidateScore - currentScores[invSlot]
                                    if delta > 0 and (not bestBySlot[invSlot] or delta > bestBySlot[invSlot].delta) then
                                        bestBySlot[invSlot] = {bag=bag, slot=slot, targetSlot=invSlot, link=itemLink, delta=delta}
                                    end
                                end
                            end
                        end
                    else
                        if equipLoc == "INVTYPE_2HWEAPON" then
                            local delta = candidateScore - currentScores[INVSLOT_MAINHAND]
                            if delta > 0 then
                                twoHandSelected = true
                                bestBySlot[INVSLOT_MAINHAND] = {bag=bag, slot=slot, targetSlot=slotInfo, link=itemLink, delta=delta}
                                bestBySlot[INVSLOT_OFFHAND] = nil
                            end
                        else
                            if twoHandSelected and (slotInfo == INVSLOT_MAINHAND or slotInfo == INVSLOT_OFFHAND) then
                                -- Ignore one-hand/offhand plans when a 2H is chosen
                            else
                                local currentScore = currentScores[slotInfo]
                                local delta = candidateScore - currentScore
                                if delta > 0 and (not bestBySlot[slotInfo] or delta > bestBySlot[slotInfo].delta) then
                                    bestBySlot[slotInfo] = {bag=bag, slot=slot, targetSlot=slotInfo, link=itemLink, delta=delta}
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    for _, entry in pairs(bestBySlot) do table.insert(self.equipQueue, entry) end
    for _, entry in pairs(ringCandidates) do table.insert(self.equipQueue, entry) end
    for _, entry in pairs(trinketCandidates) do table.insert(self.equipQueue, entry) end

    table.sort(self.equipQueue, function(a,b) return a.delta > b.delta end)

    self.isScanning = false

    self:ProcessNextInQueue()
end

-- Starts or stops the scanning ticker depending on the autoEquip setting.
function Smartbot:UpdateTicker()
    if self.ticker then
        self.ticker:Cancel()
        self.ticker = nil
    end
    if SmartbotDB.autoEquip then
        -- Periodic safety net; actual work is event driven. Throttled to keep
        -- CPU usage minimal.
        self.ticker = C_Timer.NewTicker(2, function() Smartbot:ScanBags() end)
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
        -- Clear any previous anchors (such as those created by StartMoving) to
        -- avoid "anchor family connection" errors when reattaching to the
        -- minimap.  Without this the button could remain anchored to UIParent,
        -- causing SetPoint to fail once dragging stops.
        button:ClearAllPoints()
        button:SetPoint("CENTER", minimap, "CENTER", x, y)
    end
    button.UpdatePosition = UpdatePosition
    UpdatePosition()

    button:SetMovable(true)

    local function OnUpdate(self)
        if self.dragging then
            local minimap = self:GetParent()
            local radius = (minimap:GetWidth() + self:GetWidth()) / 2
            local width = self:GetWidth()
            local x,y = minimap:GetCenter()
            local sc = minimap:GetEffectiveScale()
            local mx,my = GetCursorPosition()
            -- Normalize cursor coordinates by the minimap's scale so dragging
            -- works regardless of UI scale settings.  Use a semicolon to
            -- explicitly separate the two assignments for clarity.
            mx = mx / sc; my = my / sc
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
        self.dragging = true
        self:StartMoving()
    end)
    button:SetScript("OnDragStop", function(self)
        self.dragging = false
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
        -- When "Show all stats" is unchecked we mimic Zygor's behaviour by
        -- showing only statistics appropriate for the player's current class
        -- and specialization.  Unlike the initial version which hid every stat
        -- unless it already had a positive weight, this mirrors Zygor's UI by
        -- always displaying stats tied to the spec's primary attribute while
        -- still allowing secondary/unused stats to remain hidden unless the
        -- user enables "Show all stats".
        local weights = GetCurrentWeights()
        local specIndex = GetSpecialization()
        local primaryStat = specIndex and select(6, GetSpecializationInfo(specIndex)) or nil

        local last = showAllStats
        for _, info in ipairs(STAT_LIST) do
            local label = panel.labels[info.key]
            local box = panel.editBoxes[info.key]

            local show
            if SmartbotDB.showAllStats then
                show = true
            else
                -- When unchecked display stats that apply to the current
                -- specialization's primary attribute or have a user supplied
                -- non-zero weight.  This matches the discrimination used by
                -- Zygor where only relevant stats appear by default but users
                -- can still reveal everything with the checkbox.
                show = (info.always and StatAppliesToPrimary(info.primary, primaryStat))
                    or (info.primary and StatAppliesToPrimary(info.primary, primaryStat))
                    or (weights[info.key] or 0) > 0
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
        Smartbot:InitTooltipHooks()
        Smartbot.failedUpgrades = {}
        Smartbot.isScanning = false
        Smartbot.equipQueue = {}
        Smartbot.equipInFlight = nil
        Smartbot.rescanRequested = false
        Smartbot.debounceHandle = nil
        Smartbot.pendingItemLoad = {}
        Smartbot:RequestRescan()
    elseif event == "PLAYER_SPECIALIZATION_CHANGED" and ... == "player" then
        GetCurrentWeights()
        if SmartbotOptionsPanel and SmartbotOptionsPanel.refresh then
            SmartbotOptionsPanel.refresh()
        end
        Smartbot.failedUpgrades = {}
        Smartbot.equipQueue = {}
        Smartbot.equipInFlight = nil
        Smartbot.pendingItemLoad = {}
        Smartbot:RequestRescan()
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        local slotId = ...
        if Smartbot.equipInFlight and slotId == Smartbot.equipInFlight.slot then
            if Smartbot.equipInFlight.timeout and Smartbot.equipInFlight.timeout.Cancel then
                Smartbot.equipInFlight.timeout:Cancel()
            end
            local haveID = GetInventoryItemID("player", slotId)
            if haveID == Smartbot.equipInFlight.itemID then
                Smartbot.equipInFlight = nil
            else
                Smartbot.failedUpgrades[Smartbot.equipInFlight.link] = true
                Smartbot.equipInFlight = nil
            end
            Smartbot:ProcessNextInQueue()
            if Smartbot.rescanRequested and not Smartbot.debounceHandle and not Smartbot.equipInFlight then
                Smartbot:RequestRescan()
            end
        end
    elseif event == "BAG_UPDATE_DELAYED" then
        if Smartbot.equipInFlight then
            Smartbot.rescanRequested = true
        else
            Smartbot:RequestRescan()
        end
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
        Smartbot:ScanBags(true)
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
