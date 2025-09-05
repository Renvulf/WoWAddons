-- Smartbot.lua - main addon entry

local Smartbot = {}
Smartbot.name = "Smartbot"

local Segment = SmartbotSegment
local Features = SmartbotFeatures
local Model = SmartbotModel

-- forward declarations
local GetCurrentModel
local optionsPanel

-- constants
local MIN_SAMPLES = 20

-- SavedVariables
SmartbotDB = SmartbotDB or {}
SmartbotDB.models = SmartbotDB.models or {}
SmartbotDB.history = SmartbotDB.history or {}
SmartbotDB.settings = SmartbotDB.settings or {}
local defaults = {enabled=true, autoEquip=true, tooltip=true, delta=true, verbose=false}
for k,v in pairs(defaults) do
    if SmartbotDB.settings[k] == nil then SmartbotDB.settings[k] = v end
end
Smartbot.settings = SmartbotDB.settings

function Smartbot:Debug(...)
    if self.settings.verbose then
        print("|cff00ff00Smartbot:|r", ...)
    end
end

local currentSegment
local playerGUID
Smartbot.lastTargets = Smartbot.lastTargets or 1
Smartbot.prevSegment = Smartbot.prevSegment or nil
Smartbot.currentKey = Smartbot.currentKey or nil
Smartbot.equipQueue = Smartbot.equipQueue or {}
Smartbot.pendingScan = Smartbot.pendingScan or false
Smartbot.nextScan = Smartbot.nextScan or 0

local LUST_NAMES = {
    ["Time Warp"] = true,
    ["Bloodlust"] = true,
    ["Heroism"] = true,
    ["Drums of Deathly Ferocity"] = true,
}

local function groupSizeBucket(n)
    if n <= 1 then
        return "solo"
    elseif n <= 5 then
        return "2-5"
    elseif n <= 15 then
        return "6-15"
    else
        return "16+"
    end
end

local function targetBucket(t)
    if t <= 1.4 then
        return "S"
    elseif t <= 2.5 then
        return "C"
    else
        return "A"
    end
end

function Smartbot:BuildContextBucket()
    local instType, _, difficultyID = GetInstanceInfo and GetInstanceInfo() or nil
    local groupSize = GetNumGroupMembers and GetNumGroupMembers() or 1
    local g = groupSizeBucket(groupSize)
    local t = targetBucket(self.lastTargets or 1)
    return table.concat({instType or "world", difficultyID or 0, g, t}, ":")
end

function Smartbot:GetPlayerRole()
    if GetSpecialization and GetSpecializationInfo then
        local spec = GetSpecialization()
        if spec then
            return select(5, GetSpecializationInfo(spec)) or "DAMAGER"
        end
    end
    return "DAMAGER"
end

function Smartbot:MakeModelKey(context)
    local guid = UnitGUID and UnitGUID("player") or "player"
    local specIndex = GetSpecialization and GetSpecialization() or nil
    local specID = 0
    if specIndex and GetSpecializationInfo then
        specID = select(1, GetSpecializationInfo(specIndex)) or 0
    end
    local role = self:GetPlayerRole()
    return table.concat({guid, specID, role, context}, ":")
end

function Smartbot:RefreshOptionsStats()
    if not optionsPanel or not optionsPanel:IsShown() then return end
    local context = self:BuildContextBucket()
    local role = self:GetPlayerRole()
    local model = GetCurrentModel and GetCurrentModel(context)
    local rlsN = model and model.rls and model.rls.n or 0
    local deltaN = model and model.delta and model.delta.n or 0
    local alpha = model and model.alpha or 1
    local rlsMAD = model and model.rls and model.rls.outlier and model.rls.outlier.mad or 0
    local deltaMAD = model and model.delta and model.delta.outlier and model.delta.outlier.mad or 0
    optionsPanel.stats:SetText(string.format(
        "Context: %s\nRole: %s\nRLS n=%d MAD=%.2f\nDelta n=%d MAD=%.2f\nBlend α=%.2f",
        context, role, rlsN, rlsMAD, deltaN, deltaMAD, alpha))
end

function Smartbot:OnCombatStart()
    if not self.settings.enabled then return end
    playerGUID = UnitGUID and UnitGUID("player") or nil
    local now = GetTime and GetTime() or 0
    currentSegment = Segment:New(now)
    currentSegment.features = Features.BuildEquippedVector()
    currentSegment.context = self:BuildContextBucket()
end

