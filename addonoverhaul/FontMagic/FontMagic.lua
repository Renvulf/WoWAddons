-- FontMagic.lua
local addonName = ...

-- safe loader: C_AddOns.LoadAddOn (Retail ≥11.0.2) or legacy LoadAddOn
local safeLoadAddOn
if type(C_AddOns) == "table" and type(C_AddOns.LoadAddOn) == "function" then
    safeLoadAddOn = C_AddOns.LoadAddOn
elseif type(LoadAddOn) == "function" then
    safeLoadAddOn = LoadAddOn
else
    safeLoadAddOn = function() end
end
local ADDON_PATH = "Interface\\AddOns\\" .. addonName .. "\\"
-- Name of the optional addon supplying user fonts
local CUSTOM_ADDON = "FontMagicCustomFonts"
-- Default path for custom fonts shipped by the companion addon
local CUSTOM_PATH  = "Interface\\AddOns\\" .. CUSTOM_ADDON .. "\\Custom\\"

-- Try to load the companion addon so its global table becomes available
pcall(safeLoadAddOn, CUSTOM_ADDON)
-- If loaded, prefer its reported path in case the folder was moved/renamed
if type(FontMagicCustomFonts) == "table" and type(FontMagicCustomFonts.PATH) == "string" then
    CUSTOM_PATH = FontMagicCustomFonts.PATH
end
-- detect whether the BackdropTemplate mixin exists (Retail only)
local backdropTemplate = (BackdropTemplateMixin and "BackdropTemplate") or nil
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
if not FontMagicDB then
    FontMagicDB = { minimapAngle = 45 }
end
FontMagicPCDB = FontMagicPCDB or {}

local PERCHAR_DEFAULTS = {
    combatHealing  = tonumber(GetCVar("floatingCombatTextCombatHealing")) == 1,
    combatDamage   = tonumber(GetCVar("floatingCombatTextCombatDamage")) == 1,
    petDamage      = tonumber(GetCVar("floatingCombatTextPetMeleeDamage")) == 1,
    -- WoW's CVar controlling periodic spell damage visibility is
    -- "floatingCombatTextCombatLogPeriodicSpells".  The previous code used
    -- "floatingCombatTextPeriodicDamage" which doesn't exist and resulted in the
    -- setting not persisting between sessions.
    periodicDamage = tonumber(GetCVar("floatingCombatTextCombatLogPeriodicSpells")) == 1,
    -- incoming healing and damage defaults
    incomingDamage  = true,
    incomingHealing = true,
}
for k,v in pairs(PERCHAR_DEFAULTS) do
    if FontMagicPCDB[k] == nil then FontMagicPCDB[k] = v end
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
        -- custom fonts are provided by the optional FontMagicCustomFonts addon
        -- they reside in its Custom folder rather than this addon's
        path  = CUSTOM_PATH,
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
local hasCustomFonts = false -- tracks whether any custom font could be loaded
for group, data in pairs(COMBAT_FONT_GROUPS) do
    cachedFonts[group] = {}
    existsFonts[group] = {}
    for _, fname in ipairs(data.fonts) do
        local path = data.path .. fname
        local f = CreateFont(addonName .. "Cache" .. group .. fname)
        -- safely attempt to load the font; missing or invalid files
        -- should not throw errors during detection
        local ok = pcall(function() f:SetFont(path, 32, "") end)
        local loaded = ok and f:GetFont()
        if loaded and loaded:lower():find(fname:lower(), 1, true) then
            existsFonts[group][fname] = true
            cachedFonts[group][fname] = { font = f, path = path }
            if group == "Custom" then
                hasCustomFonts = true
            end
        else
            existsFonts[group][fname] = false
        end
    end
end

local originalInfo = {}

-- cache Blizzard's default combat text fonts so we can revert the preview
-- when the user presses the "Default" button. these paths are populated once
-- the relevant globals become available (usually when Blizzard_CombatText loads)
local blizzDefaultDamageFont
local blizzDefaultCombatFont

-- 2) MAIN WINDOW
local frame = CreateFrame("Frame", addonName .. "Frame", UIParent, backdropTemplate)
--
-- The options window previously lacked a border and used uneven padding
-- around its contents.  Here we keep all the widgets exactly where they
-- were defined and instead only change the outer frame so that it provides
-- an even buffer on every side and a simple border for clarity.
--
-- Constants control the visual spacing and border width so adjustments can
-- be made in a single location.
local PAD       = 20   -- distance from the outer edge to the nearest widget
local BORDER    = 12   -- thickness of the decorative border
local HEADER_H  = 40   -- space reserved for the InterfaceOptions header
local PREVIEW_W = 320  -- width of preview and edit boxes
local CB_COL_W  = 150  -- checkbox column width

