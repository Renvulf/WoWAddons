local ADDON_NAME, SW = ...
local C = SW.Const
local U = SW.Util
SW.ItemStats = {}
local IS = SW.ItemStats

local cache = {}

function IS:Invalidate()
    cache = {}
end

local statOrder = {
    C.SECONDARY_STATS.CRIT,
    C.SECONDARY_STATS.HASTE,
    C.SECONDARY_STATS.MASTERY,
    C.SECONDARY_STATS.VERSATILITY,
    C.SECONDARY_STATS.LEECH,
    C.SECONDARY_STATS.AVOIDANCE,
    C.SECONDARY_STATS.SPEED,
}

function IS:Features(link)
    if not link then return end
    if cache[link] then return cache[link] end
    local stats = C_Item.GetItemStats(link) or {}
    local f = {}
    local primary = stats[C.PRIMARY_STATS.STRENGTH] or stats[C.PRIMARY_STATS.AGILITY] or stats[C.PRIMARY_STATS.INTELLECT] or 0
    f[#f+1] = primary
    f[#f+1] = stats[C.PRIMARY_STATS.STAMINA] or 0
    for _,name in ipairs(statOrder) do f[#f+1] = stats[name] or 0 end
    local ilvl = select(1, GetDetailedItemLevelInfo(link)) or 0
    f[#f+1] = ilvl
    cache[link]=f
    return f
end

return IS
