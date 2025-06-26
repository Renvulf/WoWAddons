-- FPSMonitor.lua
-- Simple FPS monitoring addon for World of Warcraft
-- Displays various frame-rate statistics and provides a minimap toggle button

-- The addon name is provided as the first return from ... when this file is loaded.
-- We only need the name for event filtering so discard the second value.
local addonName = ...

-- These runtime variables are loaded from the saved configuration in
-- ValidateConfig().  Default values are defined in `defaultConfig` below.
local sampleInterval = 60 -- seconds to keep frame history for average and percentiles
local updateInterval = 0.5 -- seconds between display updates
local memoryUpdateInterval = 5 -- seconds between memory usage checks
local captureDelay = 5 -- seconds to wait after loading screens before collecting samples

-- Local references to frequently used globals for slight performance gain
local GetFramerate = GetFramerate
local GetTime = GetTime
local CreateFrame = CreateFrame
local math_sqrt = math.sqrt
local math_floor = math.floor
local math_max = math.max
local math_cos = math.cos
local math_sin = math.sin
local math_atan2 = math.atan2
local math_atan = math.atan
local TAU = math.pi * 2

local function NormalizeAngle(angle)
    angle = angle % TAU
    if angle < 0 then angle = angle + TAU end
    return angle
end

-- SavedVariables tables declared in the TOC file. They may not exist on the
-- first run so we create them if needed when the addon loads.
FPSMonitorDB = FPSMonitorDB or {}
FPSPerCharDB = FPSPerCharDB or {}
FPSPerCharDB.overall = FPSPerCharDB.overall or { min = math.huge, max = 0 }

-- Default configuration values. These are merged into the saved variables on
-- load so that new options are automatically added without wiping user data.
local defaultConfig = {
    pos = {
        point = "CENTER",
        relativePoint = "CENTER",
        x = 0,
        y = 0,
    },
    minimap = {
        hide = false,
        angle = 0, -- radians around the minimap for the button position
    },
    updateInterval = 0.5,
    sampleInterval = 60,
}

-- Default font used for the display. If the custom font fails to load we fall
-- back to STANDARD_TEXT_FONT to avoid any errors.
-- Use standard addon path delimiters with backslashes. Double backslashes are
-- required in Lua string literals to represent a single backslash.
local FONT_PATH = "Interface\\AddOns\\FPSMonitor\\Pepsi.ttf"

-- Helper to safely apply a font to a FontString
local function SetFontSafe(fs, size, flags)
    if fs and fs.SetFont then
        if not fs:SetFont(FONT_PATH, size, flags) then
            fs:SetFont(STANDARD_TEXT_FONT, size, flags)
        end
    end
end

-- History of recent frame times. We keep samples for the last `sampleInterval`
-- seconds using a simple ring buffer to avoid expensive table.remove calls.
local frameHistory = {}
local historyStart = 1 -- first valid index in the history buffer
local historyCount = 0 -- number of samples currently stored
local historyTime = 0   -- total time represented by the samples
-- Running sums allow average and jitter calculations without scanning
local sumFPS = 0
local sumDT = 0
local sumDTSquared = 0
local sessionMinFPS = math.huge
local sessionMaxFPS = 0
local capturing = false
local captureStartTime
local displayFrame
local minimapButton
local optionsPanel

-- Reposition minimap button around the minimap based on stored angle
local function UpdateMinimapButtonPosition(angle)
    if not minimapButton or not Minimap then return end
    angle = NormalizeAngle(angle or FPSMonitorDB.minimap.angle or 0)
    local radius = (Minimap:GetWidth() / 2) + 5
    local x = radius * math_cos(angle)
    local y = radius * math_sin(angle)
    minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- Utility function to merge default values into the saved configuration table
local function DeepCopyDefaults(src, dest)
    if type(src) ~= "table" then return end
    for k, v in pairs(src) do
        if type(v) == "table" then
            dest[k] = dest[k] or {}
            DeepCopyDefaults(v, dest[k])
        elseif dest[k] == nil then
            dest[k] = v
        end
    end