-- The existing widgets already expect roughly 20px from the top-left
-- of the frame, so we simply expand the overall frame to ensure the same
-- distance on the remaining sides as well.
-- Widen the frame slightly so dropdown menus and other widgets have
-- adequate padding on both sides. This prevents the second column of
-- dropdowns from touching or overlapping the right border when the
-- window is scaled.
frame:SetSize(364 + PAD * 2, 468 + PAD * 2)
frame:SetPoint("CENTER")
frame:SetBackdrop({
    bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile     = true, tileSize = 32,
    edgeSize = BORDER,
    insets   = { left = PAD - BORDER, right = PAD - BORDER,
                 top  = PAD - BORDER, bottom = PAD - BORDER },
})
frame:SetBackdropColor(0, 0, 0, 0.8)
frame:EnableMouse(true)
frame:SetMovable(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:Hide()
frame.name = "FontMagic"

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
    -- place dropdowns below the InterfaceOptions title text
    -- shift dropdowns slightly so left and right margins are even
    dd:SetPoint("TOPLEFT", frame, "TOPLEFT", 16 + col*180, -(HEADER_H + row*50))
    UIDropDownMenu_SetWidth(dd, 160)
    dropdowns[grp] = dd
    if idx == #order then
        lastDropdown = dd -- remember last dropdown for layout anchoring
    end

    local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    -- position label so its left edge aligns with the dropdown
    label:ClearAllPoints()
    label:SetPoint("BOTTOM", dd, "TOP", 0, 3)
    -- Use the frame's GetWidth() method to obtain the dropdown width.
    -- UIDropDownMenu_GetWidth has been removed in Dragonflight and older
    -- globals may not return a valid number. GetWidth() is available on all
    -- frames and ensures a numeric width is returned.
    label:SetWidth(dd:GetWidth())
    label:SetJustifyH("CENTER")
    label:SetText(grp)

    if grp == "Custom" then
        dd:SetScript("OnEnter", function(self)
            if not hasCustomFonts then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText("Install FontMagicCustomFonts to use custom fonts", nil, nil, nil, nil, true)
                GameTooltip:Show()
            end
        end)
        dd:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end

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
                    -- store the selected font as "<group>/<filename>".  The
                    -- group name itself may contain a slash (e.g. "Movie/Game"),
                    -- so when retrieving we always split on the *last* slash
                    -- rather than the first.  This avoids corrupting group
                    -- names that contain a slash.
                    FontMagicDB.selectedFont = grp .. "/" .. fname
                    UIDropDownMenu_SetText(dd, display)
                    SetPreviewFont(cache)
                    local txt = editBox:GetText()
                    preview:SetText("")
                    preview:SetText(txt)
                end
                info.checked = (FontMagicDB.selectedFont == grp .. "/" .. fname)
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

local scaleSupported = GetCVar("WorldTextScale") ~= nil

if scaleSupported then
    slider:SetMinMaxValues(0.5, 5.0)
    slider:SetValueStep(0.1)
    slider:SetObeyStepOnDrag(true)
    _G[slider:GetName() .. "Low"]:SetText("0.5")
    _G[slider:GetName() .. "High"]:SetText("5.0")
else
    slider:Disable()
    scaleLabel:SetTextColor(0.5, 0.5, 0.5)
    _G[slider:GetName() .. "Low"]:SetText("")
    _G[slider:GetName() .. "High"]:SetText("")
end

local scaleValue = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
scaleValue:ClearAllPoints()
-- center the slider value text 2px above the bar
scaleValue:SetPoint("BOTTOM", slider, "TOP", 0, 2)

local function UpdateScale(val)
    if not scaleSupported then return end
    val = math.floor(val * 10 + 0.5) / 10
    SetCVar("WorldTextScale", tostring(val))
    scaleValue:SetText(string.format("%.1f", val))
end

if scaleSupported then
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
else
    scaleValue:SetText("|cff888888N/A|r")
    slider:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Not available in this version of WoW", nil, nil, nil, nil, true)
        GameTooltip:Show()
    end)
    slider:SetScript("OnLeave", GameTooltip_Hide)
end

