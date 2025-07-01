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
-- Compatibility helpers for APIs that changed between client versions
local function IsAddonLoaded(addon)
    if type(IsAddOnLoaded) == "function" then
        return IsAddOnLoaded(addon)
    elseif C_AddOns and C_AddOns.IsAddOnLoaded then
        return C_AddOns.IsAddOnLoaded(addon)
    end
    return false
end

-- Slash command for graph options
SLASH_FPSGRAPH1 = "/fpsgraph"
SlashCmdList["FPSGRAPH"] = function(msg)
    msg = msg and msg:lower() or ""
    if msg == "toggle" or msg == "" then
        FPSMonitorDB.graph.enabled = not FPSMonitorDB.graph.enabled
        if FPSMonitorDB.graph.enabled then
            if not graphFrame then CreateGraphFrame() end
            if graphFrame then graphFrame:Show() end
            print("FPSMonitor: graph enabled")
        else
            if graphFrame then graphFrame:Hide() end
            print("FPSMonitor: graph disabled")
        end
    end
end

-- Create FPS graph frame
local function CreateGraphFrame()
    if graphFrame then return end
    graphFrame = CreateFrame("Frame", "FPSMonitorGraph", UIParent, BackdropTemplateMixin and "BackdropTemplate")
    graphFrame:SetSize(FPSMonitorDB.graph.w or 220, FPSMonitorDB.graph.h or 100)
    local gpos = FPSMonitorDB.graph.pos or { point = "TOPLEFT", relativePoint = "BOTTOMLEFT", x = 0, y = -10 }
    graphFrame:SetPoint(gpos.point, UIParent, gpos.relativePoint, gpos.x, gpos.y)
    graphFrame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 8 })
    graphFrame:SetBackdropColor(0, 0, 0, 0.4)
    graphFrame:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
    graphFrame:EnableMouse(true)
    graphFrame:SetMovable(true)
    graphFrame:SetResizable(true)
    graphFrame:SetMinResize(120, 60)
    graphFrame:SetClampedToScreen(true)
    graphFrame:RegisterForDrag("LeftButton")
    graphFrame:SetScript("OnDragStart", graphFrame.StartMoving)
    graphFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, rp, x, y = self:GetPoint()
        FPSMonitorDB.graph.pos = { point = point, relativePoint = rp, x = x, y = y }
        FPSMonitorDB.graph.w = self:GetWidth()
        FPSMonitorDB.graph.h = self:GetHeight()
    end)
    -- Resizer handle
    local sizer = CreateFrame("Frame", nil, graphFrame)
    sizer:SetSize(16, 16)
    sizer:SetPoint("BOTTOMRIGHT")
    sizer:EnableMouse(true)
    sizer:SetScript("OnMouseDown", function() graphFrame:StartSizing("BOTTOMRIGHT") end)
    sizer:SetScript("OnMouseUp", function()
        graphFrame:StopMovingOrSizing()
        local point, _, rp, x, y = graphFrame:GetPoint()
        FPSMonitorDB.graph.pos = { point = point, relativePoint = rp, x = x, y = y }
        FPSMonitorDB.graph.w = graphFrame:GetWidth()
        FPSMonitorDB.graph.h = graphFrame:GetHeight()
    end)
    sizer:SetCursor("SizeNWSE")
    graphFrame.sizer = sizer

    graphFrame.title = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    graphFrame.title:SetPoint("TOPLEFT", 4, -4)
    SetFontSafe(graphFrame.title, 12, "OUTLINE")
    graphFrame.title:SetText("FPS Graph")

    -- Pre-create line objects for reuse
    for i = 1, graphMaxSamples - 1 do
        graphLines[i] = graphFrame:CreateLine(nil, "ARTWORK")
    end

    for i = 1, 3 do
        graphGrid[i] = graphFrame:CreateLine(nil, "BACKGROUND")
        graphLabels[i] = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        SetFontSafe(graphLabels[i], 10)
    end
    graphGrid.now = graphFrame:CreateLine(nil, "BACKGROUND")

    if not FPSMonitorDB.graph.enabled then
        graphFrame:Hide()
    end