end

-- Copy an entire table recursively. This is used when replacing
-- corrupted saved variable tables with defaults so we don't end up
-- referencing the defaults directly.
local function CopyTable(tbl)
    if type(tbl) ~= "table" then return tbl end
    local copy = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            copy[k] = CopyTable(v)
        else
            copy[k] = v
        end
    end
    return copy
end

-- Validate the saved variables. If any expected value has the wrong type
-- replace it with a sensible default. This guards against corrupted saved
-- variables or manual user edits that could otherwise cause errors.
local function ValidateConfig()
    if type(FPSMonitorDB) ~= "table" then
        FPSMonitorDB = {}
    end
    DeepCopyDefaults(defaultConfig, FPSMonitorDB)

    if type(FPSMonitorDB.pos) ~= "table" then
        FPSMonitorDB.pos = CopyTable(defaultConfig.pos)
    else
        local pos = FPSMonitorDB.pos
        if type(pos.point) ~= "string" then pos.point = defaultConfig.pos.point end
        if type(pos.relativePoint) ~= "string" then pos.relativePoint = defaultConfig.pos.relativePoint end
        if type(pos.x) ~= "number" then pos.x = defaultConfig.pos.x end
        if type(pos.y) ~= "number" then pos.y = defaultConfig.pos.y end
    end

    if type(FPSMonitorDB.minimap) ~= "table" then
        FPSMonitorDB.minimap = CopyTable(defaultConfig.minimap)
    else
        local mm = FPSMonitorDB.minimap
        if type(mm.hide) ~= "boolean" then mm.hide = defaultConfig.minimap.hide end
        if type(mm.angle) ~= "number" then
            mm.angle = defaultConfig.minimap.angle
        else
            mm.angle = NormalizeAngle(mm.angle)
        end
    end

    if type(FPSMonitorDB.updateInterval) ~= "number" or FPSMonitorDB.updateInterval <= 0 then
        FPSMonitorDB.updateInterval = defaultConfig.updateInterval
    end
    if type(FPSMonitorDB.sampleInterval) ~= "number" or FPSMonitorDB.sampleInterval <= 0 then
        FPSMonitorDB.sampleInterval = defaultConfig.sampleInterval
    end
end

