local addonName, Smartbot = ...
Smartbot = Smartbot or {}
Smartbot.API = Smartbot.API or {}

local warned

local function resolvePath(name)
    local node = _G
    for part in string.gmatch(name, "[^%.]+") do
        node = node and node[part]
    end
    return node
end

function Smartbot.API.Resolve(_, symbol)
    return resolvePath(symbol)
end

function Smartbot.API.IsValidItemLink(link)
    if type(link) ~= "string" then return false end
    if string.find(link, "|Hitem:") then return true end
    if string.match(link, "^item:%d+") then return true end
    return false
end

function Smartbot.API.GetItemStatsSafe(itemLink)
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

function Smartbot.API.IsOutOfCombat()
    return not InCombatLockdown()
end

function Smartbot.API.IsPlayerBusy()
    if _G.MerchantFrame and _G.MerchantFrame:IsShown() then return true end
    if _G.TradeFrame and _G.TradeFrame:IsShown() then return true end
    if _G.AuctionHouseFrame and _G.AuctionHouseFrame:IsShown() then return true end
    if _G.MailFrame and _G.MailFrame:IsShown() then return true end
    if _G.BankFrame and _G.BankFrame:IsShown() then return true end
    if _G.ItemSocketingFrame and _G.ItemSocketingFrame:IsShown() then return true end
    if _G.CursorHasItem and _G.CursorHasItem() then return true end
    return false
end

function Smartbot.API.ClearCursorSafe()
    local CursorHasItem = _G.CursorHasItem
    if CursorHasItem and CursorHasItem() then
        local ClearCursor = _G.ClearCursor
        if ClearCursor then ClearCursor() end
    end
end

return Smartbot.API

