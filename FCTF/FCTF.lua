-- FCTF.lua
local addonName = ...
local ADDON_PATH = "Interface\\AddOns\\" .. addonName .. "\\"
--[[
  ---------------------------------------------------------------------------
    Font Detection
    Instead of checking for numbered fonts like 1.ttf, 2.ttf, etc. we now look
    for actual font files organised into folders. Each folder corresponds to a
    themed group of fonts. The table below lists the relative font file names
    shipped with the addon. Detection is performed at load time so missing
    files are ignored gracefully.
  ---------------------------------------------------------------------------
--]]

-- SavedDB defaults
if not FCTFDB then
    FCTFDB = { minimapAngle = 45 }
end
FCTFPCDB = FCTFPCDB or {}

local PERCHAR_DEFAULTS = {
    combatHealing  = tonumber(GetCVar("floatingCombatTextCombatHealing")) == 1,
    combatDamage   = tonumber(GetCVar("floatingCombatTextCombatDamage")) == 1,
    petDamage      = tonumber(GetCVar("floatingCombatTextPetMeleeDamage")) == 1,
    periodicDamage = tonumber(GetCVar("floatingCombatTextPeriodicDamage")) == 1,
}
for k,v in pairs(PERCHAR_DEFAULTS) do
    if FCTFPCDB[k] == nil then FCTFPCDB[k] = v end
end

local COMBAT_FONT_GROUPS = {
    ["Fun"] = {
        path  = ADDON_PATH .. "Fun\\",
        fonts = {
            "04b.ttf", "Barriecito.ttf", "ComicRunes.ttf", "Dmagic.ttf",
            "Elven.ttf", "Green Fuz.otf", "Gunung.ttf", "Guroes.ttf",
            "Heorot.ttf", "Kiyrand.ttf", "Kting.ttf", "Melted.ttf",
            "Midorima.ttf", "Munsteria.ttf", "Odinson.ttf", "Pau.ttf",
            "Runic.ttf", "Runy.ttf", "Shiruken.ttf", "Skullphabet.ttf",
            "WKnight.ttf", "Wasser.ttf", "WhoAsksSatan.ttf", "Wickedmouse.ttf",
            "akash.ttf", "crygords.ttf", "edgyh.ttf", "edkies.ttf",
            "figtoen.ttf", "graff.ttf", "leviathans.ttf", "shog.ttf",
            "tsuchigumo.ttf",
        },
    },
    ["Future"] = {
        path  = ADDON_PATH .. "Future\\",
        fonts = {
            "914Solid.ttf", "Audiowide.ttf", "Caesar.ttf", "ChopSic.ttf",
            "Digital.ttf", "FastHand.ttf", "Orbitron.ttf", "Pepsi.ttf",
            "Price.ttf", "RaceSpace.ttf", "RushDriver.ttf", "albra.TTF",
        },
    },
    ["Movie/Game"] = {
        path  = ADDON_PATH .. "MovieGame\\",
        fonts = {
            "Acadian.ttf", "Deltarune.ttf", "Elven.ttf", "Gunung.ttf",
            "Halo.ttf", "HarryP.ttf", "Hobbit.ttf", "Kting.ttf",
            "Ktingw.ttf", "MetalMacabre.ttf", "Odinson.ttf", "Pokemon.ttf",
            "Ruritania.ttf", "Spongebob.ttf", "Terminator.ttf",
            "The Centurion .ttf", "VTKS.ttf", "dalek.ttf",
            "modernwarfare.ttf",
        },
    },
    ["Easy-to-Read"] = {
        path  = ADDON_PATH .. "Easy-to-Read\\",
        fonts = {
            "AlteHaasGroteskBold.ttf", "Bangers.ttf", "Expressway.ttf",
            "NotoSans_Condensed-Bold.ttf", "PTSansNarrow-Bold.ttf",
            "Prototype.ttf", "Roboto-Bold.ttf", "SF-Pro.ttf",
            "accidentalpres.ttf", "bignoodletitling.ttf", "continuum.ttf",
            "pf_tempesta_seven.ttf",
        },
    },
    ["Default"] = {
        path  = ADDON_PATH,
        fonts = {"default.ttf"},
    },
    -- Folder for user provided fonts.  Any files named 1.ttf - 20.ttf will be
    -- detected and offered in the dropdown.  Missing files are ignored.
    ["Custom"] = {
        path  = ADDON_PATH .. "Custom\\",
        fonts = {}, -- populated below
    },
}