-- Insert a value into a sorted array while keeping its size limited. Used by
-- CalculateStats to efficiently maintain lists of the lowest FPS samples.
local function InsertSorted(list, value, maxSize)
    local i = #list
    while i > 0 and value < list[i] do
        list[i + 1] = list[i]
        i = i - 1
    end
    list[i + 1] = value
    if #list > maxSize then
        list[#list] = nil
    end
end

-- Utility: insert a new frame sample and maintain running statistics
local function AddSample(dt)
    -- Ignore extremely long frames which usually occur during loading screens
    -- and extremely small frames that can appear while the UI is still
    -- initializing (which would report unrealistically high FPS values).
    if dt <= 0 or dt > 1 or dt < 0.001 then return end

    local fps = 1 / dt

    -- Update running sums used for quick statistics calculation
    sumFPS = sumFPS + fps
    sumDT = sumDT + dt
    sumDTSquared = sumDTSquared + dt * dt

    -- Add sample at the end of the buffer
    local index = historyStart + historyCount
    frameHistory[index] = {dt = dt, fps = fps}
    historyCount = historyCount + 1
    historyTime = historyTime + dt

    -- Trim old samples outside the sliding window and update sums
    while historyCount > 0 and historyTime > sampleInterval do
        local sample = frameHistory[historyStart]
        historyTime = historyTime - sample.dt
        sumFPS = sumFPS - sample.fps
        sumDT = sumDT - sample.dt
        sumDTSquared = sumDTSquared - sample.dt * sample.dt
        frameHistory[historyStart] = nil
        historyStart = historyStart + 1
        historyCount = historyCount - 1
    end

    -- Reindex the buffer occasionally to avoid huge numeric indices
    if historyStart > 1000 then
        for i = historyStart, historyStart + historyCount - 1 do
            frameHistory[i - historyStart + 1] = frameHistory[i]
            frameHistory[i] = nil
        end
        historyStart = 1
    end

    -- Update session min/max only when we are actively capturing data
    if capturing then
        if fps < sessionMinFPS then sessionMinFPS = fps end
        if fps > sessionMaxFPS then sessionMaxFPS = fps end
    end
end

-- Compute stats from history
local function CalculateStats(currentFPS, currentDT)
    local count = historyCount
    if count == 0 then
        return {
            current = currentFPS,
            average = currentFPS,
            min = currentFPS,
            max = currentFPS,
            low1 = currentFPS,
            low01 = currentFPS,
            frameTime = currentDT * 1000,
            jitter = 0,
        }
    end

    -- Use running sums for faster calculations on each update
    local sumDT_local = sumDT
    local sumDTSquared_local = sumDTSquared
    -- Keep small sorted tables of the lowest 1% and 0.1% FPS values to avoid
    -- allocating large tables every update. This drastically reduces memory
    -- churn compared to sorting the full history each time.
    local low1List, low01List = {}, {}
    local low1Size = math_max(1, math_floor(count * 0.01 + 0.5))
    local low01Size = math_max(1, math_floor(count * 0.001 + 0.5))


    for i = historyStart, historyStart + historyCount - 1 do
        local sample = frameHistory[i]
        InsertSorted(low1List, sample.fps, low1Size)
        InsertSorted(low01List, sample.fps, low01Size)
    end

    local avgFPS = sumDT_local > 0 and (count / sumDT_local) or currentFPS
    local low1 = low1List[low1Size] or low1List[#low1List]
    local low01 = low01List[low01Size] or low01List[#low01List]

    -- calculate jitter as standard deviation of frame times
    local meanDT = sumDT_local / count
    local variance = (sumDTSquared_local / count) - meanDT * meanDT
    if variance < 0 then variance = 0 end

    return {
        current = currentFPS,
        average = avgFPS,
        min = sessionMinFPS,
        max = sessionMaxFPS,
        low1 = low1,
        low01 = low01,
        frameTime = currentDT * 1000,
        jitter = math_sqrt(variance) * 1000,
    }
end

-- Update the on-screen display text
local function ColorizeFPS(fps)
    if fps < 30 then
        return string.format("|cffff0000%.1f|r", fps)
    elseif fps < 60 then
        return string.format("|cffffff00%.1f|r", fps)
    else
        return string.format("|cff00ff00%.1f|r", fps)
    end
end

local function UpdateDisplay(stats, memory)
    if not displayFrame or not displayFrame:IsShown() then return end

    local values = {
        ColorizeFPS(stats.current),
        string.format("%.1f", stats.average),
        string.format("%.1f", stats.min),
        string.format("%.1f", stats.max),
        string.format("%.1f", stats.low1),
        string.format("%.1f", stats.low01),
        string.format("%.2f ms", stats.frameTime),
        string.format("%.2f ms", stats.jitter),
        memory and string.format("%.2f MB", memory / 1024) or "N/A",
    }

    for i = 1, #values do
        if displayFrame.values[i] then
            displayFrame.values[i]:SetText(values[i])
        end
    end
end

-- Print summarized statistics to the chat frame
local function PrintStats(stats, memory)
    print(string.format(
        "FPSMonitor: %.1f avg %.1f min %.1f max %.1f 1%% %.1f 0.1%% %.1f frame %.2f ms jitter %.2f ms",
        stats.current, stats.average, stats.min, stats.max, stats.low1,
        stats.low01, stats.frameTime, stats.jitter))
    if memory then
        print(string.format("Memory: %.2f MB", memory / 1024))
    end
    if FPSPerCharDB.overall then
        print(string.format("Overall min %.1f  Overall max %.1f",
            FPSPerCharDB.overall.min, FPSPerCharDB.overall.max))
    end
end

-- Update persistent per-character statistics
local function UpdateCharacterStats()
    local overall = FPSPerCharDB.overall
    if sessionMinFPS < overall.min then overall.min = sessionMinFPS end
    if sessionMaxFPS > overall.max then overall.max = sessionMaxFPS end
end

-- Create movable display frame
local function CreateDisplayFrame()
    if displayFrame then return end
    -- Use BackdropTemplate for compatibility with modern client versions
    displayFrame = CreateFrame("Frame", "FPSMonitorDisplay", UIParent, BackdropTemplateMixin and "BackdropTemplate")
    displayFrame:SetSize(220, 186)
    -- Position is restored from the saved configuration
    local pos = FPSMonitorDB.pos or defaultConfig.pos
    displayFrame:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
    displayFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"})
    displayFrame:SetBackdropColor(0, 0, 0, 0.6)
    displayFrame:EnableMouse(true)
    displayFrame:SetMovable(true)
    displayFrame:SetClampedToScreen(true)
    displayFrame:RegisterForDrag("LeftButton")
    displayFrame:SetScript("OnDragStart", displayFrame.StartMoving)
    displayFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, relativePoint, x, y = self:GetPoint()
        FPSMonitorDB.pos = { point = point, relativePoint = relativePoint, x = x, y = y }
    end)
    -- Standard close button for convenience
    local close = CreateFrame("Button", nil, displayFrame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -4, -4)

    -- Quick reset button for session statistics
    local reset = CreateFrame("Button", nil, displayFrame, "UIPanelButtonTemplate")
    reset:SetSize(60, 20)
    reset:SetPoint("BOTTOMRIGHT", displayFrame, "BOTTOMRIGHT", -8, 8)
    reset:SetText("Reset")
    reset:SetScript("OnClick", function()
        -- Clear history and running sums just like the /fpsmon reset command
        frameHistory = {}
        historyStart = 1
        historyCount = 0
        historyTime = 0
        sumFPS = 0
        sumDT = 0
        sumDTSquared = 0
        sessionMinFPS = math.huge
        sessionMaxFPS = 0
        print("FPSMonitor: session statistics reset")
    end)

    -- Button to open configuration panel
    local config = CreateFrame("Button", nil, displayFrame, "UIPanelButtonTemplate")
    config:SetSize(60, 20)
    config:SetPoint("BOTTOMLEFT", displayFrame, "BOTTOMLEFT", 8, 8)
    config:SetText("Options")
    config:SetScript("OnClick", function()
        if OpenConfigPanel then OpenConfigPanel() end
    end)
    if UISpecialFrames then
        table.insert(UISpecialFrames, "FPSMonitorDisplay")
    end

    -- Title
    displayFrame.title = displayFrame:CreateFontString(nil, "ARTWORK")
    displayFrame.title:SetPoint("TOP", 0, -10)
    SetFontSafe(displayFrame.title, 14, "OUTLINE")
    displayFrame.title:SetText("FPS Monitor")

    displayFrame.labels = {}
    displayFrame.values = {}

    local statsLabels = {
        "Current FPS",
        "Average FPS",
        "Min FPS",
        "Max FPS",
        "1% Low",
        "0.1% Low",
        "Frame Time",
        "Jitter",
        "AddOn Memory",
    }

    local y = -30
    for i, text in ipairs(statsLabels) do
        local label = displayFrame:CreateFontString(nil, "ARTWORK")
        label:SetPoint("TOPLEFT", displayFrame, "TOPLEFT", 10, y)
        SetFontSafe(label, 12)
        label:SetText(text .. ":")

        local value = displayFrame:CreateFontString(nil, "ARTWORK")
        value:SetPoint("TOPRIGHT", displayFrame, "TOPRIGHT", -10, y)
        value:SetJustifyH("RIGHT")
        SetFontSafe(value, 12, "OUTLINE")

        displayFrame.labels[i] = label
        displayFrame.values[i] = value

        y = y - 16
    end
end

-- Create simple minimap button
local function CreateMinimapButton()
    if minimapButton or not Minimap then return end
    local ok, button = pcall(CreateFrame, "Button", "FPSMonitorMinimapButton", Minimap)
    if not ok or not button then return end
    minimapButton = button
    minimapButton:SetSize(32, 32)
    minimapButton:SetFrameStrata("MEDIUM")
    minimapButton:SetFrameLevel(8)
    minimapButton:SetNormalTexture("Interface/AddOns/FPSMonitor/FPS1.tga")
    minimapButton:SetHighlightTexture("Interface/Minimap/UI-Minimap-ZoomButton-Highlight")
    UpdateMinimapButtonPosition(FPSMonitorDB.minimap.angle)
    minimapButton:RegisterForDrag("LeftButton")
    minimapButton:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            px, py = px / scale, py / scale
            -- Some WoW versions expose math.atan rather than math.atan2. The two
            -- argument form of atan behaves like atan2, so fall back to that
            -- when atan2 isn't available.
            local angle = math_atan2 and math_atan2(py - my, px - mx) or math_atan(py - my, px - mx)
            angle = NormalizeAngle(angle)
            FPSMonitorDB.minimap.angle = angle
            UpdateMinimapButtonPosition(angle)
        end)
    end)
    minimapButton:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
        FPSMonitorDB.minimap.angle = NormalizeAngle(FPSMonitorDB.minimap.angle)
        UpdateMinimapButtonPosition(FPSMonitorDB.minimap.angle)
    end)
    minimapButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    minimapButton:SetScript("OnClick", function(_, btn)
        if btn == "RightButton" then
            if OpenConfigPanel then OpenConfigPanel() end
            return
        end
        if displayFrame and displayFrame:IsShown() then
            displayFrame:Hide()
        else
            pcall(CreateDisplayFrame)
            if displayFrame then displayFrame:Show() end
        end
    end)
    minimapButton:SetScript("OnEnter", function(self)
        local fps = GetFramerate()
        local stats = CalculateStats(fps, fps > 0 and (1 / fps) or 0)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
        GameTooltip:SetText("FPS Monitor")
        GameTooltip:AddLine(string.format("Current: %.1f", stats.current))
        GameTooltip:AddLine(string.format("Average: %.1f", stats.average))
        GameTooltip:AddLine(string.format("1%% Low: %.1f", stats.low1))
        GameTooltip:AddLine(string.format("0.1%% Low: %.1f", stats.low01))
        if updateFrame and updateFrame.currentMemory then
            GameTooltip:AddLine(string.format("Memory: %.2f MB", updateFrame.currentMemory / 1024))
        end
        GameTooltip:Show()
    end)
    minimapButton:SetScript("OnLeave", GameTooltip_Hide)
    if FPSMonitorDB.minimap.hide then
        minimapButton:Hide()
    end
