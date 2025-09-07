local addonName, Smartbot = ...
Smartbot.Meter = Smartbot.Meter or {}

local fallback = {
    active = false,
    start = 0,
    damage = 0,
    heal = 0,
    last = nil,
    guid = nil,
}

function Smartbot.Meter:GetLastSegmentMetrics()
    local bridge = Smartbot.DetailsBridge
    if bridge and type(bridge.GetPlayerLastSegmentMetrics) == 'function' then
        local ok, metrics = pcall(bridge.GetPlayerLastSegmentMetrics)
        if ok and type(metrics) == 'table' then
            return metrics
        end
    end
    return fallback.last
end

local frame = _G.CreateFrame('Frame')
frame:RegisterEvent('PLAYER_REGEN_DISABLED')
frame:RegisterEvent('PLAYER_REGEN_ENABLED')
frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
frame:SetScript('OnEvent', function(_, event)
    if event == 'PLAYER_REGEN_DISABLED' then
        fallback.active = true
        fallback.start = _G.GetTime()
        fallback.damage = 0
        fallback.heal = 0
        fallback.guid = _G.UnitGUID('player')
        fallback.last = nil
    elseif event == 'PLAYER_REGEN_ENABLED' then
        if fallback.active then
            local elapsed = _G.GetTime() - fallback.start
            if elapsed > 0 then
                fallback.last = { dps = fallback.damage, hps = fallback.heal, duration = elapsed }
            end
        end
        fallback.active = false
    elseif event == 'COMBAT_LOG_EVENT_UNFILTERED' then
        if not fallback.active then return end
        local info = { _G.CombatLogGetCurrentEventInfo() }
        local subevent = info[2]
        local srcGUID = info[4]
        if srcGUID ~= fallback.guid then return end
        if subevent == 'SWING_DAMAGE' then
            fallback.damage = fallback.damage + (info[12] or 0)
        elseif subevent == 'SPELL_DAMAGE' or subevent == 'RANGE_DAMAGE' or subevent == 'SPELL_PERIODIC_DAMAGE' or subevent == 'DAMAGE_SHIELD' or subevent == 'DAMAGE_SPLIT' or subevent == 'ENVIRONMENTAL_DAMAGE' then
            fallback.damage = fallback.damage + (info[15] or 0)
        elseif subevent == 'SPELL_HEAL' or subevent == 'SPELL_PERIODIC_HEAL' then
            fallback.heal = fallback.heal + (info[15] or 0)
        end
    end
end)

return Smartbot.Meter
