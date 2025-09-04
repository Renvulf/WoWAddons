local ADDON_NAME, SW = ...
SW.Queue = {items={}}
local Q = SW.Queue

function Q:Add(slot, bag, index)
    self.items[#self.items+1] = {slot=slot,bag=bag,index=index}
    self:Process()
end

function Q:Process()
    if InCombatLockdown() or UnitCastingInfo("player") or UnitChannelInfo("player") then return end
    if #self.items==0 then return end
    local item = table.remove(self.items,1)
    SW.Equip:Equip(item)
    if #self.items>0 then
        C_Timer.After(0.5,function() Q:Process() end)
    end
end

return Q
