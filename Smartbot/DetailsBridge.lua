local addonName, Smartbot = ...
Smartbot.DetailsBridge = Smartbot.DetailsBridge or {}

function Smartbot.DetailsBridge.GetPlayerLastSegmentMetrics()
    local Details = _G.Details
    if not Details or type(Details.GetCurrentCombat) ~= 'function' then return nil end
    local okCombat, combat = pcall(Details.GetCurrentCombat, Details)
    if not okCombat or not combat then return nil end
    local duration = combat.GetCombatTime and combat:GetCombatTime()
    if not duration or duration <= 0 then return nil end
    local playerName = _G.UnitName and _G.UnitName('player')
    if not playerName then return nil end
    local dmgAttr = _G.DETAILS_ATTRIBUTE_DAMAGE or 1
    local healAttr = _G.DETAILS_ATTRIBUTE_HEAL or 2
    local okD, damageActor = pcall(combat.GetActor, combat, dmgAttr, playerName)
    local okH, healActor = pcall(combat.GetActor, combat, healAttr, playerName)
    local dps = okD and damageActor and damageActor.total or nil
    local hps = okH and healActor and healActor.total or nil
    return { dps = dps, hps = hps, duration = duration }
end

return Smartbot.DetailsBridge