end

-- Configuration options panel
local function CreateOptionsPanel()
    if optionsPanel then return end
    optionsPanel = CreateFrame("Frame", "FPSMonitorOptions", InterfaceOptionsFramePanelContainer or UIParent)
    optionsPanel.name = "FPS Monitor"

    local title = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("FPS Monitor")

    local minimapCheck = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    minimapCheck:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    minimapCheck.Text:SetText("Show minimap button")
    minimapCheck:SetChecked(not FPSMonitorDB.minimap.hide)
    minimapCheck:SetScript("OnClick", function(self)
        local show = self:GetChecked()
        FPSMonitorDB.minimap.hide = not show
        if show then
            if not minimapButton then CreateMinimapButton() end
            minimapButton:Show()
        elseif minimapButton then
            minimapButton:Hide()
        end
    end)

    local updateSlider = CreateFrame("Slider", nil, optionsPanel, "OptionsSliderTemplate")
    updateSlider:SetPoint("TOPLEFT", minimapCheck, "BOTTOMLEFT", 0, -30)
    updateSlider:SetMinMaxValues(0.1, 2)
    updateSlider:SetValueStep(0.1)
    updateSlider:SetObeyStepOnDrag(true)
    updateSlider:SetWidth(200)
    updateSlider:SetValue(updateInterval)
    _G[updateSlider:GetName() .. "Low"]:SetText("0.1")
    _G[updateSlider:GetName() .. "High"]:SetText("2.0")
    local updateText = updateSlider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    updateText:SetPoint("TOP", updateSlider, "BOTTOM", 0, -2)
    updateSlider.text = updateText
    updateSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value * 10 + 0.5) / 10
        self.text:SetText("Update interval: " .. value .. "s")
        FPSMonitorDB.updateInterval = value
        updateInterval = value
    end)
    updateSlider:SetValue(updateInterval)
    updateSlider.text:SetText("Update interval: " .. updateInterval .. "s")

    local sampleSlider = CreateFrame("Slider", nil, optionsPanel, "OptionsSliderTemplate")
    sampleSlider:SetPoint("TOPLEFT", updateSlider, "BOTTOMLEFT", 0, -40)
    sampleSlider:SetMinMaxValues(10, 120)
    sampleSlider:SetValueStep(10)
    sampleSlider:SetObeyStepOnDrag(true)
    sampleSlider:SetWidth(200)
    sampleSlider:SetValue(sampleInterval)
    _G[sampleSlider:GetName() .. "Low"]:SetText("10")
    _G[sampleSlider:GetName() .. "High"]:SetText("120")
    local sampleText = sampleSlider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    sampleText:SetPoint("TOP", sampleSlider, "BOTTOM", 0, -2)
    sampleSlider.text = sampleText
    sampleSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        self.text:SetText("Sample window: " .. value .. "s")
        FPSMonitorDB.sampleInterval = value
        sampleInterval = value
    end)
    sampleSlider:SetValue(sampleInterval)
    sampleSlider.text:SetText("Sample window: " .. sampleInterval .. "s")

    InterfaceOptions_AddCategory(optionsPanel)
