local addonName, Smartbot = ...
Smartbot.Model = Smartbot.Model or {}
local Model = Smartbot.Model

local API = Smartbot.API
local CreateFrame = API:Resolve('CreateFrame') or CreateFrame
local UnitClass = API:Resolve('UnitClass') or UnitClass
local GetSpecialization = API:Resolve('GetSpecialization') or GetSpecialization
local GetInventoryItemLink = API:Resolve('GetInventoryItemLink') or GetInventoryItemLink
local API_GetItemStats = Smartbot.API.GetItemStatsSafe
local GetTime = API:Resolve('GetTime') or GetTime

local DetailsBridge = Smartbot.DetailsBridge

local combatStart = nil
local features = nil

local function currentKey()
    local _, class = UnitClass('player')
    local spec = GetSpecialization() or 0
    return class, spec
end

local function collectFeatures()
    local stats = {}
    for slot = 1, 17 do
        local link = GetInventoryItemLink('player', slot)
        if link then
            local istats = API_GetItemStats(link)
            if istats then
                for stat, val in pairs(istats) do
                    stats[stat] = (stats[stat] or 0) + val
                end
            end
        end
    end
    return stats
end

local function ensureTables()
    Smartbot.db.weights = Smartbot.db.weights or {}
    Smartbot.db.modelMeta = Smartbot.db.modelMeta or {}
    local class, spec = currentKey()
    Smartbot.db.weights[class] = Smartbot.db.weights[class] or {}
    Smartbot.db.weights[class][spec] = Smartbot.db.weights[class][spec] or {}
    Smartbot.db.modelMeta[class] = Smartbot.db.modelMeta[class] or {}
    Smartbot.db.modelMeta[class][spec] = Smartbot.db.modelMeta[class][spec] or {g2 = {}, samples = 0}
    return class, spec
end

local function updateWeights(target, feats)
    local class, spec = ensureTables()
    local weights = Smartbot.db.weights[class][spec]
    local meta = Smartbot.db.modelMeta[class][spec]
    local lr = 0.001
    local g2 = meta.g2
    local pred = 0
    for stat, val in pairs(feats) do
        pred = pred + (weights[stat] or 0) * val
    end
    local err = pred - target
    for stat, val in pairs(feats) do
        local grad = err * val
        -- clip gradient
        if grad > 10000 then grad = 10000 elseif grad < -10000 then grad = -10000 end
        g2[stat] = (g2[stat] or 0) + grad * grad
        local rate = lr / math.sqrt(g2[stat])
        weights[stat] = (weights[stat] or 0) - rate * grad
    end
    meta.samples = (meta.samples or 0) + 1
    if Smartbot.Logger then
        Smartbot.Logger:Log('DEBUG', 'Weights updated', meta.samples)
    end
end

local function onCombatEnd()
    if not combatStart or not features then return end
    local duration = GetTime() - combatStart
    if duration < 5 then return end
    local dps, hps = DetailsBridge:GetMetrics()
    local target = math.max(dps or 0, hps or 0)
    if target <= 0 then return end
    updateWeights(target, features)
    combatStart = nil
    features = nil
end

local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_REGEN_DISABLED')
frame:RegisterEvent('PLAYER_REGEN_ENABLED')
frame:SetScript('OnEvent', function(_, event)
    if event == 'PLAYER_REGEN_DISABLED' then
        combatStart = GetTime()
        features = collectFeatures()
    elseif event == 'PLAYER_REGEN_ENABLED' then
        onCombatEnd()
    end
end)

return Model