end

local function LoadAddOnSafe(addon)
    if type(UIParentLoadAddOn) == "function" then
        return UIParentLoadAddOn(addon)
    elseif type(LoadAddOn) == "function" then
        return LoadAddOn(addon)
    elseif C_AddOns and C_AddOns.LoadAddOn then
        return C_AddOns.LoadAddOn(addon)
    end
end

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
    memoryUpdateInterval = 5,
    graph = {
        enabled = true,
        w = 220,
        h = 100,
        pos = { point = "TOPLEFT", relativePoint = "BOTTOMLEFT", x = 0, y = -10 },
    },
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

-- Labels used for the statistic display.  Keeping this table
-- at file scope allows reusing it whenever the display is
-- (re)initialized.
local STAT_LABELS = {
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
local updateFrame -- frame used for periodic updates; declared early so slash commands can reference it safely
local graphFrame
local graphLines = {}
local graphGrid = {}
local graphLabels = {}
local graphHistory = {}
local graphIndex = 1
local graphCount = 0
local graphMaxSamples = 200
local graphUpdateThrottle = 0.05
local graphElapsed = 0

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
    if type(FPSMonitorDB.memoryUpdateInterval) ~= "number" or FPSMonitorDB.memoryUpdateInterval <= 0 then
        FPSMonitorDB.memoryUpdateInterval = defaultConfig.memoryUpdateInterval
    end
    if type(FPSMonitorDB.graph) ~= "table" then
        FPSMonitorDB.graph = CopyTable(defaultConfig.graph)
    else
        if type(FPSMonitorDB.graph.enabled) ~= "boolean" then
            FPSMonitorDB.graph.enabled = defaultConfig.graph.enabled
        end
        if type(FPSMonitorDB.graph.w) ~= "number" then
            FPSMonitorDB.graph.w = defaultConfig.graph.w
        end
        if type(FPSMonitorDB.graph.h) ~= "number" then
            FPSMonitorDB.graph.h = defaultConfig.graph.h
        end
        if type(FPSMonitorDB.graph.pos) ~= "table" then
            FPSMonitorDB.graph.pos = CopyTable(defaultConfig.graph.pos)
        else
            local g = FPSMonitorDB.graph.pos
            if type(g.point) ~= "string" then g.point = defaultConfig.graph.pos.point end
            if type(g.relativePoint) ~= "string" then g.relativePoint = defaultConfig.graph.pos.relativePoint end
            if type(g.x) ~= "number" then g.x = defaultConfig.graph.pos.x end
            if type(g.y) ~= "number" then g.y = defaultConfig.graph.pos.y end
        end
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

    -- Use the API provided FPS value rather than 1/dt.  The OnUpdate elapsed
    -- time can be clamped by the client (typically to ~3ms), which caused the
    -- maximum FPS to incorrectly report ~333.3.  GetFramerate() provides a more
    -- accurate instantaneous value for this purpose.
    local fps = GetFramerate()
    if not fps or fps <= 0 then return end

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

    -- Track samples for the FPS graph
    graphHistory[graphIndex] = fps
    graphIndex = graphIndex + 1
    if graphIndex > graphMaxSamples then graphIndex = 1 end
    if graphCount < graphMaxSamples then graphCount = graphCount + 1 end
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

-- Colorize memory usage (kilobytes) for quick visual feedback
local function ColorizeMemory(mem)
    if not mem then return "N/A" end
    if mem >= 51200 then -- 50 MB+
        return string.format("|cffff0000%.2f MB|r", mem / 1024)
    elseif mem >= 20480 then -- 20 MB+
        return string.format("|cffffff00%.2f MB|r", mem / 1024)
    else
        return string.format("|cff00ff00%.2f MB|r", mem / 1024)
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
        ColorizeMemory(memory),
    }

    for i = 1, #values do
        if displayFrame.values[i] then
            displayFrame.values[i]:SetText(values[i])
        end
    end
end