end

-- Open configuration panel using whichever API is available
local function OpenConfigPanel()
    if not optionsPanel then return end
    if Settings and Settings.OpenToCategory then
        -- Dragonflight settings system
        Settings.OpenToCategory(optionsPanel.name or "FPS Monitor")
    elseif InterfaceOptionsFrame_OpenToCategory then
        -- Classic options system
        InterfaceOptionsFrame_OpenToCategory(optionsPanel)
        InterfaceOptionsFrame_OpenToCategory(optionsPanel) -- open twice for reliability
    end
end


-- Slash command to toggle
SLASH_FPSMON1 = "/fpsmon"
SLASH_FPSMON2 = "/fpsmonitor"
SlashCmdList["FPSMON"] = function(msg)
    msg = msg and msg:lower() or ""
    if msg == "reset" then
        frameHistory = {}
        historyStart = 1
        historyCount = 0
        historyTime = 0
        -- Clear running sums so averages restart cleanly
        sumFPS = 0
        sumDT = 0
        sumDTSquared = 0
        sessionMinFPS = math.huge
        sessionMaxFPS = 0
        print("FPSMonitor: session statistics reset")
        return
    elseif msg == "resetall" then
        frameHistory = {}
        historyStart = 1
        historyCount = 0
        historyTime = 0
        -- Clear running sums so averages restart cleanly
        sumFPS = 0
        sumDT = 0
        sumDTSquared = 0
        sessionMinFPS = math.huge
        sessionMaxFPS = 0
        FPSPerCharDB.overall = { min = math.huge, max = 0 }
        print("FPSMonitor: all statistics reset")
        return
    elseif msg == "minimap" then
        FPSMonitorDB.minimap.hide = not FPSMonitorDB.minimap.hide
        if FPSMonitorDB.minimap.hide then
            if minimapButton then minimapButton:Hide() end
            print("FPSMonitor: minimap button hidden")
        else
            if not minimapButton then CreateMinimapButton() end
            minimapButton:Show()
            print("FPSMonitor: minimap button shown")
        end
        return
    elseif msg == "stats" then
        local fps = GetFramerate()
        local stats = CalculateStats(fps, fps > 0 and (1 / fps) or 0)
        PrintStats(stats, updateFrame.currentMemory)
        return
    elseif msg == "config" then
        if OpenConfigPanel then
            OpenConfigPanel()
        end
        return
    elseif msg == "help" then
        print("/fpsmon - toggle display")
        print("/fpsmon minimap - toggle minimap button")
        print("/fpsmon stats - print current statistics")
        print("/fpsmon config - open configuration (or right-click minimap icon)")
        print("/fpsmon reset - reset session statistics")
        print("/fpsmon resetall - reset all statistics")
        return
    end

    if displayFrame and displayFrame:IsShown() then
        displayFrame:Hide()
    else
        pcall(CreateDisplayFrame)
        if displayFrame then displayFrame:Show() end
    end
