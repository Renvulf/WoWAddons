-- Features.lua - gear feature extraction for Smartbot

local Features = {}
Features.FEATURE_ORDER = {
    "INT", "AGI", "STR", "STAM",
    "CRIT", "HASTE", "MASTERY", "VERS",
    "LEECH", "AVOID", "SPEED",
    "WDPS", "WSPEED",
    "ARMOR", "ILVL",
    "AVG_TARGETS",
}

local function statOrZero(stats, key)
    return stats and stats[key] or 0
end

local function weaponStats(link)
    local stats = GetItemStats and GetItemStats(link) or nil
    local dps = statOrZero(stats, "ITEM_MOD_DAMAGE_PER_SECOND_SHORT")
    local speed = statOrZero(stats, "ITEM_MOD_SPEED_SHORT")
    return dps, speed
end

function Features.BuildEquippedVector()
    local vec = {}
    for i=1,#Features.FEATURE_ORDER do vec[i] = 0 end
    for slot=1,17 do
        if slot ~= 4 then
            local link = GetInventoryItemLink and GetInventoryItemLink("player", slot)
            if link then
                local stats = GetItemStats and GetItemStats(link) or {}
                vec[1] = vec[1] + statOrZero(stats, "ITEM_MOD_INTELLECT_SHORT")
                vec[2] = vec[2] + statOrZero(stats, "ITEM_MOD_AGILITY_SHORT")
                vec[3] = vec[3] + statOrZero(stats, "ITEM_MOD_STRENGTH_SHORT")
                vec[4] = vec[4] + statOrZero(stats, "ITEM_MOD_STAMINA_SHORT")
                vec[5] = vec[5] + statOrZero(stats, "ITEM_MOD_CRIT_RATING_SHORT")
                vec[6] = vec[6] + statOrZero(stats, "ITEM_MOD_HASTE_RATING_SHORT")
                vec[7] = vec[7] + statOrZero(stats, "ITEM_MOD_MASTERY_RATING_SHORT")
                vec[8] = vec[8] + statOrZero(stats, "ITEM_MOD_VERSATILITY")
                vec[9] = vec[9] + statOrZero(stats, "ITEM_MOD_CR_LIFESTEAL_SHORT")
                vec[10] = vec[10] + statOrZero(stats, "ITEM_MOD_CR_AVOIDANCE_SHORT")
                vec[11] = vec[11] + statOrZero(stats, "ITEM_MOD_CR_SPEED_SHORT")
                local dps, speed = weaponStats(link)
                vec[12] = vec[12] + dps
                vec[13] = vec[13] + speed
                vec[14] = vec[14] + statOrZero(stats, "ITEM_MOD_ARMOR_SHORT")
                local ilvl = select(4, GetDetailedItemLevelInfo and GetDetailedItemLevelInfo(link)) or 0
                vec[15] = vec[15] + ilvl
            end
        end
    end
    return vec
end

function Features.BuildItemVector(link)
    local stats = GetItemStats and GetItemStats(link) or {}
    local vec = {
        statOrZero(stats, "ITEM_MOD_INTELLECT_SHORT"),
        statOrZero(stats, "ITEM_MOD_AGILITY_SHORT"),
        statOrZero(stats, "ITEM_MOD_STRENGTH_SHORT"),
        statOrZero(stats, "ITEM_MOD_STAMINA_SHORT"),
        statOrZero(stats, "ITEM_MOD_CRIT_RATING_SHORT"),
        statOrZero(stats, "ITEM_MOD_HASTE_RATING_SHORT"),
        statOrZero(stats, "ITEM_MOD_MASTERY_RATING_SHORT"),
        statOrZero(stats, "ITEM_MOD_VERSATILITY"),
        statOrZero(stats, "ITEM_MOD_CR_LIFESTEAL_SHORT"),
        statOrZero(stats, "ITEM_MOD_CR_AVOIDANCE_SHORT"),
        statOrZero(stats, "ITEM_MOD_CR_SPEED_SHORT"),
    }
    local dps, speed = weaponStats(link)
    vec[#vec+1] = dps
    vec[#vec+1] = speed
    vec[#vec+1] = statOrZero(stats, "ITEM_MOD_ARMOR_SHORT")
    vec[#vec+1] = select(4, GetDetailedItemLevelInfo and GetDetailedItemLevelInfo(link)) or 0
    vec[#vec+1] = 0
    return vec
end

SmartbotFeatures = Features
return Features