function Smartbot:OnCombatEnd()
    if not self.settings.enabled then return end
    if currentSegment then
        currentSegment:Finish(GetTime and GetTime() or 0)
        self.lastTargets = 0.8 * (self.lastTargets or 1) + 0.2 * currentSegment.avgTargets
        local model = GetCurrentModel and GetCurrentModel(currentSegment.context)
        if model and currentSegment.features then
            local role = self:GetPlayerRole()
            local target = role == "HEALER" and currentSegment.hps or currentSegment.dps
            model:Update(currentSegment.features, target, currentSegment.weight)
            if self.prevSegment and self.prevSegment.context == currentSegment.context then
                local prevTarget = role == "HEALER" and self.prevSegment.hps or self.prevSegment.dps
                local dx = {}
                local changed = false
                for i = 1, #currentSegment.features do
                    local v = (currentSegment.features[i] or 0) - (self.prevSegment.features[i] or 0)
                    dx[i] = v
                    if v ~= 0 then changed = true end
                end
                if changed and self.settings.delta then
                    local dy = target - prevTarget
                    model:UpdateDelta(dx, dy)
                end
            end
            if self.currentKey then
                SmartbotDB.models[self.currentKey] = model:Export()
            end
        end
        local summary = {
            context = currentSegment.context,
            features = currentSegment.features,
            dps = currentSegment.dps,
            hps = currentSegment.hps,
        }
        self.prevSegment = summary
        local hist = SmartbotDB.history
        hist[#hist + 1] = summary
        if #hist > 50 then table.remove(hist, 1) end
        currentSegment = nil
    end
    self:RefreshOptionsStats()
    self:EvaluateUpgrades()
    self:ProcessEquipQueue()
end

function Smartbot:OnCombatLog()
    if not self.settings.enabled then return end
    if not currentSegment then return end
    local info = {CombatLogGetCurrentEventInfo()}
    local timestamp = info[1]
    local subevent = info[2]
    local sourceGUID = info[4]
    local destGUID = info[8]

    local petGUID = UnitGUID and UnitGUID("pet") or nil
    local vehicleGUID = UnitGUID and UnitGUID("vehicle") or nil
    if sourceGUID ~= playerGUID and sourceGUID ~= petGUID and sourceGUID ~= vehicleGUID then
        return
    end

    local amount
    local isHeal = false
    if subevent == "SWING_DAMAGE" then
        amount = info[12]
    elseif subevent == "RANGE_DAMAGE" or subevent == "SPELL_DAMAGE" or subevent == "SPELL_PERIODIC_DAMAGE" then
        amount = info[15]
    elseif subevent == "SPELL_HEAL" or subevent == "SPELL_PERIODIC_HEAL" then
        amount = info[15]
        isHeal = true
    elseif subevent == "SPELL_AURA_APPLIED" and destGUID == playerGUID then
        local spellName = info[13]
        if spellName and LUST_NAMES[spellName] then
            currentSegment.lust = true
            currentSegment.weight = 0.25
        end
        return
    else
        return
    end

    if amount and amount > 0 then
        currentSegment:AddEvent(timestamp, destGUID, amount, isHeal)
    end
end

-- scoring helpers
local INVTYPE_TO_SLOTS = {
    INVTYPE_HEAD = {1},
    INVTYPE_NECK = {2},
    INVTYPE_SHOULDER = {3},
    INVTYPE_CLOAK = {15},
    INVTYPE_CHEST = {5},
    INVTYPE_ROBE = {5},
    INVTYPE_WRIST = {9},
    INVTYPE_HAND = {10},
    INVTYPE_WAIST = {6},
    INVTYPE_LEGS = {7},
    INVTYPE_FEET = {8},
    INVTYPE_FINGER = {11, 12},
    INVTYPE_TRINKET = {13, 14},
    INVTYPE_WEAPON = {16, 17},
    INVTYPE_2HWEAPON = {16},
    INVTYPE_WEAPONMAINHAND = {16},
    INVTYPE_WEAPONOFFHAND = {17},
    INVTYPE_SHIELD = {17},
    INVTYPE_HOLDABLE = {17},
    INVTYPE_RANGED = {16},
    INVTYPE_RANGEDRIGHT = {16},
}

local function HeuristicScore(vec, role)
    local prim = (vec[1] or 0) + (vec[2] or 0) + (vec[3] or 0)
    local ilvl = vec[15] or 0
    local stam = vec[4] or 0
    local score = prim + 0.1 * ilvl
    if role == "TANK" then
        score = score + 0.05 * stam
    end
    return score
end

function Smartbot:PredictScore(vec)
    local model = GetCurrentModel and GetCurrentModel()
    local role = self:GetPlayerRole()
    if not model then
        return HeuristicScore(vec, role)
    end
    local samples = model.rls and model.rls.n or 0
    if samples < MIN_SAMPLES then
        return HeuristicScore(vec, role)
    end
    local w = model:Weights()
    local s = 0
    for i = 1, #vec do
        s = s + (w[i] or 0) * vec[i]
    end
    return s
end

function Smartbot:ItemDelta(link)
    local equipLoc = select(9, GetItemInfo(link))
    local slots = equipLoc and INVTYPE_TO_SLOTS[equipLoc] or nil
    if not slots then return end
    local itemVec = Features.BuildItemVector(link)
    local itemScore = self:PredictScore(itemVec)
    local bestDelta
    for _, slot in ipairs(slots) do
        local eqLink = GetInventoryItemLink and GetInventoryItemLink("player", slot) or nil
        local eqScore = 0
        if eqLink then
            local eqVec = Features.BuildItemVector(eqLink)
            eqScore = self:PredictScore(eqVec)
        end
        if equipLoc == "INVTYPE_2HWEAPON" and slot == 16 then
            local off = GetInventoryItemLink and GetInventoryItemLink("player", 17) or nil
            if off then
                local offVec = Features.BuildItemVector(off)
                eqScore = eqScore + self:PredictScore(offVec)
            end
        end
        local delta = itemScore - eqScore
        if not bestDelta or delta > bestDelta then
            bestDelta = delta
        end
    end
    return bestDelta
end

function Smartbot:EvaluateUpgrades()
    if not self.settings.enabled then return end
    if not self.settings.autoEquip then return end
    if InCombatLockdown and InCombatLockdown() then return end
    if GetTime and self.nextScan and GetTime() < self.nextScan then return end
    self.nextScan = GetTime and (GetTime() + 1) or nil
    local best = {}
    local needInfo = false
    for bag = 0, 4 do
        local slots = C_Container and C_Container.GetContainerNumSlots and C_Container.GetContainerNumSlots(bag) or 0
        for slot = 1, slots do
            local link = C_Container and C_Container.GetContainerItemLink and C_Container.GetContainerItemLink(bag, slot) or nil
            if link then
                if not GetItemInfo(link) then
                    needInfo = true
                else
                    local delta = self:ItemDelta(link)
                    if delta and delta > 0 then
                        local equipLoc = select(9, GetItemInfo(link))
                        local slotList = INVTYPE_TO_SLOTS[equipLoc]
                        if slotList then
                            for _, invSlot in ipairs(slotList) do
                                if equipLoc == "INVTYPE_FINGER" or equipLoc == "INVTYPE_TRINKET" then
                                    local other = (invSlot == 11 and 12) or (invSlot == 12 and 11) or (invSlot == 13 and 14) or (invSlot == 14 and 13)
                                    local otherLink = GetInventoryItemLink and GetInventoryItemLink("player", other)
                                    if otherLink and GetItemInfoInstant(otherLink) == GetItemInfoInstant(link) then
                                        goto continue_slot
                                    end
                                end
                                if not best[invSlot] or delta > best[invSlot].delta then
                                    best[invSlot] = { bag = bag, slot = slot, invSlot = invSlot, link = link, delta = delta }
                                end
                                ::continue_slot::
                            end
                        end
                    end
                end
            end
        end
    end
    if needInfo then
        self.pendingScan = true
    end
    self.equipQueue = {}
    for _, v in pairs(best) do
        self.equipQueue[#self.equipQueue + 1] = v
    end
end

function Smartbot:CanEquipNow()
    if InCombatLockdown and InCombatLockdown() then return false end
    if UnitCastingInfo and UnitCastingInfo("player") then return false end
    if UnitChannelInfo and UnitChannelInfo("player") then return false end
    if GetCursorInfo and GetCursorInfo() then return false end
    if GetSpellCooldown then
        local start, dur = GetSpellCooldown(61304)
        if start and dur and dur > 0 then
            local remain = start + dur - (GetTime and GetTime() or 0)
            if remain > 0 then return false end
        end
    end
    return true
end

function Smartbot:ProcessEquipQueue()
    if not self.settings.enabled then return end
    if not self.settings.autoEquip then return end
    if not self.equipQueue or #self.equipQueue == 0 then return end
    if not self:CanEquipNow() then
        if C_Timer and C_Timer.After then
            C_Timer.After(1, function() Smartbot:ProcessEquipQueue() end)
        end
        return
    end
    local item = table.remove(self.equipQueue, 1)
    if item and C_Container and C_Container.PickupContainerItem and EquipCursorItem then
        C_Container.PickupContainerItem(item.bag, item.slot)
        EquipCursorItem(item.invSlot)
    end
    if #self.equipQueue > 0 and C_Timer and C_Timer.After then
        C_Timer.After(0.5, function() Smartbot:ProcessEquipQueue() end)
    end
end

function Smartbot:CreateOptionsPanel()
    if optionsPanel then return end
    optionsPanel = CreateFrame("Frame")
    optionsPanel.name = "Smartbot"
    local title = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Smartbot")

    local y = -40
    local function Check(label, key)
        local cb = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 16, y)
        cb.Text:SetText(label)
        cb:SetChecked(Smartbot.settings[key])
        cb:SetScript("OnClick", function(self) Smartbot.settings[key] = self:GetChecked() end)
        y = y - 30
        return cb
    end
    Check("Enable", "enabled")
    Check("Auto-equip", "autoEquip")
    Check("Tooltip", "tooltip")
    Check("Delta learner", "delta")
    Check("Verbose", "verbose")

    local stats = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    stats:SetPoint("TOPLEFT", 16, y - 10)
    stats:SetText("")
    optionsPanel.stats = stats
    optionsPanel:SetScript("OnShow", function() Smartbot:RefreshOptionsStats() end)

    if InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(optionsPanel)
    end

    SLASH_SMARTBOT1 = "/smartbot"
    SlashCmdList.SMARTBOT = function()
        Smartbot:CreateOptionsPanel()
        if Settings and Settings.OpenToCategory then
            Settings.OpenToCategory(optionsPanel)
        elseif InterfaceOptionsFrame_OpenToCategory then
            InterfaceOptionsFrame_OpenToCategory(optionsPanel)
            InterfaceOptionsFrame_OpenToCategory(optionsPanel)
        end
    end
end

-- event frame
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_REGEN_DISABLED" then
        Smartbot:OnCombatStart()
    elseif event == "PLAYER_REGEN_ENABLED" then
        Smartbot:OnCombatEnd()
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        Smartbot:OnCombatLog()
    elseif event == "GET_ITEM_INFO_RECEIVED" and Smartbot.pendingScan then
        Smartbot.pendingScan = false
        Smartbot:EvaluateUpgrades()
        Smartbot:ProcessEquipQueue()
    elseif event == "ADDON_LOADED" then
        local addon = ...
        if addon == Smartbot.name then
            Smartbot:CreateOptionsPanel()
        end
    end
end)

