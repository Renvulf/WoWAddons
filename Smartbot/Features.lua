local Features = {}

--[[
Sampler retained for diagnostics.  It snapshots live combat ratings and primary
stats which may fluctuate due to temporary buffs.  Learning uses the stable
equipped-item vector from BuildEquippedVector instead.
--]]
local Sampler = {}
Sampler.__index = Sampler

function Sampler:New()
    local o = { samples = 0, sums = {} }
    setmetatable(o, self)
    return o
end

local GetItemStatsFunc = C_Item and C_Item.GetItemStats or _G.GetItemStats

local function PrimaryStat()
    if not GetSpecialization or not GetSpecializationInfo or not UnitStat then return 0 end
    local specIndex = GetSpecialization()
    if not specIndex then return 0 end
    local _, _, _, _, _, primary = GetSpecializationInfo(specIndex)
    if not primary then return 0 end
    local _, stat = UnitStat("player", primary)
    return stat or 0
end

local function RatingSum(a, b, c)
    local GetCombatRating = _G.GetCombatRating
    if not GetCombatRating then return 0 end
    return (GetCombatRating(a or 0) or 0) + (GetCombatRating(b or 0) or 0) + (GetCombatRating(c or 0) or 0)
end

local function WeaponDPS(slot)
    if GetInventoryItemLink and GetItemStatsFunc then
        local link = GetInventoryItemLink("player", slot)
        if link then
            local stats = GetItemStatsFunc(link)
            local dps = stats and stats["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]
            if dps then return dps end
        end
    end
    if UnitDamage and UnitAttackSpeed then
        local speedMain, speedOff = UnitAttackSpeed("player")
        local low, hi, offlow, offhi = UnitDamage("player")
        if slot == (INVSLOT_OFFHAND or 17) then
            if speedOff and offlow and offhi then
                return ((offlow + offhi) / 2) / (speedOff > 0 and speedOff or 1)
            end
        else
            if speedMain and low and hi then
                return ((low + hi) / 2) / (speedMain > 0 and speedMain or 1)
            end
        end
    end
    return 0
end

function Sampler:GetSnapshot()
    local primary = PrimaryStat()
    local crit = RatingSum(CR_CRIT_MELEE, CR_CRIT_RANGED, CR_CRIT_SPELL)
    local haste = RatingSum(CR_HASTE_MELEE, CR_HASTE_RANGED, CR_HASTE_SPELL)
    local mastery = (GetCombatRating and GetCombatRating(CR_MASTERY or 0) or 0)
    local vers = (GetCombatRating and GetCombatRating(CR_VERSATILITY_DAMAGE_DONE or 0) or 0)
    local mh = WeaponDPS(INVSLOT_MAINHAND or 16)
    local oh = WeaponDPS(INVSLOT_OFFHAND or 17)
    local ilvl = 0
    if GetAverageItemLevel then
        ilvl = select(2, GetAverageItemLevel()) or 0
    end
    local level = UnitLevel and UnitLevel("player") or 0
    return {primary, crit, haste, mastery, vers, mh, oh, ilvl, level}
end

function Sampler:AddSample()
    local snap = self:GetSnapshot()
    self.samples = self.samples + 1
    for i = 1, #snap do
        self.sums[i] = (self.sums[i] or 0) + snap[i]
    end
end

function Sampler:Average(avgTargets)
    local n = self.samples
    if n <= 0 then n = 1 end
    local avg = {}
    for i = 1, 9 do
        avg[i] = (self.sums[i] or 0) / n
    end
    avg[10] = avgTargets or 0
    return avg
end

-- Builds the feature vector from equipped items at pull start.  The vector is
-- stable across combat since it ignores temporary buffs.
function Features.BuildEquippedVector()
    local vec = {0,0,0,0,0,0,0,0}
    if not GetItemStatsFunc or not GetInventoryItemLink then return vec end

    local primaryKey
    if GetSpecialization and GetSpecializationInfo then
        local specIndex = GetSpecialization()
        if specIndex then
            local _,_,_,_,_,primary = GetSpecializationInfo(specIndex)
            if primary == LE_UNIT_STAT_STRENGTH then primaryKey = "ITEM_MOD_STRENGTH_SHORT" end
            if primary == LE_UNIT_STAT_AGILITY then primaryKey = "ITEM_MOD_AGILITY_SHORT" end
            if primary == LE_UNIT_STAT_INTELLECT then primaryKey = "ITEM_MOD_INTELLECT_SHORT" end
        end
    end

    local ilvlSum, ilvlCount = 0, 0
    for slot = 1, 17 do
        if slot ~= (INVSLOT_BODY or 4) and slot ~= (INVSLOT_TABARD or 19) then
            local link = GetInventoryItemLink("player", slot)
            if link then
                local stats = GetItemStatsFunc(link)
                if stats then
                    if primaryKey then vec[1] = vec[1] + (stats[primaryKey] or 0) end
                    vec[2] = vec[2] + (stats["ITEM_MOD_CRIT_RATING_SHORT"] or 0)
                    vec[3] = vec[3] + (stats["ITEM_MOD_HASTE_RATING_SHORT"] or 0)
                    vec[4] = vec[4] + (stats["ITEM_MOD_MASTERY_RATING_SHORT"] or 0)
                    vec[5] = vec[5] + (stats["ITEM_MOD_VERSATILITY"] or 0)
                    local dps = stats["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] or 0
                    if slot == (INVSLOT_MAINHAND or 16) then
                        vec[6] = dps
                    elseif slot == (INVSLOT_OFFHAND or 17) then
                        vec[7] = dps
                    end
                end
                local ilvl = GetDetailedItemLevelInfo and (select(1, GetDetailedItemLevelInfo(link))) or nil
                if ilvl then
                    ilvlSum = ilvlSum + ilvl
                    ilvlCount = ilvlCount + 1
                end
            end
        end
    end
    if ilvlCount > 0 then
        vec[8] = ilvlSum / ilvlCount
    elseif GetAverageItemLevel then
        vec[8] = select(2, GetAverageItemLevel()) or 0
    end
    return vec
end

Features.Sampler = Sampler

SmartbotFeatures = Features
SmartbotFeatureSampler = Sampler
return Features

