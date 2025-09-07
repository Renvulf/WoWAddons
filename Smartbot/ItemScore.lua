local addonName, Smartbot = ...
Smartbot.ItemScore = Smartbot.ItemScore or {}

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
    local _, class = _G.UnitClass('player')
    local spec = _G.GetSpecialization() or 0
    return class, spec
end

local function getRules()
    local ClassSpecRules = Smartbot.ClassSpecRules or {}
    local class, spec = getPlayerSpec()
    local classRules = ClassSpecRules[class]
    if classRules then
        return classRules[spec] or classRules[5]
    end
end

local function itemTypeToken(itemClassID, itemSubClassID)
    if itemClassID == 2 then
        return weaponTypeMap[itemSubClassID]
    elseif itemClassID == 4 then
        return armorTypeMap[itemSubClassID]
    end
end

local function getStats(link)
    return Smartbot.API.GetItemStatsSafe(link)
end

function Smartbot.ItemScore:IsAllowed(itemLink)
    local rules = getRules()
    if not rules then return true end
    local _, _, _, _, _, itemClassID, itemSubClassID = _G.GetItemInfoInstant(itemLink)
    local token = itemTypeToken(itemClassID, itemSubClassID)
    if not token then return true end
    return rules.itemtypes[token] or false
end

function Smartbot.ItemScore:GetScore(itemLink)
    if type(itemLink) ~= 'string' or not string.find(itemLink, "|Hitem:") then
        self.invalidLog = self.invalidLog or {}
        if not self.invalidLog[itemLink] and Smartbot.Logger then
            Smartbot.Logger:Log('WARN', 'Invalid itemLink', tostring(itemLink))
            self.invalidLog[itemLink] = true
        end
        return 0
    end
    local stats = getStats(itemLink) or {}
    local class, spec = getPlayerSpec()
    local weights = Smartbot.db and Smartbot.db.weights and Smartbot.db.weights[class] and Smartbot.db.weights[class][spec] or {}
    local score = 0
    for stat, value in pairs(stats) do
        local w = weights[stat] or 0
        score = score + w * value
    end
    return score
end

return Smartbot.ItemScore
