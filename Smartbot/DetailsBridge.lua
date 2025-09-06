local addonName, Smartbot = ...
Smartbot.DetailsBridge = Smartbot.DetailsBridge or {}
local Bridge = Smartbot.DetailsBridge

local API = Smartbot.API
local Details = API:Resolve('Details')
local CreateFrame = API:Resolve('CreateFrame') or CreateFrame
local UnitGUID = API:Resolve('UnitGUID') or UnitGUID
local UnitName = API:Resolve('UnitName') or UnitName
local GetTime = API:Resolve('GetTime') or GetTime
local CombatLogGetCurrentEventInfo = API:Resolve('CombatLogGetCurrentEventInfo') or CombatLogGetCurrentEventInfo

local DETAILS_ATTRIBUTE_DAMAGE = API:Resolve('DETAILS_ATTRIBUTE_DAMAGE') or 1
local DETAILS_ATTRIBUTE_HEAL = API:Resolve('DETAILS_ATTRIBUTE_HEAL') or 2

Bridge.fallback = {
    active = false,
    start = 0,
    damage = 0,
    heal = 0,
    lastDps = 0,
    lastHps = 0,
    guid = nil,
}

function Bridge:IsAvailable()
    return Details ~= nil and type(API:Resolve('Details.GetCurrentCombat')) == 'function'
end

local function getDetailsMetrics()
    if not Bridge:IsAvailable() then return nil end
    local GetCurrentCombat = API:Resolve('Details.GetCurrentCombat')
    local combat = GetCurrentCombat and GetCurrentCombat(Details)
    if not combat or type(combat.GetCombatTime) ~= 'function' then return nil end
    local combatTime = combat:GetCombatTime()
    if not combatTime or combatTime <= 0 then return nil end
    local playerName = UnitName and UnitName('player')
    if not playerName then return nil end
    local okD, damageActor = pcall(combat.GetActor, combat, DETAILS_ATTRIBUTE_DAMAGE, playerName)
    local okH, healActor = pcall(combat.GetActor, combat, DETAILS_ATTRIBUTE_HEAL, playerName)
    local dps = (okD and damageActor and damageActor.total) and (damageActor.total / combatTime) or nil
    local hps = (okH and healActor and healActor.total) and (healActor.total / combatTime) or nil
    return dps, hps
end

function Bridge:GetMetrics()
    local dps, hps = getDetailsMetrics()
    if dps or hps then
        return dps, hps
    end
    return Bridge.fallback.lastDps, Bridge.fallback.lastHps
end

local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_REGEN_DISABLED')
frame:RegisterEvent('PLAYER_REGEN_ENABLED')
frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')

frame:SetScript('OnEvent', function(_, event)
    if event == 'PLAYER_REGEN_DISABLED' then
        Bridge.fallback.active = true
        Bridge.fallback.start = GetTime()
        Bridge.fallback.damage = 0
        Bridge.fallback.heal = 0
        Bridge.fallback.lastDps = 0
        Bridge.fallback.lastHps = 0
        Bridge.fallback.guid = UnitGUID and UnitGUID('player')
    elseif event == 'PLAYER_REGEN_ENABLED' then
        if Bridge.fallback.active then
            local elapsed = GetTime() - Bridge.fallback.start
            if elapsed > 0 then
                Bridge.fallback.lastDps = Bridge.fallback.damage / elapsed
                Bridge.fallback.lastHps = Bridge.fallback.heal / elapsed
            end
        end
        Bridge.fallback.active = false
    elseif event == 'COMBAT_LOG_EVENT_UNFILTERED' then
        if not Bridge.fallback.active then return end
        local _, subevent, _, sourceGUID, _, _, _, _, _, _, _, arg12, _, _, arg15 = CombatLogGetCurrentEventInfo()
        if sourceGUID ~= Bridge.fallback.guid then return end
        if subevent == 'SWING_DAMAGE' then
            Bridge.fallback.damage = Bridge.fallback.damage + (arg12 or 0)
        elseif subevent == 'SPELL_DAMAGE' or subevent == 'RANGE_DAMAGE' or subevent == 'SPELL_PERIODIC_DAMAGE' or subevent == 'DAMAGE_SPLIT' or subevent == 'DAMAGE_SHIELD' or subevent == 'ENVIRONMENTAL_DAMAGE' then
            Bridge.fallback.damage = Bridge.fallback.damage + (arg15 or 0)
        elseif subevent == 'SPELL_HEAL' or subevent == 'SPELL_PERIODIC_HEAL' then
            Bridge.fallback.heal = Bridge.fallback.heal + (arg15 or 0)
        end
    end
end)

return Bridge
