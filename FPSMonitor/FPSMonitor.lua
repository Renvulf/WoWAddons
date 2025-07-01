-- FPSMonitor.lua
-- Simple FPS monitoring addon for World of Warcraft
-- Displays various frame-rate statistics and provides a minimap toggle button

-- The addon name is provided as the first return from ... when this file is loaded.
-- We only need the name for event filtering so discard the second value.
local addonName = ...

-- Graph related state and configuration
local graphFrame
local graphLines = { fps = {}, frameTime = {}, jitter = {}, memory = {}, latency = {}, homeLatency = {}, worldLatency = {} }
local graphGrid = { h = {}, hRight = {}, v = {}, now = nil, p1 = nil, p01 = nil }
local graphLabels = { h = {}, hRight = {}, v = {} }
local graphHistory = {
    times = {},
    fps = {},
    frameTime = {},
    jitter = {},
    memory = {},
    latency = {},
    homeLatency = {},
    worldLatency = {},
}
local graphStart = 1       -- first valid index in the history
local graphCount = 0       -- number of samples currently stored
local graphTimeWindow = 60
local graphUpdateThrottle = 0.05
local graphSampleResolution = 200
local graphElapsed = 0
local graphYMin
local graphYMax
local graphYMinFrameTime
local graphYMaxFrameTime
local graphYMinMemory
local graphYMaxMemory
local graphYMinLatency
local graphYMaxLatency
local graphYMinJitter
local graphYMaxJitter
local graphPaused = false

-- Local references to frequently used math functions
local math_sqrt  = math.sqrt
local math_floor = math.floor
local math_max   = math.max
local math_min   = math.min
local math_cos   = math.cos
local math_sin   = math.sin
local math_atan2 = math.atan2
local math_atan  = math.atan
local TAU        = math.pi * 2

-- Forward declare functions referenced before their definitions so
-- Lua's lexical scoping rules won't cause nil lookups when these
-- functions are used inside closures.
local UpdateGraph, UpdateGraphConfig, CreateGraphFrame
function UpdateGraphConfig()
    graphTimeWindow = FPSMonitorDB.graph.timeWindow or 60
    graphSampleResolution = FPSMonitorDB.graph.graphSampleResolution or 200
    graphHistory = {
        times = {},
        fps = {},
        frameTime = {},
        jitter = {},
        memory = {},
        latency = {},
        homeLatency = {},
        worldLatency = {},
    }
    graphLines = { fps = {}, frameTime = {}, jitter = {}, memory = {}, latency = {}, homeLatency = {}, worldLatency = {} }
    graphStart = 1
    graphCount = 0
    graphYMin = FPSMonitorDB.graph.yMin
    graphYMax = FPSMonitorDB.graph.yMax
    graphYMinFrameTime = FPSMonitorDB.graph.yMinFrameTime
    graphYMaxFrameTime = FPSMonitorDB.graph.yMaxFrameTime
    graphYMinMemory = FPSMonitorDB.graph.yMinMemory
    graphYMaxMemory = FPSMonitorDB.graph.yMaxMemory
    graphYMinLatency = FPSMonitorDB.graph.yMinLatency
    graphYMaxLatency = FPSMonitorDB.graph.yMaxLatency
    graphYMinJitter = FPSMonitorDB.graph.yMinJitter
    graphYMaxJitter = FPSMonitorDB.graph.yMaxJitter
    if graphFrame then
        graphFrame:Hide()
        graphFrame = nil
        CreateGraphFrame()
    end
    if graphFrame and graphFrame.title then
        graphFrame.title:SetText(string.format("FPS Graph (Last %ds)", graphTimeWindow))
    end
end

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

-- Slash command for graph options
SLASH_FPSGRAPH1 = "/fpsgraph"
SlashCmdList["FPSGRAPH"] = function(msg)
    msg = msg and msg:lower() or ""
    local secs = msg:match("^window%s+(%d+)")
    if secs then
        secs = tonumber(secs)
        if secs and secs > 0 then
            FPSMonitorDB.graph.timeWindow = secs
            UpdateGraphConfig()
            print("FPSMonitor: graph window set to " .. secs .. "s")
        end
    elseif msg == "toggle" or msg == "" then
        FPSMonitorDB.graph.enabled = not FPSMonitorDB.graph.enabled
        if FPSMonitorDB.graph.enabled then
            if not graphFrame then CreateGraphFrame() end
            if graphFrame then
                graphFrame:Show()
            end
            print("FPSMonitor: graph enabled")
        else
            if graphFrame then
                graphFrame:Hide()
            end
            print("FPSMonitor: graph disabled")
        end
    elseif msg == "export" then
        FPSMonitorExport = CopyTable(graphHistory)
        print("FPSMonitor: History exported to SavedVariables.FPSMonitorExport")
    elseif msg == "help" then
        print("/fpsgraph toggle     - show/hide graph")
        print("/fpsgraph window <s> - set time window")
        print("/fpsgraph export     - export history to SavedVariables")
    end
end

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

