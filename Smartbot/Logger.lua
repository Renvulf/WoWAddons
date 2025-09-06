local addonName, Smartbot = ...
Smartbot.Logger = Smartbot.Logger or {}
local Logger = Smartbot.Logger

local MAX_LOGS = 100
local buffer = {}

function Logger:Log(level, ...)
    local msg = table.concat({...}, " ")
    if #buffer >= MAX_LOGS then
        table.remove(buffer, 1)
    end
    table.insert(buffer, {time = GetTime(), level = level, msg = msg})
    if Smartbot.db and Smartbot.db.profile and Smartbot.db.profile.verbosity > 0 then
        DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99Smartbot|r " .. msg)
    end
end

function Logger:Get()
    return buffer
end
