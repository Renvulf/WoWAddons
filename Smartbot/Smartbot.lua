-- Smartbot.lua - main addon entry

local Smartbot = {}
Smartbot.name = "Smartbot"

local Segment = SmartbotSegment
local Features = SmartbotFeatures

-- forward declaration
local GetCurrentModel

-- SavedVariables
SmartbotDB = SmartbotDB or {}

local currentSegment
local playerGUID
Smartbot.lastTargets = Smartbot.lastTargets or 1

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
        local model = GetCurrentModel and GetCurrentModel()
        if model and currentSegment.features then
            local role = self:GetPlayerRole()
            local target = role == "HEALER" and currentSegment.hps or currentSegment.dps
            model:Update(currentSegment.features, target, currentSegment.weight)
        end
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

function GetCurrentModel()
    return nil
end

_G.Smartbot = Smartbot
return Smartbot
