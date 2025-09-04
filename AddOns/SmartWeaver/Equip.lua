local ADDON_NAME, SW = ...
SW.Equip = {}
local E = SW.Equip

function E:Equip(info)
    if not info or InCombatLockdown() then return end
    if info.bag and info.index then
        C_Container.PickupContainerItem(info.bag, info.index)
        EquipCursorItem(info.slot)
    end
end

return E
