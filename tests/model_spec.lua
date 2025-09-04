local Model = dofile("Smartbot/Model.lua")

local m = Model:New()
local seg = {activeTime=30,totalDamage=10000,avgTargets=1}
local x = {1,2,3,4,5,6,7,8,9,10}
local params = {lr=0.02, deltaHuber=300}
local yhat1, err1 = m:Update(x, 500, seg, params)
local n1 = m.n
local yhat2, err2 = m:Update(x, 600, seg, params)
assert(m.n == n1 + 1, "n increment")
local any = false
for _, w in ipairs(m.w) do if w ~= 0 then any = true break end end
assert(any, "weights updated")
assert(m.maeEWMA > 0, "maeEWMA updated")
print("model_spec passed")
