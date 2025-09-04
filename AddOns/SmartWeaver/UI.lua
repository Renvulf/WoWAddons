local ADDON_NAME, SW = ...
local C = SW.Const
SW.UI = {}
local UI = SW.UI

local category
local queueFrame

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

    StaticPopupDialogs["SW_EXPORT"] = {
        text="SmartWeaver export",
        button1="Close",
        hasEditBox=true,
        OnShow=function(self)
            self.editBox:SetText(SW.Core:Export())
            self.editBox:HighlightText()
        end,
        EditBoxOnEscapePressed=function(self) self:GetParent():Hide() end,
        whileDead=true,
        hideOnEscape=true,
    }
    StaticPopupDialogs["SW_IMPORT"] = {
        text="Paste data to import",
        button1="Import",
        button2="Cancel",
        hasEditBox=true,
        OnAccept=function(self)
            SW.Core:Import(self.editBox:GetText())
        end,
        EditBoxOnEscapePressed=function(self) self:GetParent():Hide() end,
        whileDead=true,
        hideOnEscape=true,
    }

    local frame = category:GetFrame()
    local y = -140
    local function addButton(text, cb)
        local b = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        b:SetSize(120,22)
        b:SetPoint("TOPLEFT", 20, y)
        b:SetText(text)
        b:SetScript("OnClick", cb)
        y = y - 30
    end

    addButton("Export", function() StaticPopup_Show("SW_EXPORT") end)
    addButton("Import", function() StaticPopup_Show("SW_IMPORT") end)
    addButton("Reset Spec", function() SW.Core:ResetSpec() end)
    addButton("View Queue", function() UI:ToggleQueue() end)
end

function UI:UpdateQueue()
    if not queueFrame then return end
    local lines={}
    for i,item in ipairs(SW.Queue.items) do
        local link
        if item.bag then
            link = C_Container.GetContainerItemLink(item.bag,item.index)
        else
            link = GetInventoryItemLink("player", item.slot)
        end
        lines[#lines+1]=string.format("%d. %s", i, link or "item")
    end
    queueFrame.text:SetText(#lines>0 and table.concat(lines, "\n") or "(empty)")
end

function UI:ToggleQueue()
    if not queueFrame then
        queueFrame = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplateWithInset")
        queueFrame:SetSize(260,200)
        queueFrame:SetPoint("CENTER")
        queueFrame:Hide()
        queueFrame.title=queueFrame:CreateFontString(nil,"OVERLAY","GameFontHighlight")
        queueFrame.title:SetPoint("TOP",0,-10)
        queueFrame.title:SetText("Equip Queue")
        queueFrame.text=queueFrame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
        queueFrame.text:SetPoint("TOPLEFT",10,-30)
        queueFrame.text:SetJustifyH("LEFT")
    end
    UI:UpdateQueue()
    if queueFrame:IsShown() then queueFrame:Hide() else queueFrame:Show() end
end

function UI:Open()
    if category then
        Settings.OpenToCategory(category.ID)
    end
end

return UI
