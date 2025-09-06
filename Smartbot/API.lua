local addonName, Smartbot = ...
Smartbot = Smartbot or {}
Smartbot.API = Smartbot.API or {}

local API = Smartbot.API

local function resolvePath(name)
    local node = _G
    for part in string.gmatch(name, "[^%.]+") do
        node = node and node[part]
    end
    return node
end

function API.Resolve(_, symbol)
    return resolvePath(symbol)
end

local function API_GetItemStats(itemLink)
    local func = _G.GetItemStats
    if type(func) ~= "function" and C_Item then
        func = C_Item.GetItemStats
    end
    if type(func) == "function" then
        local ok, stats = pcall(func, itemLink)
        if ok and type(stats) == "table" then
            return stats
        end
    end
    return {}
end

function API.GetItemStatsSafe(itemLink)
    if type(itemLink) ~= "string" then return {} end
    return API_GetItemStats(itemLink)
end

function API.IsOutOfCombat()
    return not InCombatLockdown()
end

function API.IsSafeToEquip()
    return API.IsOutOfCombat()
end

return API
