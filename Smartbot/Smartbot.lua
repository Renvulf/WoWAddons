-- Smartbot: A simple addon to evaluate gear upgrades based on user-defined stat weights.
-- The addon detects the player's specialization and lets users assign stat weights
-- per specialization. It can optionally auto-equip items considered upgrades
-- by scanning the player's bags periodically.

local Smartbot = {}
Smartbot.name = ...

-- List of stats exposed to the user. The keys are tokens returned by GetItemStats.
local STAT_LIST = {
    { label = "Strength",        key = "ITEM_MOD_STRENGTH_SHORT" },
    { label = "Agility",          key = "ITEM_MOD_AGILITY_SHORT" },
    { label = "Intellect",        key = "ITEM_MOD_INTELLECT_SHORT" },
    { label = "Crit",             key = "ITEM_MOD_CRIT_RATING_SHORT" },
    { label = "Haste",            key = "ITEM_MOD_HASTE_RATING_SHORT" },
    { label = "Mastery",          key = "ITEM_MOD_MASTERY_RATING_SHORT" },
    { label = "Versatility",      key = "ITEM_MOD_VERSATILITY" },
    { label = "Stamina",          key = "ITEM_MOD_STAMINA_SHORT" },
}

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
    INVTYPE_WEAPON      = INVSLOT_MAINHAND,
    INVTYPE_WEAPONOFFHAND = INVSLOT_OFFHAND,
    INVTYPE_SHIELD      = INVSLOT_OFFHAND,
}

-- Initializes the SavedVariables table and ensures all defaults are set.
local function InitDB()
    SmartbotDB = SmartbotDB or {}
    SmartbotDB.weights = SmartbotDB.weights or {}
    SmartbotDB.autoEquip = SmartbotDB.autoEquip or false
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
    return SmartbotDB.weights[specID]
end

-- Evaluates an item link and returns a score based on stat weights and item level.
function Smartbot:EvaluateItem(link)
    if not link then return 0 end
    local stats = GetItemStats(link)
    if not stats then return 0 end
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
end

-- Scans the player's bags for potential upgrades based on stat weights.
function Smartbot:ScanBags()
    if not SmartbotDB.autoEquip or InCombatLockdown() then return end
    local weights = GetCurrentWeights()
    if not next(weights) then return end -- no weights set

    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemLink = C_Container.GetContainerItemLink(bag, slot)
            if itemLink and self:CanEquip(itemLink) then
                local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(itemLink)
                local slotInfo = INVTYPE_SLOTS[equipLoc]
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
                        end
                    else
                        local currentLink = GetInventoryItemLink("player", slotInfo)
                        local currentScore = self:EvaluateItem(currentLink)
                        if candidateScore > currentScore then
                            self:EquipItem(bag, slot, slotInfo)
                            print("Smartbot equipped upgrade:", itemLink)
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
        self.ticker = C_Timer.NewTicker(10, function() Smartbot:ScanBags() end)
    end
end

-- Creates the options panel with UI elements for stat weights and auto-equip toggle.
function Smartbot:CreateOptions()
    local panel = CreateFrame("Frame", "SmartbotOptionsPanel", InterfaceOptionsFramePanelContainer)
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

    local last = autoEquip
    panel.editBoxes = {}

    for _, info in ipairs(STAT_LIST) do
        local label = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        label:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -8)
        label:SetText(info.label)

        local box = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
        box:SetAutoFocus(false)
        box:SetWidth(60)
        box:SetHeight(20)
        box:SetPoint("LEFT", label, "RIGHT", 10, 0)
        panel.editBoxes[info.key] = box

        box:SetScript("OnEnterPressed", function(self)
            local num = tonumber(self:GetText()) or 0
            local weights = GetCurrentWeights()
            weights[info.key] = num
            self:ClearFocus()
        end)
        box:SetScript("OnEditFocusLost", box:GetScript("OnEnterPressed"))

        last = label
    end

    panel.refresh = function()
        -- Called when the panel is shown. Populate values for current spec.
        for _, info in ipairs(STAT_LIST) do
            local weights = GetCurrentWeights()
            local val = weights[info.key] or 0
            panel.editBoxes[info.key]:SetText(tostring(val))
        end
        autoEquip:SetChecked(SmartbotDB.autoEquip)
    end

    InterfaceOptions_AddCategory(panel)
end

-- Event handler frame to catch game events.
local eventFrame = CreateFrame("Frame")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and ... == Smartbot.name then
        InitDB()
        Smartbot:CreateOptions()
        Smartbot:UpdateTicker()
    elseif event == "PLAYER_SPECIALIZATION_CHANGED" and ... == "player" then
        -- Refresh UI to show weights for new spec
        if SmartbotOptionsPanel and SmartbotOptionsPanel.refresh then
            SmartbotOptionsPanel.refresh()
        end
    end
end)

-- Register events
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

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
    else
        print("Smartbot commands:")
        print("/sb scan - scan bags now")
        print("/sb auto - toggle auto equip")
        print("Use the Interface Options -> AddOns -> Smartbot panel to set stat weights.")
    end
end

return Smartbot
