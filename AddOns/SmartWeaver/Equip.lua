local ADDON_NAME, SW = ...
SW.Equip = {}
local E = SW.Equip
local U = SW.Util

function E:Equip(info)
    if not info or InCombatLockdown() then
        U.log("Equip skipped")
        return end
    if info.bag and info.index then
        C_Container.PickupContainerItem(info.bag, info.index)
        EquipCursorItem(info.slot)
        U.log("Equipped item from bag %d index %d to slot %d", info.bag, info.index, info.slot)
    end
end

return E
