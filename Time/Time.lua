# Time Addon

Time is a lightweight World of Warcraft addon that provides a customizable clock with a companion minimap button and configuration panel. It also tracks play time and allows you to configure combat text fonts.

## Features
- Movable clock display with configurable font, color and size
- Optional date, seconds, server time and hourly chime
- Alarm with custom reminder text and fullscreen notification
- Playtime tracking (session/day/week/month/year) shown in tooltips
- Quality of life options for the Objective Tracker
- Combat text configuration including font overrides
- Minimap button with drag repositioning
- **New:** LibDataBroker feed for compatibility with LDB displays

## Usage
Install the addon in your `Interface/AddOns` directory and type `/time` in game to open the settings window. Hover the minimap icon or the LDB entry to view tracked play time. Drag the clock or minimap icon while "Tick to move" is enabled.

## Commands
Use these chat commands for quick actions:

* `/time` – toggle the configuration window.
* `/alarm <minutes> [message]` – set an alarm that triggers after the specified number of minutes with optional reminder text.
* `/alarm <minutes> [message]` – set an alarm that triggers after the specified number of minutes with optional reminder text. Multiple alarms can be queued.
  * Example: `/alarm 10 Brew coffee`
* `/time remind me in <number>[s|m|h|d] <message>` – show a toast reminder after the specified delay.
  * Example: `/time remind me in 5m Check the auction house`

If an alarm triggers, a fullscreen overlay with your reminder text and an alarm sound will appear. Reminders created with the `remind me in` command appear as small toasts near the top‑right of the screen.
If an alarm triggers, a fullscreen overlay with your reminder text and an alarm sound will appear. Reminders created with the `remind me in` command appear as small toasts near the top‑right of the screen. Any alarms you create are listed under **Upcoming Alarms** in the settings window; click an entry there to cancel it.

## License
This project is released under the MIT License. See `LICENSE` for details.
Time/Time.lua
+157
-60

@@ -55,76 +55,92 @@ local AVAILABLE_FONTS = {
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
  -- RGB animation default
  rgbClock           = false,
  -- Wave animation default (formerly "bounce")
  waveClock          = false,
  minimapAnchorPoint  = "TOPLEFT",
  minimapRelativePoint= "TOPLEFT",
  minimapX            = 0,
  minimapY            = 0,
  allowMove           = false,
  hideClock           = false,
  hideIcon            = false,
  alarmTime           = "",    -- Added default alarm time
  alarmReminder       = "",    -- Added default reminder text
  alarmTimestamp      = 0,     -- epoch when relative alarm should trigger
  alarms             = {},    -- table of pending alarms
  -- BEGIN FEATURE: server time and hourly chime defaults
  useServerTime       = false,
  hourlyChime         = false,
  timezoneOffset      = 0, -- hours difference from local/server time
  -- END FEATURE
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

-- Migrate legacy single alarm fields to new alarm table
if TimeDB.alarms == nil then TimeDB.alarms = {} end
do
  local h, m = (TimeDB.alarmTime or ""):match("^(%d?%d):(%d%d)$")
  if h and m then
    table.insert(TimeDB.alarms, {hour = tonumber(h), min = tonumber(m), text = TimeDB.alarmReminder or ""})
  end
  if TimeDB.alarmTimestamp and TimeDB.alarmTimestamp > 0 then
    table.insert(TimeDB.alarms, {timestamp = TimeDB.alarmTimestamp, text = TimeDB.alarmReminder or ""})
  end
  TimeDB.alarmTime = ""
  TimeDB.alarmTimestamp = 0
  TimeDB.alarmReminder = ""
end

-- Backward compatibility: migrate old bounceClock setting to waveClock
if TimeDB.waveClock == nil and TimeDB.bounceClock ~= nil then
  TimeDB.waveClock = TimeDB.bounceClock
  TimeDB.bounceClock = nil
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
@@ -802,113 +818,170 @@ function frame:StopAlarm()
  if self.alarmFrame then self.alarmFrame:Hide() end
  TimeDB.alarmTime = ""
  TimeDB.alarmTimestamp = 0
end

-- ─── Alarm Polling ────────────────────────────────────────────────────────────
function frame:CheckAlarm()
  -- BEGIN FEATURE: hourly chime support
  if TimeDB.hourlyChime then
    local h, m = nil, nil
    if TimeDB.useServerTime then
      h, m = GetServerClock()
    else
      h = tonumber(GetLocalTimeValue("%H"))
      m = tonumber(GetLocalTimeValue("%M"))
    end
    if m == 0 then
      if self.lastChimeHour ~= h then
        PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_3 or SOUNDKIT.RAID_WARNING, "Master")
        self.lastChimeHour = h
      end
    end
  end
  -- END FEATURE

  -- Check for relative alarm timestamp first
  if TimeDB.alarmTimestamp and TimeDB.alarmTimestamp > 0 and not self.alarmPlaying then
    local now = GetServerTime and GetServerTime() or time()
    if now >= TimeDB.alarmTimestamp then
      TimeDB.alarmTimestamp = 0
      TimeDB.alarmTime = ""
      self:StartAlarm()
      return
    end
  end

  if not TimeDB.alarmTime or TimeDB.alarmTime == "" or self.alarmPlaying then
    return
  end
  local current
  if not TimeDB.alarms then return end
  local now = GetServerTime and GetServerTime() or time()
  local h, m
  if TimeDB.useServerTime then
    local h, m = GetServerClock()
    current = string.format("%02d:%02d", h, m)
    h, m = GetServerClock()
  else
    current = GetLocalTimeValue("%H:%M")
  end
  if current == TimeDB.alarmTime then
    self:StartAlarm()
    h = tonumber(GetLocalTimeValue("%H"))
    m = tonumber(GetLocalTimeValue("%M"))
  end
  for i = #TimeDB.alarms, 1, -1 do
    local a = TimeDB.alarms[i]
    if a.timestamp then
      if now >= a.timestamp and not self.alarmPlaying then
        TimeDB.alarmReminder = a.text or ""
        table.remove(TimeDB.alarms, i)
        self:StartAlarm()
        if self.RefreshAlarmList then self:RefreshAlarmList() end
        break
      end
    else
      if h == a.hour and m == a.min and not self.alarmPlaying then
        TimeDB.alarmReminder = a.text or ""
        table.remove(TimeDB.alarms, i)
        self:StartAlarm()
        if self.RefreshAlarmList then self:RefreshAlarmList() end
        break
      end
    end
  end
