local ADDON_NAME, SW = ...
local C = SW.Const
SW.UI = {}
local UI = SW.UI

local category

function UI:Init()
    category = Settings.RegisterCanvasLayoutCategory({name=C.ADDON_NAME})
    Settings.RegisterAddOnCategory(category)

    local function addCheck(label, key)
        local setting = Settings.RegisterAddOnSetting(category, key, C.SAVED_VAR.."_"..key, SW.db.config[key])
        Settings.CreateCheckbox(category, setting, label, {})
        setting:SetValueChangedCallback(function(_, v) SW.db.config[key]=v end)
    end

    addCheck("Enable", "enable")
    addCheck("Auto Equip", "autoEquip")
    addCheck("Tooltip Overlay", "showTooltip")
    addCheck("Exploration", "explore")
    addCheck("Verbose Logging", "verbose")
end

function UI:Open()
    if category then
        Settings.OpenToCategory(category.ID)
    end
end

return UI
