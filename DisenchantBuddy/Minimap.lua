-- Minimap icon support for DisenchantBuddy
-- Creates a LibDataBroker launcher and registers a minimap button

local addonName = ...
local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")

local dataObject = LDB:NewDataObject("DisenchantBuddy", {
    type = "launcher",
    icon = "Interface\\Icons\\INV_Enchant_Disenchant",
    OnClick = function(_, button)
        if button == "LeftButton" and DisenchantBuddy_Toggle then
            DisenchantBuddy_Toggle()
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine("DisenchantBuddy")
        tooltip:AddLine("Left-click to toggle", 1, 1, 1)
    end,
})

local function Init()
    DisenchantBuddyDB.global.minimap = DisenchantBuddyDB.global.minimap or { hide = false, minimapPos = 220, radius = 80 }
    LDBIcon:Register("DisenchantBuddy", dataObject, DisenchantBuddyDB.global.minimap)
end

-- Register init handler
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    Init()
end)
