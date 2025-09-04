package.path = package.path .. ';../?.lua'
require("wow_stubs")
local addon="SmartWeaver"
local SW = {}
local function load(name)
    return assert(loadfile("../"..name))(addon, SW)
end
SW.Const = load("Constants.lua")
SW.Util = load("Util.lua")
SW.ItemStats = { Features=function() return {1,0,1,1,1,1,0,0,0,0} end }
SW.db={models={},history={},config={}}
SW.state={charKey="Tester-Test:62",role="DAMAGER"}
SW.Learner = load("Learner.lua")
SW.Learner:RecordEncounter(1000,0)
local w = SW.Learner:GetWeights()
print("samples", SW.db.models[SW.state.charKey].samples)
print("weights", SW.Util.jsonEncode(w))