-- Draw the scrolling FPS graph
local function UpdateGraph()
    if not graphFrame or not graphFrame:IsShown() or graphCount < 2 then return end

    local width = graphFrame:GetWidth() - 4
    local height = graphFrame:GetHeight() - 20
    if width <= 0 or height <= 0 then return end

    local minFPS, maxFPS = math.huge, 0
    for i = 1, graphCount do
        local idx = (graphIndex - graphCount + i - 1) % graphMaxSamples + 1
        local fps = graphHistory[idx]
        if fps < minFPS then minFPS = fps end
        if fps > maxFPS then maxFPS = fps end
    end
    if maxFPS == minFPS then maxFPS = minFPS + 1 end
    local range = maxFPS - minFPS

    local stepX = width / (graphMaxSamples - 1)
    local prevX, prevY
    for i = 1, graphCount do
        local idx = (graphIndex - graphCount + i - 1) % graphMaxSamples + 1
        local fps = graphHistory[idx]
        local x = (i - 1) * stepX + 2
        local y = ((fps - minFPS) / range) * height + 2
        if prevX then
            local line = graphLines[i - 1]
            if line then
                line:SetStartPoint("BOTTOMLEFT", prevX, prevY)
                line:SetEndPoint("BOTTOMLEFT", x, y)
            end
        end
        prevX, prevY = x, y
    end

    -- Hide unused lines
    for i = graphCount, graphMaxSamples - 1 do
        if graphLines[i] then graphLines[i]:Hide() end
    end

    local colorR, colorG, colorB = 0, 1, 0
    local lastFPS = graphHistory[(graphIndex - 1 - 1) % graphMaxSamples + 1]
    if lastFPS < 15 then
        colorR, colorG, colorB = 1, 0, 0
    elseif lastFPS < 30 then
        colorR, colorG, colorB = 1, 0.5, 0
    end
    for i = 1, graphCount - 1 do
        local line = graphLines[i]
        if line then
            line:SetColorTexture(colorR, colorG, colorB, 1)
            line:SetThickness(1.5)
            line:Show()
        end
    end

    -- Grid lines and labels
    for i = 1, 3 do
        local frac = i * 0.25
        local y = frac * height + 2
        local line = graphGrid[i]
        if line then
            line:SetStartPoint("BOTTOMLEFT", 2, y)
            line:SetEndPoint("BOTTOMRIGHT", -2, y)
            line:SetColorTexture(0.5, 0.5, 0.5, 0.4)
            line:SetThickness(1)
            line:Show()
        end
        local label = graphLabels[i]
        if label then
            label:SetPoint("BOTTOMLEFT", graphFrame, "BOTTOMLEFT", 4, y)
            label:SetText(string.format("%.0f", minFPS + frac * range))
            label:Show()
        end
    end

    if graphGrid.now then
        graphGrid.now:SetStartPoint("BOTTOMRIGHT", -2, 2)
        graphGrid.now:SetEndPoint("TOPRIGHT", -2, height + 2)
        graphGrid.now:SetColorTexture(0.5, 0.5, 0.5, 0.4)
        graphGrid.now:SetThickness(1)
        graphGrid.now:Show()
    end
end

-- Print summarized statistics to the chat frame
local function PrintStats(stats, memory)
    print(string.format(
        "FPSMonitor: %.1f avg %.1f min %.1f max %.1f 1%% %.1f 0.1%% %.1f frame %.2f ms jitter %.2f ms",
        stats.current, stats.average, stats.min, stats.max, stats.low1,
        stats.low01, stats.frameTime, stats.jitter))
    if memory then
        print("Memory: " .. ColorizeMemory(memory))
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
-- Initialize or refresh the label/value pairs on the display frame
local function InitializeLabels()
    if not displayFrame then return end

    local y = -30
    for i, labelText in ipairs(STAT_LABELS) do
        local label = displayFrame.labels[i]
        if not label then
            label = displayFrame:CreateFontString(nil, "ARTWORK")
            displayFrame.labels[i] = label
        end
        label:ClearAllPoints()
        label:SetPoint("TOPLEFT", displayFrame, "TOPLEFT", 10, y)
        SetFontSafe(label, 12)
        label:SetText(labelText .. ":")

        local value = displayFrame.values[i]
        if not value then
            value = displayFrame:CreateFontString(nil, "ARTWORK")
            value:SetJustifyH("RIGHT")
            displayFrame.values[i] = value
        end
        value:ClearAllPoints()
        value:SetPoint("TOPRIGHT", displayFrame, "TOPRIGHT", -10, y)
        SetFontSafe(value, 12, "OUTLINE")

        y = y - 16
    end
