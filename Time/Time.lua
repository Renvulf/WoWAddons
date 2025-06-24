--[[
  Time.lua
  Display a macOS-style clock in bottom-left with a seed icon and minimap icon,
  plus a tabbed settings panel with Clock Settings, Alarm, Quality of Life,
  Track, and Combat sections.
  Author: Renvulf

  IMPORTANT:
    Do NOT remove or omit any sections when updating this file:
      * Clock Settings Panel
      * Alarm Panel
      * Quality of Life Panel
      * Track Panel
      * Combat Panel
      * Combat Text Size Slider Section
    All changes should be additive and clearly marked.
--]]

local addonName, addonTable = ...    -- standard boilerplate
TimeDB = TimeDB or {}                -- global settings across characters
TimePerCharDB = TimePerCharDB or {}  -- per-character settings

-- ─── Combat Fonts Detection ──────────────────────────────────────────────────
local COMBAT_FONT_PATH = "Interface\\AddOns\\Time\\CombatFonts\\"
local MAX_COMBAT_FONTS  = 26

-- Store Blizzard’s original combat-text fonts so we can restore them
local ORIGINAL_DAMAGE_TEXT_FONT = _G["DAMAGE_TEXT_FONT"]
local ORIGINAL_COMBAT_TEXT_FONT = _G["COMBAT_TEXT_FONT"]

local combatFontCache   = {}
local combatFontExists  = {}
for i = 1, MAX_COMBAT_FONTS do
  local path = COMBAT_FONT_PATH .. i .. ".ttf"
  local f    = CreateFont(addonName .. "CombatFontCache" .. i)
  f:SetFont(path, 20, "")
  local loaded = f:GetFont()
  if loaded and loaded:lower():find(i .. ".ttf", 1, true) then
    combatFontExists[i] = true
    combatFontCache[i]  = f
  else
    combatFontExists[i] = false
  end
end

-- ─── Frame & Font Path ────────────────────────────────────────────────────────
local frame        = CreateFrame("Frame", "TimeFrame", UIParent)
local FONT_FOLDER  = "Interface\\AddOns\\Time\\ClockFonts\\"
local AVAILABLE_FONTS = {
  "SF-Pro-Regular",
  "Roboto",
  "Orbitron",
  "Monster",
  "Digital",
}

-- ─── Global Defaults ───────────────────────────────────────────────────────────
local DEFAULTS = {
  fontSize            = 20,
  showDate            = true,
  is24h               = false,
  showSeconds         = false,
  fontName            = "SF-Pro-Regular",
  fontColor           = {1,1,1,1},
  minimapAnchorPoint  = "TOPLEFT",
  minimapRelativePoint= "TOPLEFT",
  minimapX            = 0,
  minimapY            = 0,
  allowMove           = false,
  hideClock           = false,
  hideIcon            = false,
  alarmTime           = "",    -- Added default alarm time
  alarmReminder       = "",    -- Added default reminder text
  -- BEGIN TRACKING DEFAULTS
  trackSession        = false,
  trackDay            = false,
  trackWeek           = false,
  trackMonth          = false,
  trackYear           = false,
  trackTooltip        = false,
  dayDate             = "",    -- date identifier for daily tracking
  daySeconds          = 0,     -- accumulated seconds for current day
  weekID              = "",    -- week identifier for weekly tracking
  weekSeconds         = 0,     -- accumulated seconds for current week
  monthID             = "",    -- month identifier for current month
  monthSeconds        = 0,     -- accumulated seconds for current month
  yearID              = "",    -- year identifier for current year
  yearSeconds         = 0,     -- accumulated seconds for current year
  -- END TRACKING DEFAULTS
}
for k, v in pairs(DEFAULTS) do
  if TimeDB[k] == nil then TimeDB[k] = v end
end

-- ─── Per-Character QoL & Combat Defaults ──────────────────────────────────────
local PERCHAR_DEFAULTS = {
  hideTracker    = false,
  trackerScale   = 1,
  combatHealing  = tonumber(GetCVar("floatingCombatTextCombatHealing")) == 1,
  combatDamage   = tonumber(GetCVar("floatingCombatTextCombatDamage")) == 1,
  petDamage      = tonumber(GetCVar("floatingCombatTextPetMeleeDamage")) == 1,
  periodicDamage = tonumber(GetCVar("floatingCombatTextPeriodicDamage")) == 1,
  combatFont     = nil,  -- e.g. "3.ttf"
}
for k, v in pairs(PERCHAR_DEFAULTS) do
  if TimePerCharDB[k] == nil then TimePerCharDB[k] = v end
end

-- ─── Preload All Clock Fonts ─────────────────────────────────────────────────
-- must come *after* DEFAULTS so TimeDB.fontSize is valid
for _, fname in ipairs(AVAILABLE_FONTS) do
  local path = FONT_FOLDER .. fname .. ".ttf"
  local preloadFont = CreateFont(addonName.."PreloadFont"..fname)
  preloadFont:SetFont(path, TimeDB.fontSize, "")  -- empty-string flags
end

-- ─── Helper: format seconds as "Xh Ym" ────────────────────────────────────────
function frame:FormatSeconds(sec)
  local h = math.floor(sec / 3600)
  local m = math.floor((sec % 3600) / 60)
  return string.format("%dh %dm", h, m)
end

-- Small utility to create a checkbutton with sane defaults
local function CreateCheckbox(parent, name, label, x, y, checked, onClick, onEnter, onLeave, relativeTo, relativePoint, point)
  local cb = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
  point = point or "TOPLEFT"
  relativePoint = relativePoint or point
  relativeTo = relativeTo or parent
  cb:SetPoint(point, relativeTo, relativePoint, x, y)
  cb.text:SetText(label)
  cb:SetChecked(checked)
  if onClick then cb:SetScript("OnClick", onClick) end
  if onEnter then cb:SetScript("OnEnter", onEnter) end
  if onLeave then cb:SetScript("OnLeave", onLeave) end
  return cb
end

-- ─── Clock Core ───────────────────────────────────────────────────────────────
function frame:RestartTicker()
  if self.ticker then self.ticker:Cancel() end
  local interval = TimeDB.showSeconds and 1 or 60
  self.ticker = C_Timer.NewTicker(interval, function() self:UpdateTime() end)
end