-- 6) PREVIEW & EDIT ---------------------------------------------------------
preview = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
preview:ClearAllPoints()
preview:SetPoint("TOP", slider, "BOTTOM", 0, -20)
preview:SetWidth(PREVIEW_W)
preview:SetJustifyH("CENTER")
preview:SetText("12345")

-- Apply a default preview font. GameFontNormalLarge should normally exist,
-- but we fall back to the current FontObject if it does not to avoid errors.
SetPreviewFont(GameFontNormalLarge or preview:GetFontObject())

editBox = CreateFrame("EditBox", addonName .. "PreviewEdit", frame, "InputBoxTemplate")
editBox:SetSize(PREVIEW_W, 24)
editBox:ClearAllPoints()
editBox:SetPoint("TOP", preview, "BOTTOM", 0, -8)
editBox:SetAutoFocus(false)
editBox:SetText("12345")
editBox:SetScript("OnTextChanged", function(self) preview:SetText(self:GetText()) end)

-- 7) COMBAT OPTION CHECKBOXES ----------------------------------------------
local optionCheckboxes = {}
-- placeholders for incoming damage/healing checkboxes (Retail only)
local cbIncDam, cbIncHeal
local opts = {
    {k="combatHealing",  l="Show Combat Healing",  c="floatingCombatTextCombatHealing"},
    {k="combatDamage",   l="Show Combat Damage",   c="floatingCombatTextCombatDamage"},
    {k="petDamage",      l="Show Pet Damage",      c="floatingCombatTextPetMeleeDamage"},
    -- Use the correct CVar so the option persists between sessions
    {k="periodicDamage", l="Show Periodic Damage", c="floatingCombatTextCombatLogPeriodicSpells"},
}
for i, opt in ipairs(opts) do
    local col = (i - 1) % 2
    local row = math.floor((i - 1) / 2)
    -- anchor checkboxes below the edit box to avoid overlap with the preview box
    -- align first column with the preview edit box
    local x = (col == 0) and 0 or (CB_COL_W + 16)
    local y = -16 - row * 30

    local cvarSupported = type(GetCVar) == "function" and GetCVar(opt.c) ~= nil
    local onClick
    if cvarSupported then
        onClick = function(self)
            FontMagicPCDB[opt.k] = self:GetChecked()
            if type(SetCVar) == "function" then
                SetCVar(opt.c, self:GetChecked() and "1" or "0")
            end
        end
    else
        onClick = nil
    end

    -- initially anchor at origin; we reposition immediately after
    local cb = CreateCheckbox(frame, opt.l, 0, 0, FontMagicPCDB[opt.k], onClick)
    cb:ClearAllPoints()
    cb:SetPoint("TOPLEFT", editBox, "BOTTOMLEFT", x, y)

    if not cvarSupported then
        -- grey out checkboxes for unsupported CVars so layout remains intact
        cb:Disable()
        if cb.text then
            cb.text:SetTextColor(0.5, 0.5, 0.5)
        end
    end

    optionCheckboxes[opt.k] = { box = cb, cvar = opt.c }
end

-- 8) APPLY & DEFAULT BUTTONS -----------------------------------------------
local applyBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
-- Match the width of the Default button for consistency
applyBtn:SetSize(100, 22)
-- Position slightly closer to the bottom border now that the
-- overall frame height has been reduced
-- keep the action buttons in place or slightly lower so they no longer
-- overlap the lowest checkboxes
applyBtn:SetPoint("BOTTOMLEFT", 16, 12)
applyBtn:SetText("Apply")
applyBtn:SetScript("OnClick", function()
    if FontMagicDB.selectedFont then
        -- Parse the saved "group/filename" entry using the last '/' so
        -- groups with slashes are handled correctly.  We then look up the
        -- actual folder path from COMBAT_FONT_GROUPS to avoid constructing an
        -- invalid path like "Movie/Game".
        local grp,fname = FontMagicDB.selectedFont:match("^(.*)/([^/]+)$")
        local path = grp and fname and COMBAT_FONT_GROUPS[grp]
                       and COMBAT_FONT_GROUPS[grp].path .. fname
        if path then
            -- assign to Blizzard globals only when they exist to avoid errors
            if type(DAMAGE_TEXT_FONT) == "string" then DAMAGE_TEXT_FONT = path end
            if type(COMBAT_TEXT_FONT)  == "string" then COMBAT_TEXT_FONT  = path end
        end
        -- Inform the user that the font choice has been saved but requires a
        -- full client restart to take effect. Reloading the UI alone is not
        -- sufficient because the combat text font is cached when the game
        -- launches.
        print("|cFF00FF00[FontMagic]|r Combat font saved. Please restart WoW to apply.")
        UIErrorsFrame:AddMessage("FontMagic: restart WoW to load the new font.", 1, 1, 0)
    else
        -- Default was chosen or no custom font selected; notify the user that
        -- the stock combat font has been restored.
        print("|cFF00FF00[FontMagic]|r Default Font Applied. Please restart WoW to apply.")
    end
end)

local defaultBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
defaultBtn:SetSize(100,22)
defaultBtn:SetPoint("LEFT", applyBtn, "RIGHT", 8, 0)
defaultBtn:SetText("Default")
defaultBtn:SetScript("OnClick", function()
    -- clear any previously selected custom font
    FontMagicDB.selectedFont = nil

    -- capture the currently applied font size and flags so the preview
    -- remains visually consistent when switching fonts
    local _, size, flags = preview:GetFont()
    size  = size  or 20
    flags = flags or ""

    -- Use the cached Blizzard fonts captured at load time instead of whatever
    -- the globals might currently contain (they could have been overwritten by
    -- a custom selection earlier in the session).
    local defaultPath = blizzDefaultDamageFont or blizzDefaultCombatFont

    -- restore the Blizzard globals so the next reload also uses the real
    -- default font instead of a previously saved custom path
    if blizzDefaultDamageFont and type(DAMAGE_TEXT_FONT) == "string" then
        DAMAGE_TEXT_FONT = blizzDefaultDamageFont
    end
    if blizzDefaultCombatFont and type(COMBAT_TEXT_FONT) == "string" then
        COMBAT_TEXT_FONT = blizzDefaultCombatFont
    end

    -- safely attempt to apply the default font.  pcall prevents Lua errors if
    -- the path is invalid or the font fails to load for any reason.
    if defaultPath then
        local ok = pcall(function()
            preview:SetFont(defaultPath, size, flags)
        end)
        if not ok then
            -- fall back to the UI font if SetFont fails for any reason
            SetPreviewFont(GameFontNormalLarge or preview:GetFontObject())
        end
    else
        -- if neither Blizzard global exists we simply use the UI font object
        SetPreviewFont(GameFontNormalLarge or preview:GetFontObject())
    end

    -- ensure the preview font string's height fits the applied font
    local _, applied = preview:GetFont()
    applied = applied or size
    preview:SetHeight(applied + math.ceil(applied * 0.4))

    -- refresh the preview text and reset UI controls
    preview:SetText(editBox:GetText())
    for _, dd in pairs(dropdowns) do
        UIDropDownMenu_SetText(dd, "Select Font")
    end
    slider:SetValue(1.0); UpdateScale(1.0)

    -- enable all combat text options since these represent the default state
    for k,data in pairs(optionCheckboxes) do
        data.box:SetChecked(true)
        FontMagicPCDB[k] = true
        if type(GetCVar) == "function" and type(SetCVar) == "function" and
           data.cvar and GetCVar(data.cvar) ~= nil then
            SetCVar(data.cvar, "1")
        end
    end

    if cbIncDam then
        cbIncDam:SetChecked(true)
    end
    FontMagicPCDB.incomingDamage = true
    if type(COMBAT_TEXT_TYPE_INFO) == "table" then
        COMBAT_TEXT_TYPE_INFO.DAMAGE       = originalInfo.DAMAGE
        COMBAT_TEXT_TYPE_INFO.DAMAGE_CRIT  = originalInfo.DAMAGE_CRIT
        COMBAT_TEXT_TYPE_INFO.SPELL_DAMAGE = originalInfo.SPELL_DAMAGE
        COMBAT_TEXT_TYPE_INFO.SPELL_DAMAGE_CRIT = originalInfo.SPELL_DAMAGE_CRIT
    end

    if cbIncHeal then
        cbIncHeal:SetChecked(true)
    end
    FontMagicPCDB.incomingHealing = true
    if type(COMBAT_TEXT_TYPE_INFO) == "table" then
        COMBAT_TEXT_TYPE_INFO.HEAL      = originalInfo.HEAL
        COMBAT_TEXT_TYPE_INFO.HEAL_CRIT = originalInfo.HEAL_CRIT
    end

    print("|cFF00FF00[FontMagic]|r Default Font Applied. Please restart WoW to apply.")
end)

