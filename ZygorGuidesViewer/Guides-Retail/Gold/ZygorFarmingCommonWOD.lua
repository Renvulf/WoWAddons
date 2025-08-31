local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
ZygorGuidesViewer.Gold.guides_loaded=true
if ZGV:DoMutex("GoldFarmCWOD") then return end
ZygorGuidesViewer.GuideMenuTier = "WOD"
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Linen Cloth/Wool Cloth",{
meta={goldtype="route",levelreq={10},itemtype="cloth"},
items={{2592,450},{2589,628}},
maps={"Shadowfang Keep","Wetlands","Silverpine Forest"},
},[[
step
Click Here to Farm in Shadowfang Keep |confirm |next "Shadowfang_Keep_1"
Click Here to Farm in Wetlands |confirm |next
step
Kill enemies around this area
|goldcollect 450 Wool Cloth##2592 |goto Wetlands/0 67.31,47.30
|goldcollect 628 Linen Cloth##2589 |goto Wetlands/0 67.31,47.30
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Shadowfang_Keep_1"
map Shadowfang Keep/1
path loop off; follow loose; distance 10
path	72.20,49.90	62.00,44.80	60.50,57.00	63.70,71.00	56.50,66.60
path	37.80,39.20	Shadowfang Keep/2 56.30,13.70	44.70,38.20	34.40,74.60
path	26.80,89.50	Shadowfang Keep/1 21.00,91.10	28.00,61.40	34.70,69.80
path	24.30,75.20	51.40,83.10	56.60,95.00	59.00,82.70
Follow the Path |goto Shadowfang Keep/7 59.00,82.70 < 10 |noway |c |next "Shadowfang_Keep_2"
|tip Kill and loot any mobs you see.
|goldcollect 450 Wool Cloth##2592 |n
|goldcollect 628 Linen Cloth##2589 |n
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Shadowfang_Keep_2"
map Shadowfang Keep/7
path loop off; follow loose; distance 10
path	66.80,88.30	73.60,62.30	46.20,47.60	47.40,32.30	45.90,18.70
path	43.80,29.00	Shadowfang Keep/3 44.80,62.10	58.70,11.20
Follow the Path |goto Shadowfang Keep/3 58.70,11.20 < 10 |noway |c |next "Shadowfang_Keep_3"
|tip Kill and loot any mobs you see.
|goldcollect 450 Wool Cloth##2592 |n
|goldcollect 628 Linen Cloth##2589 |n
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Shadowfang_Keep_3"
map Shadowfang Keep/3
path loop off; follow loose; distance 10
path	62.70,15.10	65.30,35.20	54.90,74.40	47.60,96.20	Shadowfang Keep/4 50.70,68.90
path	60.90,30.80	38.40,36.90	37.00,64.00
Follow the Path |goto Shadowfang Keep/4 37.00,64.00 < 10 |noway |c |next "Shadowfang_Keep_4"
|tip Kill and loot any mobs you see.
|goldcollect 450 Wool Cloth##2592 |n
|goldcollect 628 Linen Cloth##2589 |n
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Shadowfang_Keep_4"
map Shadowfang Keep/5
path loop off; follow loose; distance 10
path	37.90,66.50	48.00,77.50	64.00,61.10	61.00,30.90	35.10,54.70
Follow the Path |goto Shadowfang Keep/5 35.10,54.70 < 10 |noway |c |next "Shadowfang_Keep_5"
|tip Kill and loot any mobs you see.
|goldcollect 450 Wool Cloth##2592 |n
|goldcollect 628 Linen Cloth##2589 |n
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Shadowfang_Keep_5"
map Shadowfang Keep/6
path loop off; follow loose; distance 10
path	49.50,87.30	58.70,53.30	62.80,20.80
Follow the Path |goto Shadowfang Keep/6 62.80,20.80 < 10 |noway |c |next "Reset_Shadowfang_Keep"
|tip Kill and loot any mobs you see.
|goldcollect 450 Wool Cloth##2592 |n
|goldcollect 628 Linen Cloth##2589 |n
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Reset_Shadowfang_Keep"
Exit Shadowfang Keep |goto Silverpine Forest/0 44.80,67.80 < 1000 |c |noway
step
Reset the dungeon
|tip Right-click your player unit frame and select "Reset all instances."
|tip Do this if you wish to continue farming.
Click Here to Continue Farming |confirm |next "Shadowfang_Keep_1"
|tip
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Sell_Items"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Silk Cloth",{
meta={goldtype="route",levelreq={15},itemtype="cloth"},
items={{4306,500},{2592,8,'crap'},{4338,36,'crap'}},
maps={"Dustwallow Marsh","Eastern Plaguelands"},
},[[
step
Click Here to Farm in Eastern Plaguelands |confirm |next "Eastern_Plaguelands"
Click Here to Farm in Dustwallow Marsh |confirm |next
step
map Dustwallow Marsh/0
path follow loose; loop on; ants curved
path	42.00,11.00	42.60,12.80	44.80,16.40	54.60,20.80	55.80,20.60
path	57.60,20.20	59.00,23.60	58.60,26.20	57.20,30.20	53.40,28.00
path	52.20,26.00	44.80,17.60	40.80,13.20	40.80,12.20
Kill enemies around this area
|goldcollect 500 Silk Cloth##4306
|meta crap_items_follow=1
|goldcollect 8 Wool Cloth##2592
|goldcollect 36 Mageweave Cloth##4338
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Eastern_Plaguelands"
map Eastern Plaguelands/0
path	follow smart; loop on; ants curved
path	16.00,78.00	16.90,79.40	19.00,82.00	19.40,77.50	18.60,76.30
Kill Death's Step enemies around this area
|goldcollect 500 Silk Cloth##4306
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Sell_Items"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Runecloth",{
meta={goldtype="route",levelreq={15},itemtype="cloth"},
items={{14047,372},{20404,120,'crap'}},
maps={"Hellfire Ramparts","Silithus"},
},[[
step
Click Here to Farm in Hellfire Ramparts |confirm |next "Hellfire_Ramparts"
Click Here to Farm in Silithus |confirm |next
step
talk Zidormi##128607
|tip She is at the top of the ramp leading from Un'Goro Crater to Silithus.
Select _"Can you show me what Silithus was like before the Wound in the World?"_
Travel to the Past |complete ZGV.InPhase('Old Silithus') |goto Silithus/0 78.93,21.97
step
map Silithus/0
path follow smart; loop on; ants curved
path	44.50,38.00	46.50,40.40	44.90,44.70	42.90,41.40	34.20,33.70
path	31.60,32.10	32.90,30.10	35.20,29.90
Kill Twilight enemies around this area
|goldcollect 372 Runecloth##14047
|meta crap_items_follow=1
|goldcollect 120 Encrypted Twilight Text##20404
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Hellfire_Ramparts"
map Hellfire Ramparts/1
path follow smart; loop off; ants curved; dist 1
path	46.90,64.10	45.90,55.00	53.10,48.80	66.60,54.90	76.10,36.60
path	70.80,32.50	65.40,39.30	65.20,44.40	57.00,50.90	50.60,61.80
Kill enemies around this area
|tip Kill and loot any humanoid mobs you see.
|tip Run out and reset the instance to continue farming.
|goldcollect 372 Runecloth##14047
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Sell_Items"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Felcloth",{
meta={goldtype="route",levelreq={15},itemtype="cloth"},
items={{14256,12}},
maps={"Blasted Lands"},
},[[
step
talk Zidormi##88206
Select _"Show me the Blasted Lands before the invasion."_
Travel to the Past |complete ZGV.InPhase('Old Blasted Lands') |goto Blasted Lands/0 48.16,7.28
step
map Blasted Lands/0
path follow smart; loop on; ants curved
path	40.80,66.00	38.80,65.70	35.60,65.60	32.80,64.30	31.00,68.00
path	34.30,70.70	35.90,70.00	36.60,72.40	32.70,75.00	36.50,75.40
path	39.80,75.30	40.70,71.00
Kill Demon enemies around this area
|goldcollect 12 Felcloth##14256
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Righteous Orb, Mageweave Cloth",{
meta={goldtype="route",levelreq={20},elitemobs=1,itemtype="cloth"},
items={{14047,32},{4338,845},{12811,5,'crap'}},
maps={"Stratholme"},
},[[
step
Kill Risen enemies around this area
|goldcollect 32 Runecloth##14047 |goto Stratholme/1 33.40,33.00
|goldcollect 845 Mageweave Cloth##4338 |goto Stratholme/1 33.40,33.00
|meta crap_items_follow=1
|goldcollect 5 Righteous Orb##12811
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Mageweave Cloth",{
meta={goldtype="route",levelreq={15},elitemobs=1,itemtype="cloth"},
items={{4338,448}},
maps={"Tanaris","Badlands"},
},[[
step
Click Here to Farm in Tanaris |confirm |next "Tanaris"
Click Here to Farm in Badlands |confirm |next
step
map Badlands/0
path follow smart; loop on; ants curved; dist 15
path	12.30,45.10	14.80,47.20	17.00,47.50	19.00,49.20	20.50,50.00
path	22.60,48.50	23.20,46.00	21.10,43.90	18.80,45.70	17.10,46.20
path	15.70,46.20	14.50,45.90	13.20,44.50
Kill Darkflight enemies around this area
|goldcollect 448 Mageweave Cloth##4338
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Tanaris"
Kill Sandfury enemies around this area
|goldcollect 448 Mageweave Cloth##4338 |goto Tanaris/0 33.80,7.10
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Sell_Items"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Netherweave Cloth",{
meta={goldtype="route",levelreq={25},itemtype="cloth"},
items={{21877,928},{30810,392,'crap'},{29739,24,'crap'},{30809,220,'crap'},{29740,24,'crap'}},
maps={"Shadowmoon Valley"},
},[[
step
Click Here to Farm in Legion Hold |confirm |next "Legion_Hold"
|tip This is also a good location to farm Aldor rep items.
Click Here to Farm in Eclipse Point |confirm |next
|tip This is also a good location to farm Scryer rep items.
step
map Shadowmoon Valley/0
path follow smart; loop on; ants curved; dist 20
path	51.10,58.80	53.00,59.30	53.20,60.50	52.80,63.20	52.80,65.40
path	52.90,69.00	52.50,71.80	47.30,71.10	45.80,71.30	45.20,69.20
path	45.60,66.10	48.00,67.20
Kill enemies around this area
|goldcollect 928 Netherweave Cloth##21877
|meta crap_items_follow=1
|goldcollect 392 Sunfury Signet##30810 |n
|goldcollect 24 Arcane Tome##29739 |n
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Legion_Hold"
map Shadowmoon Valley/0
path follow smart; loop on; ants curved; dist 20
path	23.90,41.30	22.60,40.10	22.30,38.40	22.10,37.10	20.70,38.00
path	20.80,36.20	21.80,34.20	22.70,31.20	23.70,31.10	24.90,32.30
path	26.00,33.30	25.10,34.60	26.20,36.10	25.10,38.10	24.90,39.80
Kill enemies around this area
|goldcollect 928 Netherweave Cloth##21877
|meta crap_items_follow=1
|goldcollect 220 Mark of Sargeras##30809 |n
|goldcollect 24 Fel Armament##29740 |n
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Sell_Items"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Frostweave Cloth",{
meta={goldtype="route",levelreq=25,itemtype="cloth"},
items={{33470,428}},
maps={"Icecrown"},
},[[
step
Click Here to Farm in Argent Tournament Grounds |confirm |next "Argent_Tournament_Grounds"
Click Here to Farm in Corp'Rethar |confirm |next
step
kill Chosen Zealot##32175+
|goldcollect 428 Frostweave Cloth##33470 |goto Icecrown/0 43.30,78.40
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Argent_Tournament_Grounds"
map Icecrown/0
path follow smart; loop on; ants curved; dist 20
path	65.60,22.20	64.60,22.60	63.00,21.60	60.80,23.00	60.80,20.60
path	61.40,20.00	64.00,21.20	64.60,21.00
Kill Dark enemies around this area
|goldcollect 428 Frostweave Cloth##33470
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Sell_Items"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Iceweb Spider Silk",{
meta={goldtype="route",levelreq={20},itemtype="cloth"},
items={{42253,84}},
maps={"Zul'Drak"},
},[[
step
map Zul'Drak/0
path follow smart; loop on; ants curved
path	36.20,57.90	35.80,50.80	35.10,47.90	36.40,47.60	38.20,53.60
path	38.90,57.80
kill Trapdoor Crawler##28221+
|goldcollect 84 Iceweb Spider Silk##42253
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Embersilk Cloth",{
meta={goldtype="route",levelreq=30,itemtype="cloth"},
items={{53010,248}},
maps={"Tol Barad Peninsula","Deepholm"},
},[[
step
Click Here to Farm in Tol Barad |confirm |next "Tol_Barad"
Click Here to Farm in Deepholm |confirm |next
step
map Deepholm/0
path follow smart; loop on; ants curved
path	68.20,25.60	67.20,32.00	68.60,35.80	69.00,42.60	73.00,45.00
path	77.20,42.80	76.80,35.60	74.60,32.80	74.80,28.40	72.20,26.60
Kill Verlok enemies around this area
|tip Above on the platforms.
|goldcollect 248 Embersilk Cloth##53010
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Tol_Barad"
map Tol Barad Peninsula/0
path follow smart; loop on; ants curved; dist 10
path	48.00,71.60	47.40,69.80	45.60,67.00	45.60,62.00	44.60,59.40
path	42.60,59.00	41.80,57.40	38.60,58.20	36.60,59.40	36.00,60.60
path	37.80,62.60	40.40,62.00	41.60,62.60	44.40,64.80	45.60,68.60
Kill Restless enemies around this area
|goldcollect 248 Embersilk Cloth##53010
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Sell_Items"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Windwool Cloth",{
meta={goldtype="route",levelreq=25,itemtype="cloth"},
items={{72988,308}},
maps={"Townlong Steppes"},
},[[
step
map Townlong Steppes/0
path follow loose; loop on; ants curved; dist 20
path	25.80,55.30	23.70,55.50	22.10,56.60	21.00,57.70	20.80,55.90
path	20.70,54.40	19.80,52.30	18.40,51.00	17.80,50.00	19.10,48.90
path	19.70,47.80	21.00,50.30	22.30,50.90	23.60,49.90	24.60,52.10
path	25.80,53.50
Kill Sra'thik enemies around this area
|goldcollect 308 Windwool Cloth##72988
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Sumptuous Fur",{
meta={goldtype="route",levelreq={15},itemtype="cloth"},
items={{111557,364}},
maps={"Gorgrond"},
},[[
step
map Gorgrond/0
path follow loose; loop on; ants curved; dist 20
path	46.80,89.80	46.40,91.40	45.30,93.00	43.20,91.80	42.80,89.40
path	44.50,90.70	44.60,89.20
Kill Tailthrasher enemies around this area
|goldcollect 364 Sumptuous Fur##111557
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Zesty Clam Meat, Black Pearl, Iridescent Pearl, Golden Pearl",{
meta={goldtype="route",levelreq={15},itemtype="misc"},
items={{7974,324},{7971,4},{5500,8},{13926,4},{14047,552,'crap'}},
maps={"Blasted Lands"},
},[[
step
talk Zidormi##88206
Select _"Show me the Blasted Lands before the invasion."_
Travel to the Past |complete ZGV.InPhase('Old Blasted Lands') |goto Blasted Lands/0 48.16,7.28
step
map Blasted Lands/0
path follow smart; loop on; ants curved
path	72.90,61.30	71.30,63.20	70.10,71.30	67.50,75.20	63.20,75.90
path	60.30,77.90	58.50,76.60	59.00,73.20	60.40,70.00	61.40,63.20
path	65.70,69.00	68.60,63.20	70.90,60.60
Kill Bloodwash enemies around this area
|goldcollect 324 Zesty Clam Meat##7974
|goldcollect 4 Black Pearl##7971
|goldcollect 8 Iridescent Pearl##5500
|goldcollect 4 Golden Pearl##13926
|meta crap_items_follow=1
|goldcollect 552 Runecloth##14047
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Small Egg",{
meta={goldtype="route",levelreq={5},itemtype="food"},
items={{6889,272}},
maps={"Westfall"},
},[[
step
kill Greater Fleshripper##154+
|goldcollect 272 Small Egg##6889 |goto Westfall 26.90,42.50
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Stringy Wolf Meat",{
meta={goldtype="route",levelreq={1},itemtype="food"},
items={{2672,404}},
maps={"Tirisfal Glades"},
},[[
step
talk Hero's Herald##49748
accept Battle for Azeroth: Tides of War##46727 |goto Stormwind City/0 62.17,30.14
|tip This quest is required to unlock access to Zidormi in Tirisfal Glades.
|only if Alliance
step
Watch the dialogue
|tip Inside the building.
Attend the War Council |q 46727/1 |goto Stormwind City/0 80.27,33.13
|only if Alliance
step
click Vision of Sailor's Memory
|tip Inside the building.
Witness the Vision of the Sailor's Memory |q 46727/2 |goto Stormwind City/0 80.48,33.50
|only if Alliance
step
talk Anduin Wrynn##120756
|tip Inside the building.
turnin Battle for Azeroth: Tides of War##46727 |goto Stormwind City/0 80.26,33.13
|only if Alliance
step
talk Warchief's Herald##49750
accept Battle for Azeroth: Mission Statement##51443 |goto Orgrimmar/1 49.39,76.57
|only if Horde
step
Speak to Warchief Sylvanas Windrunner in Orgrimmar |q 51443/1 |goto Orgrimmar/1 48.61,71.98
|tip Inside the building.
|only if Horde
step
Watch the dialogue
|tip Inside the building.
Meet Your Team |q 51443/2 |goto Orgrimmar/1 54.44,78.43
|only if Horde
step
talk Nathanos Blightcaller##135205
|tip Inside the building.
turnin Battle for Azeroth: Mission Statement##51443 |goto Orgrimmar/1 54.44,78.43
|only if Horde
step
talk Zidormi##141488
Select _"Can you show me what Tirisfal Glades was like before the Battle for Lordaeron?"_
Travel to the Past |complete ZGV.InPhase('Old Undercity') |goto Tirisfal Glades/0 69.46,62.80
step
map Tirisfal Glades/0
path follow smart; loop on; ants curved
path	86.00,39.20	88.20,41.80	88.00,46.20	87.60,47.60	82.80,51.00
path	81.40,51.60	82.00,48.60	80.60,42.80	83.20,40.80
kill Ravenous Darkhound##1549+
|goldcollect 404 Stringy Wolf Meat##2672
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Chunk Of Boar Meat",{
meta={goldtype="route",levelreq={5},itemtype="food"},
items={{769,296}},
maps={"Westfall"},
},[[
step
map Westfall/0
path follow smart; loop on; ants curved
path	60.80,36.60	59.20,31.40	53.80,25.60	47.60,30.80	46.80,27.40
path	46.80,19.20	49.00,16.60	53.00,17.80	55.60,16.20	58.80,13.60
path	59.80,17.60	63.00,24.60	61.60,27.60	61.00,32.60
Kill Goretusk enemies around this area
|goldcollect 296 Chunk of Boar Meat##769
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Raptor Egg, Raptor Hide, Raptor Flesh, Large Fang",{
meta={goldtype="route",levelreq={10},itemtype="food"},
items={{3685,284},{4461,108},{12184,248},{5637,8}},
maps={"Arathi Highlands"},
},[[
step
talk Zidormi##141649
Select _"Can you show me what Arathi Highlands was like before the war broke out?"_
Travel to the Past |complete ZGV.InPhase('Old Arathi') |goto Arathi Highlands/0 38.24,90.09
step
map Arathi Highlands/0
path follow smart; loop on; ants curved
path	42.80,83.60	40.20,82.20	37.60,75.10	45.40,66.20	48.80,66.80
path	49.60,67.80	48.60,69.60	42.00,76.20
kill Highland Fleshstalker##2561+
|goldcollect 284 Raptor Egg##3685
|goldcollect 108 Raptor Hide##4461
|goldcollect 248 Raptor Flesh##12184
|goldcollect 8 Large Fang##5637
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Buzzard Meat",{
meta={goldtype="route",levelreq={15},itemtype="food"},
items={{27671,176}},
maps={"Terokkar Forest"},
},[[
step
map Terokkar Forest/0
path follow loose; loop on; ants curved
path	33.60,51.60	34.80,56.40	39.60,53.00	45.00,56.60	47.20,62.60
path	47.40,70.00	49.40,64.40	46.80,53.20	42.80,49.40	39.00,48.80
kill Bonelasher##18470+
|goldcollect 176 Buzzard Meat##27671
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Jaggal Clam Meat, Jaggal Pearl, Shadow Pearl",{
meta={goldtype="route",levelreq={25},itemtype="food"},
items={{24477,88},{24479,8},{24478,12}},
maps={"Shadowmoon Valley"},
},[[
step
Kill Coilskar enemies around this area
|tip Kill them inside and outside the cave.
use the Jaggal Clam##24476+
|goldcollect 88 Jaggal Clam Meat##24477 |goto Shadowmoon Valley/0 52.90,26.10
|goldcollect 8 Shadow Pearl##24479
|goldcollect 12 Jaggal Pearl##24478
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Siren's Tear, Northsea Pearl",{
meta={goldtype="route",levelreq={10},itemtype="gem"},
items={{36784,4},{36783,8}},
maps={"Borean Tundra"},
},[[
step
map Borean Tundra/0
path follow smart; loop on; ants curved
path	41.50,18.70	41.00,16.10	39.10,15.40	37.30,15.50	38.40,17.00
path	40.00,19.60
Kill Winterfin enemies around this area
|goldcollect 4 Siren's Tear##36784
|goldcollect 8 Northsea Pearl##36783
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Viseclaw Meat, Raw Crab Meat",{
meta={goldtype="route",levelreq={15},itemtype="food"},
items={{85506,116},{74838,164},{89112,56,'crap'}},
maps={"Krasarang Wilds"},
},[[
step
map Krasarang Wilds/0
path follow smart; loop on; ants curved
path	52.30,47.50	56.40,49.80	57.40,43.90	60.10,40.70	54.30,44.50
Kill enemies around this area
|goldcollect 116 Viseclaw Meat##85506
|goldcollect 164 Raw Crab Meat##74838
|meta crap_items_follow=1
|goldcollect 56 Mote of Harmony##89112
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Raw Tiger Steak",{
meta={goldtype="route",levelreq={10},itemtype="food"},
items={{74833,220},{89112,20,'crap'}},
maps={"The Jade Forest"},
},[[
step
map The Jade Forest/0
path follow smart; loop on; ants curved
path	61.80,21.00	63.00,24.00	64.40,27.60	61.20,26.60	60.80,26.00
path	61.60,23.20
Kill Windward enemies around this area
|goldcollect 220 Raw Tiger Steak##74833
|meta crap_items_follow=1
|goldcollect 20 Mote of Harmony##89112
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Mushan Ribs",{
meta={goldtype="route",levelreq=30,itemtype="food"},
items={{74834,132},{89112,16,'crap'}},
maps={"Dread Wastes"},
},[[
step
map Dread Wastes/0
path follow smart; loop on; ants curved
path	48.80,21.40	46.80,20.40	48.40,18.60	49.60,16.60	51.60,14.80
path	54.00,16.00	51.20,16.80
kill Frightened Mushan##62760+
|goldcollect 132 Mushan Ribs##74834
|meta crap_items_follow=1
|goldcollect 16 Mote of Harmony##89112
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Raw Turtle Meat",{
meta={goldtype="route",levelreq={10},itemtype="food"},
items={{74837,176},{89112,20,'crap'}},
maps={"The Jade Forest"},
},[[
step
map The Jade Forest/0
path follow smart; loop on; ants curved
path	65.40,34.20	65.70,28.10	66.80,27.00	69.30,26.40	69.30,30.70
path	68.40,32.50
Kill Saltback enemies around this area
|goldcollect 176 Raw Turtle Meat##74837
|meta crap_items_follow=1
|goldcollect 20 Mote of Harmony##89112
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Wildfowl Breast",{
meta={goldtype="route",levelreq=87,itemtype="food"},
items={{74839,304},{89112,16,'crap'}},
maps={"Valley of the Four Winds"},
},[[
step
kill Whitefisher Crane##56752+
|goldcollect 304 Wildfowl Breast##74839 |goto Valley of the Four Winds/0 25.40,43.80
|meta crap_items_follow=1
|goldcollect 16 Mote of Harmony##89112
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Raw Crocolisk Belly",{
meta={goldtype="route",levelreq=15,itemtype="food"},
items={{75014,128},{89112,4,'crap'}},
maps={"Dread Wastes"},
},[[
step
kill Coldbite Crocolisk##62023+
|goldcollect 128 Raw Crocolisk Belly##75014 |goto Dread Wastes/0 64.70,59.00
|meta crap_items_follow=1
|goldcollect 4 Mote of Harmony##89112
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Raw Boar Meat, Rylak Egg",{
meta={goldtype="route",levelreq={10},itemtype="food"},
items={{109136,104},{109133,52},{111557,272,'crap'}},
maps={"Frostfire Ridge"},
},[[
step
map Frostfire Ridge/0
path follow smart; loop on; ants curved; dist 20
path	50.60,55.00	48.20,56.30	47.60,59.60	40.60,63.40	36.70,56.60
path	41.00,58.60	42.90,57.00	45.60,59.20	47.60,54.00
Kill enemies around this area
|goldcollect 104 Raw Boar Meat##109136
|goldcollect 52 Rylak Egg##109133
|meta crap_items_follow=1
|goldcollect 272 Sumptuous Fur##111557
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Raw Talbuk Meat",{
meta={goldtype="route",levelreq={35},itemtype="food"},
items={{109132,132},{111557,156,'crap'}},
maps={"Nagrand D"},
},[[
step
map Nagrand D/0
path follow smart; loop on; ants curved; dist 30
path	62.20,37.40	53.80,37.60	59.80,28.40	63.60,20.00	63.60,32.60
path	69.60,35.20	74.80,40.20	79.80,40.60	83.20,48.40	82.00,54.60
path	72.80,57.20	66.60,58.00	60.60,50.60	66.60,45.80
Kill Talbuk enemies around this area
|goldcollect 132 Raw Talbuk Meat##109132
|meta crap_items_follow=1
|goldcollect 156 Sumptuous Fur##111557 |n
collect 150 Hearty Soup Bone##113578 |n
|goldtracker
Click Here to Sell Items |confirm
step
label "Meatgut_Needs_Bones"
talk Meatgut##82727
|tip Sell your soup bones before going to the Auctioneer.
accept Meatgut Needs Bones##35928 |goto Nagrand D/0 78.34,52.45
|only if itemcount(113578) >= 20
step
Proceedint to Bone turn in |next "Meatgut_Needs_Bones" |only if itemcount(113578) >= 20
Proceeding to Auctioneer |next |only if default
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Raw Riverbeast Meat",{
meta={goldtype="route",levelreq={20},itemtype="food"},
items={{109135,76}},
maps={"Talador"},
},[[
step
map Talador/0
path follow smart; loop on; ants curved
path	67.40,49.20	64.60,46.80	61.80,49.60	64.00,55.20	64.80,61.40
path	69.60,64.60	68.40,60.00
Kill Riverbeast enemies around this area
|goldcollect 76 Raw Riverbeast Meat##109135
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Raw Clefthoof Meat",{
meta={goldtype="route",levelreq={35},itemtype="food"},
items={{109131,168},{111557,328,'crap'}},
maps={"Nagrand D"},
},[[
step
kill Tamed Clefthoof##79034+
|goldcollect 168 Raw Clefthoof Meat##109131 |goto Nagrand D/0 79.60,72.80
|meta crap_items_follow=1
|goldcollect 328 Sumptuous Fur##111557
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Globe Of Water, Essence Of Water, Elemental Water",{
meta={goldtype="route",levelreq={15},itemtype="elemental"},
items={{7079,24},{7080,16},{7070,40}},
maps={"Swamp of Sorrows"},
},[[
step
map Swamp of Sorrows/0
path follow loose; loop on; ants curved
path	17.20,55.70	16.70,60.50	16.50,66.10	20.00,65.80	21.00,59.30
path	21.00,55.10
kill Purespring Elemental##46953+
|goldcollect 24 Globe of Water##7079
|goldcollect 16 Essence of Water##7080
|goldcollect 40 Elemental Water##7070
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Breath Of Wind, Essence Of Air, Elemental Air",{
meta={goldtype="route",levelreq={15},itemtype="elemental"},
items={{7069,40},{7081,32},{7082,24}},
maps={"Silithus"},
},[[
step
talk Zidormi##128607
|tip She is at the top of the ramp leading from Un'Goro Crater to Silithus.
Select _"Can you show me what Silithus was like before the Wound in the World?"_
Travel to the Past |complete ZGV.InPhase('Old Silithus') |goto Silithus/0 78.93,21.97
step
map Silithus/0
path follow loose; loop on; ants curved
path	40.80,14.00	38.60,17.60	35.60,22.80	31.60,26.60	29.60,28.60
path	28.00,30.80	26.40,29.00	25.20,27.00	26.60,24.40	28.20,18.40
path	29.60,21.60	34.80,19.00	36.40,15.20	39.60,14.00
kill Dust Stormer##11744+
|goldcollect 40 Elemental Air##7069
|goldcollect 32 Breath of Wind##7081
|goldcollect 24 Essence of Air##7082
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Core Of Earth, Essence Of Earth, Elemental Earth",{
meta={goldtype="route",levelreq={15},itemtype="elemental"},
items={{7075,40},{7067,16},{7076,8}},
maps={"Winterspring"},
},[[
step
map Winterspring/0
path follow loose; loop on; ants curved
path	57.80,56.20	60.60,56.60	61.60,58.60	60.40,60.20	58.80,60.00
path	57.60,58.40
kill Frostshard Rumbler##48960+
|goldcollect 40 Core of Earth##7075
|goldcollect 16 Elemental Earth##7067
|goldcollect 8 Essence of Earth##7076
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Essence Of Fire, Elemental Fire, Heart of Fire",{
meta={goldtype="route",levelreq={15},itemtype="elemental"},
items={{7078,24},{7068,48},{7077,16}},
maps={"Un'Goro Crater"},
},[[
step
map Un'Goro Crater/0
path follow loose; loop on; ants curved
path	54.40,56.20	53.40,51.00	55.10,48.70	54.50,44.00	52.70,42.50
path	52.20,45.50	49.30,48.40	48.60,43.90	46.30,46.50	45.50,51.30
path	47.50,53.60	50.20,54.30
Kill enemies around this area
|goldcollect 24 Essence of Fire##7078
|goldcollect 48 Elemental Fire##7068
|goldcollect 16 Heart of Fire##7077
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Essence Of Undeath",{
meta={goldtype="route",levelreq={15},itemtype="elemental"},
items={{12808,12},{4338,188,'crap'},{4306,128,'crap'}},
maps={"Winterspring"},
},[[
step
map Winterspring/0
path follow smart; loop on; ants curved
path	48.60,53.40	52.60,52.60	54.40,54.60	53.80,57.60	50.80,57.20
path	48.60,57.80	46.80,53.80
Kill Undead enemies around this area
|tip Enter the buildings and kill the mobs inside as well.
|goldcollect 12 Essence of Undeath##12808
|meta crap_items_follow=1
|goldcollect 188 Mageweave Cloth##4338
|goldcollect 128 Runecloth##4306
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Ichor Of Undeath",{
meta={goldtype="route",levelreq={15},elitemobs=1,itemtype="elemental"},
items={{7972,6},{4338,324,'crap'},{4306,150,'crap'}},
maps={"Scholomance"},
},[[
step
Kill Undead enemies around this area
|goldcollect 6 Ichor of Undeath##7972 |goto Scholomance/2 59.60,19.10
|meta crap_items_follow=1
|goldcollect 324 Mageweave Cloth##4338
|goldcollect 150 Silk Cloth##4306
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Mote Of Air",{
meta={goldtype="route",levelreq={25},itemtype="elemental"},
items={{22572,36}},
maps={"Shadowmoon Valley"},
},[[
step
map Shadowmoon Valley/0
path follow loose; loop on; ants curved
path	58.80,59.80	60.80,59.80	63.00,61.00	64.80,61.60	66.00,63.60
path	62.20,64.20	61.20,67.60	59.60,71.60	57.00,73.60	55.40,72.00
path	58.20,70.60	59.20,65.40	62.00,61.80
kill Enraged Air Spirit##21060+
|goldcollect 36 Mote of Air##22572
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Mote Of Earth",{
meta={goldtype="route",levelreq={15},itemtype="elemental"},
items={{22573,64}},
maps={"Nagrand"},
},[[
step
map Nagrand/0
path follow loose; loop on; ants curved
path	25.30,71.80	27.40,77.00	28.40,81.60	31.80,81.90	36.40,83.40
path	41.00,84.70	38.10,80.90	30.50,74.90
kill Shattered Rumbler##17157+
|goldcollect 64 Mote of Earth##22573
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Mote Of Fire",{
meta={goldtype="route",levelreq={10},itemtype="elemental"},
items={{22574,108}},
maps={"Hellfire Peninsula"},
},[[
step
map Hellfire Peninsula/0
path follow loose; loop on; ants curved
path	57.80,17.80	60.80,18.80	63.60,18.20	66.20,17.60	67.00,17.80
path	67.80,20.20	65.60,19.80	63.20,20.60	60.60,23.40	57.40,22.80
path	58.20,19.60
kill Incandescent Fel Spark##22323+
|goldcollect 108 Mote of Fire##22574
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Mote Of Mana",{
meta={goldtype="route",levelreq={25},itemtype="elemental"},
items={{22576,168}},
maps={"Netherstorm"},
},[[
step
map Netherstorm/0
path follow loose; loop on; ants curved
path	54.70,88.00	56.80,85.60	57.40,87.10	55.30,89.70	54.50,90.20
Kill enemies around this area
|goldcollect 168 Mote of Mana##22576
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Mote Of Life",{
meta={goldtype="route",levelreq={10},itemtype="elemental"},
items={{22575,160}},
maps={"Zangarmarsh"},
},[[
step
map Zangarmarsh/0
path follow loose; loop on; ants curved
path	85.40,38.20	85.10,41.00	83.20,44.10	81.00,43.40	79.30,41.10
path	78.70,38.30	79.40,33.70	82.00,32.30
Kill Withered enemies around this area
|goldcollect 160 Mote of Life##22575
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Mote Of Shadow",{
meta={goldtype="route",levelreq={15},itemtype="elemental"},
items={{22577,124},{21877,412,'crap'}},
maps={"Nagrand"},
},[[
step
map Nagrand/0
path follow loose; loop on; ants curved
path	43.60,69.60	43.20,71.40	41.20,75.00	38.20,79.00	35.60,77.60
path	31.60,77.40	30.80,74.00	31.20,69.40	29.60,67.60	31.00,65.80
path	34.00,66.60	36.60,65.40	38.80,62.20	41.60,62.20	42.00,66.60
kill Voidspawn##17981+
|goldcollect 124 Mote of Shadow##22577
|meta crap_items_follow=1
|goldcollect 412 Netherweave Cloth##21877
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Mote Of Water",{
meta={goldtype="route",levelreq={15},itemtype="elemental"},
items={{22578,92}},
maps={"Nagrand"},
},[[
step
map Nagrand/0
path follow loose; loop on; ants curved
path	44.50,46.50	40.60,46.10	41.60,40.40	43.30,40.40	44.40,42.30
kill Muck Spawn##17154
|goldcollect 92 Mote of Water##22578
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Frozen Orb",{
meta={goldtype="route",levelreq={10},elitemobs=1,itemtype="gem"},
items={{43102,1}},
maps={"The Nexus","The Oculus","Old Hillsbrad Foothills","The Storm Peaks","Zul'Drak","Howling Fjord","Grizzly Hills","Burning Steppes","Icecrown"},
},[[
step
|goldcollect 1 Frozen Orb##43102
|tip Kill the final boss of any Northrend Dungeon.
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Eternal Air, Crystallized Air",{
meta={goldtype="route",levelreq={10},itemtype="elemental"},
items={{37700,180}},
maps={"Borean Tundra"},
},[[
step
map Borean Tundra/0
path follow smart; loop on; ants curved
path	45.40,6.80	46.00,7.40	46.00,10.60	44.40,11.60	42.80,10.60
path	42.20,9.40	44.40,8.00
kill Enraged Tempest##25415+
|goldcollect 180 Crystallized Air##37700
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Eternal Earth, Crystallized Earth",{
meta={goldtype="route",levelreq={20},itemtype="elemental"},
items={{37701,164}},
maps={"Sholazar Basin"},
},[[
step
map Sholazar Basin/0
path follow smart; loop on; ants curved
path	68.60,54.00	71.20,55.00	73.40,55.00	75.00,56.00	73.60,59.80
path	71.40,61.20	66.60,63.60	64.80,59.80
kill Lifeblood Elemental##29124+
|goldcollect 164 Crystallized Earth##37701
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Eternal Fire, Crystallized Fire",{
meta={goldtype="route",levelreq={25},itemtype="elemental"},
items={{37702,124}},
maps={"The Storm Peaks"},
},[[
step
map The Storm Peaks/0
path follow loose; loop on; ants curved
path	76.00,63.40	72.30,64.40	68.20,63.40	69.20,58.00	71.00,56.00
kill Seething Revenant##29504+
|goldcollect 124 Crystallized Fire##37702
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Eternal Life, Crystallized Life",{
meta={goldtype="route",levelreq={25},itemtype="elemental"},
items={{37704,164}},
maps={"Wintergrasp"},
},[[
step
map Wintergrasp/0
path follow smart; loop on; ants curved
path	11.60,60.00	13.10,63.70	10.40,64.70	6.30,65.00	5.20,59.00
path	6.90,57.90
Kill Lasher enemies around this area
|goldcollect 164 Crystallized Life##37704
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Eternal Shadow, Crystallized Shadow",{
meta={goldtype="route",levelreq={15},itemtype="elemental"},
items={{37703,256}},
maps={"Dragonblight"},
},[[
step
Enter the cave |goto Dragonblight/0 74.30,23.60 < 20
kill Deathbringer Revenant##27382+
|goldcollect 256 Crystallized Shadow##37703 |goto Dragonblight/0 75.00,20.80
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Eternal Water, Crystallized Water",{
meta={goldtype="route",levelreq={15},itemtype="elemental"},
items={{37705,112}},
maps={"Dragonblight"},
},[[
step
map Dragonblight/0
path follow smart; loop on; ants curved
path	68.60,50.80	68.60,52.00	67.80,55.80	66.40,55.00	66.20,53.00
path	66.60,51.40
kill Ice Revenant##26283+
|goldcollect 112 Crystallized Water##37705
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Chaos Orb",{
meta={goldtype="route",levelreq={10},elitemobs=1,itemtype="gem"},
items={{52078,1}},
maps={"Dalaran","Borean Tundra","Deepholm","Tanaris","Vashj'ir","Dragonblight","Pit of Saron","The Storm Peaks","Zul'Drak","Uldum","Ghostlands","Northern Stranglethorn","Howling Fjord","Grizzly Hills","Burning Steppes","Icecrown"},
},[[
step
|goldcollect 1 Chaos Orb##52078
|tip Kill the final boss of any Cataclysm Dungeon.
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Volatile Fire",{
meta={goldtype="route",levelreq={30},itemtype="elemental"},
items={{52325,140}},
maps={"Mount Hyjal"},
},[[
step
map Mount Hyjal/0
path follow loose; loop on; ants curved
path	15.90,46.20	18.00,55.50	20.50,59.40	23.30,59.90	24.80,60.50
path	32.50,63.60	32.60,58.70	34.70,57.00	39.70,53.20	38.10,51.00
path	35.90,51.70
Kill enemies around this area
|goldcollect 140 Volatile Fire##52325
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Volatile Water",{
meta={goldtype="route",levelreq={30},itemtype="elemental"},
items={{52326,88}},
maps={"Twilight Highlands"},
},[[
step
map Twilight Highlands/0
path follow loose; loop on; ants curved
path	70.90,50.30	69.80,47.80	67.70,44.70	65.20,41.50	63.10,41.50
path	63.50,44.10	65.80,46.90	67.10,51.20
kill Muddied Water Elemental##44011+
|goldcollect 88 Volatile Water##52326
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Volatile Air",{
meta={goldtype="route",levelreq={30},itemtype="elemental"},
items={{52328,76}},
maps={"Uldum"},
},[[
step
map Uldum/0
path follow smart; loop on; ants curved
path	39.60,36.20	44.40,36.80	42.80,42.20	38.60,47.00	37.00,43.20
kill Scion of Al'Akir##45755+
|goldcollect 76 Volatile Air##52328
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Volatile Earth",{
meta={goldtype="route",levelreq={30},itemtype="elemental"},
items={{52327,92}},
maps={"Twilight Highlands"},
},[[
step
map Twilight Highlands/0
path follow smart; loop on; ants curved
path	61.40,31.00	60.60,34.60	57.40,33.60	54.80,30.60	55.80,27.40
path	58.60,28.20	59.60,29.40
kill Obsidian Stoneslave##47226+
|goldcollect 92 Volatile Earth##52327
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