function frame:UpdateTime()
  local parts = {}
  if TimeDB.showDate then
    tinsert(parts, date("%a"))
    tinsert(parts, date("%b"))
    tinsert(parts, tostring(tonumber(date("%e"))))
  end

  local hr  = TimeDB.is24h and date("%H") or date("%I"):gsub("^0","")
  local min = date("%M")

  if TimeDB.showSeconds then
    tinsert(parts, ("%s:%s:%s"):format(hr, min, date("%S")))
  else
    tinsert(parts, ("%s:%s"):format(hr, min))
  end

  if not TimeDB.is24h then
    tinsert(parts, date("%p"))
  end

  self.fs:SetText(table.concat(parts, " "))
end

function frame:ApplySettings()
  if TimeDB.fontSize < 15 then TimeDB.fontSize = 15 end

  local fontFile = FONT_FOLDER .. (TimeDB.fontName or DEFAULTS.fontName) .. ".ttf"

  -- ── BEGIN FIX: Apply font and force redraw immediately ───────────────────
  -- Safely set the new font, then clear & re‐set the text to force the UI to redraw
  pcall(self.fs.SetFont, self.fs, fontFile, TimeDB.fontSize, "")
  local currentText = self.fs:GetText()
  self.fs:SetText("")                -- clear the text
  self.fs:SetText(currentText)       -- reset it, forcing an immediate redraw
  -- ── END FIX ─────────────────────────────────────────────────────────────

  local c = TimeDB.fontColor
  if type(c)~="table" or #c<4 then c={1,1,1,1}; TimeDB.fontColor=c end
  self.fs:SetTextColor(unpack(c))
  if self.icon then self.icon:SetVertexColor(unpack(c)) end

  local iconSize = TimeDB.fontSize * 2
  local gap      = -10
  local descent  = -math.floor(TimeDB.fontSize * 0.19)
  local pad      = 10

  self.fs:ClearAllPoints()
  self.fs:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", iconSize + gap, 0)

  if self.icon then
    self.icon:SetSize(iconSize, iconSize)
    self.icon:ClearAllPoints()
    self.icon:SetPoint("BOTTOMRIGHT", self.fs, "BOTTOMLEFT", -gap, descent)
  end

  local textWidth = self.fs:GetStringWidth()
  frame:SetSize(iconSize + gap + textWidth + pad, iconSize + pad)

  if TimeDB.hideClock then self.fs:Hide() else self.fs:Show() end
  if self.icon then
    if TimeDB.hideIcon or TimeDB.hideClock then self.icon:Hide() else self.icon:Show() end
  end

  self:RestartTicker()
  self:UpdateTime()
end

-- ─── Draggable / Click-Through Logic ──────────────────────────────────────────
function frame:ApplyMoveSettings()
  frame:ClearAllPoints()
  if TimeDB.positionPoint then
    frame:SetPoint(TimeDB.positionPoint, UIParent,
                   TimeDB.positionRelPoint, TimeDB.positionX, TimeDB.positionY)
  else
    frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 10, 10)
  end

  if frame.fs then frame.fs:EnableMouse(false) end
  if frame.icon then frame.icon:EnableMouse(false) end

  if TimeDB.allowMove then
    frame:EnableMouse(true); frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", function(self)
      self:StopMovingOrSizing()
      local p,_,rp,x,y = self:GetPoint()
      TimeDB.positionPoint    = p
      TimeDB.positionRelPoint = rp
      TimeDB.positionX        = x
      TimeDB.positionY        = y
    end)

    if frame.iconButton then
      -- BEGIN FIX: Ensure iconButton drives the frame move when toggled
      frame.iconButton:SetMovable(true)
      frame.iconButton:RegisterForDrag("LeftButton")
      frame.iconButton:SetScript("OnDragStart", function(self)
        frame:StartMoving()
      end)
      frame.iconButton:SetScript("OnDragStop", function(self)
        frame:StopMovingOrSizing()
        local p,_,rp,x,y = frame:GetPoint()
        TimeDB.positionPoint    = p
        TimeDB.positionRelPoint = rp
        TimeDB.positionX        = x
        TimeDB.positionY        = y
      end)
      -- END FIX
    end
  else
    frame:EnableMouse(false); frame:SetMovable(false)
    frame:RegisterForDrag(); frame:SetScript("OnDragStart", nil)
    frame:SetScript("OnDragStop",  nil)
    if frame.iconButton then
      -- BEGIN FIX: Disable movable on iconButton when dragging is disallowed
      frame.iconButton:SetMovable(false)
      frame.iconButton:RegisterForDrag()
      frame.iconButton:SetScript("OnDragStart", nil)
      frame.iconButton:SetScript("OnDragStop", nil)
      -- END FIX
    end
  end
end

-- ─── Minimap Icon ────────────────────────────────────────────────────────────
function frame:CreateMinimapIcon()
  if self.minimapIcon then return end
  local f = self

  local icon = CreateFrame("Button", "TimeMinimapButton", Minimap)
  icon:SetSize(32,32)
  icon:ClearAllPoints()
  icon:SetPoint(TimeDB.minimapAnchorPoint, Minimap, TimeDB.minimapRelativePoint, TimeDB.minimapX, TimeDB.minimapY)
  local t = icon:CreateTexture(nil,"BACKGROUND")
  t:SetTexture("Interface\\AddOns\\Time\\TimeiconMM.png")
  t:SetAllPoints(icon)
  icon.texture = t
  icon:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
  icon:RegisterForClicks("AnyUp")
  icon:SetScript("OnClick", function(_,btn)
    if btn=="LeftButton" then f:ToggleSettings() else print(addonName..": Left-click to open settings.") end
  end)
  icon:SetMovable(true); icon:EnableMouse(true)
  icon:RegisterForDrag("LeftButton")
  icon:SetScript("OnDragStart", function(self)
    self:LockHighlight()
    self:SetScript("OnUpdate", function(self)
      local mx,my = Minimap:GetCenter()
      local scale = Minimap:GetEffectiveScale()
      local cx,cy = GetCursorPosition()
      local dx,dy = (cx/scale-mx),(cy/scale-my)
      local angle  = math.atan2(dy, dx)
      local radius = Minimap:GetWidth()/2 + 10
      self:ClearAllPoints()
      self:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle)*radius, math.sin(angle)*radius)
    end)
  end)
  icon:SetScript("OnDragStop", function(self)
    self:UnlockHighlight()
    self:SetScript("OnUpdate", nil)
    local p,_,rp,x,y = self:GetPoint()
    TimeDB.minimapAnchorPoint   = p
    TimeDB.minimapRelativePoint = rp
    TimeDB.minimapX             = x
    TimeDB.minimapY             = y
  end)

  -- BEGIN MINIMAP ICON HOVER TOOLTIP
  icon:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine("Settings")
    GameTooltip:Show()
  end)
  icon:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)
  -- END MINIMAP ICON HOVER TOOLTIP

  self.minimapIcon = icon