end

-- ─── Chat Reminder Scheduling ────────────────────────────────────────────────
function frame:AddToastReminder(delay, text)
  self.reminders = self.reminders or {}
  local when = (GetServerTime and GetServerTime() or time()) + delay
  table.insert(self.reminders, {time = when, text = text})
end

function frame:ShowToast(text)
  if not self.toastFrame then
    local f = CreateFrame("Frame", addonName.."Toast", UIParent, "BackdropTemplate")
    f:SetSize(200, 40)
    f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = {left=4,right=4,top=4,bottom=4}})
    f:SetBackdropColor(0,0,0,0.9)
    f:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -20, -20)
    local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fs:SetPoint("CENTER")
    f.text = fs
    self.toastFrame = f
  end
  local f = self.toastFrame
  f.text:SetText(text)
  f:Show()
  C_Timer.After(5, function() f:Hide() end)
end

function frame:CheckReminders()
  if not self.reminders then return end
  local now = GetServerTime and GetServerTime() or time()
  for i = #self.reminders, 1, -1 do
    local r = self.reminders[i]
    if now >= r.time then
      self:ShowToast(r.text)
      table.remove(self.reminders, i)
    end
  end
end

-- Add an absolute alarm (hour/minute) to the queue
function frame:AddAbsoluteAlarm(h, m, text)
  TimeDB.alarms = TimeDB.alarms or {}
  table.insert(TimeDB.alarms, {hour = h, min = m, text = text or ""})
  if self.RefreshAlarmList then self:RefreshAlarmList() end
end

-- Add a relative alarm in minutes to the queue
function frame:AddRelativeAlarm(minutes, text)
  TimeDB.alarms = TimeDB.alarms or {}
  local now = GetServerTime and GetServerTime() or time()
  table.insert(TimeDB.alarms, {timestamp = now + minutes * 60, text = text or ""})
  if self.RefreshAlarmList then self:RefreshAlarmList() end
end

-- Remove an alarm by index
function frame:RemoveAlarm(idx)
  if not TimeDB.alarms then return end
  table.remove(TimeDB.alarms, idx)
  if self.RefreshAlarmList then self:RefreshAlarmList() end
end

-- Refresh the upcoming alarm list in the settings UI
function frame:RefreshAlarmList()
  if not self.alarmListEntries then return end
  local now = GetServerTime and GetServerTime() or time()
  TimeDB.alarms = TimeDB.alarms or {}
  -- Sort alarms by next trigger time
  table.sort(TimeDB.alarms, function(a, b)
    local at = a.timestamp or (a.hour * 60 + a.min)
    local bt = b.timestamp or (b.hour * 60 + b.min)
    return at < bt
  end)
  for i, btn in ipairs(self.alarmListEntries) do
    local a = TimeDB.alarms[i]
    if a then
      btn.alarmIndex = i
      local display
      if a.timestamp then
        display = date("%H:%M", a.timestamp) .. " - " .. (a.text or "")
      else
        display = string.format("%02d:%02d - %s", a.hour, a.min, a.text or "")
      end
      btn.text:SetText(display)
      btn:Show()
    else
      btn:Hide()
      btn.alarmIndex = nil
    end
  end
