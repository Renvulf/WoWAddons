local ADDON_NAME, SW = ...
local C = SW.Const
local U = SW.Util
SW.Events = {}
local E = SW.Events

local f
local combat = {active=false,damage=0,healing=0,start=0,last=0}

function E:Init()
    f = CreateFrame("Frame")
    f:SetScript("OnEvent", function(self,event,...)
        if E[event] then E[event](E, ...) end
    end)
    f:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    f:RegisterEvent("BAG_UPDATE_DELAYED")
    f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    f:RegisterEvent("PLAYER_REGEN_DISABLED")
    f:RegisterEvent("PLAYER_REGEN_ENABLED")
    f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function E:PLAYER_SPECIALIZATION_CHANGED(unit)
    if unit=="player" then SW.Core:SpecRole() end
end

function E:BAG_UPDATE_DELAYED()
    SW.ItemStats:Invalidate()
end

function E:PLAYER_EQUIPMENT_CHANGED()
    SW.ItemStats:Invalidate()
end

function E:PLAYER_REGEN_DISABLED()
    combat.active=true
    combat.start=GetTime()
    combat.damage=0
    combat.healing=0
end

function E:PLAYER_REGEN_ENABLED()
    if combat.active and combat.last>combat.start then
        local dur = combat.last - combat.start
        if dur>10 then
            local dps = combat.damage/dur
            local hps = combat.healing/dur
            SW.Learner:RecordEncounter(dps,hps)
        end
    end
    combat.active=false
    SW.Queue:Process()
end

function E:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, subevent, _, srcGUID, _, _, _, _, _, _, _, ... = CombatLogGetCurrentEventInfo()
    if srcGUID~=UnitGUID("player") then return end
    combat.last=timestamp
    if subevent:find("_DAMAGE") then
        local amount
        if subevent=="SWING_DAMAGE" then amount = select(2, ...) else amount=select(4, ...) end
        combat.damage = combat.damage + (amount or 0)
    elseif subevent=="SPELL_HEAL" or subevent=="SPELL_PERIODIC_HEAL" then
        local amount = select(4, ...)
        combat.healing = combat.healing + (amount or 0)
    end
end

return E