end

-- ─── QoL Settings ───────────────────────────────────────────────────────────
function frame:ApplyQoLSettings()
  if TimePerCharDB.hideTracker then ObjectiveTrackerFrame:Hide() else ObjectiveTrackerFrame:Show() end
  ObjectiveTrackerFrame:SetScale(TimePerCharDB.trackerScale or 1)
end

-- ─── Combat Settings ─────────────────────────────────────────────────────────
function frame:ApplyCombatSettings()
  local opts = {
    {key="combatHealing",  cvar="floatingCombatTextCombatHealing"},
    {key="combatDamage",   cvar="floatingCombatTextCombatDamage"},
    {key="petDamage",      cvar="floatingCombatTextPetMeleeDamage"},
    {key="periodicDamage", cvar="floatingCombatTextPeriodicDamage"},
  }
  for _,o in ipairs(opts) do
    if TimePerCharDB[o.key] ~= nil then
      SetCVar(o.cvar, TimePerCharDB[o.key] and 1 or 0)
    end
  end
  if TimePerCharDB.combatFont then
    local fontFile = COMBAT_FONT_PATH .. TimePerCharDB.combatFont
    _G["DAMAGE_TEXT_FONT"] = fontFile
    _G["COMBAT_TEXT_FONT"]  = fontFile
  end
end

-- ─── Combat Font Persistence ─────────────────────────────────────────────────
function frame:ADDON_LOADED(event, addon)
  if addon == addonName then
    self:ApplyCombatSettings()
  end
end

-- ─── Alarm Handling ───────────────────────────────────────────────────────────
function frame:StartAlarm()
  if self.alarmPlaying then return end

  -- Silence music so alarm is clear
  local prevMusic = GetCVar("Sound_EnableMusic")
  if prevMusic == "1" then
    SetCVar("Sound_EnableMusic", "0")
    self.prevMusicEnabled = prevMusic
  else
    self.prevMusicEnabled = nil
  end

  -- Play alarm sound
  local path = "Interface\\AddOns\\Time\\Alarm\\1.ogg"
  local handle
  if C_Sound and C_Sound.PlaySoundFile then
    handle = C_Sound.PlaySoundFile(path, "Master")
  elseif PlaySoundFile then
    local _, soundHandle = PlaySoundFile(path, "Master")
    handle = soundHandle
  else
    handle = PlaySound(SOUNDKIT.RAID_WARNING, "Master")
  end

  self.alarmSound   = handle
  self.alarmPlaying = true

  -- Create or show full-screen overlay
  if not self.alarmFrame then
    local overlay = CreateFrame("Frame", addonName.."AlarmOverlay", UIParent)
    overlay:SetAllPoints(UIParent)
    overlay:SetFrameStrata("DIALOG")
    overlay:EnableMouse(true)
    overlay:EnableKeyboard(true)
    overlay:SetPropagateKeyboardInput(false)
    overlay:SetScript("OnMouseDown", function() frame:StopAlarm() end)
    overlay:SetScript("OnKeyDown",   function() frame:StopAlarm() end)
    self.alarmFrame = overlay
  else
    self.alarmFrame:Show()
  end

  -- ── BEGIN FIX ─────────────────────────────────────────
  -- Ensure the clock ticker remains active and immediately update,
  -- so the time display never freezes while the alarm overlay is shown.
  self:RestartTicker()
  self:UpdateTime()
  -- ── END FIX ───────────────────────────────────────────

  -- Create or update the reminder text
  if not self.alarmText then
    local text = self.alarmFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    text:ClearAllPoints()
    text:SetPoint("CENTER", self.alarmFrame, "CENTER", 0, 0)
    text:SetJustifyH("CENTER")
    text:SetJustifyV("MIDDLE")
    text:SetWidth(1000)
    local reminderFontSize = (TimeDB.fontSize or DEFAULTS.fontSize) * 2
    text:SetFont(STANDARD_TEXT_FONT, reminderFontSize, "OUTLINE")
    self.alarmText = text
  else
    local reminderFontSize = (TimeDB.fontSize or DEFAULTS.fontSize) * 2
    self.alarmText:SetFont(STANDARD_TEXT_FONT, reminderFontSize, "OUTLINE")
  end

  self.alarmText:SetText(TimeDB.alarmReminder or "")
  self.alarmText:Show()

  -- Animate the reminder text color and position
  if self.alarmAnimTicker then self.alarmAnimTicker:Cancel() end
  local animAngle = 0
  self.alarmAnimTicker = C_Timer.NewTicker(0.05, function()
    animAngle = animAngle + math.pi * 0.1
    local r = (math.sin(animAngle) + 1) / 2
    local g = (math.sin(animAngle + 2 * math.pi / 3) + 1) / 2
    local b = (math.sin(animAngle + 4 * math.pi / 3) + 1) / 2
    self.alarmText:SetTextColor(r, g, b, 1)
    local yOffset = math.sin(animAngle * 2) * 20
    self.alarmText:ClearAllPoints()
    self.alarmText:SetPoint("CENTER", self.alarmFrame, "CENTER", 0, yOffset)
  end)
end

function frame:StopAlarm()
  -- Stop the sound
  if self.alarmSound then
    if C_Sound and C_Sound.StopSoundFile then
      C_Sound.StopSoundFile(self.alarmSound)
    elseif C_Sound and C_Sound.StopSound then
      C_Sound.StopSound(self.alarmSound)
    elseif StopSoundFile then
      StopSoundFile(self.alarmSound)
    elseif StopSound then
      StopSound(self.alarmSound)
    end
    self.alarmSound = nil
  end

  -- Stop animation ticker
  if self.alarmAnimTicker then
    self.alarmAnimTicker:Cancel()
    self.alarmAnimTicker = nil
  end

  -- Restore music setting
  if self.prevMusicEnabled == "1" then
    SetCVar("Sound_EnableMusic", "1")
    self.prevMusicEnabled = nil
  end

  self.alarmPlaying = false
  if self.alarmText  then self.alarmText:Hide() end
  if self.alarmFrame then self.alarmFrame:Hide() end
  TimeDB.alarmTime = ""
end

