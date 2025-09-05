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

function Smartbot:OnCombatStart()
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

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_DISABLED" then
        Smartbot:OnCombatStart()
    elseif event == "PLAYER_REGEN_ENABLED" then
        Smartbot:OnCombatEnd()
    end
end)

function GetCurrentModel()
    return nil
end

_G.Smartbot = Smartbot
return Smartbot
