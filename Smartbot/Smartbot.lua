-- Smartbot.lua - main addon entry

local Smartbot = {}
Smartbot.name = "Smartbot"

-- forward declaration
local GetCurrentModel

-- SavedVariables
SmartbotDB = SmartbotDB or {}

function GetCurrentModel()
    return nil
end

_G.Smartbot = Smartbot
return Smartbot
