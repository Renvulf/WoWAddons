-- test_learner.lua - validates learning blend behaviour

dofile("DevHarness/wow_stubs.lua")
local Features = dofile("Smartbot/Features.lua")
local Model = dofile("Smartbot/Model.lua")

local m = Model:New()
local dim = #Features.FEATURE_ORDER
local x = {}
for i=1,dim do x[i] = i end

-- update RLS with a known target
m:Update(x, 100)
local pred = m:Predict(x)
assert(math.abs(pred - 100) < 1e-3, "RLS prediction")

-- update delta learner to influence blending
local dx = {}
for i=1,dim do dx[i] = 1 end
m:UpdateDelta(dx, 50)
assert(m.alpha > 0 and m.alpha < 1, "blend alpha range")

print("test_learner passed")