-- Create FPS graph frame
function CreateGraphFrame()
    if graphFrame then return end
    graphFrame = CreateFrame("Frame", "FPSMonitorGraph", displayFrame or UIParent, "BackdropTemplate")
    graphFrame:SetSize(FPSMonitorDB.graph.w or 220, FPSMonitorDB.graph.h or 100)
    local gpos = FPSMonitorDB.graph.pos or { point = "TOPLEFT", relativePoint = "BOTTOMLEFT", x = 0, y = -4 }
    if displayFrame then
        graphFrame:SetPoint("TOPLEFT", displayFrame, "BOTTOMLEFT", gpos.x, gpos.y)
    else
        graphFrame:SetPoint(gpos.point, UIParent, gpos.relativePoint, gpos.x, gpos.y)
    end
    graphFrame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 8 })
    graphFrame:SetBackdropColor(0, 0, 0, 0.4)
    graphFrame:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
    graphFrame:EnableMouse(true)
    graphFrame:SetMovable(true)
    graphFrame:SetResizable(true)
    -- Set minimum resize bounds
    graphFrame:SetResizeBounds(120, 60)
    graphFrame:SetClampedToScreen(true)
    graphFrame:SetScript("OnSizeChanged", function(self)
        if C_Timer and C_Timer.After then
            C_Timer.After(0, UpdateGraph)
        else
            UpdateGraph()
        end
    end)
    -- Ensure lines are clipped within the frame bounds
    if graphFrame.SetClipsChildren then
        graphFrame:SetClipsChildren(true)
    end
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
    -- Use a Button instead of a Frame so SetCursor is available on all clients.
    local sizer = CreateFrame("Button", nil, graphFrame)
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
    -- The SetCursor method may not exist on very old clients; fall back to the
    -- global cursor API in that case.
    if sizer.SetCursor then
        sizer:SetCursor("SizeNWSE")
    else
        sizer:SetScript("OnEnter", function() SetCursor("SizeNWSE") end)
        sizer:SetScript("OnLeave", function() ResetCursor() end)
    end
    graphFrame.sizer = sizer

    graphFrame.title = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    graphFrame.title:SetPoint("TOPLEFT", 4, -4)
    SetFontSafe(graphFrame.title, 12, "OUTLINE")
    graphFrame.title:SetText(string.format("FPS Graph (Last %ds)", graphTimeWindow))

    -- Preallocate line objects for each metric to avoid runtime allocations
    do
        local keys = {"fps","frameTime","jitter","memory","latency","homeLatency","worldLatency"}
        for _, key in ipairs(keys) do
            graphLines[key] = {}
            for i = 1, graphSampleResolution - 1 do
                graphLines[key][i] = graphFrame:CreateLine(nil, "ARTWORK")
            end
        end
    end
    for i = 1, 3 do
        graphGrid.h[i] = graphFrame:CreateLine(nil, "BACKGROUND")
        graphLabels.h[i] = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        SetFontSafe(graphLabels.h[i], 10)
        graphGrid.hRight[i] = graphFrame:CreateLine(nil, "BACKGROUND")
        graphLabels.hRight[i] = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        SetFontSafe(graphLabels.hRight[i], 10)
    end

    for i = 1, 5 do
        graphGrid.v[i] = graphFrame:CreateLine(nil, "BACKGROUND")
        graphLabels.v[i] = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        SetFontSafe(graphLabels.v[i], 10)
    end

    graphGrid.now = graphFrame:CreateLine(nil, "BACKGROUND")
    graphGrid.p1  = graphFrame:CreateLine(nil, "OVERLAY")
    graphGrid.p01 = graphFrame:CreateLine(nil, "OVERLAY")
    graphFrame.alertLine = graphFrame:CreateLine(nil, "OVERLAY")
    graphFrame.alertLine:SetColorTexture(1,0,0,0.6)
    graphFrame.alertLine:SetThickness(1)
    if FPSMonitorDB.graph.showPercentiles then
        graphGrid.p1:SetColorTexture(1,0,0,0.6)
        graphGrid.p1:SetThickness(1)
        graphGrid.p01:SetColorTexture(1,0.5,0,0.6)
        graphGrid.p01:SetThickness(1)
        graphGrid.p1:Show()
        graphGrid.p01:Show()
    end
    graphFrame.legend = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    SetFontSafe(graphFrame.legend, 10)
    graphFrame.legend:SetPoint("TOPLEFT", 100, -4)
    graphFrame.legend:SetText("FPS (G) | ms (B) | Jit (R) | Mem MB (M) | Lat ms (Y)")


    -- Per-metric checkboxes aligned along the right edge
    local metricInfo = {
        { key = "showFPS",         label = "FPS",          color = {0,1,0} },
        { key = "showFrameTime",   label = "Frame Time",   color = {0,0.75,1} },
        { key = "showJitter",      label = "Jitter",       color = {1,0,0} },
        { key = "showMemory",      label = "Memory",       color = {1,0,1} },
        { key = "showLatency",     label = "Latency",      color = {1,1,0} },
        { key = "showHomeLatency", label = "Home Lat",    color = {1,0.5,0} },
        { key = "showWorldLatency",label = "World Lat",   color = {1,0.8,0} },
    }

    graphFrame.metricChecks = {}
    local labelInset = 60 -- distance from the right edge
    for i, info in ipairs(metricInfo) do
        -- Use UICheckButtonTemplate for retail clients
        local chk = CreateFrame("CheckButton", nil, graphFrame, "UICheckButtonTemplate")
        chk:SetSize(20, 20)
        -- Anchor checkbox slightly inside the frame so it isn't clipped
        chk:SetPoint("TOPRIGHT", graphFrame, "TOPRIGHT", -labelInset, -16 * i - 4)
        -- Hide the built-in label to avoid clipping
        if chk.Text then chk.Text:Hide() end

        -- Label aligned to the frame's right edge
        local lbl = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        lbl:SetPoint("TOPRIGHT", graphFrame, "TOPRIGHT", -4, -16 * i - 4)
        lbl:SetJustifyH("RIGHT")
        lbl:SetText(info.label)
        lbl:SetTextColor(unpack(info.color))

        chk:SetChecked(FPSMonitorDB.graph[info.key])
        chk:SetScript("OnClick", function(self)
            FPSMonitorDB.graph[info.key] = self:GetChecked()
            if C_Timer and C_Timer.After then
                C_Timer.After(graphUpdateThrottle, UpdateGraph)
            else
                UpdateGraph()
            end
        end)
        graphFrame.metricChecks[i] = chk
    end

    graphFrame:SetScript("OnEnter", function(self)
        local idx = graphStart + graphCount - 1
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
        GameTooltip:SetText("FPS Graph")
        if graphHistory.fps[idx] then
            GameTooltip:AddLine(string.format("FPS: %.1f", graphHistory.fps[idx]))
        end
        if graphHistory.frameTime[idx] then
            GameTooltip:AddLine(string.format("Frame: %.2f ms", graphHistory.frameTime[idx]))
        end
        if graphHistory.jitter[idx] then
            GameTooltip:AddLine(string.format("Jitter: %.2f ms", graphHistory.jitter[idx]))
        end
        if graphHistory.memory[idx] then
            GameTooltip:AddLine(string.format("Mem: %.2f MB", graphHistory.memory[idx] / 1024))
        end
        if graphHistory.latency[idx] then
            GameTooltip:AddLine(string.format("Latency: %.0f ms", graphHistory.latency[idx]))
        end
        if graphHistory.homeLatency[idx] then
            GameTooltip:AddLine(string.format("Home: %.0f ms", graphHistory.homeLatency[idx]))
        end
        if graphHistory.worldLatency[idx] then
            GameTooltip:AddLine(string.format("World: %.0f ms", graphHistory.worldLatency[idx]))
        end
        GameTooltip:Show()
    end)
    graphFrame:SetScript("OnLeave", GameTooltip_Hide)
    graphFrame:SetScript("OnMouseMove", function(self, x, y)
        local width = self:GetWidth() - 68
        local sampleCount = graphCount
        local i = math.floor(((x - 2) / width) * (sampleCount - 1)) + 1
        if i < 1 or i > sampleCount then return end
        local idx = graphStart + i - 1
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
        GameTooltip:ClearLines()
        GameTooltip:SetText(string.format("t = -%ds", graphTimeWindow - (i-1)*(graphTimeWindow/(sampleCount-1))))
        GameTooltip:AddLine(string.format("FPS: %.1f", graphHistory.fps[idx]))
        GameTooltip:AddLine(string.format("ms:  %.2f", graphHistory.frameTime[idx]))
        GameTooltip:AddLine(string.format("Jit: %.2f", graphHistory.jitter[idx] or 0))
        GameTooltip:AddLine(string.format("Mem: %.2f MB", graphHistory.memory[idx]/1024))
        GameTooltip:AddLine(string.format("Lat: %.0f / %.0f / %.0f",
            graphHistory.latency[idx],
            graphHistory.homeLatency[idx],
            graphHistory.worldLatency[idx]
        ))
        GameTooltip:Show()
    end)

    graphFrame:SetShown(FPSMonitorDB.graph.enabled)