-- 11) CLOSE BUTTON
local closeBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
closeBtn:SetSize(80, 24)
-- Align with the Apply button and use the reduced
-- bottom spacing
closeBtn:SetPoint("BOTTOMRIGHT", -16, 12)
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
    if FontMagicDB.selectedFont then
        -- parse using the last '/' to support group names that contain
        -- slashes (e.g. "Movie/Game").
        local grp,fname = FontMagicDB.selectedFont:match("^(.*)/([^/]+)$")
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

-- helper to position the minimap button at a specific angle
local function PositionMinimapButton(btn, angle)
    local a = math.rad(angle)
    local r = Minimap:GetWidth()/2 + 10
    btn:ClearAllPoints()
    btn:SetPoint("CENTER", Minimap, "CENTER", math.cos(a)*r, math.sin(a)*r)
end

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
    GameTooltip:SetText("Click to toggle FontMagic settings", 1, 1, 1)
    GameTooltip:Show()
end)
minimapButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- remember the last placed angle so we only update when needed
minimapButton.lastAngle = minimapButton.lastAngle or FontMagicDB.minimapAngle
-- place the button immediately rather than waiting for the first OnUpdate
PositionMinimapButton(minimapButton, minimapButton.lastAngle)

minimapButton:SetScript("OnUpdate", function(self)
    if self.isMoving then
        local mx, my = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        mx, my = mx / scale, my / scale
        local cx, cy = Minimap:GetCenter()
        local dx, dy = mx - cx, my - cy
        FontMagicDB.minimapAngle = math.deg(math.atan2(dy, dx))
    elseif self.lastAngle == FontMagicDB.minimapAngle then
        return -- nothing changed
    end
    self.lastAngle = FontMagicDB.minimapAngle
    PositionMinimapButton(self, self.lastAngle)
end)

