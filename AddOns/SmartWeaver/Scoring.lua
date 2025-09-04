local ADDON_NAME, SW = ...
local U = SW.Util
SW.Scoring = {}
local S = SW.Scoring

local function dot(a,b)
    local s=0
    for i=1,#a do s=s+a[i]*(b[i] or 0) end
    return s
end

function S:ScoreItem(link)
    local f = SW.ItemStats:Features(link)
    if not f then return end
    local w = SW.Learner:GetWeights()
    return dot(w,f)
end

function S:Delta(slot, link)
    local new = S:ScoreItem(link) or 0
    local curLink = GetInventoryItemLink("player", slot)
    local old = curLink and S:ScoreItem(curLink) or 0
    return new-old
end

function S:FormatDelta(delta)
    local pct = delta
    if pct>=0 then
        return string.format("|cFF00FF00+%.1f|r", pct)
    else
        return string.format("|cFFFF0000%.1f|r", pct)
    end
end

return S