end

-- Create movable display frame
local function CreateDisplayFrame()
    if displayFrame then return end
    -- Use BackdropTemplate for compatibility with modern client versions
    displayFrame = CreateFrame("Frame", "FPSMonitorDisplay", UIParent, BackdropTemplateMixin and "BackdropTemplate")
    -- Slightly taller to leave room for the buttons
    -- so they don't overlap the statistic text
    displayFrame:SetSize(220, 206)
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
    InitializeLabels()

    -- Populate with initial values so text is visible immediately
    local fps = GetFramerate()
    local stats = CalculateStats(fps, fps > 0 and (1 / fps) or 0)
    UpdateDisplay(stats, updateFrame.currentMemory)

    displayFrame:SetScript("OnShow", function()
        pcall(InitializeLabels)
        local f = GetFramerate()
        local s = CalculateStats(f, f > 0 and (1 / f) or 0)
        UpdateDisplay(s, updateFrame.currentMemory)
    end)
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
    -- Use PNG icon if supported. If the texture fails to load fall back to the
    -- provided TGA version so the button is always visible.
    minimapButton:SetNormalTexture("Interface/AddOns/FPSMonitor/FPS1.png")
    local tex = minimapButton:GetNormalTexture()
    if not tex or tex:GetTexture() == "" then
        minimapButton:SetNormalTexture("Interface/AddOns/FPSMonitor/FPS1.tga")
    end
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
            if not optionsPanel then CreateOptionsPanel() end
            if Settings and Settings.OpenToCategory and optionsPanel.category then
                Settings.OpenToCategory(optionsPanel.category)
            elseif InterfaceOptionsFrame_OpenToCategory then
                InterfaceOptionsFrame_OpenToCategory(optionsPanel)
                InterfaceOptionsFrame_OpenToCategory(optionsPanel)
            else
                optionsPanel:Show()
            end
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
            GameTooltip:AddLine("Memory: " .. ColorizeMemory(updateFrame.currentMemory))
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

    -- Ensure the Retail Settings API is loaded
    if not Settings then
        LoadAddOn("Blizzard_Settings")
    end

    optionsPanel = CreateFrame("Frame", "FPSMonitorOptions", InterfaceOptionsFramePanelContainer or UIParent)
    optionsPanel.name = "FPS Monitor"

    -- Single container for all controls
    optionsPanel.general = CreateFrame("Frame", nil, optionsPanel)
    optionsPanel.general:SetAllPoints(optionsPanel)

    --------------------------------------------------------------------
    -- General tab contents
    local title = optionsPanel.general:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("FPS Monitor")

    local minimapCheck = CreateFrame("CheckButton", nil, optionsPanel.general, "InterfaceOptionsCheckButtonTemplate")
    minimapCheck:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    minimapCheck.Text:SetText("Show minimap button")
    minimapCheck:SetChecked(not FPSMonitorDB.minimap.hide)
    minimapCheck:SetScript("OnClick", function(self)
        local show = self:GetChecked()
        FPSMonitorDB.minimap.hide = not show
        if show then
            if not minimapButton then CreateMinimapButton() end
            if minimapButton then minimapButton:Show() end
        elseif minimapButton then
            minimapButton:Hide()
        end
    end)

    local updateSlider = CreateFrame("Slider", nil, optionsPanel.general, "OptionsSliderTemplate")
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

    local sampleSlider = CreateFrame("Slider", nil, optionsPanel.general, "OptionsSliderTemplate")
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

    local memorySlider = CreateFrame("Slider", nil, optionsPanel.general, "OptionsSliderTemplate")
    memorySlider:SetPoint("TOPLEFT", sampleSlider, "BOTTOMLEFT", 0, -40)
    memorySlider:SetMinMaxValues(1, 30)
    memorySlider:SetValueStep(1)
    memorySlider:SetObeyStepOnDrag(true)
    memorySlider:SetWidth(200)
    memorySlider:SetValue(memoryUpdateInterval)
    _G[memorySlider:GetName() .. "Low"]:SetText("1")
    _G[memorySlider:GetName() .. "High"]:SetText("30")
    local memoryText = memorySlider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    memoryText:SetPoint("TOP", memorySlider, "BOTTOM", 0, -2)
    memorySlider.text = memoryText
    memorySlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        self.text:SetText("Memory update: " .. value .. "s")
        FPSMonitorDB.memoryUpdateInterval = value
        memoryUpdateInterval = value
    end)
    memorySlider:SetValue(memoryUpdateInterval)
    memorySlider.text:SetText("Memory update: " .. memoryUpdateInterval .. "s")

    local graphCheck = CreateFrame("CheckButton", nil, optionsPanel.general, "InterfaceOptionsCheckButtonTemplate")
    graphCheck:SetPoint("TOPLEFT", memorySlider, "BOTTOMLEFT", 0, -30)
    graphCheck.Text:SetText("Enable FPS graph")
    graphCheck:SetChecked(FPSMonitorDB.graph.enabled)
    graphCheck:SetScript("OnClick", function(self)
        local show = self:GetChecked()
        FPSMonitorDB.graph.enabled = show
        if show then
            if not graphFrame then CreateGraphFrame() end
            graphFrame:Show()
        elseif graphFrame then
            graphFrame:Hide()
        end
    end)

    -- Register the options panel with whichever API is available
    if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        optionsPanel.category = Settings.RegisterCanvasLayoutCategory(optionsPanel, optionsPanel.name)
        Settings.RegisterAddOnCategory(optionsPanel.category)
    elseif InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(optionsPanel)
    end