-- ─── Alarm Polling ────────────────────────────────────────────────────────────
function frame:CheckAlarm()
  if not TimeDB.alarmTime or TimeDB.alarmTime == "" or self.alarmPlaying then
    return
  end
  local t = date("%H:%M")
  if t == TimeDB.alarmTime then
    self:StartAlarm()
  end
end

-- ─── Settings Panel & Tabs ──────────────────────────────────────────────────
function frame:ToggleSettings()
  if not self.settingsFrame then self:CreateSettingsFrame() end
  if self.settingsFrame:IsShown() then
    self.settingsFrame:Hide()
    self.settingsOverlay:Hide()
  else
    self.settingsOverlay:Show()
    self.settingsFrame:Show()
  end
end

function frame:CreateSettingsFrame()
  local f = CreateFrame("Frame","TimeSettingsFrame",UIParent,"BackdropTemplate")
  f:SetSize(360,500)
  f:SetPoint("CENTER")
  f:SetMovable(true); f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart",f.StartMoving)
  f:SetScript("OnDragStop",f.StopMovingOrSizing)
  f:SetBackdrop({
    bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile     = true, tileSize=32, edgeSize=16,
    insets   = {8,8,8,8},
  })
  f:SetFrameStrata("DIALOG"); f:Hide()
  tinsert(UISpecialFrames, f:GetName())

  local overlay = CreateFrame("Frame","TimeSettingsOverlay",UIParent)
  overlay:SetAllPoints(UIParent)
  overlay:EnableMouse(true)
  overlay:SetFrameStrata("HIGH")
  overlay:SetScript("OnMouseDown", function(self) f:Hide(); self:Hide() end)
  overlay:Hide()

  local title = f:CreateFontString(nil,"OVERLAY","GameFontHighlightLarge")
  title:SetPoint("TOP",0,-12)
  title:SetText("Settings")

  local panels = {}
  for i=1,5 do
    local p = CreateFrame("Frame",f:GetName().."Panel"..i,f)
    p:SetAllPoints(f)
    p:Hide()
    panels[i] = p
  end

  local tabInfo = {
    {text="Clock Settings", panel=panels[1]},
    {text="Alarm",          panel=panels[2]},
    {text="Quality of Life",panel=panels[3]},
    {text="Track",          panel=panels[4]},
    {text="Combat",         panel=panels[5]},
  }

  for i,info in ipairs(tabInfo) do
    local tab = CreateFrame("Button",f:GetName().."Tab"..i,f,"UIPanelButtonTemplate")
    tab:SetSize(110,25)
    tab:SetText(info.text)
    local row = math.floor((i-1)/3)
    local col = (i-1)%3
    tab:SetPoint("TOPLEFT", f, "TOPLEFT", 10 + col*115, -40 - row*30)
    tab:SetScript("OnClick", function()
      for _,p in ipairs(panels) do p:Hide() end
      info.panel:Show()
      for j=1,#tabInfo do
        local other = _G[f:GetName().."Tab"..j]
        if j==i then other:LockHighlight() else other:UnlockHighlight() end
      end
    end)
  end

  panels[1]:Show()
  _G[f:GetName().."Tab1"]:LockHighlight()

  -- Clock Settings Panel
  do
    local p = panels[1]
    -- Font Size Slider
    local fs = CreateFrame("Slider","TimeFontSizeSlider",p,"OptionsSliderTemplate")
    fs:SetPoint("TOPLEFT",20,-110)
    fs:SetMinMaxValues(15,48); fs:SetValueStep(1); fs:SetWidth(300)
    fs:SetValue(TimeDB.fontSize)
    fs:SetScript("OnValueChanged",function(self,v)
      TimeDB.fontSize = v
      _G[self:GetName().."Text"]:SetText("Font Size: "..math.floor(v))
      frame:ApplySettings()
    end)
    _G["TimeFontSizeSliderLow"]:SetText("15")
    _G["TimeFontSizeSliderHigh"]:SetText("48")
    _G["TimeFontSizeSliderText"]:SetText("Font Size: "..TimeDB.fontSize)

    -- Show Date Checkbox
    local sd = CreateCheckbox(p, "TimeShowDateCB", "Show Date", 20, -160, TimeDB.showDate, function(self)
      TimeDB.showDate = self:GetChecked()
      frame:ApplySettings()
    end)

    -- 24h Format Checkbox
    local h24 = CreateCheckbox(p, "Time24hCB", "24h Format", 160, -160, TimeDB.is24h, function(self)
      TimeDB.is24h = self:GetChecked()
      frame:ApplySettings()
    end)

    -- Show Seconds Checkbox
    local ss = CreateCheckbox(p, "TimeShowSecCB", "Show Seconds", 20, -190, TimeDB.showSeconds, function(self)
      TimeDB.showSeconds = self:GetChecked()
      frame:ApplySettings()
    end)

    -- Color Picker Button
    local cb = CreateFrame("Button","TimeColorButton",p,"UIPanelButtonTemplate")
    cb:SetSize(100,22)
    cb:SetPoint("TOPLEFT",160,-190)
    cb:SetText("Font Color")
    cb:SetScript("OnClick",function()
      if LoadAddOn then LoadAddOn("Blizzard_ColorPicker") end
      local oR,oG,oB,oA = unpack(TimeDB.fontColor)
      local function live()
        local r,g,b = ColorPickerFrame:GetColorRGB()
        TimeDB.fontColor = {r,g,b,oA}
        frame.fs:SetTextColor(r,g,b,oA)
        if frame.icon then frame.icon:SetVertexColor(r,g,b,oA) end
      end
      local function cancel()
        TimeDB.fontColor = {oR,oG,oB,oA}
        frame.fs:SetTextColor(oR,oG,oB,oA)
        if frame.icon then frame.icon:SetVertexColor(oR,oG,oB,oA) end
      end
      ColorPickerFrame.func        = live
      ColorPickerFrame.swatchFunc  = live
      ColorPickerFrame.cancelFunc  = cancel
      ColorPickerFrame.hasOpacity  = false
      local sw = _G[ColorPickerFrame:GetName().."ColorSwatch"]
      if sw then sw:SetVertexColor(oR,oG,oB) end
      ShowUIPanel(ColorPickerFrame)
    end)

    -- Clock Font Dropdown
    local fontDropdown = CreateFrame("Frame", "TimeFontDropdown", p, "UIDropDownMenuTemplate")
    fontDropdown:SetPoint("TOPLEFT", 20, -250)
    UIDropDownMenu_SetWidth(fontDropdown, 150)
    UIDropDownMenu_Initialize(fontDropdown, function(self, level)
      for _, fname in ipairs(AVAILABLE_FONTS) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = fname
        info.value = fname
        info.func = function(self)
          TimeDB.fontName = self.value
          UIDropDownMenu_SetSelectedValue(fontDropdown, self.value)
          UIDropDownMenu_SetText(fontDropdown, self.value)
          -- BEGIN FIX: use unified ApplySettings for immediate redraw
          frame:ApplySettings()
          -- END FIX
        end
        info.checked = (TimeDB.fontName == fname)
        UIDropDownMenu_AddButton(info)
      end
    end)
    local ddLabel = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    ddLabel:SetPoint("BOTTOMLEFT", fontDropdown, "TOPLEFT", 0, 2)
    ddLabel:SetText("Clock Font")
    UIDropDownMenu_SetSelectedValue(fontDropdown, TimeDB.fontName)
    UIDropDownMenu_SetText(fontDropdown, TimeDB.fontName)

    hooksecurefunc("UIDropDownMenu_SetSelectedValue", function(self, value)
      if self == fontDropdown then
        TimeDB.fontName = value
        frame:ApplySettings()
      end
    end)

    local startY = -290
    local spacing = 25

    -- Move Clock Checkbox
    local mv = CreateCheckbox(p, "TimeAllowMoveCB", "Tick to move clock", 20, startY, TimeDB.allowMove,
      function(self)
        TimeDB.allowMove = self:GetChecked()
        frame:ApplyMoveSettings()
      end,
      function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Tick to enable dragging; untick for click-through", 1,1,1)
        GameTooltip:Show()
      end,
      function() GameTooltip:Hide() end
    )

    -- Hide Clock Checkbox
    local hc = CreateCheckbox(p, "TimeHideClockCB", "Tick to hide clock", 20, startY - spacing, TimeDB.hideClock, function(self)
      TimeDB.hideClock = self:GetChecked()
      frame:ApplySettings()
    end)

    -- Hide Icon Checkbox
    local hi = CreateCheckbox(p, "TimeHideIconCB", "Tick to hide icon", 20, startY - 2*spacing, TimeDB.hideIcon, function(self)
      TimeDB.hideIcon = self:GetChecked()
      frame:ApplySettings()
    end)

    -- Reset Defaults Button
    local rb = CreateFrame("Button","TimeResetButton",p,"UIPanelButtonTemplate")
    rb:SetSize(120,22)
    rb:SetPoint("BOTTOM",p,"BOTTOM",0,20)
    rb:SetText("Default")
    rb:SetScript("OnClick",function()
      -- BEGIN MOD: Preserve tracking values when resetting defaults
      for k, v in pairs(DEFAULTS) do
        -- skip all tracking-related keys to keep tracked data intact
        if not (
          k:match("^trackSession") or
          k:match("^trackDay") or
          k:match("^trackWeek") or
          k:match("^trackMonth") or
          k:match("^trackYear") or
          k == "trackTooltip" or
          k == "dayDate" or
          k == "daySeconds" or
          k == "weekID" or
          k == "weekSeconds" or
          k == "monthID" or
          k == "monthSeconds" or
          k == "yearID" or
          k == "yearSeconds"
        ) then
          TimeDB[k] = v
        end
      end
      -- END MOD

      TimeDB.positionPoint = nil; TimeDB.positionRelPoint = nil; TimeDB.positionX = nil; TimeDB.positionY = nil

      fs:SetValue(TimeDB.fontSize)
      sd:SetChecked(TimeDB.showDate)
      h24:SetChecked(TimeDB.is24h)
      ss:SetChecked(TimeDB.showSeconds)
      UIDropDownMenu_SetSelectedValue(fontDropdown, TimeDB.fontName)
      UIDropDownMenu_SetText(fontDropdown, TimeDB.fontName)
      mv:SetChecked(TimeDB.allowMove)
      hc:SetChecked(TimeDB.hideClock)
      hi:SetChecked(TimeDB.hideIcon)

      frame:ApplySettings()
      frame:ApplyMoveSettings()

      for k,v in pairs(PERCHAR_DEFAULTS) do TimePerCharDB[k] = v end
      frame:ApplyQoLSettings()

      TimePerCharDB.combatFont = nil
      _G["DAMAGE_TEXT_FONT"] = ORIGINAL_DAMAGE_TEXT_FONT
      _G["COMBAT_TEXT_FONT"] = ORIGINAL_COMBAT_TEXT_FONT
      frame:ApplyCombatSettings()

      SetCVar("WorldTextScale", "1.0")
      local csSlider = _G[addonName.."CombatScaleSlider"]
      if csSlider then csSlider:SetValue(1.0) end
      local csValue = _G[addonName.."CombatScaleValue"]
      if csValue then csValue:SetText("1.0") end

      local cfd = _G[addonName.."CombatFontDropdown"]
      if cfd then
        UIDropDownMenu_SetSelectedValue(cfd, nil)
        UIDropDownMenu_SetText(cfd, "Select Font")
      end
    end)
  end

  -- Alarm Panel
  do
    local p = panels[2]
    local timeLabel = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    timeLabel:SetPoint("TOPLEFT", 20, -110)
    timeLabel:SetText("Alarm Time (HH:MM):")

    local timeEdit = CreateFrame("EditBox", addonName.."AlarmTimeBox", p, "InputBoxTemplate")
    timeEdit:SetSize(100, 24)
    timeEdit:SetPoint("TOPLEFT", timeLabel, "BOTTOMLEFT", 0, -4)
    timeEdit:SetAutoFocus(false)
    timeEdit:SetText(TimeDB.alarmTime or "")

    local ampmDropdown = CreateFrame("Frame", addonName.."AlarmAMPMDropdown", p, "UIDropDownMenuTemplate")
    ampmDropdown:SetPoint("LEFT", timeEdit, "RIGHT", 10, 0)
    UIDropDownMenu_SetWidth(ampmDropdown, 60)
    UIDropDownMenu_Initialize(ampmDropdown, function(self, level)
      local info = UIDropDownMenu_CreateInfo()
      info.text = "AM"
      info.value = "AM"
      info.func = function(self) UIDropDownMenu_SetSelectedValue(ampmDropdown, self.value) end
      info.checked = UIDropDownMenu_GetSelectedValue(ampmDropdown) == "AM"
      UIDropDownMenu_AddButton(info)

      info = UIDropDownMenu_CreateInfo()
      info.text = "PM"
      info.value = "PM"
      info.func = function(self) UIDropDownMenu_SetSelectedValue(ampmDropdown, self.value) end
      info.checked = UIDropDownMenu_GetSelectedValue(ampmDropdown) == "PM"
      UIDropDownMenu_AddButton(info)
    end)
    UIDropDownMenu_SetSelectedValue(ampmDropdown, nil)
    UIDropDownMenu_SetText(ampmDropdown, "")

    local function validateAndSetAlarm()
      local val = timeEdit:GetText()
      local h, m = val:match("^(%d?%d):(%d%d)$")
      if not h then
        print(addonName..": Invalid time format. Use HH:MM.")
        return
      end
      h = tonumber(h); m = tonumber(m)
      if m < 0 or m > 59 then
        print(addonName..": Invalid minutes. Must be 00-59.")
        return
      end
      local sel = UIDropDownMenu_GetSelectedValue(ampmDropdown)
      if sel then
        if h < 1 or h > 12 then
          print(addonName..": Invalid hour for 12h format. Use 1-12.")
          return
        end
        if sel == "AM" then
          if h == 12 then h = 0 end
        else
          if h < 12 then h = h + 12 end
        end
      else
        if h < 0 or h > 23 then
          print(addonName..": Invalid hour for 24h format. Use 0-23.")
          return
        end
      end
      TimeDB.alarmTime = string.format("%02d:%02d", h, m)
      print(addonName..": Alarm time set to "..TimeDB.alarmTime)
    end

    timeEdit:SetScript("OnEnterPressed", function(self)
      validateAndSetAlarm()
      self:ClearFocus()
    end)
    timeEdit:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    local remLabel = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    remLabel:SetPoint("TOPLEFT", timeEdit, "BOTTOMLEFT", 0, -12)
    remLabel:SetText("Reminder Text:")
    local remEdit = CreateFrame("EditBox", addonName.."AlarmReminderBox", p, "InputBoxTemplate")
    remEdit:SetSize(300, 24)
    remEdit:SetPoint("TOPLEFT", remLabel, "BOTTOMLEFT", 0, -4)
    remEdit:SetAutoFocus(false)
    remEdit:SetText(TimeDB.alarmReminder or "")
    remEdit:SetScript("OnEnterPressed", function(self)
      TimeDB.alarmReminder = self:GetText()
      print(addonName..": Reminder text set.")
      self:ClearFocus()
    end)
    remEdit:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    local setBtn = CreateFrame("Button", addonName.."AlarmSetBtn", p, "UIPanelButtonTemplate")
    setBtn:SetSize(80, 22)
    setBtn:SetPoint("TOPLEFT", remEdit, "BOTTOMLEFT", 0, -12)
    setBtn:SetText("Set Alarm")
    setBtn:SetScript("OnClick", function()
      validateAndSetAlarm()
      TimeDB.alarmReminder = remEdit:GetText()
      print(addonName..": Reminder text set to '"..TimeDB.alarmReminder.."'.")
    end)

    local clearBtn = CreateFrame("Button", addonName.."AlarmClearBtn", p, "UIPanelButtonTemplate")
    clearBtn:SetSize(80, 22)
    clearBtn:SetPoint("LEFT", setBtn, "RIGHT", 10, 0)
    clearBtn:SetText("Clear Alarm")
    clearBtn:SetScript("OnClick", function()
      TimeDB.alarmTime = ""
      TimeDB.alarmReminder = ""
      timeEdit:SetText("")
      remEdit:SetText("")
      UIDropDownMenu_SetSelectedValue(ampmDropdown, nil)
      UIDropDownMenu_SetText(ampmDropdown, "")
      print(addonName..": Alarm cleared.")
    end)
  end

  -- Quality of Life Panel
  do
    local p = panels[3]
    local ht = CreateCheckbox(p, "TimeHideTrackerCB", "Hide Objective Tracker", 20, -110, TimePerCharDB.hideTracker, function(self)
      TimePerCharDB.hideTracker = self:GetChecked()
      if self:GetChecked() then ObjectiveTrackerFrame:Hide() else ObjectiveTrackerFrame:Show() end
    end)

    local ts = CreateFrame("Slider","TimeTrackerSizeSlider",p,"OptionsSliderTemplate")
    ts:SetPoint("TOPLEFT",ht,"BOTTOMLEFT",0,-40)
    ts:SetMinMaxValues(0.5,2); ts:SetValueStep(0.05); ts:SetWidth(300)
    ts:SetValue(TimePerCharDB.trackerScale or 1)
    ts:SetScript("OnValueChanged",function(self,v)
      TimePerCharDB.trackerScale = v
      _G[self:GetName().."Text"]:SetText("Objective Tracker Scale: "..string.format("%.2f", v))
      ObjectiveTrackerFrame:SetScale(v)
    end)
    _G["TimeTrackerSizeSliderLow"]:SetText("0.5")
    _G["TimeTrackerSizeSliderHigh"]:SetText("2")
    _G["TimeTrackerSizeSliderText"]:SetText("Objective Tracker Scale: "..string.format("%.2f", (TimePerCharDB.trackerScale or 1)))
  end

  -- Track Panel
  do
    local p = panels[4]
    local trackingOptions = {
      { key = "trackSession", label = "Time played this session" },
      { key = "trackDay",     label = "Time played today" },
      { key = "trackWeek",    label = "Time played this week" },
      { key = "trackMonth",   label = "Time played this month" },
      { key = "trackYear",    label = "Time played this year" },
    }
    local startY = -110
    local spacing = 30

    for i, opt in ipairs(trackingOptions) do
      local cb = CreateCheckbox(p, addonName.."Track"..opt.key.."CB", opt.label, 20, startY - spacing * (i - 1), TimeDB[opt.key] or false, function(self)
        TimeDB[opt.key] = self:GetChecked()
      end)

      -- create value text next to each checkbox
      if opt.key == "trackSession" then
        local val = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        val:SetPoint("LEFT", cb.text, "RIGHT", 10, 0)
        frame.sessionValText = val
      elseif opt.key == "trackDay" then
        local val = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        val:SetPoint("LEFT", cb.text, "RIGHT", 10, 0)
        frame.dayValText = val
      elseif opt.key == "trackWeek" then
        local val = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        val:SetPoint("LEFT", cb.text, "RIGHT", 10, 0)
        frame.weekValText = val
      elseif opt.key == "trackMonth" then
        local val = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        val:SetPoint("LEFT", cb.text, "RIGHT", 10, 0)
        frame.monthValText = val
      elseif opt.key == "trackYear" then
        local val = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        val:SetPoint("LEFT", cb.text, "RIGHT", 10, 0)
        frame.yearValText = val
      end
    end

    local tooltipCB = CreateCheckbox(p, addonName.."TrackTooltipCB", "Show tracking info as tooltip on icon hover", 20, startY - spacing * #trackingOptions - 10, TimeDB.trackTooltip or false, function(self)
      TimeDB.trackTooltip = self:GetChecked()
    end)
  end

  -- Combat Panel
  do
    local p = panels[5]
    local fontLabel = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fontLabel:SetPoint("TOPLEFT", p, "TOPLEFT", 20, -110)
    fontLabel:SetText("Combat Text Font:")

    local dropdown = CreateFrame("Frame", addonName .. "CombatFontDropdown", p, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", fontLabel, "BOTTOMLEFT", 0, -6)
    UIDropDownMenu_SetWidth(dropdown, 180)

    local note = p:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    note:SetPoint("TOPLEFT", dropdown, "BOTTOMLEFT", 0, -4)
    note:SetText("Requires full game restart once applied to change font")

    local preview = p:CreateFontString(addonName.."CombatPreviewFS","OVERLAY","GameFontNormalLarge")
    preview:SetJustifyH("LEFT"); preview:SetJustifyV("MIDDLE")
    preview:SetPoint("TOPLEFT", note, "BOTTOMLEFT", 0, -12)
    preview:SetWidth(300)
    preview:SetText("12345")
    preview:SetTextColor(1,1,1,1)

    local function SetCombatPreviewFont(fontObj)
      preview:SetFontObject(fontObj)
      local _, size = preview:GetFont()
      local pad = math.ceil(size * 0.2)
      preview:SetHeight(size + pad*2)
    end

    local editBox = CreateFrame("EditBox", addonName.."CombatPreviewEdit", p, "InputBoxTemplate")
    editBox:SetSize(300, 24)
    editBox:SetPoint("TOPLEFT", preview, "BOTTOMLEFT", 0, -8)
    editBox:SetAutoFocus(false)
    editBox:SetText("12345")
    editBox:SetScript("OnTextChanged", function(self)
      preview:SetText(self:GetText())
    end)

    local applyBtn = CreateFrame("Button", addonName.."CombatApplyButton", p, "UIPanelButtonTemplate")
    applyBtn:SetSize(80,22)
    applyBtn:SetPoint("TOPLEFT", editBox, "BOTTOMLEFT", 0, -8)
    applyBtn:SetText("Apply")
    applyBtn:SetScript("OnClick", function()
      if TimePerCharDB.combatFont then
        print(addonName..": Combat text font saved. Requires full game restart once applied.")
        UIErrorsFrame:AddMessage(addonName..": please EXIT & RESTART WoW to apply.",1,1,0)
      else
        print(addonName..": No combat font selected.")
      end
    end)

    UIDropDownMenu_Initialize(dropdown, function(self, level)
      for i = 1, MAX_COMBAT_FONTS do
        if combatFontExists[i] then
          local info = UIDropDownMenu_CreateInfo()
          local fname = i .. ".ttf"
          info.text  = fname
          info.value = i
          info.func  = function(self)
            TimePerCharDB.combatFont = fname
            UIDropDownMenu_SetSelectedValue(dropdown, self.value)
            UIDropDownMenu_SetText(dropdown, fname)
            SetCombatPreviewFont(combatFontCache[self.value])
            preview:SetText(editBox:GetText())
          end
          info.checked = (TimePerCharDB.combatFont == fname)
          UIDropDownMenu_AddButton(info)
        end
      end
    end)

    if TimePerCharDB.combatFont then
      local idx = tonumber(TimePerCharDB.combatFont:match("^(%d+)"))
      if idx and combatFontExists[idx] then
        UIDropDownMenu_SetSelectedValue(dropdown, idx)
        UIDropDownMenu_SetText(dropdown, TimePerCharDB.combatFont)
        SetCombatPreviewFont(combatFontCache[idx])
      else
        UIDropDownMenu_SetText(dropdown, TimePerCharDB.combatFont)
      end
    else
      UIDropDownMenu_SetText(dropdown, "Select Font")
    end

    -- Combat Text Size Slider
    local sizeLabel = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    sizeLabel:SetPoint("TOPLEFT", applyBtn, "BOTTOMLEFT", 0, -20)
    sizeLabel:SetText("Combat Text Size:")

    local sizeSlider = CreateFrame("Slider", addonName.."CombatScaleSlider", p, "OptionsSliderTemplate")
    sizeSlider:SetSize(300, 16)
    sizeSlider:SetPoint("TOPLEFT", sizeLabel, "BOTTOMLEFT", 0, -8)
    sizeSlider:SetMinMaxValues(0.5, 5.0)
    sizeSlider:SetValueStep(0.1)
    sizeSlider:SetObeyStepOnDrag(true)
    _G[sizeSlider:GetName() .. "Low"]:SetText("0.5")
    _G[sizeSlider:GetName() .. "High"]:SetText("5.0")
    local sizeValue = p:CreateFontString(addonName.."CombatScaleValue", "OVERLAY", "GameFontHighlight")
    sizeValue:SetPoint("LEFT", sizeSlider, "RIGHT", 10, 0)

    local function UpdateCombatScale(val)
      val = math.floor(val * 10 + 0.5) / 10
      SetCVar("WorldTextScale", tostring(val))
      sizeValue:SetText(string.format("%.1f", val))
    end

    local currentScale = tonumber(GetCVar("WorldTextScale")) or 1.0
    sizeSlider:SetValue(currentScale)
    sizeValue:SetText(string.format("%.1f", currentScale))
    sizeSlider:SetScript("OnValueChanged", function(self,val) UpdateCombatScale(val) end)
    sizeSlider:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:AddLine("Drag to adjust combat text size",1,1,1)
      GameTooltip:Show()
    end)
    sizeSlider:SetScript("OnLeave", function() GameTooltip:Hide() end)

    local combatOpts = {
      {k="combatHealing",  l="Show Combat Healing",  c="floatingCombatTextCombatHealing"},
      {k="combatDamage",   l="Show Combat Damage",   c="floatingCombatTextCombatDamage"},
      {k="petDamage",      l="Show Pet Damage",      c="floatingCombatTextPetMeleeDamage"},
      {k="periodicDamage", l="Show Periodic Damage", c="floatingCombatTextPeriodicDamage"},
    }
    for i,opt in ipairs(combatOpts) do
      CreateCheckbox(p, "TimeCombat"..opt.k.."CB", opt.l, 0, -30 * i, TimePerCharDB[opt.k], function(self)
        TimePerCharDB[opt.k] = self:GetChecked()
        SetCVar(opt.c, self:GetChecked() and 1 or 0)
      end, nil, nil, sizeSlider, "BOTTOMLEFT")
    end
  end

  self.settingsFrame   = f
  self.settingsOverlay = overlay