end

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
    graphUpdateThrottle = 0.05,
    graph = {
        enabled = true,
        w = 220,
        h = 100,
        timeWindow = 60,
        pos = { point = "TOPLEFT", relativePoint = "BOTTOMLEFT", x = 0, y = -10 },
        showFPS = true,
        showFrameTime = true,
        showJitter = false,
        showMemory = true,
        showLatency = true,
        yMin = nil,
        yMax = nil,
        yMinFrameTime = nil,
        yMaxFrameTime = nil,
        yMinMemory = nil,
        yMaxMemory = nil,
        yMinLatency = nil,
        yMaxLatency = nil,
        yMinJitter = nil,
        yMaxJitter = nil,
        smoothing = 0,
        showHomeLatency = false,
        showWorldLatency = false,
        showPercentiles = true,
        alertThreshold = 30,
        graphSampleResolution = 200,
    },
}
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
    if type(FPSMonitorDB.graphUpdateThrottle) ~= "number" or FPSMonitorDB.graphUpdateThrottle <= 0 then
        FPSMonitorDB.graphUpdateThrottle = defaultConfig.graphUpdateThrottle
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
        if type(FPSMonitorDB.graph.timeWindow) ~= "number" or FPSMonitorDB.graph.timeWindow <= 0 then
            FPSMonitorDB.graph.timeWindow = defaultConfig.graph.timeWindow
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
        if type(FPSMonitorDB.graph.showFPS) ~= "boolean" then
            FPSMonitorDB.graph.showFPS = defaultConfig.graph.showFPS
        end
        if type(FPSMonitorDB.graph.showFrameTime) ~= "boolean" then
            FPSMonitorDB.graph.showFrameTime = defaultConfig.graph.showFrameTime
        end
        if type(FPSMonitorDB.graph.showMemory) ~= "boolean" then
            FPSMonitorDB.graph.showMemory = defaultConfig.graph.showMemory
        end
        if type(FPSMonitorDB.graph.showJitter) ~= "boolean" then
            FPSMonitorDB.graph.showJitter = defaultConfig.graph.showJitter
        end
        if type(FPSMonitorDB.graph.showLatency) ~= "boolean" then
            FPSMonitorDB.graph.showLatency = defaultConfig.graph.showLatency
        end
        if type(FPSMonitorDB.graph.yMin) ~= "number" and FPSMonitorDB.graph.yMin ~= nil then
            FPSMonitorDB.graph.yMin = defaultConfig.graph.yMin
        end
        if type(FPSMonitorDB.graph.yMax) ~= "number" and FPSMonitorDB.graph.yMax ~= nil then
            FPSMonitorDB.graph.yMax = defaultConfig.graph.yMax
        end
        for _,k in ipairs({"FrameTime","Memory","Latency","Jitter"}) do
            local minKey = "yMin"..k
            local maxKey = "yMax"..k
            if type(FPSMonitorDB.graph[minKey]) ~= "number" and FPSMonitorDB.graph[minKey] ~= nil then
                FPSMonitorDB.graph[minKey] = defaultConfig.graph[minKey]
            end
            if type(FPSMonitorDB.graph[maxKey]) ~= "number" and FPSMonitorDB.graph[maxKey] ~= nil then
                FPSMonitorDB.graph[maxKey] = defaultConfig.graph[maxKey]
            end
        end
        if type(FPSMonitorDB.graph.smoothing) ~= "number" then
            FPSMonitorDB.graph.smoothing = defaultConfig.graph.smoothing
        end
        if type(FPSMonitorDB.graph.showHomeLatency) ~= "boolean" then
            FPSMonitorDB.graph.showHomeLatency = defaultConfig.graph.showHomeLatency
        end
        if type(FPSMonitorDB.graph.showWorldLatency) ~= "boolean" then
            FPSMonitorDB.graph.showWorldLatency = defaultConfig.graph.showWorldLatency
        end
        if type(FPSMonitorDB.graph.showPercentiles) ~= "boolean" then
            FPSMonitorDB.graph.showPercentiles = defaultConfig.graph.showPercentiles
        end
        if type(FPSMonitorDB.graph.alertThreshold) ~= "number" then
            FPSMonitorDB.graph.alertThreshold = defaultConfig.graph.alertThreshold
        end
        if type(FPSMonitorDB.graph.graphSampleResolution) ~= "number" or FPSMonitorDB.graph.graphSampleResolution <= 0 then
            FPSMonitorDB.graph.graphSampleResolution = defaultConfig.graph.graphSampleResolution
        end
    end

    UpdateGraphConfig()
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
    -- Ignore extremely small frames and clamp excessively long ones so the time
    -- axis remains consistent even when the client is unfocused.
    if dt <= 0 or dt < 0.001 then return end
    dt = math_min(dt, 1)

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

    -- Track samples for the FPS graph using a time-based sliding window
    local now = GetTime()
    local index = graphStart + graphCount
    graphHistory.times[index] = now
    graphHistory.fps[index] = fps
    if fps and fps > 0 then
        graphHistory.frameTime[index] = (1 / fps) * 1000
    else
        graphHistory.frameTime[index] = graphHistory.frameTime[index - 1] or 0
    end
    local count = historyCount
    local meanDT = sumDT / count
    local variance = (sumDTSquared / count) - meanDT * meanDT
    if variance < 0 then variance = 0 end
    graphHistory.jitter[index] = math_sqrt(variance) * 1000

    local mem = 0
    if GetAddOnMemoryUsage then
        mem = GetAddOnMemoryUsage(addonName)
    elseif updateFrame and updateFrame.currentMemory then
        mem = updateFrame.currentMemory
    end
    graphHistory.memory[index] = mem or 0

    local _, _, homeLatency, worldLatency = GetNetStats()
    local lat = (homeLatency and worldLatency) and ((homeLatency + worldLatency) / 2) or nil
    -- fall back to previous value if API returns nil
    graphHistory.latency[index] = lat or graphHistory.latency[index - 1] or 0
    graphHistory.homeLatency[index] = homeLatency or graphHistory.homeLatency[index - 1] or 0
    graphHistory.worldLatency[index] = worldLatency or graphHistory.worldLatency[index - 1] or 0

    graphCount = graphCount + 1

    -- Remove samples older than the configured time window
    local cutoff = now - graphTimeWindow
    while graphCount > 0 and graphHistory.times[graphStart] and graphHistory.times[graphStart] < cutoff do
        graphHistory.times[graphStart] = nil
        graphHistory.fps[graphStart] = nil
        graphHistory.frameTime[graphStart] = nil
        graphHistory.jitter[graphStart] = nil
        graphHistory.memory[graphStart] = nil
        graphHistory.latency[graphStart] = nil
        graphHistory.homeLatency[graphStart] = nil
        graphHistory.worldLatency[graphStart] = nil
        graphStart = graphStart + 1
        graphCount = graphCount - 1
    end

    -- Reindex occasionally to avoid huge numeric keys
    if graphStart > 1000 then
        for i = graphStart, graphStart + graphCount - 1 do
            local newIdx = i - graphStart + 1
            graphHistory.times[newIdx] = graphHistory.times[i]
            graphHistory.fps[newIdx] = graphHistory.fps[i]
            graphHistory.frameTime[newIdx] = graphHistory.frameTime[i]
            graphHistory.jitter[newIdx] = graphHistory.jitter[i]
            graphHistory.memory[newIdx] = graphHistory.memory[i]
            graphHistory.latency[newIdx] = graphHistory.latency[i]
            graphHistory.homeLatency[newIdx] = graphHistory.homeLatency[i]
            graphHistory.worldLatency[newIdx] = graphHistory.worldLatency[i]
            graphHistory.times[i] = nil
            graphHistory.fps[i] = nil
            graphHistory.frameTime[i] = nil
            graphHistory.jitter[i] = nil
            graphHistory.memory[i] = nil
            graphHistory.latency[i] = nil
            graphHistory.homeLatency[i] = nil
            graphHistory.worldLatency[i] = nil
        end
        graphStart = 1
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
function UpdateGraph()
    if not graphFrame or not graphFrame:IsShown() or graphCount < 2 then return end

    local width, height = graphFrame:GetWidth() - 68, graphFrame:GetHeight() - 20
    if width <= 0 or height <= 0 then return end

    local sampleCount = math_min(graphSampleResolution, graphCount)
    local displayIndices = {}
    for i = 1, sampleCount do
        displayIndices[i] = graphStart + math_floor((i-1) * (graphCount-1) / (sampleCount-1) + 0.5)
    end
    local stepX = (width - 4) / (sampleCount - 1)

    local metrics = {
        { key = "fps",        data = graphHistory.fps,         lines = graphLines.fps,         color = {0,1,0},   thick = 1.5, flag = FPSMonitorDB.graph.showFPS },
        { key = "frameTime",  data = graphHistory.frameTime,   lines = graphLines.frameTime,   color = {0,0.75,1}, thick = 1.5, flag = FPSMonitorDB.graph.showFrameTime },
        { key = "jitter",     data = graphHistory.jitter,      lines = graphLines.jitter,      color = {1,0,0}, thick = 1,   flag = FPSMonitorDB.graph.showJitter },
        { key = "memory",     data = graphHistory.memory,      lines = graphLines.memory,      color = {1,0,1}, thick = 1,   flag = FPSMonitorDB.graph.showMemory },
        { key = "latency",    data = graphHistory.latency,     lines = graphLines.latency,     color = {1,1,0}, thick = 1,   flag = FPSMonitorDB.graph.showLatency },
        { key = "homeLatency",data = graphHistory.homeLatency, lines = graphLines.homeLatency, color = {1,0.5,0}, thick = 1, flag = FPSMonitorDB.graph.showHomeLatency },
        { key = "worldLatency",data = graphHistory.worldLatency,lines = graphLines.worldLatency,color = {1,0.8,0}, thick = 1, flag = FPSMonitorDB.graph.showWorldLatency },
    }

    local enabledMetrics = {}
    for _, m in ipairs(metrics) do
        if m.flag then
            table.insert(enabledMetrics, m)
        else
            -- hide any previously drawn lines when disabled
            for i = 1, #m.lines do
                if m.lines[i] then m.lines[i]:Hide() end
            end
        end
    end
    metrics = enabledMetrics
    -- ▸ if the user has unchecked _all_ series, bail out early
    if #metrics == 0 then
        if graphFrame.legend then
            graphFrame.legend:SetText("no metrics selected")
        end
        return
    end

    -- Update legend text based on enabled series
    if graphFrame.legend then
        local legendParts = {}
        if FPSMonitorDB.graph.showFPS then table.insert(legendParts, "FPS (G)") end
        if FPSMonitorDB.graph.showFrameTime then table.insert(legendParts, "ms (B)") end
        if FPSMonitorDB.graph.showJitter then table.insert(legendParts, "Jit ms (R)") end
        if FPSMonitorDB.graph.showMemory then table.insert(legendParts, "Mem MB (M)") end
        if FPSMonitorDB.graph.showLatency then table.insert(legendParts, "Lat ms (Y)") end
        if FPSMonitorDB.graph.showHomeLatency then table.insert(legendParts, "Home (O)") end
        if FPSMonitorDB.graph.showWorldLatency then table.insert(legendParts, "World (O)") end
        if #legendParts == 0 then legendParts = {"none"} end
        graphFrame.legend:SetText(table.concat(legendParts, " | "))
    end

    local alpha = FPSMonitorDB.graph.smoothing or 0
    for _, m in ipairs(metrics) do
        m.plot = {}
        local prev
        for i = 1, sampleCount do
            local idx = displayIndices[i]
            local v = m.data[idx]
            if alpha > 0 then
                if prev == nil then prev = v or 0 end
                v = v or prev
                prev = alpha * v + (1 - alpha) * prev
                m.plot[i] = prev
            else
                m.plot[i] = v
            end
        end
        -- Fill gaps so lines don't break when values are nil
        local last = m.plot[1] or 0
        for i = 1, #m.plot do
            if not m.plot[i] then
                m.plot[i] = last
            else
                last = m.plot[i]
            end
        end
    end

    local minFPS, maxFPS = math.huge, -math.huge
    for i = 1, sampleCount do
        local v = metrics[1].plot[i]
        if v then
            if v < minFPS then minFPS = v end
            if v > maxFPS then maxFPS = v end
        end
    end
    if graphYMin ~= nil then minFPS = graphYMin end
    if graphYMax ~= nil then maxFPS = graphYMax end
    if maxFPS == minFPS then maxFPS = minFPS + 1 end
    local fpsRange = maxFPS - minFPS
    if FPSMonitorDB.graph.showPercentiles and graphGrid.p1 and graphGrid.p01 then
        local fps = GetFramerate()
        local stats = CalculateStats(fps, fps > 0 and (1 / fps) or 0)
        local y1  = ((stats.low1 - minFPS) / fpsRange) * height + 2
        local y01 = ((stats.low01 - minFPS) / fpsRange) * height + 2
        graphGrid.p1:SetStartPoint("BOTTOMLEFT", 2, y1)
        graphGrid.p1:SetEndPoint("BOTTOMRIGHT", -2, y1)
        graphGrid.p1:Show()
        graphGrid.p01:SetStartPoint("BOTTOMLEFT", 2, y01)
        graphGrid.p01:SetEndPoint("BOTTOMRIGHT", -2, y01)
        graphGrid.p01:Show()
    else
        if graphGrid.p1 then graphGrid.p1:Hide() end
        if graphGrid.p01 then graphGrid.p01:Hide() end
    end

    local rightMin, rightMax = math.huge, -math.huge
    for _, m in ipairs(metrics) do
        local minVal, maxVal = math.huge, -math.huge
        for i = 1, sampleCount do
            local v = m.plot[i]
            if v then
                if v < minVal then minVal = v end
                if v > maxVal then maxVal = v end
            end
        end
        if m.key == "fps" then
            if graphYMin ~= nil then minVal = graphYMin end
            if graphYMax ~= nil then maxVal = graphYMax end
        elseif m.key == "frameTime" then
            if graphYMinFrameTime ~= nil then minVal = graphYMinFrameTime end
            if graphYMaxFrameTime ~= nil then maxVal = graphYMaxFrameTime end
        elseif m.key == "jitter" then
            if graphYMinJitter ~= nil then minVal = graphYMinJitter end
            if graphYMaxJitter ~= nil then maxVal = graphYMaxJitter end
        elseif m.key == "memory" then
            if graphYMinMemory ~= nil then minVal = graphYMinMemory end
            if graphYMaxMemory ~= nil then maxVal = graphYMaxMemory end
        else -- latency metrics
            if graphYMinLatency ~= nil then minVal = graphYMinLatency end
            if graphYMaxLatency ~= nil then maxVal = graphYMaxLatency end
        end
        if not minVal or not maxVal then
            minVal, maxVal = 0, 1
        elseif maxVal == minVal then
            maxVal = minVal + 1
        end
        local range = maxVal - minVal
        local prevX, prevY
        for i = 1, sampleCount do
            local val = m.plot[i]
            if val then
                local x = (i - 1) * stepX + 2
                local y = ((val - minVal) / range) * height + 2
                if y < 2 then y = 2 elseif y > height + 2 then y = height + 2 end
                if prevX then
                    local line = m.lines[i - 1]
                    if line then
                        line:SetStartPoint("BOTTOMLEFT", prevX, prevY)
                        line:SetEndPoint("BOTTOMLEFT", x, y)
                        line:SetColorTexture(m.color[1], m.color[2], m.color[3], 1)
                        line:SetThickness(m.thick)
                        line:Show()
                    end
                end
                prevX, prevY = x, y
            end
        end
        for i = sampleCount, graphSampleResolution - 1 do
            if m.lines[i] then m.lines[i]:Hide() end
        end
        if m.key == "memory" or m.key == "latency" or m.key == "homeLatency" or m.key == "worldLatency" then
            if minVal < rightMin then rightMin = minVal end
            if maxVal > rightMax then rightMax = maxVal end
        end
    end

    for i = 1, 3 do
        local frac = i * 0.25
        local y = frac * height + 2
        local line = graphGrid.h[i]
        if line then
            line:SetStartPoint("BOTTOMLEFT", 2, y)
            line:SetEndPoint("BOTTOMRIGHT", -2, y)
            line:SetColorTexture(0.5, 0.5, 0.5, 0.4)
            line:SetThickness(1)
            line:Show()
        end
        local label = graphLabels.h[i]
        if label then
            label:SetPoint("BOTTOMLEFT", graphFrame, "BOTTOMLEFT", 4, y)
            label:SetText(string.format("%.0f", minFPS + frac * fpsRange))
            label:Show()
        end
    end

    if rightMin < math.huge then
        local rangeR = rightMax - rightMin
        if rangeR == 0 then rangeR = 1 end
        for i = 1, 3 do
            local frac = i * 0.25
            local y = frac * height + 2
            local line = graphGrid.hRight[i]
            if line then
                line:SetStartPoint("BOTTOMLEFT", 2, y)
                line:SetEndPoint("BOTTOMRIGHT", -2, y)
                line:SetColorTexture(0.5, 0.5, 0.5, 0.2)
                line:SetThickness(1)
                line:Show()
            end
            local label = graphLabels.hRight[i]
            if label then
                label:SetPoint("BOTTOMRIGHT", graphFrame, "BOTTOMRIGHT", -4, y)
                label:SetText(string.format("%.0f", rightMin + frac * rangeR))
                label:Show()
            end
        end
    else
        for i = 1, 3 do
            if graphGrid.hRight[i] then graphGrid.hRight[i]:Hide() end
            if graphLabels.hRight[i] then graphLabels.hRight[i]:Hide() end
        end
    end

    for i = 0, 4 do
        local x = (i/4) * width + 2
        local line = graphGrid.v[i+1]
        if line then
            line:SetStartPoint("BOTTOMLEFT", x, 2)
            line:SetEndPoint("TOPLEFT", x, height + 2)
            line:SetColorTexture(0.5,0.5,0.5,0.4)
            line:SetThickness(1)
            line:Show()
        end
        local label = graphLabels.v[i+1]
        if label then
            local interval = graphTimeWindow / 4
            local t = interval * (4 - i)
            label:SetPoint("BOTTOMLEFT", graphFrame, "BOTTOMLEFT", x-6, -10)
            label:SetText(string.format("%ds", t))
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

    local thresh = FPSMonitorDB.graph.alertThreshold or 0
    if thresh > 0 and graphFrame.alertLine then
        local y = ((thresh - minFPS) / (maxFPS - minFPS)) * height + 2
        graphFrame.alertLine:SetStartPoint("BOTTOMLEFT", 2, y)
        graphFrame.alertLine:SetEndPoint("BOTTOMRIGHT", -2, y)
        graphFrame.alertLine:Show()
    elseif graphFrame.alertLine then
        graphFrame.alertLine:Hide()
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
    -- Use BackdropTemplate on modern clients
    displayFrame = CreateFrame("Frame", "FPSMonitorDisplay", UIParent, "BackdropTemplate")
    -- Slightly taller to leave room for the buttons
    -- so they don't overlap the statistic text
    -- Increase height slightly to leave room for additional controls
    displayFrame:SetSize(220, 226)
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

    -- graph toggle on main display
    local graphToggle = CreateFrame("CheckButton", nil, displayFrame, "UICheckButtonTemplate")
    -- Place the checkbox at the bottom left so it does not overlap text
    graphToggle:SetPoint("BOTTOMLEFT", displayFrame, "BOTTOMLEFT", 8, 8)
    if graphToggle.Text then graphToggle.Text:SetText("Show Graph") end
    graphToggle:SetChecked(FPSMonitorDB.graph.enabled)
    graphToggle:SetScript("OnClick", function(self)
        FPSMonitorDB.graph.enabled = self:GetChecked()
        if FPSMonitorDB.graph.enabled then
            if not graphFrame then CreateGraphFrame() end
            graphFrame:SetParent(displayFrame)
            graphFrame:ClearAllPoints()
            local gpos = FPSMonitorDB.graph.pos
            graphFrame:SetPoint("TOPLEFT", displayFrame, "BOTTOMLEFT", gpos.x, gpos.y)
            graphFrame:Show()
        else
            if graphFrame then graphFrame:Hide() end
        end
    end)

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

    if FPSMonitorDB.graph.enabled then
        if graphFrame then
            graphFrame:SetParent(displayFrame)
            graphFrame:ClearAllPoints()
            local gpos = FPSMonitorDB.graph.pos or { x = 0, y = -4 }
            graphFrame:SetPoint("TOPLEFT", displayFrame, "BOTTOMLEFT", gpos.x, gpos.y)
            graphFrame:Show()
        else
            CreateGraphFrame()
        end
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
    if not Settings and C_AddOns and C_AddOns.LoadAddOn then
        C_AddOns.LoadAddOn("Blizzard_Settings")
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

    local minimapCheck = CreateFrame("CheckButton", nil, optionsPanel.general, "UICheckButtonTemplate")
    minimapCheck:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    if minimapCheck.Text then minimapCheck.Text:SetText("Show minimap button") end
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
        ValidateConfig()        -- repopulates sums, history and graph buffers
    end)
    sampleSlider:SetValue(sampleInterval)
    sampleSlider.text:SetText("Sample window: " .. sampleInterval .. "s")

    local windowSlider = CreateFrame("Slider", nil, optionsPanel.general, "OptionsSliderTemplate")
    windowSlider:SetPoint("TOPLEFT", sampleSlider, "BOTTOMLEFT", 0, -40)
    windowSlider:SetMinMaxValues(10, 120)
    windowSlider:SetValueStep(10)
    windowSlider:SetObeyStepOnDrag(true)
    windowSlider:SetWidth(200)
    windowSlider:SetValue(graphTimeWindow)
    _G[windowSlider:GetName() .. "Low"]:SetText("10")
    _G[windowSlider:GetName() .. "High"]:SetText("120")
    local windowText = windowSlider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    windowText:SetPoint("TOP", windowSlider, "BOTTOM", 0, -2)
    windowSlider.text = windowText
    windowSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        self.text:SetText("Graph window: " .. value .. "s")
        FPSMonitorDB.graph.timeWindow = value
        UpdateGraphConfig()
    end)
    windowSlider:SetValue(graphTimeWindow)
    windowSlider.text:SetText("Graph window: " .. graphTimeWindow .. "s")

    local memorySlider = CreateFrame("Slider", nil, optionsPanel.general, "OptionsSliderTemplate")
    memorySlider:SetPoint("TOPLEFT", windowSlider, "BOTTOMLEFT", 0, -40)
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

    local throttleSlider = CreateFrame("Slider", nil, optionsPanel.general, "OptionsSliderTemplate")
    throttleSlider:SetPoint("TOPLEFT", memorySlider, "BOTTOMLEFT", 0, -40)
    throttleSlider:SetMinMaxValues(0.01, 0.5)
    throttleSlider:SetValueStep(0.01)
    throttleSlider:SetObeyStepOnDrag(true)
    throttleSlider:SetWidth(200)
    throttleSlider:SetValue(graphUpdateThrottle)
    _G[throttleSlider:GetName() .. "Low"]:SetText("0.01")
    _G[throttleSlider:GetName() .. "High"]:SetText("0.5")
    local throttleText = throttleSlider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    throttleText:SetPoint("TOP", throttleSlider, "BOTTOM", 0, -2)
    throttleSlider.text = throttleText
    throttleSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value * 100 + 0.5) / 100
        self.text:SetText("Graph update: " .. value .. "s")
        FPSMonitorDB.graphUpdateThrottle = value
        graphUpdateThrottle = value
    end)
    throttleSlider:SetValue(graphUpdateThrottle)
    throttleSlider.text:SetText("Graph update: " .. graphUpdateThrottle .. "s")

    local resolutionSlider = CreateFrame("Slider", nil, optionsPanel.general, "OptionsSliderTemplate")
    resolutionSlider:SetPoint("TOPLEFT", throttleSlider, "BOTTOMLEFT", 0, -40)
    resolutionSlider:SetMinMaxValues(50, 400)
    resolutionSlider:SetValueStep(10)
    resolutionSlider:SetObeyStepOnDrag(true)
    resolutionSlider:SetWidth(200)
    resolutionSlider:SetValue(graphSampleResolution)
    _G[resolutionSlider:GetName() .. "Low"]:SetText("50")
    _G[resolutionSlider:GetName() .. "High"]:SetText("400")
    local resText = resolutionSlider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    resText:SetPoint("TOP", resolutionSlider, "BOTTOM", 0, -2)
    resolutionSlider.text = resText
    resolutionSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        self.text:SetText("Graph resolution: " .. value)
        FPSMonitorDB.graph.graphSampleResolution = value
        graphSampleResolution = value
        UpdateGraphConfig()
    end)
    resolutionSlider:SetValue(graphSampleResolution)
    resolutionSlider.text:SetText("Graph resolution: " .. graphSampleResolution)

    local graphCheck = CreateFrame("CheckButton", nil, optionsPanel.general, "UICheckButtonTemplate")
    graphCheck:SetPoint("TOPLEFT", resolutionSlider, "BOTTOMLEFT", 0, -30)
    if graphCheck.Text then graphCheck.Text:SetText("Enable FPS graph") end
    graphCheck:SetChecked(FPSMonitorDB.graph.enabled)
    graphCheck:SetScript("OnClick", function(self)
        FPSMonitorDB.graph.enabled = self:GetChecked()
        if graphFrame then
            graphFrame:SetShown(FPSMonitorDB.graph.enabled)
        elseif FPSMonitorDB.graph.enabled then
            CreateGraphFrame()
        end
    end)

    -- Per-metric visibility checkboxes
    local metricChecks = {
        { key = "showFPS", label = "Show FPS" },
        { key = "showFrameTime", label = "Show Frame Time" },
        { key = "showMemory", label = "Show Memory" },
        { key = "showLatency", label = "Show Avg Latency" },
        { key = "showHomeLatency", label = "Show Home Lat" },
        { key = "showWorldLatency", label = "Show World Lat" },
    }

    local prev = graphCheck
    for i, info in ipairs(metricChecks) do
        local chk = CreateFrame("CheckButton", nil, optionsPanel.general, "UICheckButtonTemplate")
        chk:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 20, i == 1 and -8 or -4)
        if chk.Text then chk.Text:SetText(info.label) end
        chk:SetChecked(FPSMonitorDB.graph[info.key])
        chk:SetScript("OnClick", function(self)
            FPSMonitorDB.graph[info.key] = self:GetChecked()
            if C_Timer and C_Timer.After then
                C_Timer.After(graphUpdateThrottle, UpdateGraph)
            else
                UpdateGraph()
            end
        end)
        prev = chk
    end

    -- Y-axis bounds
    local function CreateBoundsBoxes(label, keyMin, keyMax, anchor)
        local boxMin = CreateFrame("EditBox", nil, optionsPanel.general, "InputBoxTemplate")
        boxMin:SetSize(60,20)
        boxMin:SetAutoFocus(false)
        boxMin:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 20, -8)
        if FPSMonitorDB.graph[keyMin] then boxMin:SetNumber(FPSMonitorDB.graph[keyMin]) end
        local lblMin = optionsPanel.general:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        lblMin:SetPoint("LEFT", boxMin, "RIGHT", 4, 0)
        lblMin:SetText(label .. " Min")
        boxMin:SetScript("OnEnterPressed", function(self)
            local n = tonumber(self:GetText())
            FPSMonitorDB.graph[keyMin] = n
            if self:GetText() == "" then FPSMonitorDB.graph[keyMin] = nil end
            UpdateGraphConfig()
        end)
        boxMin:SetScript("OnEditFocusLost", boxMin:GetScript("OnEnterPressed"))

        local boxMax = CreateFrame("EditBox", nil, optionsPanel.general, "InputBoxTemplate")
        boxMax:SetSize(60,20)
        boxMax:SetAutoFocus(false)
        boxMax:SetPoint("LEFT", lblMin, "RIGHT", 20, 0)
        if FPSMonitorDB.graph[keyMax] then boxMax:SetNumber(FPSMonitorDB.graph[keyMax]) end
        local lblMax = optionsPanel.general:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        lblMax:SetPoint("LEFT", boxMax, "RIGHT", 4, 0)
        lblMax:SetText(label .. " Max")
        boxMax:SetScript("OnEnterPressed", function(self)
            local n = tonumber(self:GetText())
            FPSMonitorDB.graph[keyMax] = n
            if self:GetText() == "" then FPSMonitorDB.graph[keyMax] = nil end
            UpdateGraphConfig()
        end)
        boxMax:SetScript("OnEditFocusLost", boxMax:GetScript("OnEnterPressed"))
        return boxMax
    end

    local yMinBox = CreateBoundsBoxes("FPS", "yMin", "yMax", prev)
    prev = yMinBox
    prev = CreateBoundsBoxes("Frame", "yMinFrameTime", "yMaxFrameTime", prev)
    prev = CreateBoundsBoxes("Memory", "yMinMemory", "yMaxMemory", prev)
    prev = CreateBoundsBoxes("Latency", "yMinLatency", "yMaxLatency", prev)
    prev = CreateBoundsBoxes("Jitter", "yMinJitter", "yMaxJitter", prev)
    
    local smoothingSlider = CreateFrame("Slider", nil, optionsPanel.general, "OptionsSliderTemplate")
    smoothingSlider:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -30)
    smoothingSlider:SetMinMaxValues(0, 1)
    smoothingSlider:SetValueStep(0.05)
    smoothingSlider:SetObeyStepOnDrag(true)
    smoothingSlider:SetWidth(200)
    smoothingSlider:SetValue(FPSMonitorDB.graph.smoothing or 0)
    _G[smoothingSlider:GetName() .. "Low"]:SetText("0")
    _G[smoothingSlider:GetName() .. "High"]:SetText("1")
    local smoothingText = smoothingSlider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    smoothingText:SetPoint("TOP", smoothingSlider, "BOTTOM", 0, -2)
    smoothingSlider.text = smoothingText
    smoothingSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value * 100 + 0.5) / 100
        self.text:SetText("Smoothing: " .. value)
        FPSMonitorDB.graph.smoothing = value
        UpdateGraph()
    end)
    smoothingSlider:SetValue(FPSMonitorDB.graph.smoothing or 0)
    smoothingSlider.text:SetText("Smoothing: " .. (FPSMonitorDB.graph.smoothing or 0))

    local homeChk = CreateFrame("CheckButton", nil, optionsPanel.general, "UICheckButtonTemplate")
    homeChk:SetPoint("TOPLEFT", smoothingSlider, "BOTTOMLEFT", 0, -8)
    if homeChk.Text then homeChk.Text:SetText("Show home latency") end
    homeChk:SetChecked(FPSMonitorDB.graph.showHomeLatency)
    homeChk:SetScript("OnClick", function(self)
        FPSMonitorDB.graph.showHomeLatency = self:GetChecked()
        UpdateGraph()
    end)

    local worldChk = CreateFrame("CheckButton", nil, optionsPanel.general, "UICheckButtonTemplate")
    worldChk:SetPoint("TOPLEFT", homeChk, "BOTTOMLEFT", 0, -4)
    if worldChk.Text then worldChk.Text:SetText("Show world latency") end
    worldChk:SetChecked(FPSMonitorDB.graph.showWorldLatency)
    worldChk:SetScript("OnClick", function(self)
        FPSMonitorDB.graph.showWorldLatency = self:GetChecked()
        UpdateGraph()
    end)

    local pctChk = CreateFrame("CheckButton", nil, optionsPanel.general, "UICheckButtonTemplate")
    pctChk:SetPoint("TOPLEFT", worldChk, "BOTTOMLEFT", 0, -4)
    if pctChk.Text then pctChk.Text:SetText("Show percentiles") end
    pctChk:SetChecked(FPSMonitorDB.graph.showPercentiles)
    pctChk:SetScript("OnClick", function(self)
        FPSMonitorDB.graph.showPercentiles = self:GetChecked()
        UpdateGraph()
    end)

    local alertSlider = CreateFrame("Slider", nil, optionsPanel.general, "OptionsSliderTemplate")
    alertSlider:SetPoint("TOPLEFT", pctChk, "BOTTOMLEFT", 0, -30)
    alertSlider:SetMinMaxValues(5, 120)
    alertSlider:SetValueStep(5)
    alertSlider:SetObeyStepOnDrag(true)
    alertSlider:SetWidth(200)
    alertSlider:SetValue(FPSMonitorDB.graph.alertThreshold or 30)
    _G[alertSlider:GetName() .. "Low"]:SetText("5")
    _G[alertSlider:GetName() .. "High"]:SetText("120")
    local alertText = alertSlider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    alertText:SetPoint("TOP", alertSlider, "BOTTOM", 0, -2)
    alertSlider.text = alertText
    alertSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        self.text:SetText("Alert threshold: " .. value .. " FPS")
        FPSMonitorDB.graph.alertThreshold = value
    end)
    alertSlider:SetValue(FPSMonitorDB.graph.alertThreshold or 30)
    alertSlider.text:SetText("Alert threshold: " .. (FPSMonitorDB.graph.alertThreshold or 30) .. " FPS")

    local exportBtn = CreateFrame("Button", nil, optionsPanel.general, "UIPanelButtonTemplate")
    exportBtn:SetSize(100, 22)
    exportBtn:SetPoint("TOPLEFT", alertSlider, "BOTTOMLEFT", 0, -8)
    exportBtn:SetText("Export CSV")
    exportBtn:SetScript("OnClick", function()
        SlashCmdList["FPSGRAPH"]("export")
    end)

    -- Register the options panel using the Settings API
    if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        optionsPanel.category = Settings.RegisterCanvasLayoutCategory(optionsPanel, optionsPanel.name)
        Settings.RegisterAddOnCategory(optionsPanel.category)
    end

