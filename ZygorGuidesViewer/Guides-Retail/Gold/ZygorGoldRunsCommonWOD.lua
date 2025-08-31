local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if ZGV:DoMutex("GoldRunCWOD") then return end
ZygorGuidesViewer.GuideMenuTier = "WOD"
ZygorGuidesViewer:RegisterInclude("goldg_farm",[[
step
Start each day out by harvesting the crops from the previous day. |goto Valley of the Four Winds 51.90,48.30
confirm
step
talk Merchant Greenfield##58718
buy 4 %seed% |goto Valley of the Four Winds/0 52.90,52.10 |only if completedq(30257) and not completedq(31936)
buy 8 %seed% |goto Valley of the Four Winds/0 52.90,52.10 |only if completedq(31936) and not completedq(31937)
buy 12 %seed% |goto Valley of the Four Winds/0 52.90,52.10 |only if completedq(31937) and not completedq(32682)
buy 16 %seed% |goto Valley of the Four Winds/0 52.90,52.10 |only if completedq(32682)
step
goto Valley of the Four Winds 51.90,48.30
Plant the seeds in your farm. You will have to wait until the next say to harvest them.
confirm
step
Next day, harvest:
collect 20 %veggie% |only if completedq(30257) and not completedq(31936)
collect 40 %veggie% |only if completedq(31936) and not completedq(31937)
collect 60 %veggie% |only if completedq(31937) and not completedq(32682)
collect 80 %veggie% |only if completedq(32682)
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Daily Runs\\Jade Plate Set Transmog",{
meta={goldtype="xmog",levelreq=15,gold=100,time=15,icon="Interface\\ICONS\\inv_chest_plate07"},
description="\nThis guide will put you on the path to obtaining the Jade Plate Set",
items={{14920,1},{14913,1},{34535,1},{4304,1},{8170,1},{14918,1},{14914,1},{14917,1},{14915,1},{20404,1},{14047,1}},
maps={"Winterspring","Un'Goro Crater","Zul'Farrak","Silithus"},
},[[
step
label "begin"
This guide will point you in the direction to each piece of the Jade Plate armor.
Since they have a very low drop rate, do expect to farm for a bit for these items
confirm always
step
label "Jade1"
Follow the path into the cave, killing all Yeti as you come across them |goto Winterspring/0 71.70,51.70 |noway |c |next "Jade2"
You will be able to skin _Thick and Rugged Leathers_ from the yetis |only if skill("Skinning")>=250
map Winterspring/0
path follow smart; loop off; ants curved; dist 20
path	63.00,53.40	65.10,54.50	66.30,56.30
path	67.30,54.40	68.50,54.20	69.30,52.40
path	69.70,53.70	69.50,55.00	70.10,53.70
path	70.80,53.30	71.60,52.90	71.70,51.70
goldcollect Jade Legplate##14920 |n
goldcollect Jade Greaves##14913 |n
|tip It's possible to get this from the path, but it has a significantly lower drop rate
goldcollect Azure Whelpling##34535 |n
goldcollect Thick Leather##4304 |n
goldcollect Rugged Leather##8170 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to continue farming more parts to the Jade Plate Set |confirm |next "Jade3"
step
label "Jade2"
Follow the path out of the cave, killing all Yeti as you come across them |goto Winterspring/0 63.00,53.40 |noway |c |next "Jade1"
You will be able to skin _Thick and Rugged Leathers_ from the yetis |only if skill("Skinning")>=250
map Winterspring/0
path follow smart; loop off; ants curved; dist 20
path	71.70,51.70	71.60,52.90	70.80,53.30
path	70.10,53.70	69.50,55.00	69.70,53.70
path	69.30,52.40	68.50,54.20	67.30,54.40
path	66.30,56.30	65.10,54.50	63.00,53.40
goldcollect Jade Legplate##14920 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to continue farming more parts to the Jade Plate Set |confirm
step
label "Jade3"
Kill everything inside of Zul'Farrak
Follow the path through Zul'Farrak until you reach the temple area |goto Zul'Farrak/0 24.40,17.60 < 15 |noway |c
map Zul'Farrak/0
path follow smart; loop off; ants curved; dist 20
path	57.30,80.80	59.00,67.80	57.30,55.90
path	53.80,47.40	50.70,42.40	46.60,49.20
path	41.20,52.00	36.10,47.20	33.90,44.20
path	30.80,45.10	27.50,39.60	30.60,37.20
path	33.10,38.00	34.80,35.30	34.80,28.50
path	31.90,24.10	28.60,17.80	24.40,17.60
goldcollect Jade Belt##14918 |n
goldcollect Jade Bracers##14914 |n
goldcollect Jade Gauntlets##14917 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to continue farming more parts to the Jade Plate Set |confirm |next "Jade5"
step
label "Jade4"
Kill everything inside of Zul'Farrak.
Once you have, you will be able to reset the instance.
This step will take you back to the start of the dungeon. _Reset_ if you wish to continue |goto Zul'Farrak/0 57.60,78.90 < 15 |noway |c
map Zul'Farrak/0
path follow smart; loop off; ants curved; dist 20
path	32.10,16.60	39.80,20.80	46.70,20.30
path	55.40,30.90	59.40,40.80	54.80,39.90
path	52.90,44.70	57.60,57.60	58.90,67.20
path	57.60,78.90
goldcollect Jade Belt##14918 |n
goldcollect Jade Bracers##14914 |n
goldcollect Jade Gauntlets##14917 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to continue farming more parts to the Jade Plate Set |confirm
step
label "Jade5"
Follow the path and kill anything along the way.
Do note that you can _kill anything in Un'Goro_ to have a chance for this to drop.
|tip You can just fly in a giant circle killing everything if you wish.
map Un'Goro Crater/0
path follow smart; loop on; ants curved; dist 20
path	68.50,75.30	66.70,70.00	68.20,64.00
path	71.10,59.30	67.00,59.20	64.60,63.00
path	60.70,62.40	58.00,61.50	57.40,68.20
path	58.00,74.60	58.30,80.30	62.30,79.70
path	66.60,77.80
goldcollect Jade Breastplate##14915 |n
goldcollect Jade Gauntlets##14917 |n
|tip The gloves are more likely to drop from Ravensaurs in the area.
Click here to sell the items you have collected |confirm |next "sell"
_
To try your hand at farming for these items in _Silithus_, click here |confirm
step
label "Jade6"
Kill Twilight's Hammer enemies at the provided locations:
_Staghelm Point_ located here |goto Silithus/0 69.70,16.60
_Twilight Base Camp_ located here |goto Silithus/0 45.40,41.50
_Twilight Post_ located here |goto Silithus/0 34.00,31.80
_Twilight Outpost_ located here |goto Silithus/0 27.70,75.10
goldcollect Jade Breastplate##14915 |n
goldcollect Encrypted Twilight Text##20404 |n
goldcollect Runecloth##14047 |n
Click here to sell the items you have collected |confirm |next "sell"
_
To go back to farming in _Un'Goro_, click here |confirm |next "Jade5"
step
label "sell"
#include "auctioneer"
Click here to go back to the start |confirm |next "Jade1"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Daily Runs\\Saltstone Plate Set Transmog",{
meta={goldtype="xmog",levelreq=15,gold=100,time=15,icon="Interface\\ICONS\\inv_chest_plate07"},
description="\nThis guide will put you on the path to obtaining the Saltstone Plate Set",
items={{14901,1},{14895,1},{14897,1},{14903,1},{14898,1},{14900,1},{14896,1}},
maps={"Dire Maul","Thousand Needles","Feralas"},
},[[
step
label "begin"
This guide will point you in the direction to each piece of the Saltstone Plate armor.
Since they have a very low drop rate, do expect to farm for a bit for these items
confirm always
step
label "DM1"
map Dire Maul/5
path loop off; ants straight; dist 30
path	12.60,39.60	12.40,66.30	12.70,77.90
path	22.90,76.60	31.40,75.40	34.10,26.10
You will now be directed to the next portion of the dungeon |goto Dire Maul/5 34.10,26.10 < 20 |noway |c
goldcollect Saltstone Shoulder Pads##14901 |n
goldcollect Saltstone Surcoat##14895 |n
goldcollect Saltstone Gauntlets##14897 |n
goldcollect Saltstone Armsplints##14903 |n
goldcollect Saltstone Girdle##14898 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here for an alternative farming route |confirm |next "pvph"
step
label "DM2"
_Enter_ the hallway |goto Dire Maul/5 46.00,26.20 < 20
_Go through_ the hallway |goto Dire Maul/5 54.80,26.80 < 20
_Continue_ through the passage |goto Dire Maul/5 56.40,35.50 < 20
_Exit_ the passage |goto Dire Maul/5 60.80,37.80 < 20
_Go to_ the end of the hallway |goto Dire Maul/5 84.50,37.60 < 20
You will now be directed to the next portion of the dungeon |goto Dire Maul/5 84.50,37.60 < 20 |c
goldcollect Saltstone Shoulder Pads##14901 |n
goldcollect Saltstone Surcoat##14895 |n
goldcollect Saltstone Gauntlets##14897 |n
goldcollect Saltstone Armsplints##14903 |n
goldcollect Saltstone Girdle##14898 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here for an alternative farming route |confirm |next "pvph"
step
label "DM3"
_Enter_ the hallway |goto Dire Maul/5 58.70,37.70 < 20
_Go up_ the ramp |goto Dire Maul/5 54.00,26.20 < 20
_Go through_ the doorway |goto Dire Maul/5 43.80,29.40 < 20
_Clear all_ the enemies through the room as you go through it |goto Dire Maul/5 38.80,40.90 < 20
Continue through the room |goto Dire Maul/5 38.40,56.40 < 20
_Go up_ the ramp |goto Dire Maul/5 43.90,66.50 < 20
Defeat Lethtendris |goto Dire Maul/5 44.80,52.30
You will now be directed to the next portion of the dungeon  |goto Dire Maul/5 44.80,52.30 < 10 |noway |c
goldcollect Saltstone Shoulder Pads##14901 |n
goldcollect Saltstone Surcoat##14895 |n
goldcollect Saltstone Gauntlets##14897 |n
goldcollect Saltstone Armsplints##14903 |n
goldcollect Saltstone Girdle##14898 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here for an alternative farming route |confirm |next "pvph"
step
label "DM4"
_Go down_ the ramp |goto Dire Maul/5 46.60,63.50 < 15
_Follow_ the ramp into the room |goto Dire Maul/6 57.50,87.50 < 15
Defeat the _Hydrospawn_ |goto Dire Maul/6 54.30,72.90 |scenariogoal 25059
_Go up_ the ramp |goto Dire Maul/6 57.70,55.50 < 10
_Follow_ the tunnel |goto Dire Maul/6 62.10,59.60 < 5
Defeat _Zevrim Thornhoof_ |goto Dire Maul/6 58.80,72.60 < 4
You will now be directed to the next portion of the dungeon |scenariogoal 25060
goldcollect Saltstone Shoulder Pads##14901 |n
goldcollect Saltstone Surcoat##14895 |n
goldcollect Saltstone Gauntlets##14897 |n
goldcollect Saltstone Armsplints##14903 |n
goldcollect Saltstone Girdle##14898 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here for an alternative farming route |confirm |next "pvph"
step
label "DM5"
_Jump down_ the ledge |goto Dire Maul/6 54.60,72.50 < 10
_Go through_ the doorway |goto Dire Maul/6 52.90,87.90 < 15
talk Ironbark the Redeemed##11491
Tell him: _Thank you, Ironbark. We are ready for you to open the door._ |goto Dire Maul/6 41.20,81.00 < 15
_Go through_ the door once Ironbark opens it |goto Dire Maul/6 40.10,49.50
_Leave_ the tunnel |goto Dire Maul/6 45.10,28.90
_Go down_ the ramp |goto Dire Maul/6 50.80,21.90
_Continue_ down the ramp |goto Dire Maul/6 62.40,17.10
_Go down_ the second ramp |goto Dire Maul/6 65.80,28.20
Defeat Alzzin the Wildshaper |goto Dire Maul/6 55.50,28.10
You will now be directed to the next portion of the dungeon |goto Dire Maul/6 55.50,28.10 < 10 |noway |c
goldcollect Saltstone Shoulder Pads##14901 |n
goldcollect Saltstone Surcoat##14895 |n
goldcollect Saltstone Gauntlets##14897 |n
goldcollect Saltstone Armsplints##14903 |n
goldcollect Saltstone Girdle##14898 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here for an alternative farming route |confirm |next "pvph"
step
label "DME1"
Go up the ramp |goto Dire Maul/6 67.20,28.10 < 20
Make your way towards the exit |goto Dire Maul/6 58.80,16.40 < 20
_Enter_ the tunnel |goto Dire Maul/6 45.20,28.90 < 15
_Leave_ the tunnel |goto Dire Maul/6 40.10,49.20 < 15
Go through the open room |goto Dire Maul/6 40.60,67.30 < 30
_Enter_ the doorway |goto Dire Maul/6 49.10,91.20 < 15
You will now be directed to the next portion of the dungeon |goto Dire Maul/6 49.10,91.20 |noway |c
_
Click here to sell the items you have collected |confirm |next "sell"
step
label "DME2"
_Enter_ the room |goto Dire Maul/6 54.10,74.80 < 15
_Go around_ the wall |goto Dire Maul/6 57.90,75.20 < 15
_Go up_ the ramp |goto Dire Maul/6 57.80,89.00 < 15
_Enter_ the open room |goto Dire Maul/5 46.80,63.10 < 15
_Go through_ the door |goto Dire Maul/5 43.70,27.80 < 15
_Turn left_ here |goto Dire Maul/5 32.60,26.00 < 15
_Enter_ the tunnel |goto Dire Maul/5 30.10,81.70 < 15
_Leave_ the dungeon |goto Dire Maul/5 27.60,85.20
Click here to continue farming _Dire Maul_ |confirm |next "DM1"
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to move on to farming in Feralas |confirm
step
label "pvph"
Farming here _WILL FLAG YOU_ for PvP! |only Horde
Defeat Grimtotem Marauders around the area |goto Feralas/0 86.50,45.10
goldcollect Saltstone Shoulder Pads##14901 |n
goldcollect Saltstone Armsplints##14903 |n
goldcollect Saltstone Girdle##14898 |n
goldcollect Saltstone Legplates##14900 |n
goldcollect Saltstone Sabatons##14896 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to continue farming more parts to the Saltstone Plate Set |confirm
step
label "1k1"
map Thousand Needles/0
path follow strict; loop off; ants curved; dist 20
path	32.10,32.70	33.20,35.40	33.90,38.40
path	36.70,39.80	39.10,41.40	42.30,43.80
path	42.20,49.40	45.30,50.00
Farm _Grimtotem_ enemies along this path
goldcollect Saltstone Shoulder Pads##14901 |n
goldcollect Saltstone Surcoat##14895 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to farm at a different location |confirm
step
label "1k2"
map Thousand Needles/0
path follow strict; loop off; ants straight; dist 20
path	88.70,87.80	90.80,83.00	91.50,77.20
path	93.50,74.60	94.20,71.60
Farm _Southsea Pirates_ along this path
goldcollect Saltstone Shoulder Pads##14901 |n
goldcollect Saltstone Surcoat##14895 |n
goldcollect Saltstone Gauntlets##14897 |n
goldcollect Saltstone Armsplints##14903 |n
goldcollect Saltstone Girdle##14898 |n
goldcollect Saltstone Legplates##14900 |n
goldcollect Saltstone Sabatons##14896 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to farm at a different location |confirm
step
label "1k3"
Kill the _Ogres_ inside of the cave |goto Thousand Needles/0 92.20,83.30
goldcollect Saltstone Legplates##14900 |n
goldcollect Saltstone Sabatons##14896 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to continue farming the locations of Thousand Needles |confirm |next "1k1"
step
label "sell"
#include "auctioneer"
Click here to go back to the start |confirm |next "DM1"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Daily Runs\\Tyrant Plate Set Transmog",{
meta={goldtype="xmog",levelreq=15,gold=100,time=15,icon="Interface\\ICONS\\inv_chest_plate08"},
description="\nThis guide will put you on the path to obtaining the Tyrant Plate Set",
items={{14835,1},{14840,1},{14839,1},{14833,1},{14838,1},{14834,1}},
maps={"Dire Maul","Tanaris","Zul'Farrak"},
},[[
step
This guide will point you in the direction to each piece of the Tyrant Plate armors.
Since they have a very low drop rate, do expect to farm for a bit for these items
confirm always
step
label "ZF1"
Kill everything inside of Zul'Farrak
Follow the path through Zul'Farrak until you reach the temple area |goto Zul'Farrak/0 24.40,17.60 < 15 |noway |c
map Zul'Farrak/0
path follow smart; loop off; ants curved; dist 20
path	57.30,80.80	59.00,67.80	57.30,55.90
path	53.80,47.40	50.70,42.40	46.60,49.20
path	41.20,52.00	36.10,47.20	33.90,44.20
path	30.80,45.10	27.50,39.60	30.60,37.20
path	33.10,38.00	34.80,35.30	34.80,28.50
path	31.90,24.10	28.60,17.80	24.40,17.60
goldcollect Tyrant's Chestpiece##14835 |n
goldcollect Tyrant's Legplates##14840 |n
goldcollect Tyrant's Greaves##14839 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to continue farming more parts to the Tyrant Plate Set |confirm |next "OGRE1"
step
label "ZF2"
Kill everything inside of Zul'Farrak.
Once you have, you will be able to reset the instance.
This step will take you back to the start of the dungeon. _Reset_ if you wish to continue |goto Zul'Farrak/0 57.60,78.90 < 15 |noway |c
map Zul'Farrak/0
path follow smart; loop off; ants curved; dist 20
path	32.10,16.60	39.80,20.80	46.70,20.30
path	55.40,30.90	59.40,40.80	54.80,39.90
path	52.90,44.70	57.60,57.60	58.90,67.20
path	57.60,78.90
goldcollect Tyrant's Chestpiece##14835 |n
goldcollect Tyrant's Legplates##14840 |n
goldcollect Tyrant's Greaves##14839 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to continue farming more parts to the Tyrant Plate Set |confirm
step
label "OGRE1"
Be sure to kill everything in the dungeon as you go through; Also _reset_ if need be
_Go down_ the ramp|goto Dire Maul/1 69.30,86.80 < 15
_Cross_ through the open area |goto Dire Maul/1 69.30,80.30 < 20
_Go up_ the ramp |goto Dire Maul/1 69.30,69.70 < 15
_Walk around_ the ledge here |goto Dire Maul/1 64.70,68.20 < 20
_Go up_ the ramp |goto Dire Maul/1 58.80,71.20 < 15
_Continue_ up the ramp |goto Dire Maul/1 56.00,78.00 < 20
_Go through_ the doorway |goto Dire Maul/1 40.70,78.10 < 20
_Follow_ the path through the hallway |goto Dire Maul/1 30.10,77.50 < 20
_Go through_ the doorway |goto Dire Maul/1 27.00,68.80 < 20
_Walk around_ the wall |goto Dire Maul/1 25.10,57.10 < 20
_Go up_ the ramp |goto Dire Maul/1 23.30,66.70 < 20
_
You will now be directed to the next part of Dire Maul |goto Dire Maul/1 23.30,66.70 < 20 |noway |c
goldcollect Tyrant's Gauntlets##14833 |n
goldcollect Tyrant's Belt##14838 |n
goldcollect Tyrant's Greaves##14839 |n
step
_Go up_ the ramp |goto Dire Maul/1 25.40,54.40 < 15
_Go through_ the door |goto Dire Maul/1 28.90,65.70 < 15
_Follow_ the path into the open room |goto Dire Maul/1 31.80,48.90 < 20
Defeat King Gordok |goto Dire Maul/1 31.90,26.90
_
goldcollect Tyrant's Gauntlets##14833 |n
goldcollect Tyrant's Belt##14838 |n
goldcollect Tyrant's Greaves##14839 |n
Click here to continue farming in Dire Maul |confirm |next "OGRE1"
_
Click here to continue farming more pieces of the Tyrant Plate Set |confirm
step
label "DM1"
map Dire Maul/5
path loop off; ants straight; dist 30
path	12.60,39.60	12.40,66.30	12.70,77.90
path	22.90,76.60	31.40,75.40	34.10,26.10
You will now be directed to the next portion of the dungeon |goto Dire Maul/5 34.10,26.10 < 20 |noway |c
goldcollect Tyrants Armguard##14834 |n
goldcollect Tyrant's Belt##14838 |n
goldcollect Tyrant's Greaves##14839 |n
Click here to sell the items you have collected |confirm |next "sell"
step
label "DM2"
_Enter_ the hallway |goto Dire Maul/5 46.00,26.20 < 20
_Go through_ the hallway |goto Dire Maul/5 54.80,26.80 < 20
_Continue_ through the passage |goto Dire Maul/5 56.40,35.50 < 20
_Exit_ the passage |goto Dire Maul/5 60.80,37.80 < 20
_Go to_ the end of the hallway |goto Dire Maul/5 84.50,37.60 < 20
You will now be directed to the next portion of the dungeon |goto Dire Maul/5 84.50,37.60 < 20 |c
goldcollect Tyrants Armguard##14834 |n
goldcollect Tyrant's Belt##14838 |n
goldcollect Tyrant's Greaves##14839 |n
Click here to sell the items you have collected |confirm |next "sell"
step
label "DM3"
_Enter_ the hallway |goto Dire Maul/5 58.70,37.70 < 20
_Go up_ the ramp |goto Dire Maul/5 54.00,26.20 < 20
_Go through_ the doorway |goto Dire Maul/5 43.80,29.40 < 20
_Clear all_ the enemies through the room as you go through it |goto Dire Maul/5 38.80,40.90 < 20
Continue through the room |goto Dire Maul/5 38.40,56.40 < 20
_Go up_ the ramp |goto Dire Maul/5 43.90,66.50 < 20
Defeat Lethtendris |goto Dire Maul/5 44.80,52.30
You will now be directed to the next portion of the dungeon  |goto Dire Maul/5 44.80,52.30 < 10 |noway |c
goldcollect Tyrants Armguard##14834 |n
goldcollect Tyrant's Belt##14838 |n
goldcollect Tyrant's Greaves##14839 |n
Click here to sell the items you have collected |confirm |next "sell"
step
label "DM4"
_Go down_ the ramp |goto Dire Maul/5 46.60,63.50 < 15
_Follow_ the ramp into the room |goto Dire Maul/6 57.50,87.50 < 15
Defeat the _Hydrospawn_ |goto Dire Maul/6 54.30,72.90 |scenariogoal 25059
_Go up_ the ramp |goto Dire Maul/6 57.70,55.50 < 10
_Follow_ the tunnel |goto Dire Maul/6 62.10,59.60 < 5
Defeat _Zevrim Thornhoof_ |goto Dire Maul/6 58.80,72.60 < 4
You will now be directed to the next portion of the dungeon |scenariogoal 25060
goldcollect Tyrants Armguard##14834 |n
goldcollect Tyrant's Belt##14838 |n
goldcollect Tyrant's Greaves##14839 |n
Click here to sell the items you have collected |confirm |next "sell"
step
label "DM5"
_Jump down_ the ledge |goto Dire Maul/6 54.60,72.50 < 10
_Go through_ the doorway |goto Dire Maul/6 52.90,87.90 < 15
talk Ironbark the Redeemed##11491
Tell him: _Thank you, Ironbark. We are ready for you to open the door._ |goto Dire Maul/6 41.20,81.00 < 15
_Go through_ the door once Ironbark opens it |goto Dire Maul/6 40.10,49.50
_Leave_ the tunnel |goto Dire Maul/6 45.10,28.90
_Go down_ the ramp |goto Dire Maul/6 50.80,21.90
_Continue_ down the ramp |goto Dire Maul/6 62.40,17.10
_Go down_ the second ramp |goto Dire Maul/6 65.80,28.20
Defeat Alzzin the Wildshaper |goto Dire Maul/6 55.50,28.10
goldcollect Tyrants Armguard##14834 |n
goldcollect Tyrant's Belt##14838 |n
goldcollect Tyrant's Greaves##14839 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here for an alternative farming route |confirm |next "DME1"
step
label "DME1"
Go up the ramp |goto Dire Maul/6 67.20,28.10 < 20
Make your way towards the exit |goto Dire Maul/6 58.80,16.40 < 20
_Enter_ the tunnel |goto Dire Maul/6 45.20,28.90 < 15
_Leave_ the tunnel |goto Dire Maul/6 40.10,49.20 < 15
Go through the open room |goto Dire Maul/6 40.60,67.30 < 30
_Enter_ the doorway |goto Dire Maul/6 49.10,91.20 < 15
You will now be directed to the next portion of the dungeon  |goto Dire Maul/6 49.10,91.20 |noway |c
_
Click here to sell the items you have collected |confirm |next "sell"
step
label "DME2"
_Enter_ the room |goto Dire Maul/6 54.10,74.80 < 15
_Go around_ the wall |goto Dire Maul/6 57.90,75.20 < 15
_Go up_ the ramp |goto Dire Maul/6 57.80,89.00 < 15
_Enter_ the open room |goto Dire Maul/5 46.80,63.10 < 15
_Go through_ the door |goto Dire Maul/5 43.70,27.80 < 15
_Turn left_ here |goto Dire Maul/5 32.60,26.00 < 15
_Enter_ the tunnel |goto Dire Maul/5 30.10,81.70 < 15
_Leave_ the dungeon |goto Dire Maul/5 27.60,85.20
Click here to continue farming _Dire Maul_ |confirm |next "DM1"
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to move on to farming in Tanaris |confirm
step
label "SSP1"
map Tanaris/0
path follow smart; loop off; ants curved; dist 20
path	68.40,42.30	69.90,43.30	71.20,44.60
path	72.20,45.80	72.70,48.50	72.00,49.80
path	69.90,50.70	69.60,52.70	69.10,54.50
path	69.50,57.00
goldcollect Tyrant's Gauntlets##14833 |n
You will be routed back to the cave entrance of Southbreak Shore |goto Tanaris/0 69.50,57.00 < 30 |noway |c
_
Click here to move onto farming Zul'Farrak |confirm |next "ZF1"
step
label "SSP2"
map Tanaris/0
path follow smart; loop off; ants curved; dist 20
path	69.50,57.00	69.10,54.50	69.60,52.70
path	69.90,50.70	72.00,49.80	72.70,48.50
path	72.20,45.80	71.20,44.60	69.90,43.30
path	68.40,42.30
goldcollect Tyrant's Gauntlets##14833 |n
Click here to farm Southsea Pirates more |confirm |next "SSP1"
_
Click here to sell the items you have collected |confirm
step
label "sell"
#include "auctioneer"
Click here to go back to the start of the guide |next "ZF1" |confirm
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Daily Runs\\Bloodscale Plate Set Transmog",{
meta={goldtype="xmog",levelreq=10,gold=100,time=15,icon="Interface\\ICONS\\inv_chest_chain_07"},
description="\nThis guide will put you on the path to obtaining the Bloodscale Breastplate Set",
items={{24944,1},{24942,1},{24943,1},{24945,1},{24947,1},{24949,1},{14047,1},{21877,1}},
maps={"Hellfire Ramparts","The Blood Furnace"},
},[[
step
This guide will point you in the direction to each piece of the Bloodscale Plate armors.
Since they have a very low drop rate, do expect to farm for a bit for these items
confirm always
step
label "HR1"
Be sure to set the dungeon difficulty to normal
_Cross_ the bridge |goto Hellfire Ramparts/1 47.10,64.80 < 25
_Go around_ the wall |goto Hellfire Ramparts/1 46.80,52.10 < 25
_Continue_ around the wall |goto Hellfire Ramparts/1 60.60,51.10 < 20
_Enter_ the open room |goto Hellfire Ramparts/1 74.00,48.40 < 25
Defeat Watchkeeper Gargolmar |goto Hellfire Ramparts/1 71.00,30.80
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Belt##24942 |n
goldcollect Bloodscale Sabatons##24943 |n
goldcollect Bloodscale Gauntlets##24945 |n
goldcollect Bloodscale Legguards##24947 |n
goldcollect Bloodscale Bracers##24949 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Netherweave Cloth##21877 |n
Once you reach the ogre room, you will be directed to the next section of farming |goto Hellfire Ramparts/1 71.00,30.80 < 10 |noway |c
_
Click here if you want to sell what you have |confirm |next "sell"
step
map Hellfire Ramparts/1
path follow strict; loop off; ants curved; dist 20
path	64.90,40.20	69.20,41.60	63.90,44.80
path	50.00,52.20	40.10,22.80
Defeat Omor the Unscarred |goto Hellfire Ramparts/1 40.10,22.80 < 20
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Belt##24942 |n
goldcollect Bloodscale Sabatons##24943 |n
goldcollect Bloodscale Gauntlets##24945 |n
goldcollect Bloodscale Legguards##24947 |n
goldcollect Bloodscale Bracers##24949 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Netherweave Cloth##21877 |n
Once you reach the ogre room, you will be directed to the next section of farming |goto Hellfire Ramparts/1 40.10,22.80 < 20 |noway |c
_
Click here if you want to sell what you have |confirm |next "sell"
step
_Go through_ the doorway |goto Hellfire Ramparts/1 45.10,37.40 < 30
_Go down_ the bridge |goto Hellfire Ramparts/1 48.40,62.40 < 30
_Enter_ the empty room |goto Hellfire Ramparts/1 37.10,78.80
Defeat Nazan and Vazruden
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Belt##24942 |n
goldcollect Bloodscale Sabatons##24943 |n
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Gauntlets##24945 |n
goldcollect Bloodscale Legguards##24947 |n
goldcollect Bloodscale Bracers##24949 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Netherweave Cloth##21877 |n
Once you reach the ogre room, you will be directed to the next section of farming |goto Hellfire Ramparts/1 37.10,78.80 < 20 |noway |c
_
Click here if you want to sell what you have |confirm |next "sell"
step
label "BF1"
_Go up_ the stairs |goto The Blood Furnace/1 58.30,82.50 < 30
_Go into_ the doorway |goto The Blood Furnace/1 58.20,60.10 < 20
_Follow_ the path to the left |goto The Blood Furnace/1 55.50,53.90 < 20
_Enter_ the open room |goto The Blood Furnace/1 46.10,41.20 < 20
Defeat The Maker |goto The Blood Furnace/1 37.10,41.20
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Belt##24942 |n
goldcollect Bloodscale Sabatons##24943 |n
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Gauntlets##24945 |n
goldcollect Bloodscale Legguards##24947 |n
goldcollect Bloodscale Bracers##24949 |n
_Secondary Items:_
goldcollect Netherweave Cloth##21877 |n
Once you reach the ogre room, you will be directed to the next section of farming |goto The Blood Furnace/1 37.10,41.20 < 20 |noway |c
_
Click here if you want to sell what you have |confirm |next "sell"
step
_Enter_ the path |goto The Blood Furnace/1 31.80,42.30 < 20
_Leave_ the tunnel |goto The Blood Furnace/1 32.10,21.60 < 20
Click the Cell Door Lever |goto The Blood Furnace/1 43.30,22.00 < 15
Defeat Broggok
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Belt##24942 |n
goldcollect Bloodscale Sabatons##24943 |n
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Gauntlets##24945 |n
goldcollect Bloodscale Legguards##24947 |n
goldcollect Bloodscale Bracers##24949 |n
_Secondary Items:_
goldcollect Netherweave Cloth##21877 |n
Once you reach the ogre room, you will be directed to the next section of farming |goto The Blood Furnace/1 43.30,22.00 < 15 |noway |c
_
Click here if you want to sell what you have |confirm |next "sell"
step
_Enter_ the doorway |goto The Blood Furnace/1 47.50,22.00 < 20
_Go through_ the doorway on the right |goto The Blood Furnace/1 58.10,22.20 < 20
_Go down_ the ramp |goto The Blood Furnace/1 62.00,28.70 < 20
_Enter_ the room |goto The Blood Furnace/1 65.80,41.30 < 20
Defeat Keli'dan the Breaker |goto The Blood Furnace/1 58.20,42.00
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Belt##24942 |n
goldcollect Bloodscale Sabatons##24943 |n
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Gauntlets##24945 |n
goldcollect Bloodscale Legguards##24947 |n
goldcollect Bloodscale Bracers##24949 |n
_Secondary Items:_
goldcollect Netherweave Cloth##21877 |n
Once you reach the ogre room, you will be directed to the next section of farming |goto The Blood Furnace/1 58.20,42.00  < 15 |noway |c
_
Click here if you want to sell what you have |confirm |next "sell"
step
_Enter_ the tunnel |goto The Blood Furnace/1 62.50,50.60 < 20
_Exit_ the tunnel |goto The Blood Furnace/1 61.10,90.60 < 20
_Leave_ the dungeon |goto The Blood Furnace/1 47.80,90.60 < 20
Click here to continue farming the Hellfire Ramparts |confirm |next "HR1"
Click here to continue farming the Blood Furnace |confirm |next "BF1"
_
Click here if you wish to sell |confirm |next "sell"
step
label "sell"
#include "auctioneer"
Click here to go back to the start |confirm |next "HR1"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Daily Runs\\Ebonhold Mail Set Transmog",{
meta={goldtype="xmog",levelreq=20,gold=100,time=15,icon="Interface\\ICONS\\inv_chest_chain_17"},
inv_chest_plate0="inv_chest_plate08",
description="\nThis guide will put you on the path to obtaining the Ebonhold Mail Set",
items={{8269,1},{8264,1},{8267,1},{8268,1},{14047,1},{14227,1},{10285,1},{4337,1},{8265,1},{8271,1},{13466,1}},
maps={"Swamp of Sorrows","Blackrock Spire","Burning Steppes","Blasted Lands","The Temple of Atal'Hakkar"},
},[[
step
This guide will point you in the direction to each piece of the Ebonhold Mail armors.
Since they have a very low drop rate, do expect to farm for a bit for these items
confirm always
step
label "boots1"
The _Ebonhold Boots_ can be looted from _Mithril Lockboxes_, so if you get them, have a rogue open them or send them to a rogue alt.
Be sure to _kill everything_ along your path
_
_Go through_ the passage |goto Blackrock Spire/4 40.70,45.80 < 20
_Go down_ the ramp |goto Blackrock Spire/3 49.60,39.90 < 20
_Cross_ the bridge |goto Blackrock Spire/3 59.50,42.80 < 20
_Cross_ the second bridge |goto Blackrock Spire/3 66.60,44.70 < 20
_Go around_ the opening in the ground |goto Blackrock Spire/3 66.00,58.20 < 20
_Enter_ the hallway |goto Blackrock Spire/3 57.00,57.80 < 20
_Enter_ the room |goto Blackrock Spire/3 46.10,57.70 < 20
Defeat Highlord Omokk |goto Blackrock Spire/3 35.70,55.50
Once you reach the ogre room, you will be directed to the next section of farming |goto Blackrock Spire/3 35.70,55.50 < 20 |noway |c
goldcollect Ebonhold Boots##8269 |n
goldcollect Ebonhold Wristguards##8264 |n
goldcollect Ebonhold Gauntlets##8267 |n
goldcollect Ebonhold Girdle##8268 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
collect ##5758 |n
step
label "boots2"
_Cross_ the bridge |goto Blackrock Spire/3 47.80,57.70 < 20
_Exit_ the hallway |goto Blackrock Spire/3 56.70,57.70 < 15
_Go down_ the ramp |goto Blackrock Spire/3 57.00,51.10 < 10
_Enter_ the doorway |goto Blackrock Spire/2 53.20,52.60 < 5
_Go up_ the ramp and kill the enemies there |goto Blackrock Spire/2 55.30,61.50 < 10
|tip Come back down after you kill the enemies
_Go down_ the ramp |goto Blackrock Spire/2 56.90,58.30 < 15
_Enter_ the doorway |goto Blackrock Spire/1 54.20,61.60 < 15
Defeat _War Master Voone_ |goto Blackrock Spire/1 52.90,54.40
Once you reach War Master Voone, you will be directed to the next section of farming |goto Blackrock Spire/1 52.90,54.40 < 10 |noway |c
goldcollect Ebonhold Boots##8269 |n
goldcollect Ebonhold Wristguards##8264 |n
goldcollect Ebonhold Gauntlets##8267 |n
goldcollect Ebonhold Girdle##8268 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
collect ##5758 |n
step
label "boots3"
_Leave_ the room |goto Blackrock Spire/1 53.80,61.60 < 15
_Enter_ the doorway |goto Blackrock Spire/1 66.00,50.70 < 15
_Pass_ through the rocks |goto Blackrock Spire/3 61.90,46.20 < 15
_Follow_ the path through Hordemar City |goto Blackrock Spire/1 50.40,51.60 < 15
_Continue_ through the area |goto Blackrock Spire/1 49.10,63.90 < 20
_Go up_ the ramp |goto Blackrock Spire/1 57.10,70.40 < 20
_Continue_ up the ramp |goto Blackrock Spire/2 56.30,73.50 < 20
_Follow_ the path up |goto Blackrock Spire/3 46.90,68.60 < 20
_Continue_ along the path |goto Blackrock Spire/4 42.60,60.90 < 20
Once you reach this point, you willbe directed to the next section of farming |goto Blackrock Spire/4 42.60,60.90 < 20 |noway |c
goldcollect Ebonhold Boots##8269 |n
goldcollect Ebonhold Wristguards##8264 |n
goldcollect Ebonhold Gauntlets##8267 |n
goldcollect Ebonhold Girdle##8268 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Ironweb Spider Silk##14227 |n
goldcollect Shadow Silk##10285 |n
goldcollect Thick Spider's Silk##4337 |n
collect ##5758 |n
step
label "boots4"
_Enter_ the doorway |goto Blackrock Spire/4 42.80,74.00
_Go up_ the ramp |goto Blackrock Spire/5 47.40,79.90
_Enter_ the Storehouse |goto Blackrock Spire/5 53.80,84.60
Once you reach this point, you willbe directed to the next section of farming |goto Blackrock Spire/5 53.80,84.60  < 20 |noway |c
goldcollect Ebonhold Boots##8269 |n
goldcollect Ebonhold Wristguards##8264 |n
goldcollect Ebonhold Gauntlets##8267 |n
goldcollect Ebonhold Girdle##8268 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
collect ##5758 |n
collect Worg Carrier##12264 |n
step
label "boots5"
_Go down_ the ramp |goto Blackrock Spire/5 51.40,79.90 < 15
_Enter_ the room |goto Blackrock Spire/5 37.60,84.00 < 15
_Go up_ the ramp |goto Blackrock Spire/5 40.00,77.10 < 15
_Walk around_ the gap in the ground |goto Blackrock Spire/5 35.90,71.40 < 15
_Cross_ the bridge |goto Blackrock Spire/5 37.40,63.70 < 15
_Go through_ the doorway |goto Blackrock Spire/5 40.10,60.40 < 10
_Enter_ the Battle Chamber |goto Blackrock Spire/6 50.80,60.50 < 15
_Follow_ the path up |goto Blackrock Spire/6 59.00,65.30 < 15
Defeat Overlord Wyrmthalak |goto Blackrock Spire/6 56.10,57.00
Once you reach this point, you willbe directed to the next section of farming |goto Blackrock Spire/6 56.10,57.00 |noway |c
goldcollect Ebonhold Boots##8269 |n
goldcollect Ebonhold Wristguards##8264 |n
goldcollect Ebonhold Gauntlets##8267 |n
goldcollect Ebonhold Girdle##8268 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
collect ##5758 |n
step
label "boots6"
Pass through the hallway |goto Blackrock Spire/6 44.80,60.50 < 15
Go through the second doorway |goto Blackrock Spire/6 40.80,60.40 < 8
Jump down the ledge |goto Blackrock Spire/5 40.00,62.40 < 10
Jump down to the bridge below |goto Blackrock Spire/4 46.60,57.80 < 15
_Go through_ the doorway |goto Blackrock Spire/3 56.60,57.70 < 15
_Enter_ the room |goto Blackrock Spire/3 66.10,58.70 < 15
_Cross_ the bridge |goto Blackrock Spire/3 66.20,50.30 < 15
_Cross_ the second bridge |goto Blackrock Spire/3 63.70,42.90 < 15
_Go up_ the ramp |goto Blackrock Spire/3 54.50,37.40 < 15
_Go through_ the passage |goto Blackrock Spire/4 40.30,47.00 < 15
_Leave_ the instance |goto Blackrock Spire/4 37.80,41.40 < 15
You can now reset the instance if you wish to |goto Burning Steppes/14 80.30,40.30
_
To continue farming here, click here to move back to the start. |confirm |next "boots1"
_
Click here to farm other parts of the Ebonhold set |confirm
step
talk Zidormi##88206
Tell her: _Show me the Blasted Lands before the invasion._ |goto Blasted Lands/0 48.20,7.30
|confirm
step
label "chest1"
Follow this path, killing Ashmane Boars, Dreadmaul Ogres, Snickerfang Hyena, Redstone Basilisk and Enthralled Cultists.
map Blasted Lands/0
path follow smart; loop off; ants curved; dist 20
path	58.40,25.00	54.90,23.90	52.10,26.50
path	54.20,31.00	56.70,37.00	53.70,38.80
path	50.60,36.30	46.90,33.90
goldcollect Ebonhold Armor##8265
goldcollect Ebonhold Leggings##8271
goldcollect Ebonhold Boots##8269
_Secondary Items:_
goldcollect Runecloth##14047
To continue farming at another location, click here |confirm
_
Click here to farm other parts of the Ebonhold set |confirm |next "wrist1"
step
label "chest2"
map Swamp of Sorrows/0
path follow smart; loop on; ants curved; dist 20
path	37.40,51.90	33.80,55.50	30.60,54.70
path	27.60,50.90	27.40,44.70	28.60,39.80
path	32.00,38.80	34.40,35.70	37.30,34.80
path	38.20,39.10	38.10,42.90	37.20,47.50
path	33.90,47.90
Kill the slimes in the area
goldcollect Ebonhold Armor##8265 |n
_Secondary Items:_
goldcollect Sorrowmoss##13466 |n
To continue farming here, click here to move back to the start. |confirm |next "chest1"
_
Click here to farm other parts of the Ebonhold set |confirm
step
label "wrist1"
Go _down the stairs_, following the path _into the Sunken Temple_ |goto Swamp of Sorrows/0 69.70,53.60 < 10 |c
map The Temple of Atal'Hakkar/1
path follow smart; loop off; ants curved; dist 20
path	50.00,42.80	39.00,36.30	28.00,26.60
path	23.80,63.00	31.00,61.20	42.80,52.40
path	50.40,59.90	57.70,53.30	75.70,64.30
path	76.10,38.70
You will be guided to the next section once you reach this area. |goto The Temple of Atal'Hakkar/1 76.10,38.70 < 20 |noway |c
goldcollect Ebonhold Wristguards##8264 |n
goldcollect Ebonhold Gauntlets##8267 |n
goldcollect Ebonhold Girdle##8268 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
step
map The Temple of Atal'Hakkar/1
path follow smart; loop off; ants curved; dist 20
path	75.00,63.50	69.70,62.10	57.00,51.50
path	50.00,59.70	49.60,86.80	65.70,87.60
goldcollect Ebonhold Wristguards##8264 |n
goldcollect Ebonhold Gauntlets##8267 |n
goldcollect Ebonhold Girdle##8268 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
Click here to return to the start of the guide |confirm |next "boots1"
_
Click here to farm other parts of the Ebonhold set |confirm
step
label "sell"
#include "auctioneer"
Click here to go back to the start |confirm |next "boots1"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Daily Runs\\Ironhide Mail Set Transmog",{
meta={goldtype="xmog",levelreq=15,gold=100,time=15,icon="Interface\\ICONS\\inv_chest_plate08"},
description="\nThis guide will put you on the path to obtaining the Ironhide Mail Set",
items={{15639,1},{15642,1},{15641,1},{15644,1},{15647,1},{15640,1},{15646,1},{20404,1},{14047,1}},
maps={"Winterspring","Zul'Farrak","Silithus"},
},[[
step
label "begin"
This guide will point you in the direction to each piece of the Ironhide Mail armor.
Since they have a very low drop rate, do expect to farm for a bit for these items
confirm always
step
label "IH1"
Kill everything inside of Zul'Farrak
Follow the path through Zul'Farrak until you reach the temple area |goto Zul'Farrak/0 24.40,17.60 < 15 |noway |c
map Zul'Farrak/0
path follow smart; loop off; ants curved; dist 20
path	57.30,80.80	59.00,67.80	57.30,55.90
path	53.80,47.40	50.70,42.40	46.60,49.20
path	41.20,52.00	36.10,47.20	33.90,44.20
path	30.80,45.10	27.50,39.60	30.60,37.20
path	33.10,38.00	34.80,35.30	34.80,28.50
path	31.90,24.10	28.60,17.80	24.40,17.60
goldcollect Ironhide Bracers##15639 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to continue farming more parts to the Ironhide Mail Set |confirm |next "WS1"
step
label "IH2"
Kill everything inside of Zul'Farrak.
Once you have, you will be able to reset the instance.
This step will take you back to the start of the dungeon. _Reset_ if you wish to continue |goto Zul'Farrak/0 57.60,78.90 < 15 |noway |c
map Zul'Farrak/0
path follow smart; loop off; ants curved; dist 20
path	32.10,16.60	39.80,20.80	46.70,20.30
path	55.40,30.90	59.40,40.80	54.80,39.90
path	52.90,44.70	57.60,57.60	58.90,67.20
path	57.60,78.90
goldcollect Ironhide Bracers##15639 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to continue farming more parts to the Ironhide Mail Set |confirm
step
label "WS1"
Shardtooth Bears spawn in a small area
You will be provided with 2 locations to farm between
map Winterspring/0
path follow strict; loop; ants curved; dist 20
path	59.60,33.60	58.20,28.80	55.20,30.60
path	53.00,28.40	51.00,30.60	51.60,33.60
goldcollect Ironhide Greaves##15642 |n
You will be directed to the next area to farm the _Ironhide Greaves_ |goto Winterspring/0 51.60,33.60 < 20 |noway |c |next "WS2"
_
Click here to sell |confirm |next "sell"
step
label "WS2"
map Winterspring/0
path follow strict; loop; ants curved; dist 30
path	33.20,57.60	27.00,57.20
This is a rather small path, be sure to search the area for bears
goldcollect Ironhide Greaves##15642 |n
_
Click here to return to farming the _Ironhide Greaves_ at the previous location |confirm |next "WS1"
_
_Click here to move on_ to farming Imposing Leather pieces from Southsea Pirates |confirm
_Click here to sell_ any items you've collected  |confirm |next "sell"
step
label "YETI1"
Follow the path into the cave, killing all Yeti as you come across them |goto Winterspring/0 71.70,51.70 |noway |c |next "YETI2"
You will be able to skin _Thick and Rugged Leathers_ from the yetis |only if skill("Skinning")>=250
map Winterspring/0
path follow loose; loop off; ants curved; dist 20
path	63.00,53.40	65.10,54.50	66.30,56.30
path	67.30,54.40	68.50,54.20	69.30,52.40
path	69.70,53.70	69.50,55.00	70.10,53.70
path	70.80,53.30	71.60,52.90	71.70,51.70
goldcollect Ironhide Belt##15641 |n
goldcollect Ironhide Gauntlets##15644 |n
goldcollect Ironhide Bracers##15639 |n
goldcollect Thick Leather |n |only if skill("Skinning")>=250
goldcollect Rugged Leather |n |only if skill("Skinning")>=250
_Click here to sell_ the items you have collected |confirm |next "sell"
_
_Click here to continue farming_ more parts to the Ironhide Mail Set |confirm  |next "gaunt1"
step
label "YETI2"
You will be able to skin _Thick and Rugged Leathers_ from the yetis |only if skill("Skinning")>=250
map Winterspring/0
path follow loose; loop off; ants curved; dist 20
path	71.70,51.70	71.60,52.90	70.80,53.30
path	70.10,53.70	69.50,55.00	69.70,53.70
path	69.30,52.40	68.50,54.20	67.30,54.40
path	66.30,56.30	65.10,54.50	63.00,53.40
goldcollect Ironhide Belt##15641 |n
goldcollect Ironhide Gauntlets##15644 |n
goldcollect Ironhide Bracers##15639 |n
goldcollect Thick Leather |n |only if skill("Skinning")>=250
goldcollect Rugged Leather |n |only if skill("Skinning")>=250
_Click here to sell_ the items you have collected |confirm |next "sell"
_
_Click here to continue farming_ more parts to the Ironhide Mail Set |confirm
_Click here to farm_ more of the Ice Thisle Yetis |confirm |next "YETI1"
step
label "gaunt1"
map Winterspring/0
path follow smart; loop off; ants curved; dist 25
path	66.20,46.50	66.80,48.40	67.80,50.10
path	69.10,50.60
Defeat the Winterfall enemies in the area
goldcollect Ironhide Gauntlets##15644 |n
Click here to sell the items you have collected |confirm |next "sell"
_
_Click here to continue farming_ more parts to the Ironhide Mail Set |confirm
_Click here_ to continue farming in Winterspring |confirm |next "WS1"
step
label "Twilight1"
Kill Twilight's Hammer enemies at the provided locations:
_Staghelm Point_ located here |goto Silithus/0 69.70,16.60
_Twilight Base Camp_ located here |goto Silithus/0 45.40,41.50
_Twilight Post_ located here |goto Silithus/0 34.00,31.80
_Twilight Outpost_ located here |goto Silithus/0 27.70,75.10
Click the provided locations to toggle between them.
goldcollect Ironhide Pauldrons##15647 |n
goldcollect Ironhide Breastplate##15640 |n
goldcollect Ironhide Legguards##15646 |n
goldcollect Encrypted Twilight Text##20404 |n
goldcollect Runecloth##14047 |n
_Click here to sell_ the items you have collected |confirm |next "sell"
_
_Click here_ to move back to the start of the guide |confirm |next "IH1"
step
label "sell"
#include "auctioneer"
Click here to go back to the start |confirm |next "IH1"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Daily Runs\\Bloodlust Mail Set Transmog",{
meta={goldtype="xmog",levelreq=15,gold=100,time=15,icon="Interface\\ICONS\\inv_chest_chain_07"},
description="\nThis guide will put you on the path to obtaining the Bloodlust Mail Set",
items={{14804,1},{14805,1},{14799,1},{14806,1},{14798,1},{14807,1},{14802,1}},
maps={"Winterspring","Dire Maul","Silithus"},
},[[
step
This guide will point you in the direction to each piece of the Bloodlust Mail armors.
Since they have a very low drop rate, do expect to farm for a bit for these items
confirm always
step
label "OGRE1"
Be sure to kill everything in the dungeon as you go through; Also _reset_ if need be
_Go down_ the ramp|goto Dire Maul/1 69.30,86.80 < 15
_Cross_ through the open area |goto Dire Maul/1 69.30,80.30 < 20
_Go up_ the ramp |goto Dire Maul/1 69.30,69.70 < 15
_Walk around_ the ledge here |goto Dire Maul/1 64.70,68.20 < 20
_Go up_ the ramp |goto Dire Maul/1 58.80,71.20 < 15
_Continue_ up the ramp |goto Dire Maul/1 56.00,78.00 < 20
_Go through_ the doorway |goto Dire Maul/1 40.70,78.10 < 20
_Follow_ the path through the hallway |goto Dire Maul/1 30.10,77.50 < 20
_Go through_ the doorway |goto Dire Maul/1 27.00,68.80 < 20
_Walk around_ the wall |goto Dire Maul/1 25.10,57.10 < 20
_Go up_ the ramp |goto Dire Maul/1 23.30,66.70 < 20
goldcollect Bloodlust Helm##14804 |n
goldcollect Bloodlust Britches##14805 |n
goldcollect Bloodlust Boots##14799 |n
You will now be directed to the next part of Dire Maul |goto Dire Maul/1 23.30,66.70 < 20 |noway |c
_
Click here to sell what you have gathered |confirm |next "sell"
step
_Go up_ the ramp |goto Dire Maul/1 25.40,54.40 < 15
_Go through_ the door |goto Dire Maul/1 28.90,65.70 < 15
_Follow_ the path into the open room |goto Dire Maul/1 31.80,48.90 < 20
Defeat King Gordok |goto Dire Maul/1 31.90,26.90
_
goldcollect Bloodlust Helm##14804 |n
goldcollect Bloodlust Britches##14805 |n
goldcollect Bloodlust Boots##14799 |n
Click here to continue farming in Dire Maul |confirm |next "OGRE1"
_
Click here to continue farming more pieces of the Bloodlust Mail Set |confirm
Click here to sell what you have gathered |confirm |next "sell"
step
label "Twilight1"
Kill Twilight's Hammer enemies at the provided locations:
_Staghelm Point_ located here |goto Silithus/0 69.70,16.60
_Twilight Base Camp_ located here |goto Silithus/0 45.40,41.50
_Twilight Post_ located here |goto Silithus/0 34.00,31.80
_Twilight Outpost_ located here |goto Silithus/0 27.70,75.10
Click the provided locations to toggle between them.
goldcollect Bloodlust Epaulets##14806 |n
goldcollect Bloodlust Breastplate##14798 |n
goldcollect Bloodlust Bracelets##14807 |n
goldcollect Bloodlust Boots##14799 |n
_Click here to sell_ the items you have collected |confirm |next "sell"
_
Click here to move on to farming Yetis |confirm
step
label "YETI1"
Follow the path into the cave, killing all Yeti as you come across them |goto Winterspring/0 71.70,51.70 |noway |c |next "YETI2"
You will be able to skin _Thick and Rugged Leathers_ from the yetis |only if skill("Skinning")>=250
map Winterspring/0
path follow loose; loop off; ants curved; dist 20
path	63.00,53.40	65.10,54.50	66.30,56.30
path	67.30,54.40	68.50,54.20	69.30,52.40
path	69.70,53.70	69.50,55.00	70.10,53.70
path	70.80,53.30	71.60,52.90	71.70,51.70
goldcollect Bloodlust Gauntlets##14802 |n
goldcollect Bloodlust Bracelets##14807 |n
goldcollect Thick Leather |n |only if skill("Skinning")>=250
goldcollect Rugged Leather |n |only if skill("Skinning")>=250
_
_Click here to sell_ the items you have collected |confirm |next "sell"
step
label "YETI2"
Follow the path into the cave, killing all Yeti as you come across them |goto Winterspring/0 63.00,53.40 |noway |c |next "YETI1"
You will be able to skin _Thick and Rugged Leathers_ from the yetis |only if skill("Skinning")>=250
map Winterspring/0
path follow loose; loop off; ants curved; dist 20
path	71.70,51.70	71.60,52.90	70.80,53.30
path	70.10,53.70	69.50,55.00	69.70,53.70
path	69.30,52.40	68.50,54.20	67.30,54.40
path	66.30,56.30	65.10,54.50	63.00,53.40
goldcollect Bloodlust Gauntlets##14802 |n
goldcollect Bloodlust Bracelets##14807 |n
goldcollect Thick Leather |n |only if skill("Skinning")>=250
goldcollect Rugged Leather |n |only if skill("Skinning")>=250
_
_Click here to sell_ the items you have collected |confirm |next "sell"
step
label "sell"
#include "auctioneer"
Click here to go back to the start |confirm |next "OGRE1"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Daily Runs\\Ancient Mail Set Transmog",{
meta={goldtype="xmog",levelreq=15,gold=100,time=15,icon="Interface\\ICONS\\inv_chest_chain_10"},
description="\nThis guide will put you on the path to obtaining the Ancient Mail Set",
items={{15599,1},{15607,1},{15601,1},{15605,1},{15600,1}},
maps={"Zul'Farrak","Dire Maul","Tanaris"},
},[[
step
This guide will point you in the direction to each piece of the Ancient Mail armors.
Since they have a very low drop rate, do expect to farm for a bit for these items
confirm always
step
label "SSP1"
map Tanaris/0
path follow smart; loop off; ants curved; dist 20
path	68.40,42.30	69.90,43.30	71.20,44.60
path	72.20,45.80	72.70,48.50	72.00,49.80
path	69.90,50.70	69.60,52.70	69.10,54.50
path	69.50,57.00
goldcollect Ancient Greaves##15599 |n
goldcollect Ancient Legguards##15607 |n
goldcollect Ancient Chest##15601 |n
You will be routed back to the cave entrance of Southbreak Shore |goto Tanaris/0 69.50,57.00 < 30 |noway |c |or
_
Click here to move onto farming Zul'Farrak |confirm |next "ZF1"
Click here to sell what you have gathered |confirm |next "sell"
step
label "SSP2"
map Tanaris/0
path follow smart; loop off; ants curved; dist 20
path	69.50,57.00	69.10,54.50	69.60,52.70
path	69.90,50.70	72.00,49.80	72.70,48.50
path	72.20,45.80	71.20,44.60	69.90,43.30
path	68.40,42.30
goldcollect Ancient Greaves##15599 |n
goldcollect Ancient Legguards##15607 |n
goldcollect Ancient Chest##15601 |n
Click here to farm Southsea Pirates more |confirm |next "SSP1"
_
Click here to move on to farming Zul'Farrak |confirm
Click here to sell what you have gathered |confirm |next "sell"
step
label "ZF1"
Kill everything inside of Zul'Farrak
Follow the path through Zul'Farrak until you reach the temple area |goto Zul'Farrak/0 24.40,17.60 < 15 |noway |c |or
map Zul'Farrak/0
path follow smart; loop off; ants curved; dist 20
path	57.30,80.80	59.00,67.80	57.30,55.90
path	53.80,47.40	50.70,42.40	46.60,49.20
path	41.20,52.00	36.10,47.20	33.90,44.20
path	30.80,45.10	27.50,39.60	30.60,37.20
path	33.10,38.00	34.80,35.30	34.80,28.50
path	31.90,24.10	28.60,17.80	24.40,17.60
goldcollect Ancient Chest##15601 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to continue farming more parts to the Ancient Mail Set |confirm |next "DM1"
step
Kill everything inside of Zul'Farrak.
Once you have, you will be able to reset the instance.
This step will take you back to the start of the dungeon. _Reset_ if you wish to continue |goto Zul'Farrak/0 57.60,78.90 < 15 |noway |c |or |next "ZF1"
map Zul'Farrak/0
path follow smart; loop off; ants curved; dist 20
path	32.10,16.60	39.80,20.80	46.70,20.30
path	55.40,30.90	59.40,40.80	54.80,39.90
path	52.90,44.70	57.60,57.60	58.90,67.20
path	57.60,78.90
goldcollect Ancient Chest##15601 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to continue farming more parts to the Jade Plate Set |confirm
step
label "DM1"
Be sure to kill everything in the dungeon as you go through; Also reset if need be
_Go down_ the ramp |goto Dire Maul/1 69.30,86.80 < 15
_Cross_ through the open area |goto Dire Maul/1 69.30,80.30 < 20
_Go up_ the ramp |goto Dire Maul/1 69.30,69.70 < 15
_Walk around_ the ledge here |goto Dire Maul/1 64.70,68.20 < 20
_Go up_ the ramp |goto Dire Maul/1 58.80,71.20 < 15
_Continue_ up the ramp |goto Dire Maul/1 56.00,78.00 < 20
_Go through_ the doorway |goto Dire Maul/1 40.70,78.10 < 20
_Follow_ the path through the hallway |goto Dire Maul/1 30.10,77.50 < 20
_Go through_ the doorway |goto Dire Maul/1 27.00,68.80 < 20
_Walk around_ the wall |goto Dire Maul/1 25.10,57.10 < 20
_Go up_ the ramp |goto Dire Maul/1 23.30,66.70 < 20
goldcollect Ancient Greaves##15599 |n
goldcollect Ancient Legguards##15607 |n
You will now be directed to the next part of Dire Maul |goto Dire Maul/1 23.30,66.70 < 20 |noway |c
_
Click here to sell what you have gathered |confirm |next "sell"
step
_Go up_ the ramp |goto Dire Maul/1 25.40,54.40 < 15
_Go through_ the door |goto Dire Maul/1 28.90,65.70 < 15
_Follow_ the path into the open room |goto Dire Maul/1 31.80,48.90 < 20
Defeat King Gordok |goto Dire Maul/1 31.90,26.90
goldcollect Ancient Greaves##15599 |n
goldcollect Ancient Legguards##15607 |n
Click here to continue farming in Dire Maul |confirm |next "DM1"
_
Click here to continue farming more pieces of the Imposing Leather Set |confirm
step
label "DM01"
map Dire Maul/5
path loop off; ants straight; dist 30
path	12.60,39.60	12.40,66.30	12.70,77.90
path	22.90,76.60	31.40,75.40	34.10,26.10
You will now be directed to the next portion of the dungeon |goto Dire Maul/5 34.10,26.10 < 20 |noway |c |or
goldcollect Ancient Gauntlets##15605 |n
goldcollect Ancient Vambraces##15600 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here for an alternative farming route |confirm |next "DME1"
step
label "DM02"
_Enter_ the hallway |goto Dire Maul/5 46.00,26.20 < 20
_Go through_ the hallway |goto Dire Maul/5 54.80,26.80 < 20
_Continue_ through the passage |goto Dire Maul/5 56.40,35.50 < 20
_Exit_ the passage |goto Dire Maul/5 60.80,37.80 < 20
_Go to_ the end of the hallway |goto Dire Maul/5 84.50,37.60 < 20
You will now be directed to the next portion of the dungeon |goto Dire Maul/5 84.50,37.60 < 20 |c |or
goldcollect Ancient Gauntlets##15605 |n
goldcollect Ancient Vambraces##15600 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here for an alternative farming route |confirm |next "DME1"
step
label "DM03"
_Enter_ the hallway |goto Dire Maul/5 58.70,37.70 < 20
_Go up_ the ramp |goto Dire Maul/5 54.00,26.20 < 20
_Go through_ the doorway |goto Dire Maul/5 43.80,29.40 < 20
_Clear all_ the enemies through the room as you go through it |goto Dire Maul/5 38.80,40.90 < 20
Continue through the room |goto Dire Maul/5 38.40,56.40 < 20
_Go up_ the ramp |goto Dire Maul/5 43.90,66.50 < 20
Defeat Lethtendris |goto Dire Maul/5 44.80,52.30
You will now be directed to the next portion of the dungeon  |goto Dire Maul/5 44.80,52.30 < 10 |noway |c |or
goldcollect Ancient Gauntlets##15605 |n
goldcollect Ancient Vambraces##15600 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here for an alternative farming route |confirm |next "DME1"
step
label "DM04"
_Go down_ the ramp |goto Dire Maul/5 46.60,63.50 < 15
_Follow_ the ramp into the room |goto Dire Maul/6 57.50,87.50 < 15
Defeat the _Hydrospawn_ |goto Dire Maul/6 54.30,72.90 |scenariogoal 25059
_Go up_ the ramp |goto Dire Maul/6 57.70,55.50 < 10
_Follow_ the tunnel |goto Dire Maul/6 62.10,59.60 < 5
Defeat _Zevrim Thornhoof_ |goto Dire Maul/6 58.80,72.60 < 4
You will now be directed to the next portion of the dungeon |scenariogoal 25060 |or
goldcollect Ancient Gauntlets##15605 |n
goldcollect Ancient Vambraces##15600 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here for an alternative farming route |confirm |next "DME1"
step
label "DM05"
_Jump down_ the ledge |goto Dire Maul/6 54.60,72.50 < 10
_Go through_ the doorway |goto Dire Maul/6 52.90,87.90 < 15
talk Ironbark the Redeemed##11491
Tell him: _Thank you, Ironbark. We are ready for you to open the door._ |goto Dire Maul/6 41.20,81.00 < 15
_Go through_ the door once Ironbark opens it |goto Dire Maul/6 40.10,49.50
_Leave_ the tunnel |goto Dire Maul/6 45.10,28.90
_Go down_ the ramp |goto Dire Maul/6 50.80,21.90
_Continue_ down the ramp |goto Dire Maul/6 62.40,17.10
_Go down_ the second ramp |goto Dire Maul/6 65.80,28.20
Defeat Alzzin the Wildshaper |goto Dire Maul/6 55.50,28.10
You will now be directed to the next portion of the dungeon |goto Dire Maul/6 55.50,28.10 < 10 |noway |c |or |next "DM01"
goldcollect Ancient Gauntlets##15605 |n
goldcollect Ancient Vambraces##15600 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here for an alternative farming route |confirm |next "DME1"
step
label "DME1"
Go up the ramp |goto Dire Maul/6 67.20,28.10 < 20
Make your way towards the exit |goto Dire Maul/6 58.80,16.40 < 20
_Enter_ the tunnel |goto Dire Maul/6 45.20,28.90 < 15
_Leave_ the tunnel |goto Dire Maul/6 40.10,49.20 < 15
Go through the open room |goto Dire Maul/6 40.60,67.30 < 30
_Enter_ the doorway |goto Dire Maul/6 49.10,91.20 < 15
You will now be directed to the next portion of the dungeon |goto Dire Maul/6 49.10,91.20 |noway |c
_
Click here to sell the items you have collected |confirm |next "sell"
step
label "DME2"
_Enter_ the room |goto Dire Maul/6 54.10,74.80 < 15
_Go around_ the wall |goto Dire Maul/6 57.90,75.20 < 15
_Go up_ the ramp |goto Dire Maul/6 57.80,89.00 < 15
_Enter_ the open room |goto Dire Maul/5 46.80,63.10 < 15
_Go through_ the door |goto Dire Maul/5 43.70,27.80 < 15
_Turn left_ here |goto Dire Maul/5 32.60,26.00 < 15
_Enter_ the tunnel |goto Dire Maul/5 30.10,81.70 < 15
_Leave_ the dungeon |goto Dire Maul/5 27.60,85.20
Click here to continue farming _Dire Maul_ |confirm |next "DME1"
_
Click here to sell the items you have collected |confirm |next "sell"
step
label "sell"
#include "auctioneer"
Click here to go back to the start |confirm |next "SSP1"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Daily Runs\\Imposing Leather Set Transmog",{
meta={goldtype="xmog",levelreq=15,gold=100,time=15,icon="Interface\\ICONS\\inv_chest_leather_05"},
description="\nThis guide will put you on the path to obtaining the Imposing Leather Set",
items={{15167,1},{15164,1},{15166,1},{15168,1},{15162,1}},
maps={"Zul'Farrak","Dire Maul","Winterspring","Tanaris"},
},[[
step
This guide will point you in the direction to each piece of the Imposing armors.
Since they have a very low drop rate, do expect to farm for a bit for these items
confirm always
step
label "WS1"
Shardtooth Bears spawn in a small area
You will be provided with 2 locations to farm between
map Winterspring/0
path follow strict; loop; ants curved; dist 20
path	59.60,33.60	58.20,28.80	55.20,30.60
path	53.00,28.40	51.00,30.60	51.60,33.60
goldcollect Imposing Bandana##15167 |n
You will be directed to the next area to farm the _Imposing Bandana_ |goto Winterspring/0 51.60,33.60 < 20 |noway |c |next "WS2"
_
Click here to sell |confirm |next "sell"
step
label "WS2"
map Winterspring/0
path follow strict; loop; ants curved; dist 30
path	33.20,57.60	27.00,57.20
This is a rather small path, be sure to search the area for bears
goldcollect Imposing Bandana##15167 |n
_
Click here to return to farming the Imposing Bandana at the previous location |confirm |next "WS1"
_
_Click here to move on_ to farming Imposing Leather pieces from Southsea Pirates |confirm
_Click here to sell_ any items you've collected  |confirm |next "sell"
step
label "DM1"
Be sure to kill everything in the dungeon as you go through; Also reset if need be
_Go down_ the ramp|goto Dire Maul/1 69.30,86.80 < 15
_Cross_ through the open area |goto Dire Maul/1 69.30,80.30 < 20
_Go up_ the ramp |goto Dire Maul/1 69.30,69.70 < 15
_Walk around_ the ledge here |goto Dire Maul/1 64.70,68.20 < 20
_Go up_ the ramp |goto Dire Maul/1 58.80,71.20 < 15
_Continue_ up the ramp |goto Dire Maul/1 56.00,78.00 < 20
_Go through_ the doorway |goto Dire Maul/1 40.70,78.10 < 20
_Follow_ the path through the hallway |goto Dire Maul/1 30.10,77.50 < 20
_Go through_ the doorway |goto Dire Maul/1 27.00,68.80 < 20
_Walk around_ the wall |goto Dire Maul/1 25.10,57.10 < 20
_Go up_ the ramp |goto Dire Maul/1 23.30,66.70 < 20
_
You will now be directed to the next part of Dire Maul |goto Dire Maul/1 23.30,66.70 < 20 |noway |c
goldcollect Imposing Vest##15164 |n
goldcollect Imposing Gloves##15166 |n
goldcollect Imposing Pants##15168 |n
goldcollect Imposing Boots##15162 |n
step
_Go up_ the ramp |goto Dire Maul/1 25.40,54.40 < 15
_Go through_ the door |goto Dire Maul/1 28.90,65.70 < 15
_Follow_ the path into the open room |goto Dire Maul/1 31.80,48.90 < 20
Defeat King Gordok |goto Dire Maul/1 31.90,26.90
_
goldcollect Imposing Vest##15164 |n
goldcollect Imposing Gloves##15166 |n
goldcollect Imposing Pants##15168 |n
goldcollect Imposing Boots##15162 |n
Click here to continue farming in Dire Maul |confirm |next "DM1"
_
Click here to continue farming more pieces of the Imposing Leather Set |confirm
step
label "SSP1"
map Tanaris/0
path follow smart; loop off; ants curved; dist 20
path	68.40,42.30	69.90,43.30	71.20,44.60
path	72.20,45.80	72.70,48.50	72.00,49.80
path	69.90,50.70	69.60,52.70	69.10,54.50
path	69.50,57.00
goldcollect Imposing Pants##15168 |n
goldcollect Imposing Gloves##15166 |n
goldcollect Imposing Boots##15162 |n
You will be routed back to the cave entrance of Southbreak Shore |goto Tanaris/0 69.50,57.00 < 30 |noway |c
_
Click here to move onto farming Zul'Farrak |confirm |next "ZF1"
step
label "SSP2"
map Tanaris/0
path follow smart; loop off; ants curved; dist 20
path	69.50,57.00	69.10,54.50	69.60,52.70
path	69.90,50.70	72.00,49.80	72.70,48.50
path	72.20,45.80	71.20,44.60	69.90,43.30
path	68.40,42.30
goldcollect Imposing Pants##15168 |n
goldcollect Imposing Gloves##15166 |n
goldcollect Imposing Boots##15162 |n
Click here to farm Southsea Pirates more |confirm |next "SSP1"
_
Click here to move on to farming Zul'Farrak |confirm
step
label "ZF1"
Kill everything inside of Zul'Farrak
Follow the path through Zul'Farrak until you reach the temple area |goto Zul'Farrak/0 24.40,17.60 < 15 |noway |c
map Zul'Farrak/0
path follow smart; loop off; ants curved; dist 20
path	57.30,80.80	59.00,67.80	57.30,55.90
path	53.80,47.40	50.70,42.40	46.60,49.20
path	41.20,52.00	36.10,47.20	33.90,44.20
path	30.80,45.10	27.50,39.60	30.60,37.20
path	33.10,38.00	34.80,35.30	34.80,28.50
path	31.90,24.10	28.60,17.80	24.40,17.60
goldcollect Imposing Vest##15164 |n
goldcollect Imposing Bandana##15167 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to continue farming more parts to the Jade Plate Set |confirm |next
step
Kill everything inside of Zul'Farrak.
Once you have, you will be able to reset the instance.
This step will take you back to the start of the dungeon. _Reset_ if you wish to continue |goto Zul'Farrak/0 57.60,78.90 < 15 |noway |c
map Zul'Farrak/0
path follow smart; loop off; ants curved; dist 20
path	32.10,16.60	39.80,20.80	46.70,20.30
path	55.40,30.90	59.40,40.80	54.80,39.90
path	52.90,44.70	57.60,57.60	58.90,67.20
path	57.60,78.90
goldcollect Imposing Vest##15164 |n
goldcollect Imposing Bandana##15167 |n
Click here to sell the items you have collected |confirm |next "sell"
_
Click here to continue farming more parts to the Jade Plate Set |confirm
step
label "sell"
#include "auctioneer"
Click here to go back to the start |confirm |next "WS1"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Daily Runs\\Imperial Leather Set Transmog",{
meta={goldtype="xmog",levelreq=20,gold=100,time=15,icon="Interface\\ICONS\\inv_chest_leather_07"},
description="\nThis guide will put you on the path to obtaining the Imperial Leather Set",
items={{6433,1},{4737,1},{6430,1},{4063,1},{4062,1},{6431,1},{14047,1},{4338,1},{12811,1},{4738,1}},
maps={"Stratholme","Eastern Plaguelands"},
},[[
step
label "begin"
This guide will point you in the direction to each piece of the Imperial Leather armor.
Since they have a very low drop rate, do expect to farm for a bit for these items
confirm always
step
label "Strath1"
_Follow_ the path through King's Square |goto Stratholme/1 66.30,75.60 < 20
_Continue_ along the streets of King's Square |goto Stratholme/1 67.30,59.30 < 20
_Turn left_ here |goto Stratholme/1 60.00,55.00 < 20
_Defeat_ the enemies in the area |goto Stratholme/1 57.10,66.10 < 20
goldcollect Imperial Leather Helm##6433	|n
goldcollect Imperial Leather Spaulder##4737 |n
goldcollect Imperial Leather Breastplate##6430 |n
goldcollect Imperial Leather Glove##4063 |n
goldcollect Imperial Leather Pants##4062 |n
goldcollect Imperial Leather Boots##6431 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Stratholme/1 57.10,66.10 < 20 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Make your way_ through the gate to Market Row |goto Stratholme/1 60.00,41.90 < 15
|tip You will be trapped. Defeat the enemies who come
_Continue through_ Market Row |goto Stratholme/1 59.40,31.10 < 20
_Go through_ the large gates into Crusaders' Square |goto Stratholme/1 46.60,25.10 < 20
_Enter_ the Scarlet Bastion |goto Stratholme/1 32.00,34.70 < 20
_Go through_ the door to The Hoard |goto Stratholme/1 19.80,51.20 < 10
goldcollect Imperial Leather Helm##6433	|n
goldcollect Imperial Leather Spaulder##4737 |n
goldcollect Imperial Leather Breastplate##6430 |n
goldcollect Imperial Leather Glove##4063 |n
goldcollect Imperial Leather Pants##4062 |n
goldcollect Imperial Leather Boots##6431 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Stratholme/1 19.80,51.20 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Make your way_ through the Hoard and defeat Willey Hopebreaker |goto Stratholme/1 4.10,50.80
goldcollect Imperial Leather Helm##6433	|n
goldcollect Imperial Leather Spaulder##4737 |n
goldcollect Imperial Leather Breastplate##6430 |n
goldcollect Imperial Leather Glove##4063 |n
goldcollect Imperial Leather Pants##4062 |n
goldcollect Imperial Leather Boots##6431 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Stratholme/1 4.10,50.80 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Leave_ The Hoard |goto Stratholme/1 19.10,52.10 < 20
_Go through_ the doors |goto Stratholme/1 19.10,52.10 < 20
_Defeat_ Balnazzar |goto Stratholme/1 20.30,82.00 < 20
goldcollect Imperial Leather Helm##6433	|n
goldcollect Imperial Leather Spaulder##4737 |n
goldcollect Imperial Leather Breastplate##6430 |n
goldcollect Imperial Leather Glove##4063 |n
goldcollect Imperial Leather Pants##4062 |n
goldcollect Imperial Leather Boots##6431 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Stratholme/1 20.30,82.00 < 20 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Leave_ the Scarlet Bastion |goto Stratholme/1 32.20,34.40 < 20
_Go through_ the gate and travel through Market Row |goto Stratholme/1 50.60,23.70 < 20
_Continue through_ Market Row |goto Stratholme/1 61.30,29.70 < 20
_Cross under_ the bridge |goto Stratholme/1 77.30,18.80 < 20
_Go through_ Festival Lane |goto Stratholme/1 82.20,24.70 < 20
_Continue through_ the area |goto Stratholme/1 81.60,42.80 < 20
_Go through_ the Stratholme Gates |goto Stratholme/1 77.20,49.40 < 20
_Continue through_ the gates |goto Stratholme/1 73.10,55.20 < 20
_Leave_ Stratholme |goto Eastern Plaguelands/0 27.80,11.60
goldcollect Imperial Leather Helm##6433	|n
goldcollect Imperial Leather Spaulder##4737 |n
goldcollect Imperial Leather Breastplate##6430 |n
goldcollect Imperial Leather Glove##4063 |n
goldcollect Imperial Leather Pants##4062 |n
goldcollect Imperial Leather Boots##6431 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Eastern Plaguelands/0 27.80,11.60 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Go through_ the gate |goto Eastern Plaguelands/0 43.50,19.20 < 20
_Go through_ the Service Entrance Gate |goto Stratholme/2 67.50,80.80 < 20
_Make your way_ through the gates |goto Stratholme/2 61.40,58.30 < 20
_Turn left_ when you reach this area |goto Stratholme/2 67.40,51.80 < 20
_Defeat_ Nerub'enkan |goto Stratholme/2 56.50,46.80 < 20
_Defeat_ the Thuzadin Acolytes inside the building |goto Stratholme/2 53.50,49.20 < 20
goldcollect Imperial Leather Helm##6433	|n
goldcollect Imperial Leather Spaulder##4737 |n
goldcollect Imperial Leather Breastplate##6430 |n
goldcollect Imperial Leather Glove##4063 |n
goldcollect Imperial Leather Pants##4062 |n
goldcollect Imperial Leather Boots##6431 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Stratholme/2 53.50,49.20 < 5 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Back track_ to the fork in the road here |goto Stratholme/2 66.00,51.40 < 20
_Defeat_ Baroness Anastari |goto Stratholme/2 74.80,46.80
_Defeat_ the Thuzadin Acolytes inside the building |goto Stratholme/2 78.00,48.00
goldcollect Imperial Leather Helm##6433	|n
goldcollect Imperial Leather Spaulder##4737 |n
goldcollect Imperial Leather Breastplate##6430 |n
goldcollect Imperial Leather Glove##4063 |n
goldcollect Imperial Leather Pants##4062 |n
goldcollect Imperial Leather Boots##6431 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Stratholme/2 78.00,48.00 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Pass through_ the alleyway |goto Stratholme/2 68.60,34.60 < 20
_Defeat_ Maleki the Pallid |goto Stratholme/2 67.90,20.40 < 20
_Defeat_ the Thuzadin Acolytes inside the building |goto Stratholme/2 70.00,16.80 < 20
goldcollect Imperial Leather Helm##6433	|n
goldcollect Imperial Leather Spaulder##4737 |n
goldcollect Imperial Leather Breastplate##6430 |n
goldcollect Imperial Leather Glove##4063 |n
goldcollect Imperial Leather Pants##4062 |n
goldcollect Imperial Leather Boots##6431 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Stratholme/2 70.00,16.80 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Make your way_ through |goto Stratholme/2 62.10,25.10
_Defeat_ Magistrate Barthilas |goto Stratholme/2 57.10,14.60
_Pass through_ the gates to Slaughter Square |goto Stratholme/2 51.40,19.50 < 20
_Defeat_ the Venom Belchers, Bile Spewers, Ramstein the Gorger, the horde of zombies that flood the room and finally the Black Guard |goto Stratholme/2 45.50,19.60
_Defeat_ Lord Aurius Rivendare |goto Stratholme/2 38.30,20.20 |noway |c
goldcollect Imperial Leather Helm##6433	|n
goldcollect Imperial Leather Spaulder##4737 |n
goldcollect Imperial Leather Breastplate##6430 |n
goldcollect Imperial Leather Glove##4063 |n
goldcollect Imperial Leather Pants##4062 |n
goldcollect Imperial Leather Boots##6431 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
_
Click here if you are ready to sell |confirm |next "sell"
step
_Leave_ the Slaughter House |goto Stratholme/2 42.90,20.40 < 20
_Leave_ the Slaughter Square |goto Stratholme/2 53.10,19.10 < 20
_Make your way_ through the gauntlet |goto Stratholme/2 59.50,29.30 < 20
_Go through_ the gate |goto Stratholme/2 58.00,37.30 < 20
_Head towards_ the gates |goto Stratholme/2 66.50,53.30 < 20
_Pass through_ the gates |goto Stratholme/2 61.50,58.40 < 20
_Leave_ Stratholme |goto Stratholme/2 67.30,86.60 < 20
goldcollect Imperial Leather Helm##6433	|n
goldcollect Imperial Leather Spaulder##4737 |n
goldcollect Imperial Leather Breastplate##6430 |n
goldcollect Imperial Leather Glove##4063 |n
goldcollect Imperial Leather Pants##4062 |n
goldcollect Imperial Leather Boots##6431 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
_
If you wish to return to farming Stratholme, _reset the instance, then click here_ |confirm |next "Strath1"
_Click here to sell_ any items you have |confirm |next "sell"
_Click here_ if you want _to continue farming for more_ Imperial Leather Armor |confirm
step
label "bleh"
map Eastern Plaguelands/0
path	59.70,63.20	63.70,67.90	66.30,69.30
path	69.80,67.80	72.40,66.00	73.20,61.90
path	70.50,59.70	68.80,63.00	66.00,63.00
path	62.70,63.10	59.60,59.70
Kill the Carrion Grub around and inside of the provide path
Eastern Plaguelands; Carrion Grub, Infected Mossflayer, Scarlet Warder
goldcollect Imperial Leather Belt##4738
_Click here to sell_ any items you have |confirm |next "sell"
step
label "sell"
#include "auctioneer"
Click here to go back to the start of the guide |confirm |next "Strath1"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Daily Runs\\Bonechewer Leather Set Transmog",{
meta={goldtype="xmog",levelreq=10,gold=100,time=15,icon="Interface\\ICONS\\inv_chest_leather_07"},
description="\nThis guide will put you on the path to obtaining the Bonechewer Leather Set",
items={{24697,1},{24695,1},{24700,1},{24696,1},{24693,1},{24698,1},{24694,1},{14047,1},{21877,1},{24944,1},{24942,1},{24943,1},{24945,1},{24947,1},{24949,1}},
maps={"Hellfire Ramparts","The Blood Furnace"},
},[[
step
This guide will point you in the direction to each piece of the Bonechewer Leather armors.
Since they have a very low drop rate, do expect to farm for a bit for these items
confirm always
step
label "HR1"
|tip Be sure to set the dungeon difficulty to normal
_Cross_ the bridge |goto Hellfire Ramparts/1 47.10,64.80 < 25
_Go around_ the wall |goto Hellfire Ramparts/1 46.80,52.10 < 25
_Continue_ around the wall |goto Hellfire Ramparts/1 60.60,51.10 < 20
_Enter_ the open room |goto Hellfire Ramparts/1 74.00,48.40 < 25
Defeat Watchkeeper Gargolmar |goto Hellfire Ramparts/1 71.00,30.80
goldcollect Bonechewer Skincloak##24697 |n
goldcollect Bonechewer Chestpiece##24695 |n
goldcollect Bonechewer Bands##24700 |n
goldcollect Bonechewer Spikegloves##24696 |n
goldcollect Bonechewer Pelt-Girdle##24693 |n
goldcollect Bonechewer Ripleggings##24698 |n
goldcollect Bonechewer Shredboots##24694 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Netherweave Cloth##21877 |n
Once you reach the ogre room, you will be directed to the next section of farming |goto Hellfire Ramparts/1 71.00,30.80 < 10 |noway |c
_
Click here if you want to sell what you have |confirm |next "sell"
step
map Hellfire Ramparts/1
path follow strict; loop off; ants curved; dist 20
path	64.90,40.20	69.20,41.60	63.90,44.80
path	50.00,52.20	40.10,22.80
Defeat Omor the Unscarred |goto Hellfire Ramparts/1 40.10,22.80 < 20
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Belt##24942 |n
goldcollect Bloodscale Sabatons##24943 |n
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Gauntlets##24945 |n
goldcollect Bloodscale Legguards##24947 |n
goldcollect Bloodscale Bracers##24949 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Netherweave Cloth##21877 |n
Once you reach the ogre room, you will be directed to the next section of farming |goto Hellfire Ramparts/1 40.10,22.80 < 20 |noway |c
_
Click here if you want to sell what you have |confirm |next "sell"
step
_Go through_ the doorway |goto Hellfire Ramparts/1 45.10,37.40 < 30
_Go down_ the bridge |goto Hellfire Ramparts/1 48.40,62.40 < 30
_Enter_ the empty room |goto Hellfire Ramparts/1 37.10,78.80
Defeat Nazan and Vazruden
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Belt##24942 |n
goldcollect Bloodscale Sabatons##24943 |n
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Gauntlets##24945 |n
goldcollect Bloodscale Legguards##24947 |n
goldcollect Bloodscale Bracers##24949 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Netherweave Cloth##21877 |n
Once you reach the ogre room, you will be directed to the next section of farming |goto Hellfire Ramparts/1 37.10,78.80 < 20
_
Click here if you want to sell what you have |confirm |next "sell"
step
label "BF1"
_Go up_ the stairs |goto The Blood Furnace/1 58.30,82.50 < 30
_Go into_ the doorway |goto The Blood Furnace/1 58.20,60.10 < 20
_Follow_ the path to the left |goto The Blood Furnace/1 55.50,53.90 < 20
_Enter_ the open room |goto The Blood Furnace/1 46.10,41.20 < 20
Defeat The Maker |goto The Blood Furnace/1 37.10,41.20
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Belt##24942 |n
goldcollect Bloodscale Sabatons##24943 |n
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Gauntlets##24945 |n
goldcollect Bloodscale Legguards##24947 |n
goldcollect Bloodscale Bracers##24949 |n
_Secondary Items:_
goldcollect Netherweave Cloth##21877
Once you reach the ogre room, you will be directed to the next section of farming |goto The Blood Furnace/1 37.10,41.20 < 20 |noway |c
_
Click here if you want to sell what you have |confirm |next "sell"
step
_Enter_ the path |goto The Blood Furnace/1 31.80,42.30 < 20
_Leave_ the tunnel |goto The Blood Furnace/1 32.10,21.60 < 20
Click the Cell Door Lever |goto The Blood Furnace/1 43.30,22.00 < 15
Defeat Broggok
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Belt##24942 |n
goldcollect Bloodscale Sabatons##24943 |n
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Gauntlets##24945 |n
goldcollect Bloodscale Legguards##24947 |n
goldcollect Bloodscale Bracers##24949 |n
_Secondary Items:_
goldcollect Netherweave Cloth##21877
Once you reach the ogre room, you will be directed to the next section of farming |goto The Blood Furnace/1 43.30,22.00 < 15 |noway |c
_
Click here if you want to sell what you have |confirm |next "sell"
step
_Enter_ the doorway |goto The Blood Furnace/1 47.50,22.00 < 20
_Go through_ the doorway on the right |goto The Blood Furnace/1 58.10,22.20 < 20
_Go down_ the ramp |goto The Blood Furnace/1 62.00,28.70 < 20
_Enter_ the room |goto The Blood Furnace/1 65.80,41.30 < 20
Defeat Keli'dan the Breaker |goto The Blood Furnace/1 58.20,42.00
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Belt##24942 |n
goldcollect Bloodscale Sabatons##24943 |n
goldcollect Bloodscale Breastplate##24944 |n
goldcollect Bloodscale Gauntlets##24945 |n
goldcollect Bloodscale Legguards##24947 |n
goldcollect Bloodscale Bracers##24949 |n
_Secondary Items:_
goldcollect Netherweave Cloth##21877
Once you reach the ogre room, you will be directed to the next section of farming |goto The Blood Furnace/1 58.20,42.00  < 15 |noway |c
_
Click here if you want to sell what you have |confirm |next "sell"
step
_Enter_ the tunnel |goto The Blood Furnace/1 62.50,50.60 < 20
_Exit_ the tunnel |goto The Blood Furnace/1 61.10,90.60 < 20
_Leave_ the dungeon |goto The Blood Furnace/1 47.80,90.60 < 20
_
Click here to continue farming the Hellfire Ramparts |confirm |next "HR1"
Click here to continue farming the Blood Furnace |confirm |next "BF1"
_
Click here if you wish to sell |confirm
step
label "sell"
#include "auctioneer"
Click here to go back to the start |confirm |next "HR1"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Daily Runs\\Arachnidian Cloth Set Transmog",{
meta={goldtype="xmog",levelreq=15,gold=100,time=15,icon="Interface\\ICONS\\inv_chest_cloth_35"},
description="\nThis guide will put you on the path to obtaining the Arachnidian Cloth Set",
items={{14296,1},{14289,1},{14290,1},{4304,1},{8170,1},{14288,1},{14295,1},{20404,1},{14047,1},{14291,1},{14294,1}},
maps={"Zul'Farrak","Winterspring","Silithus"},
},[[
step
This guide will point you in the direction to each piece of the Arachnidian Cloth armors.
Since they have a very low drop rate, do expect to farm for a bit for these items
confirm always
step
label "Pauldron1"
Follow the path into the cave, killing all Yeti as you come across them |goto Winterspring/0 71.70,51.70 |noway |c |next "Pauldron2"
You will be able to skin _Thick and Rugged Leathers_ from the yetis |only if skill("Skinning")>=250
map Winterspring/0
path follow loose; loop off; ants curved; dist 20
path	63.00,53.40	65.10,54.50	66.30,56.30
path	67.30,54.40	68.50,54.20	69.30,52.40
path	69.70,53.70	69.50,55.00	70.10,53.70
path	70.80,53.30	71.60,52.90	71.70,51.70
goldcollect Arachnidian Pauldrons##14296 |n
goldcollect Arachnidian Girdle##14289 |n
goldcollect Arachnidian Footpads##14290 |n
goldcollect Thick Leather##4304 |n |only if skill("Skinning")>=250
goldcollect Rugged Leather##8170 |n |only if skill("Skinning")>=250
_Click here to sell_ the items you have collected |confirm |next "sell"
_
_Click here to continue farming_ more parts to the Arachnidian Cloth Set |confirm |next "BEAR1"
step
label "Pauldron2"
Follow the path into the cave, killing all Yeti as you come across them |goto Winterspring/0 63.00,53.40 |noway |c |next "Pauldron3"
You will be able to skin _Thick and Rugged Leathers_ from the yetis |only if skill("Skinning")>=250
map Winterspring/0
path follow loose; loop off; ants curved; dist 20
path	71.70,51.70	71.60,52.90	70.80,53.30
path	70.10,53.70	69.50,55.00	69.70,53.70
path	69.30,52.40	68.50,54.20	67.30,54.40
path	66.30,56.30	65.10,54.50	63.00,53.40
goldcollect Arachnidian Pauldrons##14296|n
goldcollect Arachnidian Girdle##14289 |n
goldcollect Arachnidian Footpads##14290 |n
goldcollect Thick Leather##4304 |n |only if skill("Skinning")>=250
goldcollect Rugged Leather##8170 |n |only if skill("Skinning")>=250
_Click here to sell_ the items you have collected |confirm |next "sell"
_
_Click here to continue farming_ more parts to the Arachnidian Cloth Set |confirm |next "BEAR1"
step
label "Pauldron3"
map Winterspring/0
path follow smart; loop; ants curved; dist 30
path	46.50,28.70	46.40,24.10	45.90,14.90
path	48.70,16.40	49.30,19.50	51.40,19.80
path	51.00,24.00
Defeat Frostsabers along the path
goldcollect Arachnidian Pauldrons##14296|n
goldcollect Thick Leather##4304 |n |only if skill("Skinning")>=250
goldcollect Rugged Leather##8170 |n |only if skill("Skinning")>=250
_Click here to sell_ the items you have collected |confirm |next "sell"
_
_Click here to continue farming_ more parts to the Arachnidian Cloth Set |confirm
_Click here_ to go back to _Yeti Farming_ |confirm |next "Pauldron1"
step
label "BEAR1"
Shardtooth Bears spawn in a small area
You will be provided with 2 locations to farm between
map Winterspring/0
path follow loose; loop off; ants curved; dist 30
path	59.60,33.60	58.20,28.80	55.20,30.60
path	53.00,28.40	51.00,30.60	51.60,33.60
goldcollect Arachnidian Girdle##14289 |n
goldcollect Arachnidian Footpads##14290 |n
You will be directed to the next area to farm the Arachnidian Girdle and Footpads |goto Winterspring/0 51.60,33.60 < 20 |noway |c
_
Click here to sell |confirm |next "sell"
step
label "BEAR2"
map Winterspring/0
path follow loose; loop; ants curved; dist 50
path	33.20,57.60	27.00,57.20
This is a rather small path, be sure to search the area for bears
goldcollect Arachnidian Girdle##14289 |n
goldcollect Arachnidian Footpads##14290 |n
_Click here to return to farming_ the Arachnidian Girdle and Footpads at the previous location |confirm |next "BEAR1"
_
_Click here to move on_ to farming Arachnidian Cloth pieces from Twilight enemies |confirm
Click here to sell |confirm |next "sell"
step
label "Twilight1"
Kill Twilight's Hammer enemies at the provided locations:
_Staghelm Point_ located here |goto Silithus/0 69.70,16.60
_Twilight Base Camp_ located here |goto Silithus/0 45.40,41.50
_Twilight Post_ located here |goto Silithus/0 34.00,31.80
_Twilight Outpost_ located here |goto Silithus/0 27.70,75.10
Click the provided locations to toggle between them.
goldcollect Arachnidian Armor##14288 |n
goldcollect Arachnidian Legguards##14295 |n
goldcollect Encrypted Twilight Text##20404 |n
goldcollect Runecloth##14047 |n
_Click here to sell_ the items you have collected |confirm |next "sell"
_
_Click here to move on_ to farming Arachnidian Cloth pieces from the Zul'Farrak dungeon |confirm
step
label "ZF1"
Kill everything inside of Zul'Farrak
Follow the path through Zul'Farrak until you reach the temple area |goto Zul'Farrak/0 24.40,17.60 < 15 |noway |c
map Zul'Farrak/0
path follow smart; loop off; ants curved; dist 20
path	57.30,80.80	59.00,67.80	57.30,55.90
path	53.80,47.40	50.70,42.40	46.60,49.20
path	41.20,52.00	36.10,47.20	33.90,44.20
path	30.80,45.10	27.50,39.60	30.60,37.20
path	33.10,38.00	34.80,35.30	34.80,28.50
path	31.90,24.10	28.60,17.80	24.40,17.60
goldcollect Arachnidian Bracelets##14291 |n
goldcollect Arachnidian Gloves##14294 |n
_Click here to sell_ the items you have collected |confirm |next "sell"
_
_Click here to continue farming_ more parts to the Arachnidian Cloth Set |confirm |next "WF1e"
step
label "ZF2"
Kill everything inside of Zul'Farrak.
Once you have, you will be able to reset the instance.
This step will take you back to the start of the dungeon. _Reset_ if you wish to continue |goto Zul'Farrak/0 57.60,78.90 < 15 |noway |c
map Zul'Farrak/0
path follow smart; loop off; ants curved; dist 20
path	32.10,16.60	39.80,20.80	46.70,20.30
path	55.40,30.90	59.40,40.80	54.80,39.90
path	52.90,44.70	57.60,57.60	58.90,67.20
path	57.60,78.90
goldcollect Arachnidian Bracelets##14291 |n
goldcollect Arachnidian Gloves##14294 |n
Click here to sell the items you have collected |confirm |next "sell"
step
label "WF1e"
map Winterspring/0
path follow smart; loop off; ants curved; dist 25
path	66.20,46.50	66.80,48.40	67.80,50.10
path	69.10,50.60
Defeat the Winterfall enemies in the area
goldcollect Arachnidian Girdle##14289 |n
goldcollect Arachnidian Footpads##14290 |n
Click here to sell the items you have collected |confirm |next "sell"
step
label "sell"
#include "auctioneer"
Click here to go back to the start |confirm |next "Pauldron1"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Daily Runs\\Hibernal Cloth Set Transmog",{
meta={goldtype="xmog",levelreq=20,gold=100,time=15,icon="Interface\\ICONS\\inv_shirt_06"},
description="\nThis guide will put you on the path to obtaining the Hibernal Cloth Set",
items={{8115,1},{8111,1},{8108,1},{8110,1},{8114,1},{8112,1},{8107,1},{14047,1},{4338,1},{12811,1},{8106,1},{12208,1},{12203,1}},
maps={"Stratholme","Burning Steppes","Eastern Plaguelands","Blackrock Depths"},
},[[
step
This guide will point you in the direction to each piece of the Hibernal Cloth armors.
Since they have a very low drop rate, do expect to farm for a bit for these items
confirm always
step
label "Strath1"
_Follow_ the path through King's Square |goto Stratholme/1 66.30,75.60 < 20
_Continue_ along the streets of King's Square |goto Stratholme/1 67.30,59.30 < 20
_Turn left_ here |goto Stratholme/1 60.00,55.00 < 20
_Defeat_ the enemies in the area |goto Stratholme/1 57.10,66.10 < 20
goldcollect Hibernal Cowl##8115 |n
goldcollect Hibernal Mantle##8111 |n
goldcollect Hibernal Bracers##8108 |n
goldcollect Hibernal Gloves##8110 |n
goldcollect Hibernal Sash##8114 |n
goldcollect Hibernal Pants##8112 |n
goldcollect Hibernal Boots##8107 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Stratholme/1 57.10,66.10 < 20 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Make your way_ through the gate to Market Row |goto Stratholme/1 60.00,41.90 < 15
|tip You will be trapped. Defeat the enemies who come
_Continue through_ Market Row |goto Stratholme/1 59.40,31.10 < 20
_Go through_ the large gates into Crusaders' Square |goto Stratholme/1 46.60,25.10 < 20
_Enter_ the Scarlet Bastion |goto Stratholme/1 32.00,34.70 < 20
_Go through_ the door to The Hoard |goto Stratholme/1 19.80,51.20 < 10
goldcollect Hibernal Cowl##8115 |n
goldcollect Hibernal Mantle##8111 |n
goldcollect Hibernal Bracers##8108 |n
goldcollect Hibernal Gloves##8110 |n
goldcollect Hibernal Sash##8114 |n
goldcollect Hibernal Pants##8112 |n
goldcollect Hibernal Boots##8107 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Stratholme/1 19.80,51.20 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Make your way_ through the Hoard and defeat Willey Hopebreaker |goto Stratholme/1 4.10,50.80
goldcollect Runecloth##14047 |n
goldcollect Hibernal Cowl##8115 |n
goldcollect Hibernal Mantle##8111 |n
goldcollect Hibernal Bracers##8108 |n
goldcollect Hibernal Gloves##8110 |n
goldcollect Hibernal Sash##8114 |n
goldcollect Hibernal Pants##8112 |n
goldcollect Hibernal Boots##8107 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Stratholme/1 4.10,50.80 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Leave_ The Hoard |goto Stratholme/1 19.10,52.10 < 20
_Go through_ the doors |goto Stratholme/1 19.10,52.10 < 20
_Defeat_ Balnazzar |goto Stratholme/1 20.30,82.00 < 20
goldcollect Hibernal Cowl##8115 |n
goldcollect Hibernal Mantle##8111 |n
goldcollect Hibernal Bracers##8108 |n
goldcollect Hibernal Gloves##8110 |n
goldcollect Hibernal Sash##8114 |n
goldcollect Hibernal Pants##8112 |n
goldcollect Hibernal Boots##8107 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Stratholme/1 20.30,82.00 < 20 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Leave_ the Scarlet Bastion |goto Stratholme/1 32.20,34.40 < 20
_Go through_ the gate and travel through Market Row |goto Stratholme/1 50.60,23.70 < 20
_Continue through_ Market Row |goto Stratholme/1 61.30,29.70 < 20
_Cross under_ the bridge |goto Stratholme/1 77.30,18.80 < 20
_Go through_ Festival Lane |goto Stratholme/1 82.20,24.70 < 20
_Continue through_ the area |goto Stratholme/1 81.60,42.80 < 20
_Go through_ the Stratholme Gates |goto Stratholme/1 77.20,49.40 < 20
_Continue through_ the gates |goto Stratholme/1 73.10,55.20 < 20
_Leave_ Stratholme |goto Eastern Plaguelands/0 27.80,11.60
goldcollect Hibernal Cowl##8115 |n
goldcollect Hibernal Mantle##8111 |n
goldcollect Hibernal Bracers##8108 |n
goldcollect Hibernal Gloves##8110 |n
goldcollect Hibernal Sash##8114 |n
goldcollect Hibernal Pants##8112 |n
goldcollect Hibernal Boots##8107 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Eastern Plaguelands/0 27.80,11.60 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Go through_ the gate |goto Eastern Plaguelands/0 43.50,19.20 < 20
_Go through_ the Service Entrance Gate |goto Stratholme/2 67.50,80.80 < 20
_Make your way_ through the gates |goto Stratholme/2 61.40,58.30 < 20
_Turn left_ when you reach this area |goto Stratholme/2 67.40,51.80 < 20
_Defeat_ Nerub'enkan |goto Stratholme/2 56.50,46.80 < 20
_Defeat_ the Thuzadin Acolytes inside the building |goto Stratholme/2 53.50,49.20 < 20
goldcollect Hibernal Cowl##8115 |n
goldcollect Hibernal Mantle##8111 |n
goldcollect Hibernal Bracers##8108 |n
goldcollect Hibernal Gloves##8110 |n
goldcollect Hibernal Sash##8114 |n
goldcollect Hibernal Pants##8112 |n
goldcollect Hibernal Boots##8107 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Stratholme/2 53.50,49.20 < 5 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Back track_ to the fork in the road here |goto Stratholme/2 66.00,51.40 < 20
_Defeat_ Baroness Anastari |goto Stratholme/2 74.80,46.80
_Defeat_ the Thuzadin Acolytes inside the building |goto Stratholme/2 78.00,48.00
goldcollect Hibernal Cowl##8115 |n
goldcollect Hibernal Mantle##8111 |n
goldcollect Hibernal Bracers##8108 |n
goldcollect Hibernal Gloves##8110 |n
goldcollect Hibernal Sash##8114 |n
goldcollect Hibernal Pants##8112 |n
goldcollect Hibernal Boots##8107 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Stratholme/2 78.00,48.00 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Pass through_ the alleyway |goto Stratholme/2 68.60,34.60 < 20
_Defeat_ Maleki the Pallid |goto Stratholme/2 67.90,20.40 < 20
_Defeat_ the Thuzadin Acolytes inside the building |goto Stratholme/2 70.00,16.80 < 20
goldcollect Hibernal Cowl##8115 |n
goldcollect Hibernal Mantle##8111 |n
goldcollect Hibernal Bracers##8108 |n
goldcollect Hibernal Gloves##8110 |n
goldcollect Hibernal Sash##8114 |n
goldcollect Hibernal Pants##8112 |n
goldcollect Hibernal Boots##8107 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
You will now be directed to the next section of the guide |goto Stratholme/2 70.00,16.80 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Make your way_ through |goto Stratholme/2 62.10,25.10
_Defeat_ Magistrate Barthilas |goto Stratholme/2 57.10,14.60
_Pass through_ the gates to Slaughter Square |goto Stratholme/2 51.40,19.50 < 20
_Defeat_ the Venom Belchers, Bile Spewers, Ramstein the Gorger, the horde of zombies that flood the room and finally the Black Guard |goto Stratholme/2 45.50,19.60
_Defeat_ Lord Aurius Rivendare |goto Stratholme/2 38.30,20.20 |noway |c
goldcollect Hibernal Cowl##8115 |n
goldcollect Hibernal Mantle##8111 |n
goldcollect Hibernal Bracers##8108 |n
goldcollect Hibernal Gloves##8110 |n
goldcollect Hibernal Sash##8114 |n
goldcollect Hibernal Pants##8112 |n
goldcollect Hibernal Boots##8107 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
_
Click here if you are ready to sell |confirm |next "sell"
step
_Leave_ the Slaughter House |goto Stratholme/2 42.90,20.40 < 20
_Leave_ the Slaughter Square |goto Stratholme/2 53.10,19.10 < 20
_Make your way_ through the gauntlet |goto Stratholme/2 59.50,29.30 < 20
_Go through_ the gate |goto Stratholme/2 58.00,37.30 < 20
_Head towards_ the gates |goto Stratholme/2 66.50,53.30 < 20
_Pass through_ the gates |goto Stratholme/2 61.50,58.40 < 20
_Leave_ Stratholme |goto Stratholme/2 67.30,86.60 < 20
goldcollect Hibernal Cowl##8115 |n
goldcollect Hibernal Mantle##8111 |n
goldcollect Hibernal Bracers##8108 |n
goldcollect Hibernal Gloves##8110 |n
goldcollect Hibernal Sash##8114 |n
goldcollect Hibernal Pants##8112 |n
goldcollect Hibernal Boots##8107 |n
_Secondary Items:_
goldcollect Runecloth##14047 |n
goldcollect Mageweave Cloth##4338 |n
goldcollect Righteous Orb##12811 |n
_
If you wish to return to farming Stratholme, _reset the instance, then click here_ |confirm |next "Strath1"
_Click here to sell_ any items you have |confirm |next "sell"
_Click here_ if you want _to continue farming for more_ Hibernal Armor |confirm
step
label "BRD1"
_Follow_ the path into the open area |goto Blackrock Depths/1 39.20,75.60
_Enter_ the stone tunnel |goto Blackrock Depths/1 45.00,78.80
_Go down_ the path |goto Blackrock Depths/1 46.70,88.80 |tip Clear the side rooms
_Defeat_ High Interrogator Gerstahn |goto Blackrock Depths/1 47.50,93.10
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
You will now be directed to the next section of the guide |goto Blackrock Depths/1 47.50,93.10 < 20 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Make your way_ through the door |goto Blackrock Depths/1 48.30,97.80 < 20
_Follow_ the curved path |goto Blackrock Depths/1 51.70,92.00 < 20
_Continue_ along the path |goto Blackrock Depths/1 51.40,84.90 < 20
_Move into_ the open room |goto Blackrock Depths/1 47.10,77.50 < 20
_Make your way_ into the corridor |goto Blackrock Depths/1 45.60,67.30 < 20
_Follow_ the path down |goto Blackrock Depths/1 47.60,58.60 < 20
_Turn right_ into the room here |goto Blackrock Depths/1 54.40,59.00 < 20
_Defeat_ Houndmaster Grebmar |goto Blackrock Depths/1 51.50,62.20 < 20
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
You will now be directed to the next section of the guide |goto Blackrock Depths/1 51.50,62.20 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Leave_ the room |goto Blackrock Depths/1 54.80,59.30
_Make your way_ through the tunnel |goto Blackrock Depths/1 55.70,68.00
_Exit_ the tunnel into the open room |goto Blackrock Depths/1 48.10,72.50
_Go through_ the door |goto Blackrock Depths/1 37.80,66.00
_Go down_ to the path |goto Blackrock Depths/1 34.90,60.30
_Defeat_ Bael'Gar |goto Blackrock Depths/1 25.00,52.70
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
You will now be directed to the next section of the guide |goto Blackrock Depths/1 25.00,52.70 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Follow_ the path |goto Blackrock Depths/1 28.40,56.20
_Make your way_ towards the giant gates |goto Blackrock Depths/1 36.80,59.60
_Go through_ the gate |goto Blackrock Depths/1 44.40,50.00
_Defeat_ Lord Incendius |goto Blackrock Depths/1 56.50,31.40
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
You will now be directed to the next section of the guide |goto Blackrock Depths/1 56.50,31.40 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Go up_ the ramp |goto Blackrock Depths/1 61.20,24.30 < 15
_Continue_ up the ramp |goto Blackrock Depths/1 66.50,25.70 < 15
_Go through_ the door |goto Blackrock Depths/2 60.40,60.00 < 15
_Enter_ the Black Vault |goto Blackrock Depths/1 59.00,35.00 < 15
Defeat Warder Stilgiss |goto Blackrock Depths/2 60.90,68.20 < 10
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
You will now be directed to the next section of the guide |goto Blackrock Depths/2 60.90,68.20 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Leave_ the room |goto Blackrock Depths/2 58.50,64.10 < 15
_Enter_ the doorway |goto Blackrock Depths/2 54.40,65.00 < 15
_Go up_ the stairs |goto Blackrock Depths/2 53.30,68.10 <15
_Enter_ the pathway |goto Blackrock Depths/2 56.30,76.00 < 20
_Follow_ the path back |goto Blackrock Depths/2 56.30,93.40 < 15
Defeat Pyromancer Loregrain |goto Blackrock Depths/2 54.20,96.30
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
You will now be directed to the next section of the guide |goto Blackrock Depths/2 54.20,96.30 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Go up_ the ramp |goto Blackrock Depths/2 55.70,90.00 < 20
_Go down_ the ramp |goto Blackrock Depths/1 45.90,63.10 < 15
_Jump down_ here |goto Blackrock Depths/2 42.10,89.70 < 15
_Click_ the switch |goto Blackrock Depths/2 41.20,88.30
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
You will now be directed to the next section of the guide |goto Blackrock Depths/2 41.20,88.30 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Go up_ the ramp |goto Blackrock Depths/2 42.20,90.40 < 20
Make your way _into the hallway_ |goto Blackrock Depths/2 46.00,86.30 < 20
_Go down_ the hallway |goto Blackrock Depths/2 47.40,81.70 < 20
_Go through_ the door |goto Blackrock Depths/1 43.10,47.30 < 20
_Go into_ the open room |goto Blackrock Depths/2 38.60,77.30 < 20
_Go down_ the ramp |goto Blackrock Depths/2 36.40,80.60< 20
Deafeat General Angerforge |goto Blackrock Depths/2 36.60,84.40
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
You will now be directed to the next section of the guide |goto Blackrock Depths/2 36.60,84.40 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Go up_ the stairs |goto Blackrock Depths/2 36.50,80.10 < 15
_Go down_ the ramp |goto Blackrock Depths/2 36.50,76.50 < 15
Defeat Golem Lord Argelmach |goto Blackrock Depths/2 36.70,65.50
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
You will now be directed to the next section of the guide |goto Blackrock Depths/2 36.70,65.50  < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Go down_ the hallway |goto Blackrock Depths/2 40.80,68.30 < 15
_Go up_ the stairs |goto Blackrock Depths/2 46.90,65.00 < 15
_Continue up_ the stairs |goto Blackrock Depths/2 51.80,65.40 < 15
talk Plugger Spazzring##9499
buy 2 Dark Iron Ale Mug##11325 |goto Blackrock Depths/2 49.80,61.20 < 15
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
_
Click here if you are ready to sell |confirm |next "sell"
step
talk Private Rocknot##9503
accept Rocknot's Ale##4295 |goto Blackrock Depths/2 51.03,60.67 |instant
Attack the Bar Patrons, it will force the Fireguard Destroyer out
Defeat Fireguard Destroyer |goto Blackrock Depths/2 52.40,63.30 < 15
_Go down_ the ramp |goto Blackrock Depths/1 53.00,32.00 < 15
_Enter_ the doorway then go down the stairs |goto Blackrock Depths/2 53.40,56.10 < 15
Defeat Ambassador Flamelash |goto Blackrock Depths/2 53.60,49.10
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
You will now be directed to the next section of the guide |goto Blackrock Depths/2 53.60,49.10 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Go through_ the doorway |goto Blackrock Depths/2 49.40,41.90
_Clear the room_ as you pass through |goto Blackrock Depths/2 48.50,34.40 < 20 |tip Clear the entire room
_Go down_ the ramp |goto Blackrock Depths/2 50.10,29.10 < 15
talk Doom'rel##9039 |goto Blackrock Depths/2 56.50,21.90
Tell him: _Your bondage is at an end, Doom'rel. I challenge you!_
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
After you complete the event, click here to continue |confirm
_
Click here if you are ready to sell |confirm |next "sell"
step
_Go through_ the door |goto Blackrock Depths/2 57.50,23.60 < 15
_Continue_ through the giant doors |goto Blackrock Depths/2 60.80,18.60 < 15
kill Shadowforge Flame Keeper##9956 |n
collect Shadowforge Torch##11885 |n
click Shadowforge Brazier
Light the Shadowforge Brazier |goto Blackrock Depths/2 71.50,16.90
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
After you light this torch, click here to continue |confirm
_
Click here if you are ready to sell |confirm |next "sell"
step
kill Shadowforge Flame Keeper##9956 |n
collect Shadowforge Torch##11885 |n
click Shadowforge Brazier
Light the Shadowforge Brazier |goto Blackrock Depths/2 71.90,6.90 < 15
_Go through_ the doorway |goto Blackrock Depths/2 75.10,11.10 < 15
Defeat Magmus |goto Blackrock Depths/2 81.50,11.90
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
You will now be directed to the next section of the guide |goto Blackrock Depths/2 81.50,11.90 < 10 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Go through_ the giant doors |goto Blackrock Depths/2 85.80,11.90 < 15
Clear out the room as you go through it
Defeat Emperor Dagran Thaurissan |goto Blackrock Depths/2 93.10,11.90
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
After you defeat Emperor Dagran, click here to continue |confirm
_
Click here if you are ready to sell |confirm |next "sell"
step
_Go through_ the big doors |goto Blackrock Depths/2 85.40,12.00 < 20
_Continue_ through the big doors |goto Blackrock Depths/2 74.90,12.90 < 20
_Go up_ the ramp |goto Blackrock Depths/2 59.80,20.00 < 20
_Go down_ the ramp |goto Blackrock Depths/2 59.00,23.70 < 20
_Enter_ the molten core |goto Blackrock Depths/2 68.40,38.30 < 10
goldcollect Hibernal Armor##8106 |n
goldcollect Runecloth##14047 |n
goldcollect Tender Wolf Meat##12208 |n
goldcollect Red Wolf Meat##12203 |n
You will now be directed to the next section of the guide |goto Blackrock Depths/2 68.40,38.30 < 10 |noway |c
_
Click here if you are ready to sell |confirm  |goto Blackrock Depths/2 68.40,38.30 < 10 |next "sell"
step
_Leave_ the Molten Core |goto Burning Steppes/16 54.40,83.50 < 20
This step will take you back to the start of the dungeon. _Reset_ if you wish to continue |confirm |next "BRD1"
_
_Click here_ if you wish _to return to farming Stratholme_ |confirm |next "Strath1"
_
_Click here to sell_ the items you have |confirm  |goto Blackrock Depths/2 68.40,38.30 < 10 |next "sell"
step
label "sell"
#include "auctioneer"
Click here to go back to the start |confirm |next "Strath1"
Click here to go back to farming Blackrock Depths |confirm |next "BRD1"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Daily Runs\\Master's Cloth Set Transmog",{
meta={goldtype="xmog",levelreq=30,gold=100,time=15,icon="Interface\\ICONS\\inv_shirt_06"},
description="\nThis guide will put you on the path to obtaining the Master's Cloth Set",
items={{10250,1},{10253,1},{10246,1},{10248,1},{10251,1},{10255,1},{10247,1},{10252,1},{17011,1},{7076,1},{7078,1},{7077,1},{7068,1},{7075,1},{17203,1}},
maps={"Molten Core"},
},[[
step
This guide will point you in the direction to each piece of the Master's Cloth Armor.
Since they have a very low drop rate, do expect to farm for a bit for these items
confirm always
step
label "start"
_Follow_ the path |goto Molten Core/1 32.40,20.70 < 20
_Go around_ the path |goto Molten Core/1 43.20,15.10 < 20
_Cross_ the bridge |goto Molten Core/1 49.40,30.00 < 20
_Go through_ the cave |goto Molten Core/1 54.80,31.70 < 20
_Enter_ the passageway |goto Molten Core/1 62.30,40.10 < 20
Defeat Magmadar |goto Molten Core/1 70.00,20.80
goldcollect Master's Hat##10250 |n
goldcollect Master's Mantle##10253 |n
goldcollect Master's Vest##10246 |n
goldcollect Master's Bracers##10248 |n
goldcollect Master's Gloves##10251 |n
goldcollect Master's Belt##10255 |n
goldcollect Master's Boots##10247 |n
goldcollect Master's Leggings##10252 |n
_Secondary Items:_
goldcollect Lava Core##17011 |n
goldcollect Essence of Earth##7076 |n
goldcollect  Essence of Fire##7078 |n
goldcollect  Heart of Fire##7077 |n
goldcollect  Elemental Fire##7068 |n
You will now be directed to the next section of the guide |goto Molten Core/1 70.00,20.80 < 20 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Enter_ the doorway |goto Molten Core/1 62.30,40.10 < 20
_Cross_ the bridge |goto Molten Core/1 54.70,31.50 < 20
_Go down_ the hill |goto Molten Core/1 45.90,26.90 < 20
Defeat Gehennas |goto Molten Core/1 33.00,48.20
goldcollect Master's Hat##10250 |n
goldcollect Master's Mantle##10253 |n
goldcollect Master's Vest##10246 |n
goldcollect Master's Bracers##10248 |n
goldcollect Master's Gloves##10251 |n
goldcollect Master's Belt##10255 |n
goldcollect Master's Boots##10247 |n
goldcollect Master's Leggings##10252 |n
_Secondary Items:_
goldcollect Lava Core##17011 |n
goldcollect Essence of Earth##7076 |n
goldcollect  Essence of Fire##7078 |n
goldcollect  Heart of Fire##7077 |n
goldcollect  Elemental Fire##7068 |n
goldcollect Core of Earth##7075 |n
goldcollect Essence of Earth##7076 |n
You will now be directed to the next section of the guide |goto Molten Core/1 33.00,48.20 < 20 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
Defeat Garr |goto Molten Core/1 29.40,72.20
goldcollect Master's Hat##10250 |n
goldcollect Master's Mantle##10253 |n
goldcollect Master's Vest##10246 |n
goldcollect Master's Bracers##10248 |n
goldcollect Master's Gloves##10251 |n
goldcollect Master's Belt##10255 |n
goldcollect Master's Boots##10247 |n
goldcollect Master's Leggings##10252 |n
_Secondary Items:_
goldcollect Lava Core##17011 |n
goldcollect Essence of Earth##7076 |n
goldcollect  Essence of Fire##7078 |n
goldcollect  Heart of Fire##7077 |n
goldcollect  Elemental Fire##7068 |n
goldcollect Core of Earth##7075 |n
goldcollect Essence of Earth##7076 |n
You will now be directed to the next section of the guide  |goto Molten Core/1 29.40,72.20 < 20 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Enter_ the tunnel |goto Molten Core/1 36.90,70.20 < 20
_Continue_ along the tunnel |goto Molten Core/1 42.20,72.40 < 20
Defeat Shazzrah |goto Molten Core/1 53.90,84.10
goldcollect Master's Hat##10250 |n
goldcollect Master's Mantle##10253 |n
goldcollect Master's Vest##10246 |n
goldcollect Master's Bracers##10248 |n
goldcollect Master's Gloves##10251 |n
goldcollect Master's Belt##10255 |n
goldcollect Master's Boots##10247 |n
goldcollect Master's Leggings##10252 |n
_Secondary Items:_
goldcollect Lava Core##17011 |n
goldcollect Essence of Earth##7076 |n
goldcollect  Essence of Fire##7078 |n
goldcollect  Heart of Fire##7077 |n
goldcollect  Elemental Fire##7068 |n
goldcollect Core of Earth##7075 |n
goldcollect Essence of Earth##7076 |n
You will now be directed to the next section of the guide  |goto Molten Core/1 53.90,84.10 < 20 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Go up_ the hill |goto Molten Core/1 57.80,74.30 < 20
_Cross_ the platform |goto Molten Core/1 68.30,65.90 < 20
Defeat Sulfuron Harbinger|goto Molten Core/1 83.40,82.70
goldcollect Master's Hat##10250 |n
goldcollect Master's Mantle##10253 |n
goldcollect Master's Vest##10246 |n
goldcollect Master's Bracers##10248 |n
goldcollect Master's Gloves##10251 |n
goldcollect Master's Belt##10255 |n
goldcollect Master's Boots##10247 |n
goldcollect Master's Leggings##10252 |n
_Secondary Items:_
goldcollect Lava Core##17011 |n
goldcollect Essence of Earth##7076 |n
goldcollect  Essence of Fire##7078 |n
goldcollect  Heart of Fire##7077 |n
goldcollect  Elemental Fire##7068 |n
goldcollect Core of Earth##7075 |n
goldcollect Essence of Earth##7076 |n
goldcollect Sulfuron Ingot##17203 |n
You will now be directed to the next section of the guide |goto Molten Core/1 68.60,61.20 < 20 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Jump down_ the ledge here |goto Molten Core/1 67.80,64.90 < 20
Defeat Golemagg the Incinerator |goto Molten Core/1 68.50,61.10
goldcollect Master's Hat##10250 |n
goldcollect Master's Mantle##10253 |n
goldcollect Master's Vest##10246 |n
goldcollect Master's Bracers##10248 |n
goldcollect Master's Gloves##10251 |n
goldcollect Master's Belt##10255 |n
goldcollect Master's Boots##10247 |n
goldcollect Master's Leggings##10252 |n
_Secondary Items:_
goldcollect Lava Core##17011 |n
goldcollect Essence of Earth##7076 |n
goldcollect  Essence of Fire##7078 |n
goldcollect  Heart of Fire##7077 |n
goldcollect  Elemental Fire##7068 |n
goldcollect Core of Earth##7075 |n
goldcollect Essence of Earth##7076 |n
goldcollect Sulfuron Ingot##17203 |n
You will now be directed to the next section of the guide |goto Molten Core/1 68.60,61.20 < 20 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Go up_ the ramp |goto Molten Core/1 73.10,50.50 < 30
_Continue up_ the ramp |goto Molten Core/1 78.20,64.30 < 20
Defeat Majordomo Executus |goto Molten Core/1 83.20,65.90
goldcollect Master's Hat##10250 |n
goldcollect Master's Mantle##10253 |n
goldcollect Master's Vest##10246 |n
goldcollect Master's Bracers##10248 |n
goldcollect Master's Gloves##10251 |n
goldcollect Master's Belt##10255 |n
goldcollect Master's Boots##10247 |n
goldcollect Master's Leggings##10252 |n
_Secondary Items:_
goldcollect Lava Core##17011 |n
goldcollect Essence of Earth##7076 |n
goldcollect  Essence of Fire##7078 |n
goldcollect  Heart of Fire##7077 |n
goldcollect  Elemental Fire##7068 |n
goldcollect Core of Earth##7075 |n
goldcollect Essence of Earth##7076 |n
goldcollect Sulfuron Ingot##17203 |n
You will now be directed to the next section of the guide |goto Molten Core/1 68.60,61.20 < 20 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
step
_Jump_ down the ledge here |goto Molten Core/1 78.00,73.10 < 20
_Follow_ the narrow path |goto Molten Core/1 71.70,68.00 < 20
_Continue_ along the path |goto Molten Core/1 52.70,75.40 < 30
_Go up_ the hill |goto Molten Core/1 43.60,71.00 < 20
_Go around_ the wall |goto Molten Core/1 34.40,66.00 < 20
_Follow_ the path back |goto Molten Core/1 39.30,56.40 < 20
talk Majordomo Executus##54404 |goto Molten Core/1 54.30,54.30
goldcollect Master's Hat##10250 |n
goldcollect Master's Mantle##10253 |n
goldcollect Master's Vest##10246 |n
goldcollect Master's Bracers##10248 |n
goldcollect Master's Gloves##10251 |n
goldcollect Master's Belt##10255 |n
goldcollect Master's Boots##10247 |n
goldcollect Master's Leggings##10252 |n
_Secondary Items:_
goldcollect Lava Core##17011 |n
goldcollect Essence of Earth##7076 |n
goldcollect  Essence of Fire##7078 |n
goldcollect  Heart of Fire##7077 |n
goldcollect  Elemental Fire##7068 |n
goldcollect Core of Earth##7075 |n
goldcollect Essence of Earth##7076 |n
goldcollect Sulfuron Ingot##17203 |n
You will now be directed to the next section of the guide |goto Molten Core/1 68.60,61.20 < 20 |noway |c
_
Click here if you are ready to sell |confirm |next "sell"
Defeat Ragnaros
step
label "sell"
#include "auctioneer"
Click here to go back to the start |confirm |next "start"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Daily Runs\\Resilient Cloth Set Transmog",{
meta={goldtype="xmog",levelreq=10,gold=100,time=15,icon="Interface\\ICONS\\inv_shirt_09"},
description="\nThis guide will put you on the path to obtaining the Resilient Cloth Set",
items={{14403,1},{14402,1},{14406,1},{14399,1},{14398,1},{14404,1},{4338,1}},
maps={"Southern Barrens","Desolace","Maraudon"},
},[[
step
This guide will point you in the direction to each piece of the Resilient Cloth Armor.
Since they have a very low drop rate, do expect to farm for a bit for these items
confirm always
step
label "SB1"
map Southern Barrens/0
path follow smart; loop on; ants curved; dist 20
path	40.80,15.60	42.20,22.00	40.60,24.00
path	43.40,27.00	39.60,34.20	42.60,37.60
path	43.60,42.60	53.60,49.60	55.00,47.80
path	52.80,46.90	55.80,44.20
Kill Hecklefang Scavengers, Terrortooth Runners and Bristleback enemies along this path
goldcollect Resilient Handgrips##14403 |n
goldcollect Resilient Bands##14402 |n
confirm
step
map Desolace/0
path	73.70,16.40	77.50,15.40	79.70,18.10
path	76.80,22.20	76.40,25.50	72.90,26.20
path	70.70,25.00	67.00,24.40	64.00,24.40
path	59.70,23.60	58.40,18.90	60.20,16.50
path	63.30,15.90	68.30,19.80	70.50,17.90
goldcollect Resilient Handgrips##14403 |n
goldcollect Resilient Cord##14406 |n
goldcollect Resilient Boots##14399 |n
Click here to sell |confirm |next "sell"
_
Click here to move onto the next farming path |confirm
step
label "MSr"
|tip Make sure you reset the dungeon if required
_Enter_ the dungeon |goto Maraudon/1 76.40,62.70 < 20
_Follow_ the ledge |goto Maraudon/1 72.30,68.40 < 25
_Confinue_ around the path here |goto Maraudon/1 66.50,71.40 < 20
_Cross_ the bridge|goto Maraudon/1 63.20,69.90 < 20
_Go down_ the ramp |goto Maraudon/1 68.90,65.40 < 25
goldcollect Resilient Tunic###14398 |n
goldcollect Resilient Leggings##14404 |n
goldcollect Mageweave Cloth##4338 |n
You will be guided to the next portion of the guide |goto Maraudon/1 68.90,65.40 < 25 |noway |c
_
Click here if you wish to sell |confirm |next "sell"
step
_Go up_ the stairs |goto Maraudon/1 59.90,54.00 < 20
_Follow_ the path along the right wall |goto Maraudon/1 55.90,48.00 < 25
_Continue_ along the path |goto Maraudon/1 50.20,51.70
_Go through_ the doorway|goto Maraudon/1 49.60,71.90 < 20
_Pass_ through the room |goto Maraudon/1 50.80,78.90 < 20
_Clear_ the enemies in the back room here |goto Maraudon/1 54.80,92.40 < 20
goldcollect Resilient Tunic###14398 |n
goldcollect Resilient Leggings##14404 |n
goldcollect Mageweave Cloth##4338 |n
You will be directed out of the dungeon now |goto Maraudon/1 54.80,92.40 < 20 |noway |c
_
Click here if you wish to sell |confirm |next "sell"
step
_Go through_ the doorway |goto Maraudon/1 49.50,72.00 < 20
_Jump_ down the ledge |goto Maraudon/1 51.50,66.40 < 20
_Follow_ the path up |goto Maraudon/1 57.10,61.00 < 20
_Take_ the path to the right |goto Maraudon/1 62.00,58.20 < 20
_Go up_ the ramp |goto Maraudon/1 69.00,65.20 < 20
_Follow_ the path |goto Maraudon/1 63.20,67.20 < 20
Leave Maraudon |goto Maraudon/1 79.10,68.20 < 10
Click here to go back to the start of the guide |confirm |next "SB1"
_
Click here if you wish to reset the instance and continue farming Maraudon |confirm |next "MSr"
Click here to sell |confirm
step
label "sell"
#include "auctioneer"
Click here to go back to the start |confirm |next "SB1"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Green Cabbage",{
condition_valid="completedq(30257)",
meta={goldtype="till",levelreq=15,time=1440,icon="Interface\\ICONS\\INV_Misc_Food_Vendor_GreenCabbage"},
items={{74840,20}},
},[[
#include "goldg_farm",seed="Green Cabbage Seeds##79102",veggie="Green Cabbage##74840"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Mogu Pumpkin",{
condition_valid="completedq(30257)",
meta={goldtype="till",levelreq=15,time=1440,icon="Interface\\ICONS\\INV_Misc_Food_Vendor_MoguPumpkin"},
items={{74842,20}},
},[[
#include "goldg_farm",seed="Mogu Pumpkin Seeds##80592",veggie="Mogu Pumpkin##74842"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Juicycrunch Carrot",{
condition_valid="completedq(30257)",
meta={goldtype="till",levelreq=15,time=1440,icon="Interface\\ICONS\\INV_Misc_Food_Vendor_Carrot"},
items={{74841,20}},
},[[
#include "goldg_farm",seed="Juicycrunch Carrot Seeds##80590",veggie="Juicycrunch Carrot##74841"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Scallion",{
condition_valid="completedq(30257)",
meta={goldtype="till",levelreq=15,time=1440,icon="Interface\\ICONS\\INV_Misc_Food_Vendor_Scallions"},
items={{74843,20}},
},[[
#include "goldg_farm",seed="Scallion Seeds##80591",veggie="Scallions##74843"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Red Blossom Leek",{
condition_valid="completedq(30257)",
meta={goldtype="till",levelreq=15,time=1440,icon="Interface\\ICONS\\INV_Misc_Food_Vendor_RedBlossomLeek"},
items={{74844,20}},
},[[
#include "goldg_farm",seed="Red Blossom Leek Seeds##80593",veggie="Red Blossom Leek##74844"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Witchberries",{
condition_valid="completedq(30257)",
meta={goldtype="till",levelreq=15,time=1440,icon="Interface\\ICONS\\INV_Misc_Food_Vendor_Witchberries"},
items={{74846,20}},
},[[
#include "goldg_farm",seed="Witchberry Seeds##89326",veggie="Witchberries##74846"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Jade Squash",{
condition_valid="completedq(30257)",
meta={goldtype="till",levelreq=15,time=1440,icon="Interface\\ICONS\\INV_Misc_Food_Vendor_JadeSquash"},
items={{74847,20}},
},[[
#include "goldg_farm",seed="Jade Squash Seeds##89328",veggie="Jade Squash##74847"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Striped Melon",{
condition_valid="completedq(30257)",
meta={goldtype="till",levelreq=15,time=1440,icon="Interface\\ICONS\\INV_Misc_Food_Vendor_StripedMelon"},
items={{74848,20}},
},[[
#include "goldg_farm",seed="Striped Melon Seeds##89329",veggie="Striped Melon##74848"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\Pink Turnips",{
condition_valid="completedq(30257)",
meta={goldtype="till",levelreq=15,time=1440,icon="Interface\\ICONS\\INV_Misc_Food_Vendor_PinkTurnip"},
items={{74849,20}},
},[[
#include "goldg_farm",seed="Pink Turnip Seeds##80594",veggie="Pink Turnip##74849"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Farming\\White Turnips",{
condition_valid="completedq(30257)",
meta={goldtype="till",levelreq=15,time=1440,icon="Interface\\ICONS\\INV_Misc_Food_Vendor_WhiteTurnip"},
items={{74850,20}},
},[[
#include "goldg_farm",seed="White Turnip Seeds##80595",veggie="White Turnip##74850"
]])
