local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
ZygorGuidesViewer.Gold.guides_loaded=true
if ZGV:DoMutex("GoldFarmHWOD") then return end
if UnitFactionGroup("player")~="Horde" then return end
ZygorGuidesViewer.GuideMenuTier = "WOD"
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Clam Meat, Small Lustrous Pearl",{
meta={goldtype="route",levelreq={1},itemtype="misc"},
items={{5503,324},{5498,8}},
maps={"Echo Isles"},
},[[
step
map Echo Isles/0
path follow smart; loop on; ants curved
path	64.90,25.90	67.20,18.30	65.20,10.40
path	59.40,9.30	54.90,13.10	56.70,23.70
Kill Spitescale enemies around this area
|tip Follow the path as well as enter the cave when you come across them.
use the Small Barnacled Clam##5523
|goldcollect 324 Clam Meat##5503
|goldcollect 8 Small Lustrous Pearl##5498
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Raw Elekk Meat",{
meta={goldtype="route",levelreq={35},itemtype="food"},
items={{109134,232},{111557,656,'crap'}},
maps={"Nagrand D"},
},[[
step
label "First_Path"
map Nagrand D/0
path follow loose; loop on; ants curved; dist 20
path	63.20,44.30	61.20,45.00	61.00,47.10
path	59.80,47.30	60.30,48.90	62.10,46.70
path	62.80,49.00	63.70,49.60
Kill Meadowstomper enemies around this area
|goldcollect 232 Raw Elekk Meat##109134
|meta crap_items_follow=1
|goldcollect 656 Sumptuous Fur##111557
|goldtracker
Click Here to Farm in Another Location  |confirm |next "Second_Path"
|tip Sometimes multiple people can be farming the same location.
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Second_Path"
map Nagrand D/0
path follow smart; loop on; ants curved; dist 30
path	50.40,61.30	48.60,60.80	47.30,60.80
path	46.00,60.70	45.40,63.00	45.20,65.30
path	45.90,68.70	48.50,70.30	50.40,68.40
path	51.00,66.80	51.20,65.20
Kill Meadowstomper enemies around this area
|goldcollect 232 Raw Elekk Meat##109134
|meta crap_items_follow=1
|goldcollect 656 Sumptuous Fur##111557
|goldtracker
Click Here to Farm in Another Location |confirm |next "First_Path"
|tip Sometimes multiple people can be farming the same location.
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Sell_Items"
#include "auctioneer"
]])
