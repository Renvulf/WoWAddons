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

local warned

function API.GetItemStatsSafe(itemLink)
    if type(itemLink) ~= "string" then return {} end
    local API_GetItemStats = _G and _G.GetItemStats
    if type(API_GetItemStats) ~= "function" and C_Item and type(C_Item.GetItemStats) == "function" then
        API_GetItemStats = function(link)
            return C_Item.GetItemStats(link)
        end
    end
    if type(API_GetItemStats) == "function" then
        local ok, stats = pcall(API_GetItemStats, itemLink)
        if ok and type(stats) == "table" then
            return stats
        end
    end
    if not warned and Smartbot.Logger then
        Smartbot.Logger:Log('WARN', 'GetItemStats unavailable')
        warned = true
    end
    return {}
end

function API.IsOutOfCombat()
    return not InCombatLockdown()
end

function API.IsSafeToEquip()
    return API.IsOutOfCombat()
end

return API