end

function frame:HandleCalendarAlarm(...)
  local title
  if C_Calendar and C_Calendar.GetEventIndex then
    local idx = C_Calendar.GetEventIndex()
    if idx then
      local info = C_Calendar.GetEventInfo(idx)
      if info and info.title then title = info.title end
    end
  elseif CalendarGetEventIndex then
    local month, day, eventIndex = CalendarGetEventIndex()
    if month and day and eventIndex then
      CalendarGetDayEvent(month, day, eventIndex)
      if CalendarEventGetTitle then title = CalendarEventGetTitle() end
    end
  end
  TimeDB.alarmReminder = title or "Calendar Event"
  self:StartAlarm()
end

-- ─── Settings Panel & Tabs ──────────────────────────────────────────────────
function frame:ToggleSettings()
  if not self.settingsFrame then self:CreateSettingsFrame() end
  if self.settingsFrame:IsShown() then
    self.settingsFrame:Hide()
    self.settingsOverlay:Hide()
@@ -1261,150 +1334,178 @@ function frame:CreateSettingsFrame()
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
    timeEdit:SetText("")

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
    local function parseAlarmInput()
      local val = timeEdit:GetText()
      local h, m = val:match("^(%d?%d):(%d%d)$")
      if not h then
        print(addonName..": Invalid time format. Use HH:MM.")
        return
        return nil
      end
      h = tonumber(h); m = tonumber(m)
      if m < 0 or m > 59 then
        print(addonName..": Invalid minutes. Must be 00-59.")
        return
        return nil
      end
      local sel = UIDropDownMenu_GetSelectedValue(ampmDropdown)
      if sel then
        if h < 1 or h > 12 then
          print(addonName..": Invalid hour for 12h format. Use 1-12.")
          return
          return nil
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
          return nil
        end
      end
      TimeDB.alarmTime = string.format("%02d:%02d", h, m)
      print(addonName..": Alarm time set to "..TimeDB.alarmTime)
      return h, m
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
    remEdit:SetText("")
    remEdit:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    remEdit:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    local setBtn = CreateFrame("Button", addonName.."AlarmSetBtn", p, "UIPanelButtonTemplate")
    setBtn:SetSize(80, 22)
    setBtn:SetPoint("TOPLEFT", remEdit, "BOTTOMLEFT", 0, -12)
    setBtn:SetText("Set Alarm")
    setBtn:SetText("Add Alarm")
    setBtn:SetScript("OnClick", function()
      validateAndSetAlarm()
      TimeDB.alarmReminder = remEdit:GetText()
      print(addonName..": Reminder text set to '"..TimeDB.alarmReminder.."'.")
      local h, m = parseAlarmInput()
      if not h then return end
      local text = remEdit:GetText()
      frame:AddAbsoluteAlarm(h, m, text)
      print(addonName..": Alarm time set to "..string.format("%02d:%02d", h, m))
      if text and strtrim(text) ~= "" then
        print(addonName..": Reminder text set to '"..strtrim(text).."'.")
      end
      timeEdit:SetText("")
      remEdit:SetText("")
      UIDropDownMenu_SetSelectedValue(ampmDropdown, nil)
      UIDropDownMenu_SetText(ampmDropdown, "")
    end)

    local clearBtn = CreateFrame("Button", addonName.."AlarmClearBtn", p, "UIPanelButtonTemplate")
    clearBtn:SetSize(80, 22)
    clearBtn:SetPoint("LEFT", setBtn, "RIGHT", 10, 0)
    clearBtn:SetText("Clear Alarm")
    clearBtn:SetText("Clear All")
    clearBtn:SetScript("OnClick", function()
      TimeDB.alarmTime = ""
      TimeDB.alarmReminder = ""
      timeEdit:SetText("")
      remEdit:SetText("")
      UIDropDownMenu_SetSelectedValue(ampmDropdown, nil)
      UIDropDownMenu_SetText(ampmDropdown, "")
      print(addonName..": Alarm cleared.")
      TimeDB.alarms = {}
      frame:RefreshAlarmList()
      print(addonName..": all alarms cleared.")
    end)

    local upLabel = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    upLabel:SetPoint("TOPLEFT", setBtn, "BOTTOMLEFT", 0, -16)
    upLabel:SetText("Upcoming Alarms:")

    p.alarmEntries = {}
    frame.alarmListEntries = p.alarmEntries
    for i = 1, 5 do
      local btn = CreateFrame("Button", addonName.."AlarmEntry"..i, p)
      btn:SetSize(300, 20)
      if i == 1 then
        btn:SetPoint("TOPLEFT", upLabel, "BOTTOMLEFT", 0, -2)
      else
        btn:SetPoint("TOPLEFT", p.alarmEntries[i-1], "BOTTOMLEFT", 0, 0)
      end
      btn:SetHighlightTexture("Interface/QuestFrame/UI-QuestTitleHighlight")
      local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      fs:SetAllPoints(btn)
      fs:SetJustifyH("LEFT")
      btn.text = fs
      btn:SetScript("OnClick", function(self)
        if self.alarmIndex then
          frame:RemoveAlarm(self.alarmIndex)
          print(addonName..": alarm cancelled.")
        end
      end)
      p.alarmEntries[i] = btn
    end
    p:HookScript("OnShow", function() frame:RefreshAlarmList() end)
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
@@ -1585,135 +1686,131 @@ function frame:CreateSettingsFrame()
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
  if self.RefreshAlarmList then self:RefreshAlarmList() end
