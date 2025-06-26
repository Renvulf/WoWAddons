-- FCTF.lua
local addonName = ...
local ADDON_PATH = "Interface\\AddOns\\" .. addonName .. "\\"
local MAX_FONTS = 20

-- SavedDB defaults
if not FCTFDB then
    FCTFDB = { minimapAngle = 45 }
end

-- 1) PRELOAD & DETECT NUMBERED FONTS AT 32px
local cachedFonts, existsFonts = {}, {}
for i = 1, MAX_FONTS do
    local path = ADDON_PATH .. i .. ".ttf"
    local f = CreateFont(addonName .. "CacheFont" .. i)
    f:SetFont(path, 32, "")
    local loaded = f:GetFont()
    if loaded and loaded:lower():find(i .. ".ttf", 1, true) then
        existsFonts[i] = true
        cachedFonts[i] = f
    else
        existsFonts[i] = false
    end
end

-- 1b) PRELOAD & DETECT default.ttf
local defaultFontObj = CreateFont(addonName .. "CacheFontDefault")
defaultFontObj:SetFont(ADDON_PATH .. "default.ttf", 32, "")
local defaultLoaded = defaultFontObj:GetFont()
local defaultExists = (defaultLoaded and defaultLoaded:lower():find("default.ttf", 1, true)) and true or false

-- 2) MAIN WINDOW
local frame = CreateFrame("Frame", addonName .. "Frame", UIParent, "BackdropTemplate")
frame:SetSize(360, 360)
frame:SetPoint("CENTER")
frame:SetBackdrop({
    bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile     = true, tileSize = 32, edgeSize = 32,
})
frame:SetBackdropColor(0, 0, 0, 1)
frame:EnableMouse(true)
frame:SetMovable(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:Hide()
frame.name = "FCTF"

-- allow ESC key to close the frame
if UISpecialFrames then
    tinsert(UISpecialFrames, frame:GetName())
end

-- 3) FONT LABEL + DROPDOWN
local fontLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fontLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -16)
fontLabel:SetText("Select Font:")
local dropdown = CreateFrame("Frame", addonName .. "Dropdown", frame, "UIDropDownMenuTemplate")
dropdown:SetPoint("LEFT", fontLabel, "RIGHT", 8, 0)
UIDropDownMenu_SetWidth(dropdown, 140)

-- 4) SCALE LABEL + LIVE NOTE
local scaleLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
scaleLabel:SetPoint("TOPLEFT", fontLabel, "BOTTOMLEFT", 0, -24)
scaleLabel:SetText("Combat Text Scale:")
local scaleLive = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
scaleLive:SetPoint("TOPLEFT", scaleLabel, "BOTTOMLEFT", 0, -4)
scaleLive:SetText("(live adjustment)")

-- 5) SLIDER & SCALE VALUE
local slider = CreateFrame("Slider", addonName .. "ScaleSlider", frame, "OptionsSliderTemplate")
slider:SetSize(328, 16)
slider:SetPoint("TOPLEFT", scaleLive, "BOTTOMLEFT", 0, -8)
slider:SetMinMaxValues(0.1, 10.0)
slider:SetValueStep(0.1)
slider:SetObeyStepOnDrag(true)
_G[slider:GetName() .. "Text"]:SetText("")
_G[slider:GetName() .. "Low"]:SetText("0.1")
_G[slider:GetName() .. "High"]:SetText("10.0")

local scaleValue = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
scaleValue:SetPoint("TOP", slider, "BOTTOM", 0, -6)

local function UpdateScale(val)
    val = math.floor(val * 10 + 0.5) / 10
    SetCVar("WorldTextScale", tostring(val))
    scaleValue:SetText(string.format("%.1f", val))
end

local currentScale = tonumber(GetCVar("WorldTextScale")) or 1.0
slider:SetValue(currentScale)
scaleValue:SetText(string.format("%.1f", currentScale))
slider:SetScript("OnValueChanged", function(self, val) UpdateScale(val) end)
slider:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Drag to adjust combat text scale live", nil, nil, nil, nil, true)
    GameTooltip:Show()
end)
slider:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- 6) PREVIEW TEXT + DYNAMIC HEIGHT + COLOR
local preview = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
preview:SetJustifyH("CENTER")
preview:SetJustifyV("MIDDLE")
preview:SetTextColor(1, 1, 0, 1)
preview:SetPoint("TOP", scaleValue, "BOTTOM", 0, -12)
preview:SetWidth(328)