end

-- ─── Slash Command ───────────────────────────────────────────────────────────
SLASH_TIME1 = "/time"
SlashCmdList["TIME"] = function() frame:ToggleSettings() end

-- ─── Initialization & Events ─────────────────────────────────────────────────
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT")

frame:SetScript("OnEvent", function(self, event, ...)
  if event == "PLAYER_LOGIN" then
    if not self.fs then
      -- Create clock text
      self.fs  = frame:CreateFontString(addonName.."Font","OVERLAY")
      self.fs:SetJustifyH("LEFT"); self.fs:SetJustifyV("BOTTOM")
      -- Create icon texture
      self.icon = frame:CreateTexture(addonName.."Icon","ARTWORK")
      self.icon:SetTexture("Interface\\AddOns\\Time\\Timeicon.tga")

      -- ─── NEW: Icon Button for tracking tooltip on hover ──────────────────
      self.iconButton = CreateFrame("Button", addonName.."IconButton", frame)
      self.iconButton:SetAllPoints(self.icon)
      -- Show tracking tooltip when hovering icon next to clock text
      self.iconButton:SetScript("OnEnter", function(btn)
        if TimeDB.trackTooltip then
          GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
          local now = time()
          local sessionElapsed = now - (frame.sessionStart or now)
          if TimeDB.trackSession then
            GameTooltip:AddLine("Session: " .. frame:FormatSeconds(sessionElapsed))
          end
          if TimeDB.trackDay then
            local dayTotal = (TimeDB.daySeconds or 0) + sessionElapsed
            GameTooltip:AddLine("Today: " .. frame:FormatSeconds(dayTotal))
          end
          if TimeDB.trackWeek then
            local weekTotal = (TimeDB.weekSeconds or 0) + sessionElapsed
            GameTooltip:AddLine("This Week: " .. frame:FormatSeconds(weekTotal))
          end
          if TimeDB.trackMonth then
            local monthTotal = (TimeDB.monthSeconds or 0) + sessionElapsed
            GameTooltip:AddLine("This Month: " .. frame:FormatSeconds(monthTotal))
          end
          if TimeDB.trackYear then
            local yearTotal = (TimeDB.yearSeconds or 0) + sessionElapsed
            GameTooltip:AddLine("This Year: " .. frame:FormatSeconds(yearTotal))
          end
          GameTooltip:Show()
        end
      end)
      self.iconButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
      self.iconButton:EnableMouse(true)
      -- ────────────────────────────────────────────────────────────────
    end

    self:ApplySettings()
    self:CreateMinimapIcon()
    self:ApplyQoLSettings()
    self:ApplyCombatSettings()
    self:ApplyMoveSettings()

    -- BEGIN TRACKING ENHANCEMENT: initialize session & periods
    local now = time()
    self.sessionStart = now

    local today = date("%Y-%m-%d")
    if TimeDB.dayDate ~= today then
      TimeDB.dayDate    = today
      TimeDB.daySeconds = 0
    end

    local weekID = date("%Y-%U")
    if TimeDB.weekID ~= weekID then
      TimeDB.weekID      = weekID
      TimeDB.weekSeconds = 0
    end

    local monthID = date("%Y-%m")
    if TimeDB.monthID ~= monthID then
      TimeDB.monthID      = monthID
      TimeDB.monthSeconds = 0
    end

    local yearID = date("%Y")
    if TimeDB.yearID ~= yearID then
      TimeDB.yearID      = yearID
      TimeDB.yearSeconds = 0
    end

    if self.trackTicker then self.trackTicker:Cancel() end
    self:UpdateTracking()
    self.trackTicker = C_Timer.NewTicker(1, function() self:UpdateTracking() end)
    -- END TRACKING ENHANCEMENT

    self.alarmChecker = C_Timer.NewTicker(1, function() self:CheckAlarm() end)
    self:UnregisterEvent("PLAYER_LOGIN")

  elseif event == "PLAYER_LOGOUT" then
    -- BEGIN TRACKING ENHANCEMENT: save session to accumulators
    local now = time()
    local elapsed = now - (self.sessionStart or now)
    TimeDB.daySeconds   = (TimeDB.daySeconds   or 0) + elapsed
    TimeDB.weekSeconds  = (TimeDB.weekSeconds  or 0) + elapsed
    TimeDB.monthSeconds = (TimeDB.monthSeconds or 0) + elapsed
    TimeDB.yearSeconds  = (TimeDB.yearSeconds  or 0) + elapsed
    if self.trackTicker then self.trackTicker:Cancel(); self.trackTicker = nil end
    if self.alarmChecker then self.alarmChecker:Cancel(); self.alarmChecker = nil end
    -- END TRACKING ENHANCEMENT

  else
    return self[event] and self[event](self, event, ...)
  end
end)