-- 14) EVENT HANDLER SETUP ---------------------------------------------------
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:SetScript("OnEvent", function(self, event, name)
    if event == "ADDON_LOADED" and name == addonName then
        -- store Blizzard's default fonts before applying any custom path so we
        -- can revert the preview later even after the globals change
        if not blizzDefaultDamageFont and type(DAMAGE_TEXT_FONT) == "string" then
            blizzDefaultDamageFont = DAMAGE_TEXT_FONT
        end
        if not blizzDefaultCombatFont and type(COMBAT_TEXT_FONT) == "string" then
            blizzDefaultCombatFont = COMBAT_TEXT_FONT
        end

        -- apply saved checkbox states in case the frame was
        -- created before SavedVariables were available
        if cbIncDam then
            cbIncDam:SetChecked(FontMagicPCDB.incomingDamage)
        end
        if cbIncHeal then
            cbIncHeal:SetChecked(FontMagicPCDB.incomingHealing)
        end

        if InterfaceOptions_AddCategory then
            InterfaceOptions_AddCategory(frame)
        end

        if FontMagicDB.selectedFont then
            -- extract group and filename using the last '/' so that
            -- group names containing slashes are handled correctly
            local g,f = FontMagicDB.selectedFont:match("^(.*)/([^/]+)$")
            if g and f and dropdowns[g] and existsFonts[g] and existsFonts[g][f] then
                -- Reconstruct the absolute path using the group's folder path
                -- so that names like "Movie/Game" map correctly to the
                -- "MovieGame" directory.
                local fontPath = COMBAT_FONT_GROUPS[g].path .. f
                -- apply the font if the Blizzard globals are available
                if type(DAMAGE_TEXT_FONT) == "string" then DAMAGE_TEXT_FONT = fontPath end
                if type(COMBAT_TEXT_FONT)  == "string" then COMBAT_TEXT_FONT  = fontPath end
                local cache = cachedFonts[g] and cachedFonts[g][f]
                if cache then SetPreviewFont(cache) end
                preview:SetText(editBox:GetText())
                for grp,dd in pairs(dropdowns) do UIDropDownMenu_SetText(dd, "Select Font") end
                UIDropDownMenu_SetText(dropdowns[g], f:gsub("%.otf$",""):gsub("%.ttf$",""))
            end
        end
    elseif event == "ADDON_LOADED" and name == "Blizzard_CombatText" then
        -- record Blizzard's default font paths once the combat text addon is
        -- loaded; this guarantees the globals have been initialised before we
        -- possibly overwrite them with a custom selection
        if not blizzDefaultDamageFont and type(DAMAGE_TEXT_FONT) == "string" then
            blizzDefaultDamageFont = DAMAGE_TEXT_FONT
        end
        if not blizzDefaultCombatFont and type(COMBAT_TEXT_FONT) == "string" then
            blizzDefaultCombatFont = COMBAT_TEXT_FONT
        end

        -- snapshot Blizzard's default combat text type info now that it's loaded
        originalInfo = {}
        if type(COMBAT_TEXT_TYPE_INFO) == "table" then
            for k, v in pairs(COMBAT_TEXT_TYPE_INFO) do
                originalInfo[k] = v
            end
        end

        -- apply saved incoming damage/heal toggles only after the table exists
        if not FontMagicPCDB.incomingDamage and type(COMBAT_TEXT_TYPE_INFO) == "table" then
            COMBAT_TEXT_TYPE_INFO.DAMAGE       = nil
            COMBAT_TEXT_TYPE_INFO.DAMAGE_CRIT  = nil
            COMBAT_TEXT_TYPE_INFO.SPELL_DAMAGE = nil
            COMBAT_TEXT_TYPE_INFO.SPELL_DAMAGE_CRIT = nil
        end
        if not FontMagicPCDB.incomingHealing and type(COMBAT_TEXT_TYPE_INFO) == "table" then
            COMBAT_TEXT_TYPE_INFO.HEAL      = nil
            COMBAT_TEXT_TYPE_INFO.HEAL_CRIT = nil
        end

        -- only now add the options panel to interface options
        if InterfaceOptions_AddCategory then
            InterfaceOptions_AddCategory(frame)
        end

        -- Retail-only incoming damage/healing checkboxes
        do
            local newRow = math.floor(#opts/2)
            local baseX, baseY = 0, -16 - newRow*30

            cbIncDam = CreateCheckbox(frame, "Show Incoming Damage", 0, 0,
                FontMagicPCDB.incomingDamage, function(self)
                FontMagicPCDB.incomingDamage = self:GetChecked()
                if type(COMBAT_TEXT_TYPE_INFO) ~= "table" then return end
                if not self:GetChecked() then
                    COMBAT_TEXT_TYPE_INFO.DAMAGE       = nil
                    COMBAT_TEXT_TYPE_INFO.DAMAGE_CRIT  = nil
                    COMBAT_TEXT_TYPE_INFO.SPELL_DAMAGE = nil
                    COMBAT_TEXT_TYPE_INFO.SPELL_DAMAGE_CRIT = nil
                else
                    COMBAT_TEXT_TYPE_INFO.DAMAGE       = originalInfo.DAMAGE
                    COMBAT_TEXT_TYPE_INFO.DAMAGE_CRIT  = originalInfo.DAMAGE_CRIT
                    COMBAT_TEXT_TYPE_INFO.SPELL_DAMAGE = originalInfo.SPELL_DAMAGE
                    COMBAT_TEXT_TYPE_INFO.SPELL_DAMAGE_CRIT = originalInfo.SPELL_DAMAGE_CRIT
                end
            end)
            cbIncDam:ClearAllPoints()
            cbIncDam:SetPoint("TOPLEFT", editBox, "BOTTOMLEFT", baseX, baseY)

            cbIncHeal = CreateCheckbox(frame, "Show Incoming Healing", 0, 0,
                FontMagicPCDB.incomingHealing, function(self)
                FontMagicPCDB.incomingHealing = self:GetChecked()
                if type(COMBAT_TEXT_TYPE_INFO) ~= "table" then return end
                if not self:GetChecked() then
                    COMBAT_TEXT_TYPE_INFO.HEAL      = nil
                    COMBAT_TEXT_TYPE_INFO.HEAL_CRIT = nil
                else
                    COMBAT_TEXT_TYPE_INFO.HEAL      = originalInfo.HEAL
                    COMBAT_TEXT_TYPE_INFO.HEAL_CRIT = originalInfo.HEAL_CRIT
                end
            end)
            cbIncHeal:ClearAllPoints()
            cbIncHeal:SetPoint("TOPLEFT", editBox, "BOTTOMLEFT", baseX + CB_COL_W + 16, baseY)
        end
    elseif event == "PLAYER_LOGOUT" then
        -- store the latest checkbox states on logout to ensure persistence
        if cbIncDam then
            FontMagicPCDB.incomingDamage = cbIncDam:GetChecked()
        end
        if cbIncHeal then
            FontMagicPCDB.incomingHealing = cbIncHeal:GetChecked()
        end
    end
end)
