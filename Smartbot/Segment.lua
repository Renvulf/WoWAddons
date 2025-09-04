local Segment = {}
Segment.__index = Segment

-- Creates a new combat segment starting at startTime.
-- Each instance tracks cumulative damage/healing and target counts.
function Segment:New(startTime)
    local seg = {
        segStart = startTime or 0,
        segEnd = nil,
        totalDamage = 0,
        totalHealing = 0,
        events = 0,
        healingEvents = 0,
        activeTime = 0,
        lastEventTime = nil,
        targetTimes = {},
        targetSum = 0,
        features = nil,
        avgTargets = 0,
        dps = 0,
        hps = 0,
    }
    return setmetatable(seg, Segment)
end

local function Count(tbl)
    local n = 0
    for _ in pairs(tbl) do
        n = n + 1
    end
    return n
end

-- Records a combat log event for this segment.
-- timestamp: event time from CombatLogGetCurrentEventInfo().
-- destGUID: target GUID of the event.
-- amount: damage or healing amount.
-- isHeal: true when the event is a heal.
function Segment:AddEvent(timestamp, destGUID, amount, isHeal)
    self.events = self.events + 1
    if isHeal then
        self.healingEvents = (self.healingEvents or 0) + 1
        self.totalHealing = (self.totalHealing or 0) + (amount or 0)
    else
        self.totalDamage = self.totalDamage + (amount or 0)
    end

    if self.lastEventTime then
        local dt = timestamp - self.lastEventTime
        if dt > 3 then
            dt = 3
        end
        if dt > 0 then
            self.activeTime = self.activeTime + dt
        end
    end
    self.lastEventTime = timestamp

    local tt = self.targetTimes
    tt[destGUID] = timestamp
    for guid, t in pairs(tt) do
        if timestamp - t > 5 then
            tt[guid] = nil
        end
    end
    self.targetSum = self.targetSum + Count(tt)
end

-- Finalizes the segment and computes summary stats.
function Segment:Finish(endTime)
    self.segEnd = endTime or (GetTime and GetTime() or 0)
    if self.events > 0 then
        self.avgTargets = self.targetSum / self.events
    else
        self.avgTargets = 0
    end
    if self.features then
        self.features[#self.features + 1] = self.avgTargets
    end
    if (self.activeTime or 0) > 0 then
        self.dps = self.totalDamage / self.activeTime
        self.hps = self.totalHealing / self.activeTime
    else
        self.dps = 0
        self.hps = 0
    end
    return self
end

SmartbotSegment = Segment
return Segment
