local Model = dofile("Smartbot/Model.lua")

local m = Model:New()
-- PredictDelta on empty model should be 0 and finite
local y = m:PredictDelta({0,0,0,0,0,0,0,0,0})
assert(y == 0 and y == y, "empty model delta")

-- Standardize should handle zero variance without NaN
local vec = m:Standardize({1,2,3,4,5,6,7,8,9})
for i=1,#vec do assert(vec[i] == vec[i], "std finite") end

-- PredictDelta with zero variance but nonzero weight stays finite
m.w[1] = 1
m.var[1] = 0
m.n = 10
local y2 = m:PredictDelta({1,0,0,0,0,0,0,0,0})
assert(y2 == y2 and math.abs(y2) < 1e9, "finite delta")

print("guards_spec passed")
