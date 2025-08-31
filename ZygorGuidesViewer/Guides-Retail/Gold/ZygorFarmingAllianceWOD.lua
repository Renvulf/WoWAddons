local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
ZygorGuidesViewer.Gold.guides_loaded=true
if ZGV:DoMutex("GoldFarmAWOD") then return end
if UnitFactionGroup("player")~="Alliance" then return end
ZygorGuidesViewer.GuideMenuTier = "WOD"
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Clam Meat, Small Lustrous Pearl",{
meta={goldtype="route",levelreq={7},itemtype="misc"},
items={{5503,196},{5498,4},{2592,216,'crap'},{2589,292,'crap'}},
maps={"Redridge Mountains"},
},[[
step
kill Murloc Nightcrawler##544+
|tip When you kill all six, two more will spawn instantly.
use the Small Barnacled Clam##5523+
|goldcollect 196 Clam Meat##5503 |goto Redridge Mountains/0 71.80,56.10
|goldcollect 4 Small Lustrous Pearl##5498
|meta crap_items_follow=1
|goldcollect 216 Wool Cloth##2592
|goldcollect 292 Linen Cloth##2589
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Raw Elekk Meat",{
meta={goldtype="route",levelreq=10,itemtype="food"},
items={{109134,232},{111557,656,'crap'}},
maps={"Shadowmoon Valley D"},
},[[
step
map Shadowmoon Valley D/0
path follow smart; loop on; ants curved
path	42.00,26.20	43.00,31.60	47.80,30.60	55.60,37.60	58.60,40.60
path	63.00,41.60	64.80,34.80	59.20,34.00	48.60,28.20	47.40,26.00
path	44.20,28.40
Kill enemies around this area
|goldcollect 232 Raw Elekk Meat##109134
|meta crap_items_follow=1
|goldcollect 656 Sumptuous Fur##111557
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
