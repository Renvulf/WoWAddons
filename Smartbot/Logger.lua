local addonName, Smartbot = ...
Smartbot.Logger = Smartbot.Logger or {}

local buffer = {}
local MAX_LOGS = 100

function Smartbot.Logger:Log(level, ...)
    local msg = table.concat({...}, " ")
    if #buffer >= MAX_LOGS then
        table.remove(buffer, 1)
    end
    table.insert(buffer, {time = _G.GetTime(), level = level, msg = msg})
    if Smartbot.db and Smartbot.db.profile and Smartbot.db.profile.verbosity > 0 then
        local frame = _G.DEFAULT_CHAT_FRAME
        if frame and frame.AddMessage then
            frame:AddMessage("|cff33ff99Smartbot|r " .. msg)
        end
    end
end

function Smartbot.Logger:Get()
    return buffer
end

return Smartbot.Logger