-- ─── UpdateTracking: refresh the value texts ────────────────────────────────
function frame:UpdateTracking()
  local now = time()
  local sessionElapsed = now - (self.sessionStart or now)

  if self.sessionValText then
    local txt = self:FormatSeconds(sessionElapsed)
    self.sessionValText:SetText(txt)
    self.sessionValText:SetShown(TimeDB.trackSession)
  end

  if self.dayValText then
    local dayTotal = (TimeDB.daySeconds or 0) + sessionElapsed
    self.dayValText:SetText(self:FormatSeconds(dayTotal))
    self.dayValText:SetShown(TimeDB.trackDay)
  end

  if self.weekValText then
    local weekTotal = (TimeDB.weekSeconds or 0) + sessionElapsed
    self.weekValText:SetText(self:FormatSeconds(weekTotal))
    self.weekValText:SetShown(TimeDB.trackWeek)
  end

  if self.monthValText then
    local monthTotal = (TimeDB.monthSeconds or 0) + sessionElapsed
    self.monthValText:SetText(self:FormatSeconds(monthTotal))
    self.monthValText:SetShown(TimeDB.trackMonth)
  end

  if self.yearValText then
    local yearTotal = (TimeDB.yearSeconds or 0) + sessionElapsed
    self.yearValText:SetText(self:FormatSeconds(yearTotal))
    self.yearValText:SetShown(TimeDB.trackYear)
  end
end
