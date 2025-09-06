local addonName, Smartbot = ...
Smartbot = Smartbot or {}
Smartbot.API = Smartbot.API or {}
Smartbot.rgar = Smartbot.rgar or { choices = {} }

local API = Smartbot.API
local map = Smartbot.APIMap or {}

local function resolvePath(name)
    local node = _G
    for part in string.gmatch(name, "[^%.]+") do
        node = node and node[part]
        if not node then return nil end
    end
    return node
end

function API:Resolve(symbol)
    local candidates = map[symbol]
    if candidates then
        table.sort(candidates, function(a, b) return (a.confidence or 0) > (b.confidence or 0) end)
        for _, entry in ipairs(candidates) do
            local obj = resolvePath(entry.name)
            if obj ~= nil then
                Smartbot.rgar.choices[symbol] = entry.name
                return obj
            end
        end
    end
    local fallback = resolvePath(symbol)
    if fallback ~= nil then
        Smartbot.rgar.choices[symbol] = symbol
        return fallback
    end
    return nil
end
