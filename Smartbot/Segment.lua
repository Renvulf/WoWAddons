-- Segment.lua - combat segment tracking for Smartbot

local Segment = {}
Segment.__index = Segment

function Segment:New(startTime)
    local o = {
        segStart = startTime or 0,
        segEnd = 0,
        totalDamage = 0,
        totalHealing = 0,
        events = 0,
        activeTime = 0,
        lastEventTime = nil,
        targetTimes = {},
        targetSum = 0,
        features = nil,
        avgTargets = 0,
        dps = 0,
        hps = 0,
    }
    return setmetatable(o, Segment)
end

local function count(tbl)
    local n = 0
    for _ in pairs(tbl) do n = n + 1 end
    return n
end

function Segment:AddEvent(timestamp, destGUID, amount, isHeal)
    self.events = self.events + 1
    if isHeal then
        self.totalHealing = self.totalHealing + (amount or 0)
    else
        self.totalDamage = self.totalDamage + (amount or 0)
    end

    if self.lastEventTime then
        local dt = timestamp - self.lastEventTime
        if dt > 3 then dt = 3 end
        if dt > 0 then
            self.activeTime = self.activeTime + dt
        end
    end
    self.lastEventTime = timestamp

    if destGUID then
        self.targetTimes[destGUID] = timestamp
    end
    for guid, t in pairs(self.targetTimes) do
        if timestamp - t > 5 then
            self.targetTimes[guid] = nil
        end
    end
    self.targetSum = self.targetSum + count(self.targetTimes)
end

function Segment:Finish(endTime)
    self.segEnd = endTime or 0
    if self.events > 0 then
        self.avgTargets = self.targetSum / self.events
    else
        self.avgTargets = 0
    end
    if self.features then
        self.features[#self.features + 1] = self.avgTargets
    end
    if self.activeTime > 0 then
        self.dps = self.totalDamage / self.activeTime
        self.hps = self.totalHealing / self.activeTime
    else
        self.dps, self.hps = 0, 0
    end
    return self
end

SmartbotSegment = Segment
return Segment
