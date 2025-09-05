local Segment = dofile("Interface/AddOns/Smartbot/Segment.lua")

local seg = Segment:New(0)
seg:AddEvent(0, "A", 100, false)
seg:AddEvent(1, "B", 50, true)
seg:AddEvent(4, "A", 20, false)
seg:AddEvent(7, "C", 30, false)
seg:Finish(10)

assert(seg.events == 4, "events count")
assert(seg.totalDamage == 150, "total damage")
assert(seg.totalHealing == 50, "total healing")
assert(math.abs(seg.activeTime - 7) < 1e-6, "active time")
assert(math.abs(seg.avgTargets - 1.75) < 1e-6, "avg targets")
assert(math.abs(seg.dps - (150/7)) < 1e-6, "dps")
assert(math.abs(seg.hps - (50/7)) < 1e-6, "hps")

print("segment_spec passed")
