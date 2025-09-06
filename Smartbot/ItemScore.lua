local addonName, Smartbot = ...
Smartbot.ItemScore = Smartbot.ItemScore or {}
local ItemScore = Smartbot.ItemScore

local API = Smartbot.API
local API_GetItemStats = Smartbot.API.GetItemStatsSafe
local GetItemInfoInstant = API:Resolve('GetItemInfoInstant') or (C_Item and C_Item.GetItemInfoInstant)
local UnitClass = API:Resolve('UnitClass') or UnitClass
local GetSpecialization = API:Resolve('GetSpecialization') or GetSpecialization

local ClassSpecRules = Smartbot.ClassSpecRules or {}

-- Weapon and armor type mappings derived from ZygorGuidesViewer/Code-Retail/Item-DataTables.lua (MIT License)
local weaponTypeMap = {
    [0] = 'AXE', [1] = 'TH_AXE', [2] = 'BOW', [3] = 'GUN', [4] = 'MACE',
    [5] = 'TH_MACE', [6] = 'TH_POLE', [7] = 'SWORD', [8] = 'TH_SWORD',
    [9] = 'WARGLAIVE', [10] = 'TH_STAFF', [11] = 'DRUID_BEAR', [12] = 'DRUID_CAT',
    [13] = 'FIST', [14] = 'MISCWEAP', [15] = 'DAGGER', [16] = 'THROWN',
    [17] = 'SPEAR', [18] = 'CROSSBOW', [19] = 'WAND', [20] = 'FISHPOLE',
}

local armorTypeMap = {
    [0] = 'JEWELERY', [1] = 'CLOTH', [2] = 'LEATHER', [3] = 'MAIL',
    [4] = 'PLATE', [5] = 'COSMETIC', [6] = 'SHIELD', [7] = 'LIBRAM',
    [8] = 'IDOL', [9] = 'TOTEM', [10] = 'SIGIL', [11] = 'RELIC', [12] = 'MISCARM',
}

local function getPlayerSpec()
    local _, class = UnitClass('player')
    local spec = GetSpecialization() or 0
    return class, spec
end

local function getRules()
    local class, spec = getPlayerSpec()
    local classRules = ClassSpecRules[class]
    if classRules then
        return classRules[spec] or classRules[5] -- spec 5 before choosing spec
    end
end

local function itemTypeToken(itemClassID, itemSubClassID)
    if itemClassID == 2 then
        return weaponTypeMap[itemSubClassID]
    elseif itemClassID == 4 then
        return armorTypeMap[itemSubClassID]
    end
end

function ItemScore:IsAllowed(itemLink)
    local rules = getRules()
    if not rules then return true end
    local _, _, _, _, _, itemClassID, itemSubClassID = GetItemInfoInstant(itemLink)
    local token = itemTypeToken(itemClassID, itemSubClassID)
    if not token then return true end
    return rules.itemtypes[token] or false
end

function ItemScore:GetScore(itemLink)
    if type(itemLink) ~= 'string' or not string.find(itemLink, "|Hitem:") then
        ItemScore.invalidLog = ItemScore.invalidLog or {}
        if not ItemScore.invalidLog[itemLink] and Smartbot.Logger then
            Smartbot.Logger:Log('WARN', 'Invalid itemLink', tostring(itemLink))
            ItemScore.invalidLog[itemLink] = true
        end
        return 0
    end
    local stats = API_GetItemStats(itemLink) or {}
    local class, spec = getPlayerSpec()
    local weights = (Smartbot.db.weights[class] and Smartbot.db.weights[class][spec]) or {}
    local score = 0
    for stat, value in pairs(stats) do
        local w = weights[stat] or 0
        score = score + w * value
    end
    return score
end

return ItemScore
