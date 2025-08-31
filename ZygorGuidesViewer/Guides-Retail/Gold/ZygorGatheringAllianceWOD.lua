local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
ZygorGuidesViewer.Gold.guides_loaded=true
if ZGV:DoMutex("GoldGatherAWOD") then return end
if UnitFactionGroup("player")~="Alliance" then return end
ZygorGuidesViewer.GuideMenuTier = "WOD"
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Abyssal Gulper Eel Flesh/Crescent Saberfish Flesh (Garrison)",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq={10}},
description="\nThis guide will walk you through fishing Abyssal Gulper Eel Flesh and Crescent Saberfish Flesh from your garrison waters.",
items={{109143,872},{109137,160}},
maps={"Lunarfall"},
},[[
step
You do not have a Fishing Shack in your garrison! |complete hasbuilding(64) or hasbuilding(134) or hasbuilding(135) |only if not hasbuilding(64) and not hasbuilding(134) and not hasbuilding(135)
Proceeding to garrison fishing |next "Fish" |only if hasbuilding(64) or hasbuilding(134) or hasbuilding(135)
step
label "Fish"
use the Abyssal Gulper Eel Bait##110293
|tip This is fished up. You must re-use new bait every 5 minutes.
use the Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(1)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(2)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(3)
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your Crescent Saberfish |use Crescent Saberfish##111595
Fillet your Abyssal Gulper |use Abyssal Gulper Eel##111664
|goldcollect 872 Abyssal Gulper Eel Flesh##109143
|goldcollect 160 Crescent Saberfish Flesh##109137
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Blackwater Whiptail Flesh/Crescent Saberfish Flesh (Garrison)",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq={10}},
description="\nThis guide will walk you through fishing Blackwater Whiptail Flesh and Crescent Saberfish Flesh from your garrison waters.",
items={{109144,908},{109137,276}},
maps={"Lunarfall"},
},[[
step
You do not have a Fishing Shack in your garrison! |complete hasbuilding(64) or hasbuilding(134) or hasbuilding(135) |only if not hasbuilding(64) and not hasbuilding(134) and not hasbuilding(135)
Proceeding to garrison fishing |next "Fish" |only if hasbuilding(64) or hasbuilding(134) or hasbuilding(135)
step
label "Fish"
Use your Blackwater Whiptail Bait |use Blackwater Whiptail Bait##110294
|tip This is fished up. You must re-use new bait every 5 minutes.
Use your Worm Supreme lure |use Worm Supreme##118391 |tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(1)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(2)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(3)
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your fish by right-clicking the fish in your inventory
|goldcollect 908 Blackwater Whiptail Flesh##109144
|goldcollect 276 Crescent Saberfish Flesh##109137
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Blind Lake Sturgeon Flesh/Crescent Saberfish Flesh (Garrison)",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq={10}},
description="\nThis guide will walk you through fishing Blind Lake Sturgeon Flesh and Crescent Saberfish Flesh from your garrison waters.",
items={{109140,796},{109137,196}},
maps={"Lunarfall"},
},[[
step
You do not have a Fishing Shack in your garrison! |complete hasbuilding(64) or hasbuilding(134) or hasbuilding(135) |only if not hasbuilding(64) and not hasbuilding(134) and not hasbuilding(135)
Proceeding to garrison fishing |next "Fish" |only if hasbuilding(64) or hasbuilding(134) or hasbuilding(135)
step
label "Fish"
Use your Blind Lake Sturgeon Bait |use Blind Lake Sturgeon Bait##110290
|tip This is fished up. You must re-use new bait every 5 minutes.
Use your Worm Supreme lure |use Worm Supreme##118391 |tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(1)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(2)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(3)
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your fish by right-clicking the fish in your inventory
|goldcollect 796 Blind Lake Sturgeon Flesh##109140
|goldcollect 196 Crescent Saberfish Flesh##109137
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Crescent Saberfish Flesh",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq={10}},
description="\nThis guide will walk you through fishing Crescent Saberfish Flesh from open water.",
items={{109140,160},{109137,808}},
maps={"Shadowmoon Valley D"},
},[[
step
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from the shore here |goto Shadowmoon Valley D/0 40.60,49.80
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your fish by right-clicking the fish in your inventory
|goldcollect 160 Blind Lake Sturgeon Flesh##109140
|goldcollect 808 Crescent Saberfish Flesh##109137
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Crescent Saberfish Flesh (Garrison)",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq={10}},
description="\nThis guide will walk you through fishing Crescent Saberfish Flesh from your garrison waters.",
items={{109137,756},{109139,25},{109143,25},{109142,25},{109141,25},{109144,25},{109140,25}},
maps={"Lunarfall"},
},[[
step
You do not have a Fishing Shack in your garrison! |complete hasbuilding(64) or hasbuilding(134) or hasbuilding(135) |only if not hasbuilding(64) and not hasbuilding(134) and not hasbuilding(135)
Proceeding to garrison fishing |next "Fish" |only if hasbuilding(64) or hasbuilding(134) or hasbuilding(135)
step
label "Fish"
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(1)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(2)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(3)
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your fish by right-clicking the fish in your inventory
|goldcollect 756 Crescent Saberfish Flesh##109137
|goldcollect 25 Fat Sleeper Flesh##109139
|goldcollect 25 Abyssal Gulper Eel Flesh##109143
|goldcollect 25 Sea Scorpion Segment##109142
|goldcollect 25 Fire Ammonite Tentacle##109141
|goldcollect 25 Blackwater Whiptail Flesh##109144
|goldcollect 25 Blind Lake Sturgeon Flesh##109140
|goldtracker 25 Jawless Skulker Flesh##109138
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Fat Sleeper Flesh/Crescent Saberfish Flesh (Garrison)",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq={10}},
description="\nThis guide will walk you through fishing Fat Sleeper Flesh and Crescent Saberfish Flesh from your garrison waters.",
items={{109139,708},{109137,316}},
maps={"Lunarfall"},
},[[
step
You do not have a Fishing Shack in your garrison! |complete hasbuilding(64) or hasbuilding(134) or hasbuilding(135) |only if not hasbuilding(64) and not hasbuilding(134) and not hasbuilding(135)
Proceeding to garrison fishing |next "Fish" |only if hasbuilding(64) or hasbuilding(134) or hasbuilding(135)
step
label "Fish"
Use your Fat Sleeper Bait |use Fat Sleeper Bait##110289
|tip This is fished up. You must re-use new bait every 5 minutes.
Use your Worm Supreme lure |use Worm Supreme##118391 |tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(1)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(2)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(3)
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your fish by right-clicking the fish in your inventory
|goldcollect 708 Fat Sleeper Flesh##109139
|goldcollect 316 Crescent Saberfish Flesh##109137
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Fire Ammonite Tentacle/Crescent Saberfish Flesh (Garrison)",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq={10}},
description="\nThis guide will walk you through fishing Fire Ammonite Tentacle and Crescent Saberfish Flesh from your garrison waters.",
items={{109141,556},{109137,552}},
maps={"Lunarfall"},
},[[
step
You do not have a Fishing Shack in your garrison! |complete hasbuilding(64) or hasbuilding(134) or hasbuilding(135) |only if not hasbuilding(64) and not hasbuilding(134) and not hasbuilding(135)
Proceeding to garrison fishing |next "Fish" |only if hasbuilding(64) or hasbuilding(134) or hasbuilding(135)
step
label "Fish"
Use your Fire Ammonite Bait |use Fire Ammonite Bait##110291
|tip This is fished up. You must re-use new bait every 5 minutes.
Use your Worm Supreme lure |use Worm Supreme##118391 |tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(1)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(2)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(3)
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your fish by right-clicking the fish in your inventory
|goldcollect 556 Fire Ammonite Tentacle##109141
|goldcollect 552 Crescent Saberfish Flesh##109137
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Jawless Skulker Flesh/Crescent Saberfish Flesh (Garrison)",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq={10}},
description="\nThis guide will walk you through fishing Jawless Skulker Flesh and Crescent Saberfish Flesh from your garrison waters.",
items={{109138,800},{109137,236}},
maps={"Lunarfall"},
},[[
step
You do not have a Fishing Shack in your garrison! |complete hasbuilding(64) or hasbuilding(134) or hasbuilding(135) |only if not hasbuilding(64) and not hasbuilding(134) and not hasbuilding(135)
Proceeding to garrison fishing |next "Fish" |only if hasbuilding(64) or hasbuilding(134) or hasbuilding(135)
step
label "Fish"
Use your Jawless Skulker Bait |use Jawless Skulker Bait##110274
|tip This is fished up. You must re-use new bait every 5 minutes.
Use your Worm Supreme lure |use Worm Supreme##118391 |tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(1)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(2)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(3)
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your fish by right-clicking the fish in your inventory
|goldcollect 800 Jawless Skulker Flesh##109138
|goldcollect 236 Crescent Saberfish Flesh##109137
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Sea Scorpion Segment/Crescent Saberfish Flesh (Garrison)",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq={10}},
description="\nThis guide will walk you through fishing Sea Scorpion Segment and Crescent Saberfish Flesh from your garrison waters.",
items={{109142,780},{109137,220}},
maps={"Lunarfall"},
},[[
step
You do not have a Fishing Shack in your garrison! |complete hasbuilding(64) or hasbuilding(134) or hasbuilding(135) |only if not hasbuilding(64) and not hasbuilding(134) and not hasbuilding(135)
Proceeding to garrison fishing |next "Fish" |only if hasbuilding(64) or hasbuilding(134) or hasbuilding(135)
step
label "Fish"
Use your Sea Scorpion Bait |use Sea Scorpion Bait##110292
|tip This is fished up. You must re-use new bait every 5 minutes.
Use your Worm Supreme lure |use Worm Supreme##118391 |tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(1)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(2)
Fish from your garrison waters |goto Lunarfall/0 52.10,15.50 |only if garrisonlvl(3)
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your fish by right-clicking the fish in your inventory
|goldcollect 780 Sea Scorpion Segment##109142
|goldcollect 220 Crescent Saberfish Flesh##109137
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Peacebloom/Silverleaf/Earthroot",{
meta={goldtype="route",skillreq={herbalism=1},levelreq={1}},
items={{2447,200},{765,240},{2449,140}},
maps={"Elwynn Forest"},
},[[
step
map Elwynn Forest/0
path	follow strict; loop on; ants curved; dist 25
path	35.10,58.10	27.90,73.90	25.80,88.90
path	38.80,87.50	39.90,76.50	46.80,74.60
path	53.50,84.00	62.90,77.80	73.90,83.80
path	77.00,76.50	84.00,85.10	88.50,77.10
path	85.90,61.00	74.50,53.90	70.60,61.70
path	62.10,62.60	62.50,58.10	45.20,63.40
path	44.70,55.50	40.90,53.70
|goldcollect 200 Peacebloom##2447
|goldcollect 240 Silverleaf##765
|goldcollect 140 Earthroot##2449
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Rain Poppy",{
meta={goldtype="route",skillreq={pandaria_herbalism=1},levelreq={10}},
items={{72237,384},{89640,18}},
maps={"The Jade Forest"},
},[[
step
map The Jade Forest
path	follow smart; loop off; ants curved; dist 10
path	56.70,80.60	57.60,85.90	61.30,83.70
path	61.10,80.20	60.30,79.60	59.50,74.60
path	57.30,70.90	52.70,69.50	46.50,68.40
path	46.20,63.20	49.00,62.20	48.40,58.60
path	46.20,59.10	41.60,55.50	38.00,51.60
path	35.20,47.90	31.90,45.70	27.40,44.50
path	24.80,41.10	24.90,36.30	26.00,33.10
|goldcollect 384 Rain Poppy##72237
|goldcollect 18 Life Spirit##89640
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Alabaster Pigment",{
meta={goldtype="route",skillreq={herbalism=1,inscription=1},levelreq={1}},
items={{2447,200},{765,240},{2449,140},{39151,304}},
maps={"Elwynn Forest"},
},[[
step
map Elwynn Forest
path	follow strict; loop on; ants curved; dist 25
path	35.10,58.10	27.90,73.90	25.80,88.90
path	38.80,87.50	39.90,76.50	46.80,74.60
path	53.50,84.00	62.90,77.80	73.90,83.80
path	77.00,76.50	84.00,85.10	88.50,77.10
path	85.90,61.00	74.50,53.90	70.60,61.70
path	62.10,62.60	62.50,58.10	45.20,63.40
path	44.70,55.50	40.90,53.70
|goldcollect 200 Peacebloom##2447|n
|goldcollect 240 Silverleaf##765 |n
|goldcollect 140 Earthroot##2449 |n
Mill the herbs you've gathered into Alabaster Pigment |cast Milling##51005
|goldcollect 304 Alabaster Pigment##39151
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Light Leather/Medium Leather/Light Hide/Medium Hide",{
meta={goldtype="route",skillreq={skinning=1},levelreq=10},
items={{4304,8},{2319,420},{4232,44},{2318,384},{783,12},{2592,592},{2589,400},{4306,104}},
maps={"Wetlands"},
},[[
step
kill Ebon Slavehunter##42043+
|goldcollect 8 Thick Leather##4304 |goto Wetlands 67.60,47.20
|goldcollect 420 Medium Leather##2319 |goto Wetlands 67.60,47.20
|goldcollect 44 Medium Hide##4232 |goto Wetlands 67.60,47.20
|goldcollect 384 Light Leather##2318 |goto Wetlands 67.60,47.20
|goldcollect 12 Light Hide##783 |goto Wetlands 67.60,47.20
|goldcollect 592 Wool Cloth##2592 |goto Wetlands 67.60,47.20
|goldcollect 400 Linen Cloth##2589 |goto Wetlands 67.60,47.20
|goldcollect 104 Silk Cloth##4306 |goto Wetlands 67.60,47.20
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