local function SetPreviewFont(obj)
    preview:SetFontObject(obj)
    local _, size = preview:GetFont()
    local padding = math.ceil(size * 0.2)
    preview:SetHeight(size + (padding * 2))
end

SetPreviewFont(GameFontNormalLarge)
preview:SetText("Absorb 12340")

-- 7) CUSTOM PREVIEW EDIT BOX
local editBox = CreateFrame("EditBox", addonName .. "PreviewEdit", frame, "InputBoxTemplate")
editBox:SetSize(328, 24)
editBox:SetPoint("TOP", preview, "BOTTOM", 0, -8)
editBox:SetAutoFocus(false)
editBox:SetText("Absorb 12340")
editBox:SetScript("OnTextChanged", function(self)
    preview:SetText(self:GetText())
end)

-- 8) INFO TEXT
local infoText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
infoText:SetPoint("TOP", editBox, "BOTTOM", 0, -8)
infoText:SetText("Pick a font, adjust scale, or click Default")

-- 9) SAVE BUTTON
local saveBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
saveBtn:SetSize(200, 24)
saveBtn:SetPoint("BOTTOMLEFT", 16, 16)
saveBtn:SetText("Save & Show Reminder")
saveBtn:SetScript("OnClick", function()
    if FCTFDB and FCTFDB.selectedFont then
        DAMAGE_TEXT_FONT = ADDON_PATH .. FCTFDB.selectedFont
        print("|cFF00FF00[FCTF]|r Font saved. Restart WoW to apply.")
        UIErrorsFrame:AddMessage("FCTF: please EXIT & RESTART WoW to apply.", 1, 1, 0)
    end
end)
saveBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Save your chosen font & remind to.restart WoW", nil, nil, nil, nil, true)
    GameTooltip:Show()
end)
saveBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- 10) DEFAULT BUTTON
local defaultBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
defaultBtn:SetSize(100, 24)
defaultBtn:SetPoint("BOTTOMLEFT", saveBtn, "TOPLEFT", 0, 8)
defaultBtn:SetText("Default")
defaultBtn:SetScript("OnClick", function()
    if defaultExists then
        FCTFDB.selectedFont = "default.ttf"
        DAMAGE_TEXT_FONT = ADDON_PATH .. "default.ttf"
        SetCVar("WorldTextScale", "1")
        slider:SetValue(1)
        scaleValue:SetText("1.0")
        SetPreviewFont(defaultFontObj)
        preview:SetText(editBox:GetText())
        UIDropDownMenu_SetText(dropdown, "Default")
        print("|cFF00FF00[FCTF]|r Reset to default font & scale. Restart WoW to apply.")
        UIErrorsFrame:AddMessage("FCTF: please EXIT & RESTART WoW to apply.", 1, 1, 0)
    else
        print("|cFFFF0000[FCTF]|r default.ttf not found!")
        UIErrorsFrame:AddMessage("FCTF: default.ttf missing!", 1, 0, 0)
    end
end)
defaultBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Reset font to default.ttf & scale to 1", nil, nil, nil, nil, true)
    GameTooltip:Show()
end)
defaultBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- 11) CLOSE BUTTON
local closeBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
closeBtn:SetSize(80, 24)
closeBtn:SetPoint("BOTTOMRIGHT", -16, 16)
closeBtn:SetText("Close")
closeBtn:SetScript("OnClick", function() frame:Hide() end)
closeBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Close this window", nil, nil, nil, nil, true)
    GameTooltip:Show()
