-- FPSMonitor.lua
-- Simple FPS monitoring addon for World of Warcraft
-- Displays various frame-rate statistics and provides a minimap toggle button

local addonName, addon = ...

local sampleInterval = 60 -- seconds to keep frame history for average and percentiles
local updateInterval = 0.5 -- seconds between display updates

-- SavedVariables tables declared in the TOC file. They may not exist on the
-- first run so we create them if needed when the addon loads.
FPSMonitorDB = FPSMonitorDB or {}
FPSPerCharDB = FPSPerCharDB or {}

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
    },
}

local frameHistory = {}
local historyTime = 0
local lastTime = GetTime()
local sessionMinFPS = math.huge
local sessionMaxFPS = 0
local displayFrame
local minimapButton

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

-- Utility: insert value and trim time window
local function AddSample(dt)
    -- Ignore extremely long frames which usually occur during loading screens
    if dt <= 0 or dt > 1 then return end
    local fps = 1 / dt
    table.insert(frameHistory, {dt = dt, fps = fps})
    historyTime = historyTime + dt
    while historyTime > sampleInterval do
        local removed = table.remove(frameHistory, 1)
        historyTime = historyTime - removed.dt
    end
    if fps < sessionMinFPS then sessionMinFPS = fps end
    if fps > sessionMaxFPS then sessionMaxFPS = fps end
end

-- Compute stats from history
local function CalculateStats(currentFPS, currentDT)
    local count = #frameHistory
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

    local sumFPS, sumDT = 0, 0
    local dtValues = {}
    local fpsValues = {}
    for i, sample in ipairs(frameHistory) do
        sumFPS = sumFPS + sample.fps
        sumDT = sumDT + sample.dt
        table.insert(dtValues, sample.dt)
        table.insert(fpsValues, sample.fps)
    end
    local avgFPS = sumFPS / count
    table.sort(fpsValues)
    table.sort(dtValues)
    local function percentile(values, p)
        local index = math.max(1, math.floor(#values * p + 0.5))
        return values[index]
    end
    local low1 = percentile(fpsValues, 0.01)
    local low01 = percentile(fpsValues, 0.001)

    -- calculate jitter as standard deviation of frame times
    local meanDT = sumDT / count
    local variance = 0
    for _, dt in ipairs(dtValues) do
        local diff = dt - meanDT
        variance = variance + diff * diff
    end
    variance = variance / count

    return {
        current = currentFPS,
        average = avgFPS,
        min = sessionMinFPS,
        max = sessionMaxFPS,
        low1 = low1,
        low01 = low01,
        frameTime = currentDT * 1000,
        jitter = math.sqrt(variance) * 1000,
    }
end

-- Update the on-screen display text
local function UpdateDisplay(stats)
    if not displayFrame then return end
    local text = string.format(
        "Current FPS: %.1f\nAverage FPS: %.1f\nMin FPS: %.1f / Max FPS: %.1f\n1%% Low FPS: %.1f\n0.1%% Low FPS: %.1f\nFrame Time: %.2f ms\nJitter: %.2f ms",
        stats.current, stats.average, stats.min, stats.max, stats.low1, stats.low01, stats.frameTime, stats.jitter)
    displayFrame.text:SetText(text)
end

-- Create movable display frame
local function CreateDisplayFrame()
    if displayFrame then return end
    displayFrame = CreateFrame("Frame", "FPSMonitorDisplay", UIParent)
    displayFrame:SetSize(220, 140)
    -- Position is restored from the saved configuration
    local pos = FPSMonitorDB.pos or defaultConfig.pos
    displayFrame:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
    displayFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"})
    displayFrame:SetBackdropColor(0, 0, 0, 0.6)
    displayFrame:EnableMouse(true)
    displayFrame:SetMovable(true)
    displayFrame:RegisterForDrag("LeftButton")
    displayFrame:SetScript("OnDragStart", displayFrame.StartMoving)
    displayFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, relativePoint, x, y = self:GetPoint()
        FPSMonitorDB.pos = { point = point, relativePoint = relativePoint, x = x, y = y }
    end)

    displayFrame.text = displayFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    displayFrame.text:SetPoint("TOPLEFT", 10, -10)
    displayFrame.text:SetJustifyH("LEFT")
    displayFrame.text:SetText("FPS Monitor")
end

-- Create simple minimap button
local function CreateMinimapButton()
    minimapButton = CreateFrame("Button", "FPSMonitorMinimapButton", Minimap)
    minimapButton:SetSize(32, 32)
    minimapButton:SetFrameStrata("MEDIUM")
    minimapButton:SetFrameLevel(8)
    minimapButton:SetNormalTexture("Interface/AddOns/FPSMonitor/FPS1.tga")
    minimapButton:SetHighlightTexture("Interface/Minimap/UI-Minimap-ZoomButton-Highlight")
    minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT")
    minimapButton:SetScript("OnClick", function()
        if displayFrame and displayFrame:IsShown() then
            displayFrame:Hide()
        else
            CreateDisplayFrame()
            displayFrame:Show()
        end
    end)
    if FPSMonitorDB.minimap.hide then
        minimapButton:Hide()
    end
end

-- Slash command to toggle
SLASH_FPSMON1 = "/fpsmon"
SlashCmdList["FPSMON"] = function(msg)
    msg = msg and msg:lower() or ""
    if msg == "reset" then
        frameHistory = {}
        historyTime = 0
        sessionMinFPS = math.huge
        sessionMaxFPS = 0
        print("FPSMonitor: session statistics reset")
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
    end

    if displayFrame and displayFrame:IsShown() then
        displayFrame:Hide()
    else
        CreateDisplayFrame()
        displayFrame:Show()
    end
end

-- Main OnUpdate handler: collect data and refresh display
local updateFrame = CreateFrame("Frame")
updateFrame:SetScript("OnUpdate", function(self, elapsed)
    local now = GetTime()
    local dt = now - lastTime
    lastTime = now

    AddSample(dt)
    self.t = (self.t or 0) + elapsed
    if self.t >= updateInterval then
        self.t = 0
        local currentFPS = GetFramerate()
        local stats = CalculateStats(currentFPS, math.min(dt, 1))
        UpdateDisplay(stats)
    end
end)

-- Initialize addon
local function OnEvent(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        -- Merge saved variables with defaults
        DeepCopyDefaults(defaultConfig, FPSMonitorDB)
    elseif event == "PLAYER_LOGIN" then
        if not FPSMonitorDB.minimap.hide then
            CreateMinimapButton()
        end
    end
end
updateFrame:RegisterEvent("ADDON_LOADED")
updateFrame:RegisterEvent("PLAYER_LOGIN")
updateFrame:SetScript("OnEvent", OnEvent)
