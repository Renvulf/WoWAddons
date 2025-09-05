-- wow_stubs.lua - minimal WoW API stubs for DevHarness tests

local items = {}
local inventory = {}

-- Register a fake item for testing
function StubItem(id, stats, ilvl, equipLoc)
    items[id] = {stats = stats or {}, ilvl = ilvl or 0, equipLoc = equipLoc}
end

-- Put an item into the fake inventory
function SetInventory(slot, id)
    inventory[slot] = id
end

function GetItemStats(link)
    local item = items[link]
    return item and item.stats or {}
end

function GetDetailedItemLevelInfo(link)
    local item = items[link]
    if item then
        return nil, nil, nil, item.ilvl
    end
end

function GetItemInfo(link)
    local item = items[link]
    if not item then return nil end
    return "Item" .. tostring(link), link, 1, item.ilvl, 0, "", "", 1, item.equipLoc
end

function GetItemInfoInstant(link)
    return link
end

function GetInventoryItemLink(unit, slot)
    return inventory[slot]
end

-- unused but referenced utilities
function select(index, ...)
    local args = {...}
    return args[index]
end

return true