end

-- ─── Slash Command ───────────────────────────────────────────────────────────
SLASH_TIME1 = "/time"
SlashCmdList["TIME"] = function(msg)
  local cmd = msg and strtrim(msg) or ""
  if cmd == "" then
    frame:ToggleSettings()
    return
  end

  local num, unit, text = cmd:lower():match("^remind%s+me%s+in%s+(%d+)([smhd])%s+(.+)$")
  if num then
    local secs = tonumber(num)
    if unit == "m" then secs = secs * 60
    elseif unit == "h" then secs = secs * 3600
    elseif unit == "d" then secs = secs * 86400
    end
    frame:AddToastReminder(secs, text)
    print(addonName..": reminder set in "..num..unit)
    return
  end

  -- Check for an alarm command in the format "alarm HH:MM [AM/PM] [reminder]"
  local h, m, ap, reminder = cmd:match("^alarm%s+(%d?%d):(%d%d)%s*(%a%a)?%s*(.*)$")
  if h then
    local hour = tonumber(h)
    local min  = tonumber(m)
    ap = ap and ap:upper() or nil
    -- validate minutes
    if min < 0 or min > 59 then
      print(addonName..": Invalid minutes. Must be 00-59.")
      return
    end
    -- handle 12h or 24h input
    if ap == "AM" or ap == "PM" then
      if hour < 1 or hour > 12 then
        print(addonName..": Invalid hour for 12h format. Use 1-12.")
        return
      end
      if ap == "PM" and hour < 12 then hour = hour + 12 end
      if ap == "AM" and hour == 12 then hour = 0 end
    else
      if hour < 0 or hour > 23 then
        print(addonName..": Invalid hour for 24h format. Use 0-23.")
        return
      end
    end

    TimeDB.alarmTime = string.format("%02d:%02d", hour, min)
    TimeDB.alarmReminder = strtrim(reminder or "")
    print(addonName..": Alarm time set to "..TimeDB.alarmTime)
    if TimeDB.alarmReminder ~= "" then
      print(addonName..": Reminder text set to '"..TimeDB.alarmReminder.."'.")
    frame:AddAbsoluteAlarm(hour, min, strtrim(reminder or ""))
    print(addonName..": Alarm time set to "..string.format("%02d:%02d", hour, min))
    if reminder and strtrim(reminder) ~= "" then
      print(addonName..": Reminder text set to '"..strtrim(reminder).."'.")
    end
    return
  end

  print(addonName..": unknown command")
end

-- ─── Relative Alarm Slash Command (/alarm) ───────────────────────────────────
SLASH_ALARM1 = "/alarm"
SlashCmdList["ALARM"] = function(msg)
  local input = msg and strtrim(msg) or ""
  if input == "" then
    print(addonName..": usage: /alarm <minutes> [message]")
    return
  end

  local mins, text = input:match("^(%d+)%s*(.*)$")
  mins = tonumber(mins)
  if not mins or mins <= 0 then
    print(addonName..": invalid minutes. Usage: /alarm <minutes> [message]")
    return
  end

  local now = GetServerTime and GetServerTime() or time()
  TimeDB.alarmTimestamp = now + mins * 60
  TimeDB.alarmTime = ""
  TimeDB.alarmReminder = strtrim(text or "")

  frame:AddRelativeAlarm(mins, strtrim(text or ""))
  print(string.format("%s: Alarm set for %d minute(s) from now.", addonName, mins))
  if TimeDB.alarmReminder ~= "" then
    print(addonName..": Reminder text set to '"..TimeDB.alarmReminder.."'.")
  if text and strtrim(text) ~= "" then
    print(addonName..": Reminder text set to '"..strtrim(text).."'.")
  end
end

-- ─── Initialization & Events ─────────────────────────────────────────────────
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("CALENDAR_EVENT_ALARM")

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
        frame:ShowTrackingTooltip(btn)