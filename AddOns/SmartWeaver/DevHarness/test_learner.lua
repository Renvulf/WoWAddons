package.path = package.path .. ';../?.lua'
require('wow_stubs')
local addon='SmartWeaver'
local SW = {}
local function load(name)
    return assert(loadfile('../'..name))(addon, SW)
end
SW.Const = load('Constants.lua')
SW.Util = load('Util.lua')
SW.ItemStats = { Features=function() return {1,0,1,1,1,1,0,0,0,0} end }
SW.db={models={},history={},config={}}
SW.state={charKey='Tester-Test:62',role='DAMAGER'}
SW.Learner = load('Learner.lua')
SW.Learner:RecordEncounter(1000,0)
local wD = SW.Learner:GetWeights()
print('dps_samples', SW.db.models[SW.state.charKey].samples)
print('dps_weight1', wD[1])
SW.state={charKey='Tester-Test:65',role='HEALER'}
SW.Learner:RecordEncounter(0,2000)
local wH = SW.Learner:GetWeights()
print('hps_samples', SW.db.models[SW.state.charKey].samples)
print('hps_weight1', wH[1])