function GetCurrentModel(context)
    context = context or Smartbot:BuildContextBucket()
    local key = Smartbot:MakeModelKey(context)
    Smartbot.currentKey = key
    local data = SmartbotDB.models[key]
    if data then
        Smartbot.model = Model.Import(data)
    else
        Smartbot.model = Model:New()
        SmartbotDB.models[key] = Smartbot.model:Export()
    end
    return Smartbot.model
end

-- tooltip overlay
local function TooltipHook(tooltip)
    if not Smartbot.settings.enabled or not Smartbot.settings.tooltip then return end
    local _, link = tooltip:GetItem()
    if not link then return end
    local model = GetCurrentModel and GetCurrentModel()
    if not model then return end
    local samples = model.rls and model.rls.n or 0
    if samples < MIN_SAMPLES then
        tooltip:AddLine(string.format("Smartbot: training (%d)", samples))
        return
    end
    local delta = Smartbot:ItemDelta(link)
    if not delta then
        tooltip:AddLine("Smartbot: no data")
        return
    end
    local eqLink = select(2, tooltip:GetItem())
    local baseVec = Features.BuildItemVector(eqLink)
    local base = Smartbot:PredictScore(baseVec)
    local denom = math.abs(base)
    if denom < 1e-9 then denom = 1 end
    local pct = (delta / denom) * 100
    local role = Smartbot:GetPlayerRole()
    local label = role == "HEALER" and "HPS" or "DPS"
    tooltip:AddLine(string.format("Smartbot: %+0.1f%% est. (%s)", pct, label))
end

if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall then
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, TooltipHook)
end

_G.Smartbot = Smartbot
return Smartbot
