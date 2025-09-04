-- Smartbot - Features.lua
local F = {}
F.__index = F

-- Map stat tokens from GetItemStats to our feature order
local FEATURE_ORDER = {
    "STR","AGI","INT","STAM",
    "CRIT","HASTE","MASTERY","VERS",
    "LEECH","AVOIDANCE","SPEED",
    "WEAPON_DPS","WEAPON_SPEED",
    "ARMOR","ILVL",
    "AVG_TARGETS",
}

local STATS_MAP = {
    ITEM_MOD_STRENGTH_SHORT = "STR",
    ITEM_MOD_AGILITY_SHORT = "AGI",
    ITEM_MOD_INTELLECT_SHORT = "INT",
    ITEM_MOD_STAMINA_SHORT = "STAM",
    ITEM_MOD_CRIT_RATING_SHORT = "CRIT",
    ITEM_MOD_HASTE_RATING_SHORT = "HASTE",
    ITEM_MOD_MASTERY_RATING_SHORT = "MASTERY",
    ITEM_MOD_VERSATILITY = "VERS",
    ITEM_MOD_LIFESTEAL = "LEECH",
    ITEM_MOD_AVOIDANCE = "AVOIDANCE",
    ITEM_MOD_SPEED = "SPEED",
    -- WEAPON_DPS & WEAPON_SPEED handled separately
    -- ARMOR handled via GetItemStats sum
}

local function zeros(n) local t={} for i=1,n do t[i]=0 end return t end

local function feature_index(name)
    for i,v in ipairs(FEATURE_ORDER) do if v==name then return i end end
end

local function ensure_len(vec)
    local need = #FEATURE_ORDER
    for i=1,need do vec[i] = vec[i] or 0 end
    return vec
end

local function fill_from_stats(vec, stats)
    for token,val in pairs(stats or {}) do
        local key = STATS_MAP[token]
        if key then
            local idx = feature_index(key)
            vec[idx] = (vec[idx] or 0) + (val or 0)
        elseif token == "ITEM_MOD_VERSATILITY_RATING_SHORT" then
            local idx = feature_index("VERS")
            vec[idx] = (vec[idx] or 0) + (val or 0)
        elseif token == "ITEM_MOD_CR_MULTISTRike_SHORT" then
            -- legacy no-op
        elseif token == "ITEM_MOD_ARMOR_SHORT" then
            local idx = feature_index("ARMOR")
            vec[idx] = (vec[idx] or 0) + (val or 0)
        end
    end
end

local function weapon_info_from_stats(stats)
    local dps, speed = 0, 0
    if stats and stats.DAMAGE_PER_SECOND then
        dps = tonumber(stats.DAMAGE_PER_SECOND) or 0
    end
    if stats and stats.ITEM_MOD_WEAPON_SPEED_SHORT then
        speed = tonumber(stats.ITEM_MOD_WEAPON_SPEED_SHORT) or 0
    end
    return dps, speed
end

-- Build a per-equip snapshot feature vector for the currently equipped gear.
function F.BuildEquippedVector()
    local vec = zeros(#FEATURE_ORDER)
    if not GetInventoryItemLink then return ensure_len(vec) end
    for slot=1,19 do
        if slot ~= 4 then -- shirt
            local link = GetInventoryItemLink("player", slot)
            if link and GetItemStats then
                local stats = GetItemStats(link) or {}
                fill_from_stats(vec, stats)
                local dps, speed = weapon_info_from_stats(stats)
                local iDps = feature_index("WEAPON_DPS"); vec[iDps] = (vec[iDps] or 0) + dps
                local iSpd = feature_index("WEAPON_SPEED"); vec[iSpd] = math.max(vec[iSpd] or 0, speed or 0)
                local ilvl = select(4, GetDetailedItemLevelInfo(link)) or 0
                vec[feature_index("ILVL")] = (vec[feature_index("ILVL")] or 0) + ilvl
            end
        end
    end
    return ensure_len(vec)
end

-- Build a feature vector for a specific item link as if equipped (approx).
function F.BuildItemVector(itemLink)
    local vec = zeros(#FEATURE_ORDER)
    if itemLink and GetItemStats then
        local stats = GetItemStats(itemLink) or {}
        fill_from_stats(vec, stats)
        local dps, speed = weapon_info_from_stats(stats)
        vec[feature_index("WEAPON_DPS")] = dps
        vec[feature_index("WEAPON_SPEED")] = speed
        local ilvl = select(4, GetDetailedItemLevelInfo(itemLink)) or 0
        vec[feature_index("ILVL")] = ilvl
    end
    return ensure_len(vec)
end

F.FEATURE_ORDER = FEATURE_ORDER
SmartbotFeatures = F
return F
