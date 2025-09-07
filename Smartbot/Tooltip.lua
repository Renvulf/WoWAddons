local addonName, Smartbot = ...
Smartbot.Tooltip = Smartbot.Tooltip or {}
Smartbot.Tooltip.health = Smartbot.Tooltip.health or { usesGetItem = false }

local function OnItemTooltip(tooltip, data)
    if not data or data.type ~= Enum.TooltipDataType.Item then return end
    local link
    if data.guid and C_Item and C_Item.GetItemLinkByGUID then
        link = C_Item.GetItemLinkByGUID(data.guid)
    elseif type(data.hyperlink) == 'string' then
        link = data.hyperlink
    elseif data.id then
        link = 'item:' .. tostring(data.id)
    end
    if type(link) ~= 'string' then return end
    if not (string.find(link, '|Hitem:') or string.match(link, '^item:%d+')) then return end
    local score, deltaPct
    if Smartbot.ItemScore and Smartbot.ItemScore.GetScore then
        local ok, s = pcall(Smartbot.ItemScore.GetScore, Smartbot.ItemScore, link)
        if ok then score = s end
        if Smartbot.ItemScore.GetDeltaPct then
            local ok2, d = pcall(Smartbot.ItemScore.GetDeltaPct, Smartbot.ItemScore, link)
            if ok2 then deltaPct = d end
        end
    end
    if not score or score == 0 then return end
    if Smartbot.Tooltip.Append then
        Smartbot.Tooltip.Append(tooltip, score, deltaPct)
    else
        tooltip:AddLine(("Smartbot score: %s%s"):format(tostring(score), deltaPct and ("  (%+0.1f%%)"):format(deltaPct) or ""))
        tooltip:Show()
    end
end

if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType and Enum.TooltipDataType.Item then
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnItemTooltip)
end

return Smartbot.Tooltip

