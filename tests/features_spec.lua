-- Stubs for WoW API
LE_UNIT_STAT_INTELLECT = 4
CR_CRIT_MELEE = 1
CR_CRIT_RANGED = 2
CR_CRIT_SPELL = 3
CR_HASTE_MELEE = 4
CR_HASTE_RANGED = 5
CR_HASTE_SPELL = 6
CR_MASTERY = 7
CR_VERSATILITY_DAMAGE_DONE = 8
INVSLOT_MAINHAND = 16
INVSLOT_OFFHAND = 17

function GetSpecialization() return 1 end
function GetSpecializationInfo(idx) return nil,nil,nil,nil,nil,LE_UNIT_STAT_INTELLECT end
function UnitStat(unit, stat) return 0, 1 end
function GetCombatRating(id)
    if id == CR_CRIT_MELEE then return 2 end
    if id == CR_HASTE_MELEE then return 3 end
    if id == CR_MASTERY then return 4 end
    if id == CR_VERSATILITY_DAMAGE_DONE then return 5 end
    return 0
end
function GetInventoryItemLink(unit, slot)
    if slot == INVSLOT_MAINHAND then return "mh" end
    if slot == INVSLOT_OFFHAND then return "oh" end
end
function GetItemStats(link)
    if link == "mh" then return {ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 6} end
    if link == "oh" then return {ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 7} end
end
function GetAverageItemLevel() return 0, 8 end
function UnitLevel(unit) return 9 end
function UnitDamage(unit) return 0,0,0,0 end
function UnitAttackSpeed(unit) return 1,1 end

local Features = dofile("Smartbot/Features.lua")
local Sampler = Features.Sampler
local s = Sampler:New()
s:AddSample()
s:AddSample()
local vec = s:Average(10)
assert(#vec == 10, "feature length")
for i=1,10 do
    assert(vec[i] == i, "feature order "..i)
end
print("features_spec passed")