-- Populate the expected custom font names (1.ttf .. 20.ttf)
do
    local t = COMBAT_FONT_GROUPS["Custom"].fonts
    for i = 1, 20 do
        t[i] = i .. ".ttf"
    end
end

-- Cache loaded fonts to allow previewing in the options panel
local cachedFonts, existsFonts = {}, {}
for group, data in pairs(COMBAT_FONT_GROUPS) do
    cachedFonts[group] = {}
    existsFonts[group] = {}
    for _, fname in ipairs(data.fonts) do
        local path = data.path .. fname
        local f = CreateFont(addonName .. "Cache" .. group .. fname)
        f:SetFont(path, 32, "")
        local loaded = f:GetFont()
        if loaded and loaded:lower():find(fname:lower(), 1, true) then
            existsFonts[group][fname] = true
            cachedFonts[group][fname] = {font=f, path=path}
        else
            existsFonts[group][fname] = false
        end
    end
end

-- 2) MAIN WINDOW
local frame = CreateFrame("Frame", addonName .. "Frame", UIParent, "BackdropTemplate")
-- Expanded size and extra top padding so header text doesn't clip
frame:SetSize(420, 500)
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

-- 3) COMMON WIDGET HELPERS ---------------------------------------------------
local function CreateCheckbox(parent, label, x, y, checked, onClick)
    local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    cb:SetPoint("TOPLEFT", x, y)
    cb.text:SetText(label)
    cb:SetChecked(checked)
    if onClick then cb:SetScript("OnClick", onClick) end
    return cb
end

-- 4) FONT DROPDOWNS ---------------------------------------------------------
local dropdowns = {}
local preview
local editBox

--[[
    Apply a font to the preview field.

    The original implementation assumed fontObj was always valid. During early
    loading however, "GameFontNormalLarge" may not yet exist which triggered
    the reported "attempt to index local 'fontObj'" error. To make the function
    robust we guard against nil values and gracefully fall back when loading via
    the font path fails.
--]]
local function SetPreviewFont(fontObj, path)
    if not fontObj then return end -- nothing to apply

    -- allow passing the cached font table directly
    if type(fontObj) == "table" then
        path    = fontObj.path
        fontObj = fontObj.font
    end

    if not fontObj or type(fontObj.GetFont) ~= "function" then return end

    -- retrieve font attributes for scaling
    local fPath, size, flags = fontObj:GetFont()
    path  = path  or fPath
    size  = (size or 20) * 2
    flags = flags or ""

    -- attempt to load via explicit path first
    local ok = false
    if path then
        ok = pcall(preview.SetFont, preview, path, size, flags)
    end
    if not ok then
        preview:SetFontObject(fontObj)
    end

    -- adjust height so tall fonts are not clipped
    local _, applied = preview:GetFont()
    applied = applied or size
    preview:SetHeight(applied + math.ceil(applied * 0.4))
end

