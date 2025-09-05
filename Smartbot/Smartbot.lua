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

function Smartbot:OnCombatStart()
    playerGUID = UnitGUID and UnitGUID("player") or nil
    local now = GetTime and GetTime() or 0
    currentSegment = Segment:New(now)
    currentSegment.features = Features.BuildEquippedVector()
end

function Smartbot:OnCombatEnd()
    if currentSegment then
        currentSegment:Finish(GetTime and GetTime() or 0)
        currentSegment = nil
    end
end

function Smartbot:OnCombatLog()
    if not currentSegment then return end
    local timestamp, subevent, _, sourceGUID, _, _, _, destGUID, _, _, _, arg12, _, _, arg15 = CombatLogGetCurrentEventInfo()
    if not sourceGUID then return end
    local petGUID = UnitGUID and UnitGUID("pet") or nil
    local vehicleGUID = UnitGUID and UnitGUID("vehicle") or nil
    if sourceGUID ~= playerGUID and sourceGUID ~= petGUID and sourceGUID ~= vehicleGUID then
        return
    end
    local amount
    local isHeal = false
    if subevent == "SWING_DAMAGE" then
        amount = arg12
    elseif subevent == "RANGE_DAMAGE" or subevent == "SPELL_DAMAGE" or subevent == "SPELL_PERIODIC_DAMAGE" then
        amount = arg15
    elseif subevent == "SPELL_HEAL" or subevent == "SPELL_PERIODIC_HEAL" then
        amount = arg15
        isHeal = true
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
