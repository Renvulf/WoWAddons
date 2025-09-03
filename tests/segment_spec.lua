local Segment = dofile("Smartbot/Segment.lua")

local seg = Segment:New(0)
seg:AddEvent(0, "A", 100)
seg:AddEvent(1, "B", 50)
seg:AddEvent(4, "A", 20)
seg:AddEvent(7, "C", 30)
seg:Finish(10)

assert(seg.events == 4, "events count")
assert(seg.totalDamage == 200, "total damage")
assert(math.abs(seg.activeTime - 7) < 1e-6, "active time")
assert(math.abs(seg.avgTargets - 1.75) < 1e-6, "avg targets")

print("segment_spec passed")