-- Dropdowns for each font group arranged neatly in two columns
-- Displayed dropdown order; the "Custom" category replaces the old "Default"
-- dropdown to allow users to provide their own fonts.
local order = {"Fun", "Future", "Movie/Game", "Easy-to-Read", "Custom"}
local lastDropdown
for idx, grp in ipairs(order) do
    local dd = CreateFrame("Frame", addonName .. grp:gsub("[^%w]", "") .. "DD", frame, "UIDropDownMenuTemplate")
    local row = math.floor((idx-1)/2)
    local col = (idx-1) % 2
    -- extra vertical padding to keep labels away from the top border
    dd:SetPoint("TOPLEFT", frame, "TOPLEFT", 20 + col*180, -40 - row*50)
    UIDropDownMenu_SetWidth(dd, 160)
    dropdowns[grp] = dd
    if idx == #order then
        lastDropdown = dd -- remember last dropdown for layout anchoring
    end

    local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("BOTTOMLEFT", dd, "TOPLEFT", 16, 3)
    label:SetText(grp)

    UIDropDownMenu_Initialize(dd, function()
        local added = false
        for _, fname in ipairs(COMBAT_FONT_GROUPS[grp].fonts) do
            if existsFonts[grp][fname] then
                added = true
                local info = UIDropDownMenu_CreateInfo()
                local display = fname:gsub("%.otf$", ""):gsub("%.ttf$", "")
                local cache  = cachedFonts[grp][fname]
                info.text  = display
                info.func  = function()
                    for g,d in pairs(dropdowns) do UIDropDownMenu_SetText(d, "Select Font") end
                    FCTFDB.selectedFont = grp .. "/" .. fname
                    UIDropDownMenu_SetText(dd, display)
                    SetPreviewFont(cache)
                    local txt = editBox:GetText()
                    preview:SetText("")
                    preview:SetText(txt)
                end
                info.checked = (FCTFDB.selectedFont == grp .. "/" .. fname)
                UIDropDownMenu_AddButton(info)
            end
        end
        if not added then
            local info = UIDropDownMenu_CreateInfo()
            info.text = "No font detected"
            info.disabled = true
            UIDropDownMenu_AddButton(info)
        end
    end)
end

-- 5) SCALE SLIDER -----------------------------------------------------------
local scaleLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
-- position the label below the last dropdown to prevent overlap
local sliderOffsetX = 15 -- shift controls slightly right for centering
if lastDropdown then
    scaleLabel:SetPoint("TOPLEFT", lastDropdown, "BOTTOMLEFT", sliderOffsetX, -20)
else
    scaleLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 16 + sliderOffsetX, -160)
end
scaleLabel:SetText("Combat Text Size:")

local slider = CreateFrame("Slider", addonName .. "ScaleSlider", frame, "OptionsSliderTemplate")
slider:SetSize(300, 16)
slider:SetPoint("TOPLEFT", scaleLabel, "BOTTOMLEFT", 0, -8)
slider:SetMinMaxValues(0.5, 5.0)
slider:SetValueStep(0.1)
slider:SetObeyStepOnDrag(true)
_G[slider:GetName() .. "Low"]:SetText("0.5")
_G[slider:GetName() .. "High"]:SetText("5.0")

local scaleValue = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
scaleValue:SetPoint("LEFT", slider, "RIGHT", 10, 0)

local function UpdateScale(val)
    val = math.floor(val * 10 + 0.5) / 10
    SetCVar("WorldTextScale", tostring(val))
    scaleValue:SetText(string.format("%.1f", val))
end

local currentScale = tonumber(GetCVar("WorldTextScale")) or 1.0
slider:SetValue(currentScale)
scaleValue:SetText(string.format("%.1f", currentScale))
slider:SetScript("OnValueChanged", function(self,val) UpdateScale(val) end)
slider:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine("Drag to adjust combat text size",1,1,1)
    GameTooltip:Show()
end)
slider:SetScript("OnLeave", GameTooltip_Hide)

-- 6) PREVIEW & EDIT ---------------------------------------------------------
preview = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
preview:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 0, -20)
preview:SetWidth(360)
preview:SetJustifyH("LEFT")
preview:SetText("12345")

-- Apply a default preview font. GameFontNormalLarge should normally exist,
-- but we fall back to the current FontObject if it does not to avoid errors.
SetPreviewFont(GameFontNormalLarge or preview:GetFontObject())

editBox = CreateFrame("EditBox", addonName .. "PreviewEdit", frame, "InputBoxTemplate")
editBox:SetSize(360, 24)
editBox:SetPoint("TOPLEFT", preview, "BOTTOMLEFT", 0, -8)
editBox:SetAutoFocus(false)
editBox:SetText("12345")
editBox:SetScript("OnTextChanged", function(self) preview:SetText(self:GetText()) end)

