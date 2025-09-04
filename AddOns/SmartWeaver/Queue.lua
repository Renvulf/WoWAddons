local ADDON_NAME, SW = ...
SW.Queue = {items={}}
local Q = SW.Queue
local U = SW.Util

function Q:Add(slot, bag, index)
    self.items[#self.items+1] = {slot=slot,bag=bag,index=index}
    U.log("Queued item slot=%d bag=%s index=%s", slot, tostring(bag), tostring(index))
    self:Process()
end

function Q:Process()
    if #self.items==0 then return end
    if InCombatLockdown() or UnitCastingInfo("player") or UnitChannelInfo("player") then
        U.log("Queue blocked: in combat or casting")
        return
    end
    local item = table.remove(self.items,1)
    U.log("Processing equip for slot %d", item.slot)
    SW.Equip:Equip(item)
    if #self.items>0 then
        C_Timer.After(0.5,function() Q:Process() end)
    end
end

return Q
