local addonName, Smartbot = ...
Smartbot.Tooltip = Smartbot.Tooltip or {}

local function formatDelta(delta)
    if delta > 0 then
        return string.format("|cff00ff00+%.1f|r", delta)
    elseif delta < 0 then
        return string.format("|cffff0000%.1f|r", delta)
    else
        return string.format("%.1f", delta)
    end
end

local function compareScore(itemLink)
    local _, _, _, equipLoc = _G.GetItemInfoInstant(itemLink)
    local slots = Smartbot.Equip.invTypeToSlots[equipLoc]
    if not slots then
        return Smartbot.ItemScore:GetScore(itemLink), 0
    end
    local newScore = Smartbot.ItemScore:GetScore(itemLink)
    local delta
    if equipLoc == 'INVTYPE_FINGER' or equipLoc == 'INVTYPE_TRINKET' then
        for _, slot in ipairs(slots) do
            local current = Smartbot.Equip.GetEquippedScore(slot)
            local d = newScore - current
            if not delta or d > delta then
                delta = d
            end
        end
    elseif equipLoc == 'INVTYPE_2HWEAPON' then
        local current = Smartbot.Equip.GetEquippedScore(slots[1]) + Smartbot.Equip.GetEquippedScore(slots[2])
        delta = newScore - current
    else
        local current = Smartbot.Equip.GetEquippedScore(slots[1])
        delta = newScore - current
    end
    return newScore, delta
end

local function handleTooltip(tooltip, data)
    local itemLink
    if type(data) == 'table' and data.hyperlink then
        itemLink = data.hyperlink
    else
        _, itemLink = tooltip:GetItem()
    end
    if not itemLink or not Smartbot.ItemScore:IsAllowed(itemLink) then return end
    local score, delta = compareScore(itemLink)
    tooltip:AddLine(string.format('Smartbot: %.1f (%s)', score, formatDelta(delta or 0)))
    tooltip:Show()
end

if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType and Enum.TooltipDataType.Item then
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, handleTooltip)
else
    local GameTooltip = _G.GameTooltip
    if GameTooltip and GameTooltip.HookScript and GameTooltip.HasScript and GameTooltip:HasScript('OnTooltipSetItem') then
        GameTooltip:HookScript('OnTooltipSetItem', handleTooltip)
    end
end

return Smartbot.Tooltip