-- 7) COMBAT OPTION CHECKBOXES ----------------------------------------------
local opts = {
    {k="combatHealing",  l="Show Combat Healing",  c="floatingCombatTextCombatHealing"},
    {k="combatDamage",   l="Show Combat Damage",   c="floatingCombatTextCombatDamage"},
    {k="petDamage",      l="Show Pet Damage",      c="floatingCombatTextPetMeleeDamage"},
    {k="periodicDamage", l="Show Periodic Damage", c="floatingCombatTextPeriodicDamage"},
}
for i,opt in ipairs(opts) do
    local col = (i-1) % 2
    local row = math.floor((i-1) / 2)
    -- anchor checkboxes below the edit box to avoid overlap with the preview box
    local x = 16 + col * 200
    local y = -16 - row * 30
    -- initially anchor at origin; we reposition immediately after
    local cb = CreateCheckbox(frame, opt.l, 0, 0, FCTFPCDB[opt.k], function(self)
        FCTFPCDB[opt.k] = self:GetChecked()
        SetCVar(opt.c, self:GetChecked() and 1 or 0)
    end)
    cb:ClearAllPoints()
    cb:SetPoint("TOPLEFT", editBox, "BOTTOMLEFT", x, y)
end

-- 8) APPLY & DEFAULT BUTTONS -----------------------------------------------
local applyBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
applyBtn:SetSize(120, 22)
applyBtn:SetPoint("BOTTOMLEFT", 16, 16)
applyBtn:SetText("Apply")
applyBtn:SetScript("OnClick", function()
    if FCTFDB.selectedFont then
        DAMAGE_TEXT_FONT = ADDON_PATH .. FCTFDB.selectedFont
        print("|cFF00FF00[FCTF]|r Combat font saved. Restart WoW to apply.")
        UIErrorsFrame:AddMessage("FCTF: please EXIT & RESTART WoW to apply.",1,1,0)
    else
        print("|cFFFF0000[FCTF]|r No font selected.")
    end
end)

local defaultBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
defaultBtn:SetSize(100,22)
defaultBtn:SetPoint("LEFT", applyBtn, "RIGHT", 8, 0)
defaultBtn:SetText("Default")
defaultBtn:SetScript("OnClick", function()
    FCTFDB.selectedFont = "Default/default.ttf"
    local cache = cachedFonts["Default"] and cachedFonts["Default"]["default.ttf"]
    if cache then
        SetPreviewFont(cache)
    else
        SetPreviewFont(GameFontNormalLarge or preview:GetFontObject())
    end
    editBox:SetText(editBox:GetText())
    slider:SetValue(1.0); UpdateScale(1.0)
    for g,d in pairs(dropdowns) do UIDropDownMenu_SetText(d, "Select Font") end
    print("|cFF00FF00[FCTF]|r Reset to default font.")
end)

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
    if frame:IsShown() then
        frame:Hide()
        return
    end

    for g,d in pairs(dropdowns) do UIDropDownMenu_SetText(d, "Select Font") end
    if FCTFDB.selectedFont then
        local grp,fname = FCTFDB.selectedFont:match("^([^/]+)/(.+)$")
        if grp and fname and dropdowns[grp] and existsFonts[grp][fname] then
            UIDropDownMenu_SetText(dropdowns[grp], fname:gsub("%.otf$",""):gsub("%.ttf$",""))
            local cache = cachedFonts[grp][fname]
            if cache then SetPreviewFont(cache) end
        end
    end
    preview:SetText(editBox:GetText())
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
        if FCTFDB.selectedFont then
            local g,f = FCTFDB.selectedFont:match("^([^/]+)/(.+)$")
            if g and f and dropdowns[g] and existsFonts[g] and existsFonts[g][f] then
                DAMAGE_TEXT_FONT = ADDON_PATH .. FCTFDB.selectedFont
                local cache = cachedFonts[g] and cachedFonts[g][f]
                if cache then SetPreviewFont(cache) end
                preview:SetText(editBox:GetText())
                for grp,dd in pairs(dropdowns) do UIDropDownMenu_SetText(dd, "Select Font") end
                UIDropDownMenu_SetText(dropdowns[g], f:gsub("%.otf$",""):gsub("%.ttf$",""))
            end
        end
        if InterfaceOptions_AddCategory then InterfaceOptions_AddCategory(frame) end
    end
end)
