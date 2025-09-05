-- Smartbot.lua - main addon entry

local Smartbot = {}
Smartbot.name = "Smartbot"

local Segment = SmartbotSegment
local Features = SmartbotFeatures
local Model = SmartbotModel

-- forward declaration
local GetCurrentModel

-- constants
local MIN_SAMPLES = 20

-- SavedVariables
SmartbotDB = SmartbotDB or {}
SmartbotDB.models = SmartbotDB.models or {}
SmartbotDB.history = SmartbotDB.history or {}

local currentSegment
local playerGUID
Smartbot.lastTargets = Smartbot.lastTargets or 1
Smartbot.prevSegment = Smartbot.prevSegment or nil
Smartbot.currentKey = Smartbot.currentKey or nil

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

function Smartbot:OnCombatStart()
    playerGUID = UnitGUID and UnitGUID("player") or nil
    local now = GetTime and GetTime() or 0
    currentSegment = Segment:New(now)
    currentSegment.features = Features.BuildEquippedVector()
    currentSegment.context = self:BuildContextBucket()
end

function Smartbot:OnCombatEnd()
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
                if changed then
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
end

function Smartbot:OnCombatLog()
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

function Smartbot:PredictScore(vec)
    local model = GetCurrentModel and GetCurrentModel()
    if not model then return 0 end
    local w = model:Weights()
    local s = 0
    for i = 1, #vec do
        s = s + (w[i] or 0) * vec[i]
    end
    return s
end

function Smartbot:ItemDelta(link)
    local slots = nil
    local equipLoc = select(9, GetItemInfo(link))
    if equipLoc then
        slots = INVTYPE_TO_SLOTS[equipLoc]
    end
    if not slots then return end
    local itemVec = Features.BuildItemVector(link)
    local itemScore = self:PredictScore(itemVec)
    local bestDelta
    local baseScore
    for _, slot in ipairs(slots) do
        local eqLink = GetInventoryItemLink and GetInventoryItemLink("player", slot) or nil
        local eqScore = 0
        if eqLink then
            local eqVec = Features.BuildItemVector(eqLink)
            eqScore = self:PredictScore(eqVec)
        end
        local delta = itemScore - eqScore
        if not bestDelta or delta > bestDelta then
            bestDelta = delta
            baseScore = eqScore
        end
    end
    return bestDelta, baseScore
end

-- event frame
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_DISABLED" then
        Smartbot:OnCombatStart()
    elseif event == "PLAYER_REGEN_ENABLED" then
        Smartbot:OnCombatEnd()
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        Smartbot:OnCombatLog()
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
    local _, link = tooltip:GetItem()
    if not link then return end
    local model = GetCurrentModel and GetCurrentModel()
    if not model then return end
    local samples = model.rls and model.rls.n or 0
    if samples < MIN_SAMPLES then
        tooltip:AddLine(string.format("Smartbot: training (%d)", samples))
        return
    end
    local delta, base = Smartbot:ItemDelta(link)
    if not delta then
        tooltip:AddLine("Smartbot: no data")
        return
    end
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