end)
closeBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- 12) SLASH COMMANDS & DROPDOWN
SLASH_FCT1, SLASH_FCT2 = "/FCT", "/fct"
SLASH_FCT3, SLASH_FCT4 = "/FLOAT", "/float"
SLASH_FCT5, SLASH_FCT6 = "/FLOATING", "/floating"
SLASH_FCT7, SLASH_FCT8 = "/FLOATINGTEXT", "/floatingtext"
SlashCmdList["FCT"] = function()
    UIDropDownMenu_Initialize(dropdown, function()
        for i = 1, MAX_FONTS do
            local info = UIDropDownMenu_CreateInfo()
            info.text  = "Font " .. i
            info.value = i
            info.func  = function()
                FCTFDB = FCTFDB or {}
                FCTFDB.selectedFont = i .. ".ttf"
                UIDropDownMenu_SetText(dropdown, info.text)
                if existsFonts[i] then
                    SetPreviewFont(cachedFonts[i])
                    preview:SetText(editBox:GetText())
                else
                    SetPreviewFont(GameFontNormalLarge)
                    preview:SetText("Font " .. i .. " not found")
                end
            end
            info.checked = (FCTFDB and FCTFDB.selectedFont == i .. ".ttf")
            UIDropDownMenu_AddButton(info)
        end
    end)

    if frame:IsShown() then
        frame:Hide()
        return
    end

    if FCTFDB and FCTFDB.selectedFont then
        local idx = tonumber(FCTFDB.selectedFont:match("^(%d+)"))
        if idx and existsFonts[idx] then
            DAMAGE_TEXT_FONT = ADDON_PATH .. FCTFDB.selectedFont
            SetPreviewFont(cachedFonts[idx])
            preview:SetText(editBox:GetText())
            UIDropDownMenu_SetText(dropdown, "Font " .. idx)
        else
            SetPreviewFont(GameFontNormalLarge)
            preview:SetText("Font " .. (idx or "?") .. " not found")
            UIDropDownMenu_SetText(dropdown, FCTFDB.selectedFont)
        end
    else
        UIDropDownMenu_SetText(dropdown, "Select Font")
        preview:SetText("")
    end

    frame:Show()
end

-- 13) MINIMAP ICON
local minimapButton = CreateFrame("Button", addonName .. "MinimapButton", Minimap)
minimapButton:SetSize(20, 20)
minimapButton:SetFrameStrata("MEDIUM")
minimapButton:SetFrameLevel(8)

-- icon (masked to a circle)
local iconTex = minimapButton:CreateTexture(nil, "BACKGROUND")
iconTex:SetTexture(ADDON_PATH .. "floaticon.png")
iconTex:SetAllPoints(minimapButton)
if iconTex.SetMaskTexture then
    iconTex:SetMaskTexture("Interface\\Minimap\\UI-Minimap-Mask")
end

-- your custom ring overlay
local ring = minimapButton:CreateTexture(nil, "OVERLAY")
ring:SetTexture(ADDON_PATH .. "ring.png")
local w, h = minimapButton:GetSize()
ring:SetSize(w * 1.6, h * 1.6)
ring:SetPoint("CENTER", minimapButton, "CENTER", 0, 0)

minimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
minimapButton:EnableMouse(true)
minimapButton:RegisterForClicks("LeftButtonUp")
minimapButton:RegisterForDrag("LeftButton")
minimapButton:SetScript("OnClick", function() SlashCmdList["FCT"]() end)
minimapButton:SetScript("OnDragStart", function(self) self.isMoving = true end)
minimapButton:SetScript("OnDragStop", function(self) self.isMoving = false end)
minimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText("Click to toggle FCTF settings", 1, 1, 1)
    GameTooltip:Show()
end)
minimapButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

minimapButton:SetScript("OnUpdate", function(self)
    if self.isMoving then
        local mx, my = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        mx, my = mx / scale, my / scale
        local cx, cy = Minimap:GetCenter()
        local dx, dy = mx - cx, my - cy
        FCTFDB.minimapAngle = math.deg(math.atan2(dy, dx))
    end
    local ang = math.rad(FCTFDB.minimapAngle or 45)
    local r = Minimap:GetWidth() / 2 + 10
    self:ClearAllPoints()
    self:SetPoint("CENTER", Minimap, "CENTER", math.cos(ang) * r, math.sin(ang) * r)
end)

-- 14) APPLY/SAVE ON ADDON_LOADED
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, name)
    if name == addonName then
        if not FCTFDB then FCTFDB = {} end
        if FCTFDB.selectedFont then
            local idx = tonumber(FCTFDB.selectedFont:match("^(%d+)"))
            if idx and existsFonts[idx] then
                DAMAGE_TEXT_FONT = ADDON_PATH .. FCTFDB.selectedFont
                SetPreviewFont(cachedFonts[idx])
                preview:SetText(editBox:GetText())
                UIDropDownMenu_SetText(dropdown, "Font " .. idx)
            end
        end
        if InterfaceOptions_AddCategory then
            InterfaceOptions_AddCategory(frame)
        end
    end
end)