end

-- Main OnUpdate handler: collect data and refresh display
local updateFrame = CreateFrame("Frame")
updateFrame:SetScript("OnUpdate", function(self, elapsed)
    -- 'elapsed' is the time since the last OnUpdate and represents the
    -- frame's duration. It is more reliable than calculating our own
    -- delta using GetTime().

    -- Handle delayed start after loading screens
    if captureStartTime and GetTime() >= captureStartTime then
        capturing = true
        captureStartTime = nil
    end

    if capturing then
        AddSample(elapsed)
    end

    self.memT = (self.memT or 0) + elapsed
    if self.memT >= memoryUpdateInterval then
        self.memT = 0
        if UpdateAddOnMemoryUsage and GetAddOnMemoryUsage then
            UpdateAddOnMemoryUsage()
            self.currentMemory = GetAddOnMemoryUsage(addonName)
        end
    end

    self.t = (self.t or 0) + elapsed
    if self.t >= updateInterval then
        self.t = 0
        local currentFPS = GetFramerate()
        local stats = CalculateStats(currentFPS, elapsed)
        UpdateDisplay(stats, self.currentMemory)
    end
end)

-- Initialize addon
local function OnEvent(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        -- Validate saved variables on startup. This also merges any new
        -- defaults that may have been added between versions.
        ValidateConfig()
        sampleInterval = FPSMonitorDB.sampleInterval or sampleInterval
        updateInterval = FPSMonitorDB.updateInterval or updateInterval
        pcall(CreateOptionsPanel)
        updateFrame:UnregisterEvent("ADDON_LOADED")
    elseif event == "PLAYER_LOGIN" then
        if not FPSMonitorDB.minimap.hide then
            pcall(CreateMinimapButton)
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Delay sample collection for a short period to avoid skewing
        -- statistics with extremely high FPS values while assets load.
        captureStartTime = GetTime() + captureDelay
        capturing = false
        sessionMinFPS = math.huge
        sessionMaxFPS = 0
    elseif event == "PLAYER_LEAVING_WORLD" then
        capturing = false
        captureStartTime = nil
        UpdateCharacterStats()
    elseif event == "PLAYER_LOGOUT" then
        UpdateCharacterStats()
    end
end
updateFrame:RegisterEvent("ADDON_LOADED")
updateFrame:RegisterEvent("PLAYER_LOGIN")
updateFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
updateFrame:RegisterEvent("PLAYER_LEAVING_WORLD")
updateFrame:RegisterEvent("PLAYER_LOGOUT")
updateFrame:SetScript("OnEvent", OnEvent)