end

-- Open configuration panel using whichever API is available
local function OpenConfigPanel()
    if not optionsPanel then return end

    if Settings and Settings.OpenToCategory and optionsPanel.category then
        Settings.OpenToCategory(optionsPanel.category)
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
        print("/fpsgraph window <s> - set graph time window")
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

    -- Throttled graph updates only when graph is visible and not paused
    if graphFrame and graphFrame:IsShown() and not graphPaused then
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
        captureStartTime = GetTime() + captureDelay
        capturing = false
        -- Seed graph history with initial values to avoid extreme spikes
        do
            local now = GetTime()
            local initialFPS = GetFramerate() or 0
            local initialFrameTime = initialFPS > 0 and (1000 / initialFPS) or 0
            local _, _, homeLat, worldLat = GetNetStats()
            local initLatency = (homeLat and worldLat) and ((homeLat + worldLat) / 2) or 0
            graphHistory.times[1] = now
            graphHistory.frameTime[1] = initialFrameTime
            graphHistory.fps[1] = initialFPS
            graphHistory.memory[1] = updateFrame and updateFrame.currentMemory or 0
            graphHistory.latency[1] = initLatency
            graphHistory.homeLatency[1] = homeLat or 0
            graphHistory.worldLatency[1] = worldLat or 0
            graphStart = 1
            graphCount = 1
        end
        sampleInterval = FPSMonitorDB.sampleInterval or sampleInterval
        updateInterval = FPSMonitorDB.updateInterval or updateInterval
        memoryUpdateInterval = FPSMonitorDB.memoryUpdateInterval or memoryUpdateInterval
        graphUpdateThrottle = FPSMonitorDB.graphUpdateThrottle or graphUpdateThrottle
        if UpdateAddOnMemoryUsage and GetAddOnMemoryUsage then
            UpdateAddOnMemoryUsage()
            updateFrame.currentMemory = GetAddOnMemoryUsage(addonName)
        end
        -- Initialize configuration panel and graph frame
        pcall(CreateOptionsPanel)
        -- Ensure the graph enabled flag defaults to true on first run
        FPSMonitorDB.graph.enabled = FPSMonitorDB.graph.enabled == nil and true or FPSMonitorDB.graph.enabled
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
        graphPaused = false
    elseif event == "PLAYER_LEAVING_WORLD" then
        capturing = false
        captureStartTime = nil
        UpdateCharacterStats()
        graphPaused = true
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
