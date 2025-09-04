-- Smartbot - Segment.lua
local Segment = {}
Segment.__index = Segment

function Segment:New(startTime)
    local o = {
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
        features = nil, -- optional: feature vector captured at pull start
        avgTargets = 0,
        dps = 0, hps = 0,
    }
    setmetatable(o, Segment)
    return o
end

local function Count(tbl)
    local n = 0
    for _ in pairs(tbl) do n = n + 1 end
    return n
end

-- timestamp: number, destGUID: string, amount: number, isHeal: boolean
function Segment:AddEvent(timestamp, destGUID, amount, isHeal)
    self.events = (self.events or 0) + 1
    if isHeal then
        self.healingEvents = (self.healingEvents or 0) + 1
        self.totalHealing = (self.totalHealing or 0) + (amount or 0)
    else
        self.totalDamage = (self.totalDamage or 0) + (amount or 0)
    end

    if self.lastEventTime then
        local dt = timestamp - self.lastEventTime
        if dt > 3 then dt = 3 end
        if dt > 0 then
            self.activeTime = (self.activeTime or 0) + dt
        end
    end
    self.lastEventTime = timestamp

    -- moving window for unique target count
    local tt = self.targetTimes
    if destGUID then
        tt[destGUID] = timestamp
    end
    for guid, t in pairs(tt) do
        if timestamp - t > 5 then tt[guid] = nil end
    end
    self.targetSum = (self.targetSum or 0) + Count(tt)
end

function Segment:Finish(endTime)
    self.segEnd = endTime or (GetTime and GetTime()) or 0
    if (self.events or 0) > 0 then
        self.avgTargets = (self.targetSum or 0) / (self.events or 1)
    else
        self.avgTargets = 0
    end
    if self.features then
        self.features[#self.features + 1] = self.avgTargets
    end
    if (self.activeTime or 0) > 0 then
        self.dps = (self.totalDamage or 0) / self.activeTime
        self.hps = (self.totalHealing or 0) / self.activeTime
    else
        self.dps, self.hps = 0, 0
    end
    return self
end

SmartbotSegment = Segment
return Segment
