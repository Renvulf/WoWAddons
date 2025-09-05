-- test_scoring.lua - validates score monotonicity

dofile("DevHarness/wow_stubs.lua")
local Features = dofile("Smartbot/Features.lua")
local Model = dofile("Smartbot/Model.lua")

-- create two items and place one in inventory
StubItem("base", {ITEM_MOD_INTELLECT_SHORT = 10}, 100, "INVTYPE_HEAD")
StubItem("better", {ITEM_MOD_INTELLECT_SHORT = 20}, 100, "INVTYPE_HEAD")
SetInventory(1, "base")

local model = Model:New()
for i=1,#Features.FEATURE_ORDER do
    model.rls.w[i] = 1
end

local baseVec = Features.BuildItemVector("base")
local newVec = Features.BuildItemVector("better")
local baseScore = 0
local newScore = 0
for i=1,#baseVec do
    baseScore = baseScore + model.rls.w[i] * baseVec[i]
    newScore = newScore + model.rls.w[i] * newVec[i]
end
assert(newScore > baseScore, "improved item should score higher")
print("test_scoring passed")