end

-- Open configuration panel using whichever API is available
local function OpenConfigPanel()
    if not optionsPanel then return end

    if Settings and Settings.OpenToCategory and optionsPanel.category then
        Settings.OpenToCategory(optionsPanel.category)
    elseif InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory(optionsPanel)
        InterfaceOptionsFrame_OpenToCategory(optionsPanel)
    else
        optionsPanel:Show()
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
        -- updateFrame may not have collected memory yet; guard with nil check
        local mem = updateFrame and updateFrame.currentMemory
        PrintStats(stats, mem)
        return
    elseif msg == "config" then
        if not optionsPanel then
            CreateOptionsPanel()
        end
        if OpenConfigPanel then
            OpenConfigPanel()
        else
            print("FPSMonitor: configuration panel unavailable")
        end
        return
    elseif msg == "help" then
        print("/fpsmon - toggle display")
        print("/fpsmon minimap - toggle minimap button")
        print("/fpsmon stats - print current statistics")
        print("/fpsmon config - open configuration (or right-click minimap icon)")
        print("/fpsmon reset - reset session statistics")
        print("/fpsmon resetall - reset all statistics")
        print("/fpsgraph toggle - toggle FPS graph")
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
updateFrame = CreateFrame("Frame")
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

    -- Throttled graph updates only when graph is visible
    if graphFrame and graphFrame:IsShown() then
        graphElapsed = graphElapsed + elapsed
        if graphElapsed >= graphUpdateThrottle then
            graphElapsed = 0
            UpdateGraph()
        end
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
        memoryUpdateInterval = FPSMonitorDB.memoryUpdateInterval or memoryUpdateInterval
        -- Initialize configuration panel and graph frame
        pcall(CreateOptionsPanel)
        -- Ensure the graph enabled flag defaults to true on first run
        FPSMonitorDB.graph.enabled = FPSMonitorDB.graph.enabled == nil and true or FPSMonitorDB.graph.enabled
        updateFrame:UnregisterEvent("ADDON_LOADED")
    elseif event == "PLAYER_LOGIN" then
        if not FPSMonitorDB.minimap.hide then
            pcall(CreateMinimapButton)
        end
        if FPSMonitorDB.graph.enabled and not graphFrame then
            CreateGraphFrame()
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
