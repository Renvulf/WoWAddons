-- FPSMonitor.lua
-- Simple FPS monitoring addon for World of Warcraft
-- Displays various frame-rate statistics and provides a minimap toggle button

-- The addon name is provided as the first return from ... when this file is loaded.
-- We only need the name for event filtering so discard the second value.
local addonName = ...

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
        angle = 0, -- radians around the minimap for the button position
    },
}

-- History of recent frame times. We keep samples for the last `sampleInterval`
-- seconds using a simple ring buffer to avoid expensive table.remove calls.
local frameHistory = {}
local historyStart = 1
local historyCount = 0
local historyTime = 0
local sessionMinFPS = math.huge
local sessionMaxFPS = 0
local displayFrame
local minimapButton

-- Reposition minimap button around the minimap based on stored angle
local function UpdateMinimapButtonPosition(angle)
    if not minimapButton or not Minimap then return end
    angle = angle or FPSMonitorDB.minimap.angle or 0
    local radius = (Minimap:GetWidth() / 2) + 5
    local x = radius * math.cos(angle)
    local y = radius * math.sin(angle)
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

-- Utility: insert value and trim time window
local function AddSample(dt)
    -- Ignore extremely long frames which usually occur during loading screens
    if dt <= 0 or dt > 1 then return end

    local fps = 1 / dt

    -- Add sample at the end of the buffer
    local index = historyStart + historyCount
    frameHistory[index] = {dt = dt, fps = fps}
    historyCount = historyCount + 1
    historyTime = historyTime + dt

    -- Trim old samples outside the sliding window
    while historyCount > 0 and historyTime > sampleInterval do
        local sample = frameHistory[historyStart]
        historyTime = historyTime - sample.dt
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

    if fps < sessionMinFPS then sessionMinFPS = fps end
    if fps > sessionMaxFPS then sessionMaxFPS = fps end
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

    local sumFPS, sumDT, sumDTSquared = 0, 0, 0
    -- Keep small sorted tables of the lowest 1% and 0.1% FPS values to avoid
    -- allocating large tables every update. This drastically reduces memory
    -- churn compared to sorting the full history each time.
    local low1List, low01List = {}, {}
    local low1Size = math.max(1, math.floor(count * 0.01 + 0.5))
    local low01Size = math.max(1, math.floor(count * 0.001 + 0.5))

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

    for i = historyStart, historyStart + historyCount - 1 do
        local sample = frameHistory[i]
        sumFPS = sumFPS + sample.fps
        sumDT = sumDT + sample.dt
        sumDTSquared = sumDTSquared + sample.dt * sample.dt

        InsertSorted(low1List, sample.fps, low1Size)
        InsertSorted(low01List, sample.fps, low01Size)
    end

    local avgFPS = sumFPS / count
    local low1 = low1List[low1Size] or low1List[#low1List]
    local low01 = low01List[low01Size] or low01List[#low01List]

    -- calculate jitter as standard deviation of frame times
    local meanDT = sumDT / count
    local variance = (sumDTSquared / count) - meanDT * meanDT

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
local function ColorizeFPS(fps)
    if fps < 30 then
        return string.format("|cffff0000%.1f|r", fps)
    elseif fps < 60 then
        return string.format("|cffffff00%.1f|r", fps)
    else
        return string.format("|cff00ff00%.1f|r", fps)
    end
end

local function UpdateDisplay(stats)
    if not displayFrame then return end
    local text = string.format(
        "Current FPS: %s\n" ..
        "Average FPS: %.1f\n" ..
        "Min FPS: %.1f / Max FPS: %.1f\n" ..
        "1%% Low FPS: %.1f\n" ..
        "0.1%% Low FPS: %.1f\n" ..
        "Frame Time: %.2f ms\n" ..
        "Jitter: %.2f ms",
        ColorizeFPS(stats.current), stats.average, stats.min, stats.max,
        stats.low1, stats.low01, stats.frameTime, stats.jitter)
    displayFrame.text:SetText(text)
end

-- Create movable display frame
local function CreateDisplayFrame()
    if displayFrame then return end
    -- Use BackdropTemplate for compatibility with modern client versions
    displayFrame = CreateFrame("Frame", "FPSMonitorDisplay", UIParent, BackdropTemplateMixin and "BackdropTemplate")
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
    displayFrame.text:SetWidth(displayFrame:GetWidth() - 20)
    displayFrame.text:SetFont(STANDARD_TEXT_FONT, 12)
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
            local angle = math.atan2 and math.atan2(py - my, px - mx) or math.atan(py - my, px - mx)
            FPSMonitorDB.minimap.angle = angle
            UpdateMinimapButtonPosition(angle)
        end)
    end)
    minimapButton:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
        UpdateMinimapButtonPosition(FPSMonitorDB.minimap.angle)
    end)
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
        historyStart = 1
        historyCount = 0
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
    -- 'elapsed' is the time since the last OnUpdate and represents the
    -- frame's duration. It is more reliable than calculating our own
    -- delta using GetTime().
    AddSample(elapsed)

    self.t = (self.t or 0) + elapsed
    if self.t >= updateInterval then
        self.t = 0
        local currentFPS = GetFramerate()
        local stats = CalculateStats(currentFPS, elapsed)
        UpdateDisplay(stats)
    end
end)

-- Initialize addon
local function OnEvent(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        -- Ensure saved variables exist then merge defaults
        if type(FPSMonitorDB) ~= "table" then
            FPSMonitorDB = {}
        end
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
