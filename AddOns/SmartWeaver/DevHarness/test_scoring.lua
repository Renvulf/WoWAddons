package.path = package.path .. ';../?.lua'
require("wow_stubs")
local addon="SmartWeaver"
local SW = {}
local function load(name)
    return assert(loadfile("../"..name))(addon, SW)
end
SW.Const = load("Constants.lua")
SW.Util = load("Util.lua")
SW.ItemStats = { Features=function(link) return link.stats end }
SW.db={models={},history={},config={}}
SW.state={charKey="Tester-Test:62",role="DAMAGER"}
SW.Learner = load("Learner.lua")
SW.Scoring = load("Scoring.lua")
local itemA={stats={1,0,1,0,0,0,0,0,0,0}}
local itemB={stats={2,0,1,0,0,0,0,0,0,0}}
C_Item.GetItemStats=function(link) return link.stats end
print("scoreA", SW.Scoring:ScoreItem(itemA))
print("scoreB", SW.Scoring:ScoreItem(itemB))
