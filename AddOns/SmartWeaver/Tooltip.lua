local ADDON_NAME, SW = ...
SW.Tooltip = {}
local S = SW.Scoring

local slotMap = {
    INVTYPE_HEAD = "HeadSlot",
    INVTYPE_NECK = "NeckSlot",
    INVTYPE_SHOULDER = "ShoulderSlot",
    INVTYPE_CHEST = "ChestSlot",
    INVTYPE_ROBE = "ChestSlot",
    INVTYPE_WAIST = "WaistSlot",
    INVTYPE_LEGS = "LegsSlot",
    INVTYPE_FEET = "FeetSlot",
    INVTYPE_WRIST = "WristSlot",
    INVTYPE_HAND = "HandsSlot",
    INVTYPE_FINGER = {"Finger0Slot","Finger1Slot"},
    INVTYPE_TRINKET = {"Trinket0Slot","Trinket1Slot"},
    INVTYPE_CLOAK = "BackSlot",
    INVTYPE_WEAPON = {"MainHandSlot","SecondaryHandSlot"},
    INVTYPE_2HWEAPON = "MainHandSlot",
    INVTYPE_WEAPONMAINHAND = "MainHandSlot",
    INVTYPE_WEAPONOFFHAND = "SecondaryHandSlot",
    INVTYPE_HOLDABLE = "SecondaryHandSlot",
    INVTYPE_SHIELD = "SecondaryHandSlot",
}

local function slotsFor(equipLoc)
    return slotMap[equipLoc]
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
    if not SW.db or not SW.db.config.showTooltip then return end
    local link = data and data.hyperlink
    if not link then return end
    local equipLoc = select(9, GetItemInfo(link))
    local slots = slotsFor(equipLoc)
    if not slots then return end
    local delta
    if type(slots)=="table" then
        for _,slotName in ipairs(slots) do
            local slot = GetInventorySlotInfo(slotName)
            local d = S:Delta(slot, link)
            if not delta or d>delta then delta = d end
        end
    else
        local slot = GetInventorySlotInfo(slots)
        delta = S:Delta(slot, link)
    end
    if delta then
        tooltip:AddLine("SmartWeaver: "..S:FormatDelta(delta))
    end
end)

return SW.Tooltip
