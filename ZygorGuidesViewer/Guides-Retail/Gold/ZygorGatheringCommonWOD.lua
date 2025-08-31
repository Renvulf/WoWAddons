local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
ZygorGuidesViewer.Gold.guides_loaded=true
if ZGV:DoMutex("GoldGatherH") then return end
ZygorGuidesViewer.GuideMenuTier = "WOD"
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Strange Dust",{
meta={goldtype="route",levelreq={5},skillreq={enchanting=1}},
items={{10940,92},{10938,18,'crap'},{10939,2,'crap'},{10998,1,'crap'},{11082,1,'crap'},{2589,108,'crap'},{2592,60,'crap'}},
maps={"Northern Barrens"},
},[[
step
Enter the Wailing Caverns |goto Northern Barrens/20 55.00,66.00
|goldcollect 92 Strange Dust##10940
|tip Strange Dust can be Disenchanted from Uncommon items with an item level of 1 to 25.
|tip The Wailing Caverns dungeon offers the best yield of Strange Dust.
|meta crap_items_follow=1
|goldcollect 18 Lesser Magic Essence##10938
|goldcollect 2 Greater Magic Essence##10939
|goldcollect 1 Lesser Astral Essence##10998
|goldcollect 1 Greater Astral Essence##11082
|goldcollect 108 Linen Cloth##2589
|goldcollect 60 Wool Cloth##2592
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Illusion Dust",{
meta={goldtype="route",levelreq={15},skillreq={enchanting=1}},
items={{16204,33},{16202,15,'crap'},{16203,10,'crap'},{14047,630,'crap'}},
maps={"Burning Steppes"},
},[[
step
Enter Lower Blackrock Spire |goto Burning Steppes/14 80.30,40.70
|goldcollect 33 Illusion Dust##16204
|tip Illusion Dust can be Disenchanted from Uncommon items with an item level of 27 to 58.
|tip The Lower Blackrock Spire dungeon offers the best yield of Illusion Dust.
|meta crap_items_follow=1
|goldcollect 15 Lesser Eternal Essence##16202
|goldcollect 10 Greater Eternal Essence##16203
|goldcollect 630 Runecloth##14047
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Arcane Dust",{
meta={goldtype="route",levelreq={25},skillreq={outland_enchanting=1}},
items={{22445,68},{22447,12,'crap'},{22446,4,'crap'},{21877,1424,'crap'}},
maps={"Shadowmoon Valley"},
},[[
step
map Shadowmoon Valley/0
path follow loose; loop on; ants curved
path	51.10,58.80	53.00,59.30	53.20,60.50	52.80,63.20	52.80,65.40
path	52.90,69.00	52.50,71.80	47.30,71.10	45.80,71.30	45.20,69.20
path	45.60,66.10	48.00,67.20
Kill enemies around this area
|tip Arcane Dust can be Disenchanted from Uncommon items with an item level of 69 to 80.
|goldcollect 68 Arcane Dust##22445
|meta crap_items_follow=1
|goldcollect 12 Lesser Planar Essence##22447
|goldcollect 4 Greater Planar Essence##22446
|goldcollect 1424 Netherweave Cloth##21877
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Infinite Dust",{
meta={goldtype="route",levelreq={25},skillreq={northrend_enchanting=1}},
items={{34054,92},{33470,180,'crap'},{34056,6,'crap'},{34055,2,'crap'}},
maps={"Icecrown"},
},[[
step
kill Mjordin Combatant##30037+
|tip Infinite Dust can be Disenchanted from Uncommon items with an item level of 80 to 100.
|goldcollect 92 Infinite Dust##34054 |goto Icecrown/0 37.60,22.80
|meta crap_items_follow=1
|goldcollect 180 Frostweave Cloth##33470
|goldcollect 6 Lesser Cosmic Essence##34056
|goldcollect 2 Greater Cosmic Essence##34055
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Hypnotic Dust",{
meta={goldtype="route",levelreq={30},skillreq={cataclysm_enchanting=1}},
items={{52555,27},{52718,6,'crap'},{52719,5,'crap'},{53010,232,'crap'}},
maps={"Deepholm"},
},[[
step
map Deepholm/0
path follow loose; loop on; ants curved; dist 20
path	68.20,25.60	67.20,32.00	68.60,35.80	69.00,42.60	73.00,45.00
path	77.20,42.80	76.80,35.60	74.60,32.80	74.80,28.40	72.20,26.60
Kill Verlok enemies around this area
|tip Hypnotic Dust can be Disenchanted from Uncommon items with an item level of 102 to 108.
|tip Up on the platforms.
|goldcollect 27 Hypnotic Dust##52555
|meta crap_items_follow=1
|goldcollect 6 Lesser Celestial Essence##52718
|goldcollect 5 Greater Celestial Essence##52719
|goldcollect 232 Embersilk Cloth##53010
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Spirit Dust",{
meta={goldtype="route",levelreq={25},skillreq={pandaria_enchanting=1}},
items={{74249,126},{72988,308,'crap'},{89112,64,'crap'}},
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
|tip Spirit Dust can be Disenchanted from Uncommon items with an item level of 108 to 115.
|goldcollect 126 Spirit Dust##74249
|meta crap_items_follow=1
|goldcollect 308 Windwool Cloth##72988
|goldcollect 64 Mote of Harmony##89112 |n
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Draenic Dust",{
meta={goldtype="route",levelreq={15},skillreq={draenor_enchanting=1}},
items={{109693,105},{111557,364}},
maps={"Gorgrond"},
},[[
step
map Gorgrond/0
path follow loose; loop on; ants curved; dist 20
path	46.80,89.80	46.40,91.40	45.30,93.00	43.20,91.80	42.80,89.40
path	44.50,90.70	44.60,89.20
Kill Tailthrasher enemies around this area
|tip Draenic Dust can be Disenchanted from Uncommon items with an item level of 116 to 136.
|goldcollect 105 Draenic Dust##109693
|goldcollect 364 Sumptuous Fur##111557 |n
|meta crap_items_follow=1
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Deviate Fish",{
meta={goldtype="route",skillreq={fishing=1},levelreq=5},
items={{6522,184}},
maps={"Northern Barrens"},
},[[
step
Use your Fishing skill to fish from the School of Deviate Fish |cast Fishing##131474
|goldcollect 184 Deviate Fish##6522 |goto Northern Barrens/0 39.60,76.10
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Oily Blackmouth/Firefin Snapper/Stonescale Eel",{
meta={goldtype="route",skillreq={fishing=1},levelreq=15},
items={{6358,52},{6359,44},{13422,64}},
maps={"Swamp of Sorrows"},
},[[
step
label "route_1"
Follow the path, fishing at any pools |goto Swamp of Sorrows/0 77.50,10.00 < 20 |noway |c |or |next "route_2"
Use your Fishing skill to fish in the water |cast Fishing##131474
map Swamp of Sorrows
path follow smart; loop off; ants curved; dist 20
path	80.10,91.00	83.50,88.10	84.80,82.90
path	86.20,77.60	88.80,71.20	90.80,65.20
path	89.50,58.40	79.50,56.60	74.00,61.90
path	68.20,62.90	63.60,58.80	63.60,47.70
path	72.70,42.30	77.90,44.20	85.60,46.00
path	90.00,43.40	90.40,37.20	89.30,31.80
path	87.30,26.00	85.80,21.90	84.00,18.80
path	81.80,16.10	77.50,10.00
|goldcollect 52 Oily Blackmouth##6358 |or
|goldcollect 44 Firefin Snapper##6359 |n
|goldcollect 64 Stonescale Eel##13422 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_2"
Follow the path, fishing at any pools |goto Swamp of Sorrows/0 80.10,91.00 < 20 |noway |c |or |next "route_1"
Use your Fishing skill to fish in the water |cast Fishing##131474
map Swamp of Sorrows
path follow smart; loop off; ants curved; dist 20
path	77.50,10.00	81.80,16.10	84.00,18.80
path	85.80,21.90	87.30,26.00	89.30,31.80
path	90.40,37.20	90.00,43.40	85.60,46.00
path	77.90,44.20	72.70,42.30	63.60,47.70
path	63.60,58.80	68.20,62.90	74.00,61.90
path	79.50,56.60	89.50,58.40	90.80,65.20
path	88.80,71.20	86.20,77.60	84.80,82.90
path	83.50,88.10	80.10,91.00
|goldcollect 52 Oily Blackmouth##6358 |or
|goldcollect 44 Firefin Snapper##6359 |n
|goldcollect 64 Stonescale Eel##13422 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Glassfin Minnow/Pygmy Suckerfish",{
meta={goldtype="route",skillreq={northrend_fishing=1},levelreq=25},
items={{41814,156},{40199,48}},
maps={"Crystalsong Forest"},
},[[
step
label "route_1"
Fish in any Glassfin Minnow Schools you find |cast Fishing##131474
Follow the path, fishing at each pool |goto Crystalsong Forest 49.40,56.60 < 20 |noway |c |or |next "route_2"
map Crystalsong Forest
path follow smart; loop off; ants curved; dist 20
path	17.70,21.30	21.40,30.50	24.60,42.10
path	33.00,45.50	35.60,49.40	40.20,54.90
path	49.40,56.60
|goldcollect 156 Glassfin Minnow##41814 |or
|goldcollect 48 Pygmy Suckerfish##40199 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_2"
Fish in any Glassfin Minnow Schools you find |cast Fishing##131474
Follow the path, fishing at each pool |goto Crystalsong Forest 17.70,21.30 < 20 |noway |c |or |next "route_1"
map Crystalsong Forest
path follow smart; loop off; ants curved; dist 20
path	49.40,56.60	40.20,54.90	35.60,49.40
path	33.00,45.50	24.60,42.10	21.40,30.50
path	17.70,21.30
|goldcollect 156 Glassfin Minnow##41814 |or
|goldcollect 48 Pygmy Suckerfish##40199 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Albino Cavefish",{
meta={goldtype="route",skillreq={cataclysm_fishing=1},levelreq=30},
items={{53065,148},{52326,24}},
maps={"Deepholm"},
},[[
step
label "route_1"
Fish in any Albino Cavefish Schools you find |cast Fishing##131474
Follow the path, fishing at each pool |goto Deepholm 73.80,32.10 < 20 |noway |c |or |next "route_2"
map Deepholm
path follow smart; loop off; ants curved; dist 20
path	69.90,41.90	70.50,45.60	71.10,48.80
path	73.90,50.90	76.50,52.70	77.50,49.10
path	77.40,44.00	74.20,42.50	76.00,39.70
path	75.70,35.80	73.80,32.10
|goldcollect 148 Albino Cavefish##53065 |or
|goldcollect 24 Volatile Water##52326 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_2"
Fish in any Albino Cavefish Schools you find |cast Fishing##131474
Follow the path, fishing at each pool |goto Deepholm 69.90,41.90 < 20 |noway |c |or |next "route_1"
map Deepholm
path follow smart; loop off; ants curved; dist 20
path	73.80,32.10	75.70,35.80	76.00,39.70
path	74.20,42.50	77.40,44.00	77.50,49.10
path	76.50,52.70	73.90,50.90	71.10,48.80
path	70.50,45.60	69.90,41.90
|goldcollect 148 Albino Cavefish##53065 |or
|goldcollect 24 Volatile Water##52326 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Emperor Salmon/Krasarang Paddlefish",{
meta={goldtype="route",skillreq={pandaria_fishing=1},levelreq=15},
items={{74859,96},{74865,96}},
maps={"Valley of the Four Winds"},
},[[
step
label "route_1"
Use your fishing ability to fish from Emperor Salmon and Krasarang Paddlefish pools |cast Fishing##131474
Follow the path, fishing at each pool |goto Valley of the Four Winds 42.50,30.00 < 20 |noway |c |or |next "route_2"
map Valley of the Four Winds
path follow smart; loop off; ants curved; dist 25
path	87.60,22.10	86.90,32.20	83.70,35.30
path	76.80,40.90	74.10,46.70	72.60,52.70
path	69.10,59.30	65.80,64.80	63.90,67.00
path	61.50,69.90	59.20,64.80	59.20,59.70
path	57.30,55.20	59.40,49.80	59.10,43.10
path	56.80,41.10	56.70,29.10	55.90,25.00
path	51.80,26.40	49.10,25.20	45.60,27.40
path	42.50,30.00
|goldcollect 96 Emperor Salmon##74859 |or
|goldcollect 96 Krasarang Paddlefish##74865 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_2"
Use your fishing ability to fish from Emperor Salmon and Krasarang Paddlefish pools |cast Fishing##131474
Follow the path, fishing at each pool |goto Valley of the Four Winds 87.60,22.10 < 20 |noway |c |or |next "route_1"
map Valley of the Four Winds
path follow smart; loop off; ants curved; dist 25
path	42.50,30.00	45.60,27.40	49.10,25.20
path	51.80,26.40	55.90,25.00	56.70,29.10
path	56.80,41.10	59.10,43.10	59.40,49.80
path	57.30,55.20	59.20,59.70	59.20,64.80
path	61.50,69.90	63.90,67.00	65.80,64.80
path	69.10,59.30	72.60,52.70	74.10,46.70
path	76.80,40.90	83.70,35.30	86.90,32.20
path	87.60,22.10
|goldcollect 96 Emperor Salmon##74859 |or
|goldcollect 96 Krasarang Paddlefish##74865 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Giant Mantis Shrimp/Reef Octopus",{
meta={goldtype="route",skillreq={pandaria_fishing=1},levelreq=15},
items={{74857,90},{74864,90}},
maps={"Krasarang Wilds"},
},[[
step
label "route_1"
Use your Fishing skill to fish in any pools you find |cast Fishing##131474
Follow the path, fishing at each pool |goto Krasarang Wilds 19.80,72.30 < 20 |noway |c |or |next "route_2"
map Krasarang Wilds
path follow smart; loop off; ants curved; dist 25
path	87.10,11.80	86.10,17.70	88.30,28.70
path	83.10,28.80	80.50,28.10	77.90,36.80
path	74.50,34.90	69.20,36.30	70.20,42.40
path	65.20,44.80	60.50,42.10	57.80,46.00
path	57.60,51.30	52.50,48.10	50.50,50.30
path	44.30,62.60	51.30,69.40	48.80,73.00
path	44.90,73.50	42.00,75.00	40.60,71.30
path	37.80,73.50	37.80,78.10	37.30,83.40
path	34.00,84.40	29.90,80.00	28.00,72.50
path	27.00,67.00	24.30,63.10	22.20,66.30
path	19.80,72.30
|goldcollect 90 Giant Mantis Shrimp##74857 |or
|goldcollect 90 Reef Octopus##74864 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_2"
Use your Fishing skill to fish in any pools you find |cast Fishing##131474
Follow the path, fishing at each pool |goto Krasarang Wilds 87.10,11.80 |noway |c |or |next "route_1"
map Krasarang Wilds
path follow smart; loop off; ants curved; dist 25
path	19.80,72.30	22.20,66.30	24.30,63.10
path	27.00,67.00	28.00,72.50	29.90,80.00
path	34.00,84.40	37.30,83.40	37.80,78.10
path	37.80,73.50	40.60,71.30	42.00,75.00
path	44.90,73.50	48.80,73.00	51.30,69.40
path	44.30,62.60	50.50,50.30	52.50,48.10
path	57.60,51.30	57.80,46.00	60.50,42.10
path	65.20,44.80	70.20,42.40	69.20,36.30
path	74.50,34.90	77.90,36.80	80.50,28.10
path	83.10,28.80	88.30,28.70	86.10,17.70
path	87.10,11.80
|goldcollect 90 Giant Mantis Shrimp##74857 |or
|goldcollect 90 Reef Octopus##74864 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Golden Carp",{
meta={goldtype="route",skillreq={pandaria_fishing=1},levelreq=10},
items={{74866,160},{74856,56},{74860,48},{88496,8}},
maps={"The Jade Forest"},
},[[
step
Use your Fishing skill to fish in the water |cast Fishing##131474 |goto The Jade Forest/0 56.80,43.50
|goldcollect 160 Golden Carp##74866
|goldcollect 56 Jade Lungfish##74856
|goldcollect 48 Redbelly Mandarin##74860
|goldcollect 8 Sealed Crate##88496
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Jade Lungfish",{
meta={goldtype="route",skillreq={pandaria_fishing=1},levelreq=10},
items={{74856,208},{88496,8}},
maps={"The Jade Forest"},
},[[
step
label "route_1"
Use your Fishing skill to fish in any pools you find |cast Fishing##131474
Follow the path, fishing at each pool |goto The Jade Forest 25.30,43.10 < 20 |noway |c |or |next "route_2"
map The Jade Forest
path follow smart; loop off; ants curved; dist 20
path	57.60,84.80	59.50,80.00	55.90,77.80
path	52.30,77.80	47.70,76.10	46.20,72.80
path	46.70,64.40	49.00,61.70	47.80,56.60
path	42.80,61.90	42.00,57.20	39.50,53.00
path	36.00,48.30	32.10,45.60	28.40,45.20
path	25.30,43.10
|goldcollect 208 Jade Lungfish##74856 |or
|goldcollect 8 Sealed Crate##88496 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_2"
Use your Fishing skill to fish in any pools you find |cast Fishing##131474
Follow the path, fishing at each pool |goto The Jade Forest 57.60,84.80 < 20 |noway |c |or |next "route_1"
map The Jade Forest
path follow smart; loop off; ants curved; dist 20
path	25.30,43.10	28.40,45.20	32.10,45.60
path	36.00,48.30	39.50,53.00	42.00,57.20
path	42.80,61.90	47.80,56.60	49.00,61.70
path	46.70,64.40	46.20,72.80	47.70,76.10
path	52.30,77.80	55.90,77.80	59.50,80.00
path	57.60,84.80
|goldcollect 208 Jade Lungfish##74856 |or
|goldcollect 8 Sealed Crate##88496 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Jewel Danio",{
meta={goldtype="route",skillreq={pandaria_fishing=1},levelreq=30},
items={{74863,212},{88496,4}},
maps={"Timeless Isle"},
},[[
step
Use your Fishing skill to fish in any pools you find |cast Fishing##131474
Fish from the various Jewel Danio Schools around this pond |goto Timeless Isle/0 47.40,55.00
|goldcollect 212 Jewel Danio##74863
|goldcollect 4 Sealed Crate##88496
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Redbelly Mandarin/Emperor Salmon",{
meta={goldtype="route",skillreq={pandaria_fishing=1},levelreq=25},
items={{74860,74},{74859,74}},
maps={"Townlong Steppes"},
},[[
step
label "route_1"
Use your Fishing skill to fish in any pools you find |cast Fishing##131474
Follow the path, fishing at each pool |goto Townlong Steppes 50.70,93.30 < 25 |noway |c |or |next "route_2"
map Townlong Steppes
path follow smart; loop off; ants curved; dist 25
path	59.20,87.00	56.80,85.70	55.20,86.40
path	54.40,88.70	52.30,89.20	50.70,93.30
|goldcollect 74 Redbelly Mandarin##74860 |or
|goldcollect 74 Emperor Salmon##74859 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_2"
Use your Fishing skill to fish in any pools you find |cast Fishing##131474
Follow the path, fishing at each pool |goto Townlong Steppes 59.20,87.00 < 25 |noway |c |or |next "route_1"
map Townlong Steppes
path follow smart; loop off; ants curved; dist 25
path	50.70,93.30	52.30,89.20	54.40,88.70
path	55.20,86.40	56.80,85.70	59.20,87.00
|goldcollect 74 Redbelly Mandarin##74860 |or
|goldcollect 74 Emperor Salmon##74859 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Spinefish",{
meta={goldtype="route",skillreq={pandaria_fishing=1},levelreq=20},
items={{83064,172}},
maps={"Kun-Lai Summit"},
},[[
step
Follow the path, fishing at any pools
Use your Fishing skill to fish in the water |cast Fishing##131474
map Kun-Lai Summit
path	follow smart; loop on; ants curved; dist 20
path	76.50,86.00	75.00,80.70	71.10,80.10
path	69.90,82.70	76.50,86.00
|goldcollect 172 Spinefish##83064
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Tiger Gourami/Golden Carp",{
meta={goldtype="route",skillreq={pandaria_fishing=1},levelreq=20},
items={{74861,184},{88496,16}},
maps={"Kun-Lai Summit"},
},[[
step
label "route_1"
Follow the path, fishing at any pools |goto Kun-Lai Summit 72.20,33.50 < 20 |noway |c |or |next "route_2"
Use your Fishing skill to fish in the water |cast Fishing##131474
map Kun-Lai Summit
path	follow smart; loop off; ants curved; dist 20
path	67.40,53.30	64.40,48.10	65.60,45.00
path	67.20,48.70	69.90,48.70	72.70,48.70
path	72.60,41.70	72.20,33.50
|goldcollect 184 Tiger Gourami##74861 |or
|goldcollect 16 Sealed Crate##88496 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_2"
Follow the path, fishing at any pools |goto Kun-Lai Summit 67.40,53.30 < 20 |noway |c |or |next "route_1"
Use your Fishing skill to fish in the water |cast Fishing##131474
map Kun-Lai Summit
path	follow smart; loop off; ants curved; dist 20
path	72.20,33.50	72.60,41.70	72.70,48.70
path	69.90,48.70	67.20,48.70	65.60,45.00
path	64.40,48.10	67.40,53.30
|goldcollect 184 Tiger Gourami##74861 |or
|goldcollect 16 Sealed Crate##88496 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Abyssal Gulper Eel Flesh/Crescent Saberfish Flesh",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq=30},
description="\nThis guide will walk you through fishing Abyssal Gulper Eel Flesh and Crescent Saberfish Flesh from open water.",
items={{109143,824},{109137,216}},
maps={"Spires of Arak"},
},[[
step
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from the shore here |goto Spires of Arak/0 60.90,17.80
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your fish by right-clicking the fish in your inventory
|goldcollect 824 Abyssal Gulper Eel Flesh##109143
|goldcollect 216 Crescent Saberfish Flesh##109137
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Abyssal Gulper Eel Flesh",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq=30},
description="\nThis guide will walk you through fishing Abyssal Gulper Eel Flesh from Abyssal Gulper Schools.",
items={{109143,396}},
maps={"Spires of Arak"},
},[[
step
label "route_1"
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Follow the path, fishing at any pools |goto Spires of Arak/0 47.10,34.10 < 20 |noway |c |or |next "route_2"
Use your Fishing skill to fish in the water |cast Fishing##131474
map Spires of Arak/0
path follow smart; loop off; ants curved; dist 20
path	56.80,47.90	55.10,41.70	55.50,38.40
path	54.50,36.10	53.50,33.90	52.60,33.20
path	51.60,34.10	50.20,33.10	49.00,32.20
path	47.10,34.10
|goldcollect 396 Abyssal Gulper Eel Flesh##109143 |or
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_2"
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Follow the path, fishing at any pools |goto Spires of Arak/0 56.80,47.90 < 20 |noway |or |next "route_1"
Use your Fishing skill to fish in the water |cast Fishing##131474
map Spires of Arak/0
path follow smart; loop off; ants curved; dist 20
path	47.10,34.10	49.00,32.20	50.20,33.10
path	51.60,34.10	52.60,33.20	53.50,33.90
path	54.50,36.10	55.50,38.40	55.10,41.70
path	56.80,47.90
|goldcollect 396 Abyssal Gulper Eel Flesh##109143 |or
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Blackwater Whiptail Flesh/Crescent Saberfish Flesh",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq=20},
description="\nThis guide will walk you through fishing Blackwater Whiptail Flesh and Crescent Saberfish Flesh from open water.",
items={{109144,568},{109137,120}},
maps={"Talador"},
},[[
step
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from the shore here |goto Talador/0 72.10,54.70
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your fish by right-clicking the fish in your inventory
|goldcollect 568 Blackwater Whiptail Flesh##109144
|goldcollect 120 Crescent Saberfish Flesh##109137
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Blackwater Whiptail Flesh",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq=20},
description="\nThis guide will walk you through fishing Blackwater Whiptail Flesh from Blackwater Whiptail Schools.",
items={{109144,704}},
maps={"Talador"},
},[[
step
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Follow the path, fishing at any pools
Use your Fishing skill to fish in the water |cast Fishing##131474
map Talador/0
path follow smart; loop on; ants curved; dist 20
path	73.60,59.30	76.10,58.90	77.80,59.20
path	79.50,58.40	79.50,56.10	79.80,54.20
path	77.60,54.50	76.60,56.30	75.30,57.00
path	73.80,56.40	72.50,53.40	71.30,52.00
path	70.30,50.20	68.10,48.70	66.20,46.90
path	65.30,43.50	65.80,40.60	63.90,36.30
path	62.30,32.50	60.70,31.20	59.30,32.00
path	58.40,34.70	57.80,38.20	58.10,41.90
path	59.70,42.30	62.60,45.00	61.80,46.70
path	60.60,49.00	61.90,52.10	63.60,56.00
path	65.80,62.50	67.40,58.30	70.50,60.50
|goldcollect 704 Blackwater Whiptail Flesh##109144
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Blind Lake Sturgeon Flesh/Crescent Saberfish Flesh",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq=10},
description="\nThis guide will walk you through fishing Blind Lake Sturgeon Flesh and Crescent Saberfish Flesh from open water.",
items={{109140,828},{109137,248}},
maps={"Shadowmoon Valley D"},
},[[
step
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from the shore here |goto Shadowmoon Valley D/0 40.60,49.80
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your fish by right-clicking the fish in your inventory
|goldcollect 828 Blind Lake Sturgeon Flesh##109140
|goldcollect 248 Crescent Saberfish Flesh##109137
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Blind Lake Sturgeon Flesh",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq=10},
description="\nThis guide will walk you through fishing Blind Lake Sturgeon Flesh from Blind Lake Sturgeon Schools.",
items={{109140,464}},
maps={"Shadowmoon Valley D"},
},[[
step
label "route_1"
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Follow the path, fishing at any pools |goto Shadowmoon Valley D/0 53.10,41.30 < 20 |noway |c |next "route_2"
Use your Fishing skill to fish in the water |cast Fishing##131474
map Shadowmoon Valley D/0
path follow smart; loop off; ants curved; dist 20
path	39.20,49.10	41.60,47.90	43.10,49.60
path	45.20,49.40	46.90,49.50	49.80,52.60
path	51.00,52.30	52.20,51.30	53.00,51.00
path	53.90,48.80	54.40,45.30	53.10,41.30
|goldcollect 464 Blind Lake Sturgeon Flesh##109140 |or
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_2"
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Follow the path, fishing at any pools |goto Shadowmoon Valley D/0 52.80,70.70 < 20 |noway |c |or |next "route_3"
Use your Fishing skill to fish in the water |cast Fishing##131474
map Shadowmoon Valley D/0
path follow smart; loop off; ants curved; dist 20
path	53.10,41.30	54.40,45.30	53.90,48.80
path	53.00,51.00	52.20,51.30	51.00,52.30
path	49.80,52.60	49.00,53.70	48.80,56.60
path	50.00,60.00	51.70,61.60	52.50,63.70
path	52.30,68.30	52.80,70.70
|goldcollect 464 Blind Lake Sturgeon Flesh##109140 |or
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_3"
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Follow the path, fishing at any pools |goto Shadowmoon Valley D/0 39.20,49.10 < 20 |noway |c |or |next "route_1"
Use your Fishing skill to fish in the water |cast Fishing##131474
map Shadowmoon Valley D/0
path follow smart; loop off; ants curved; dist 20
path	52.80,70.70	52.30,68.30	52.50,63.70
path	51.70,61.60	50.00,60.00	48.80,56.60
path	49.00,53.70	46.90,49.50	45.20,49.40
path	43.10,49.60	41.60,47.90	39.20,49.10
|goldcollect 464 Blind Lake Sturgeon Flesh##109140 |or
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Fat Sleeper Flesh/Crescent Saberfish Flesh",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq=35},
description="\nThis guide will walk you through fishing Fat Sleeper Flesh and Crescent Saberfish Flesh from open water.",
items={{109139,624},{109137,172}},
maps={"Nagrand D"},
},[[
step
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from the shore here |goto Nagrand D/0 72.80,27.20
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your fish by right-clicking the fish in your inventory
|goldcollect 624 Fat Sleeper Flesh##109139
|goldcollect 172 Crescent Saberfish Flesh##109137
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Fat Sleeper Flesh",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq=35},
description="\nThis guide will walk you through fishing Fat Sleeper Flesh fromFat Sleeper Schools.",
items={{109139,776}},
maps={"Nagrand D"},
},[[
step
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Follow the path, fishing at any pools
Use your Fishing skill to fish in the water |cast Fishing##131474
map Nagrand D/0
path follow smart; loop on; ants curved; dist 20
path	73.60,25.00	73.50,21.40	74.20,19.30
path	73.00,14.90	71.70,15.00	70.00,16.70
path	68.30,15.40	67.50,16.80	67.80,19.30
path	66.30,20.20	67.00,24.90	68.70,24.00
path	70.20,26.20	71.30,27.70	73.40,27.60
|goldcollect 776 Fat Sleeper Flesh##109139
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Fire Ammonite Tentacle/Crescent Saberfish Flesh",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq=10},
description="\nThis guide will walk you through fishing Fire Ammonite Tentacle and Crescent Saberfish Flesh from open water.",
items={{109141,784},{109137,192}},
maps={"Frostfire Ridge"},
},[[
step
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from the shore here |goto Frostfire Ridge/0 50.00,59.20
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your fish by right-clicking the fish in your inventory
|goldcollect 784 Fire Ammonite Tentacle##109141
|goldcollect 192 Crescent Saberfish Flesh##109137
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Jawless Skulker Flesh/Crescent Saberfish Flesh",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq=15},
description="\nThis guide will walk you through fishing Jawless Skulker Flesh and Crescent Saberfish Flesh from open water.",
items={{109138,844},{109137,192}},
maps={"Gorgrond"},
},[[
step
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from the shore here |goto Gorgrond/0 64.10,53.60
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your fish by right-clicking the fish in your inventory
|goldcollect 844 Jawless Skulker Flesh##109138
|goldcollect 192 Crescent Saberfish Flesh##109137
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Sea Scorpion Segment/Crescent Saberfish Flesh",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq=10},
description="\nThis guide will walk you through fishing Sea Scorpion Segment and Crescent Saberfish Flesh from open water.",
items={{109142,856},{109137,96}},
maps={"Shadowmoon Valley D"},
},[[
step
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Fish from atop this mushroom |goto Shadowmoon Valley D/0 34.10,75.60
Use your Fishing skill to fish in the water |cast Fishing##131474
Fillet your fish by right-clicking the fish in your inventory
|goldcollect 856 Sea Scorpion Segment##109142
|goldcollect 96 Crescent Saberfish Flesh##109137
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Sea Scorpion Segment",{
meta={goldtype="route",skillreq={draenor_fishing=1},levelreq=30},
description="\nThis guide will walk you through fishing Sea Scorpion Segment from Sea Scorpion Schools.",
items={{109142,932}},
maps={"Spires of Arak"},
},[[
step
label "route_1"
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Follow the path, fishing at any pools |goto Spires of Arak/0 56.20,93.50 < 20 |noway |c |next "route_2" |or
Use your Fishing skill to fish in the water |cast Fishing##131474
map Spires of Arak/0
path follow smart; loop off; ants curved; dist 20
path	30.50,38.40	32.60,41.70	29.90,44.80
path	32.90,46.60	32.10,52.50	32.40,56.30
path	34.50,56.10	36.00,62.90	38.70,59.80
path	38.40,63.80	41.70,64.60	46.50,73.00
path	48.70,77.40	50.50,80.60	52.40,81.50
path	52.80,84.60	53.70,90.20	56.20,93.50
|goldcollect 932 Sea Scorpion Segment##109142 |next "Sell" |or
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_2"
Use your Worm Supreme lure |use Worm Supreme##118391
|tip You can buy this cheap from the auction house or get it randomly fishing in Draenor.
Follow the path, fishing at any pools |goto Spires of Arak/0 30.50,38.40 < 20 |noway |c |next "route_1" |or
Use your Fishing skill to fish in the water |cast Fishing##131474
map Spires of Arak/0
path follow smart; loop off; ants curved; dist 20
path	56.20,93.50	53.70,90.20	52.80,84.60
path	52.40,81.50	50.50,80.60	48.70,77.40
path	46.50,73.00	41.70,64.60	38.40,63.80
path	38.70,59.80	36.00,62.90	34.50,56.10
path	32.40,56.30	32.10,52.50	32.90,46.60
path	29.90,44.80	32.60,41.70	30.50,38.40
|goldcollect 932 Sea Scorpion Segment##109142 |next "Sell" |or
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Blindweed",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{3818,68},{8839,332},{3358,56}},
maps={"Feralas"},
},[[
step
map Feralas
path	follow loose; loop on; ants curved; dist 25
path	52.90,15.40	53.90,7.30	49.70,4.90
path	48.50,6.80	50.10,9.90	47.70,11.90
path	44.00,12.70	47.90,15.50	46.50,20.10
path	49.40,23.90	49.30,24.90	51.50,13.50
_Follow_ the path, collecting any nodes you come across
|goldcollect 68 Fadeleaf##3818
|goldcollect 332 Blindweed##8839
|goldcollect 56 Khadgar's Whisker##3358
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Bruiseweed",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=10},
items={{3356,270},{2453,204},{3355,84}},
maps={"Northern Stranglethorn"},
},[[
step
map Northern Stranglethorn
path	follow loose; loop on; ants curved; dist 10
path	29.20,25.00	27.50,22.10	25.70,22.00
path	23.80,25.00	34.20,35.90	41.30,30.10
path	43.60,43.10	46.30,54.10	53.70,60.80
path	58.00,67.10	62.90,72.90	62.40,67.10
path	60.50,56.00	58.90,19.50
_Follow_ the path, collecting any nodes you come across
|goldcollect 270 Kingsblood##3356
|goldcollect 204 Bruiseweed##2453
|goldcollect 84 Wild Steelbloom##3355
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Dragon's Teeth",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{3819,84},{8838,16},{13464,12},{4625,4}},
maps={"Badlands"},
},[[
step
map Badlands
path	follow loose; loop on; ants curved; dist 10
path	27.00,61.30	29.80,51.70	42.00,42.50
path	38.80,49.70	36.10,54.70	32.10,57.10
_Follow_ the path, collecting any nodes you come across
|goldcollect 84 Dragon's Teeth##3819
|goldcollect 16 Sungrass##8838
|goldcollect 12 Golden Sansam##13464
|goldcollect 4 Firebloom##4625
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Dreamfoil/Black Lotus (15-30)",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{13463,280},{13464,24},{13465,20}},
maps={"Blasted Lands"},
},[[
step
talk Zidormi##88206
Tell her: "_Show me the Blasted Lands before the Invasion._" |complete ZGV.InPhase('Old Blasted Lands') |goto Blasted Lands 48.20,7.30
step
map Blasted Lands
path	follow loose; loop on; ants curved; dist 30
path	66.70,28.00	71.40,35.80	66.50,35.80
path	69.50,41.80	72.30,60.80	65.60,79.90
path	62.90,69.40	59.90,70.00	58.20,79.80
path	45.00,82.00	37.30,73.90	32.30,79.50
path	32.50,64.80	37.00,54.90	33.80,48.50
path	43.20,43.90	43.20,32.40	44.30,16.40
path	51.80,36.10	59.50,41.60	61.10,31.50
_Follow_ the path, collecting any nodes you come across
|goldcollect 280 Dreamfoil##13463
|goldcollect 24 Golden Sansam##13464
|goldcollect 20 Mountain Silversage##13465
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Dreamfoil/Black Lotus (15-30)",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{13463,280},{13464,24},{13465,20}},
maps={"Blasted Lands"},
},[[
step
map Blasted Lands
path	follow loose; loop on; ants curved; dist 30
path	66.70,28.00	71.40,35.80	66.50,35.80
path	69.50,41.80	72.30,60.80	65.60,79.90
path	62.90,69.40	59.90,70.00	58.20,79.80
path	45.00,82.00	37.30,73.90	32.30,79.50
path	32.50,64.80	37.00,54.90	33.80,48.50
path	43.20,43.90	43.20,32.40	44.30,16.40
path	51.80,36.10	59.50,41.60	61.10,31.50
_Follow_ the path, collecting any nodes you come across
|goldcollect 280 Dreamfoil##13463
|goldcollect 24 Golden Sansam##13464
|goldcollect 20 Mountain Silversage##13465
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Fadeleaf",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{3818,236},{3821,32},{8839,100},{3358,160}},
maps={"Feralas"},
},[[
step
map Feralas
path	follow loose; loop on; ants curved; dist 25
path	58.90,50.20	58.30,62.10	55.20,70.90
path	56.00,74.30	60.70,61.50	62.00,55.30
path	69.00,54.10	68.90,61.70	76.20,59.40
path	71.30,47.10	77.80,44.90	83.30,44.10
path	84.80,39.30	75.50,37.20	70.00,41.50
path	67.00,47.10
_Follow_ the path, collecting any nodes you come across
|goldcollect 236 Fadeleaf##3818
|goldcollect 32 Goldthorn##3821
|goldcollect 100 Blindweed##8839
|goldcollect 160 Khadgar's Whisker##3358
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Firebloom",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{4625,224},{8838,172}},
maps={"Searing Gorge"},
},[[
step
map Searing Gorge
path	follow smart; loop on; ants curved; dist 10
path	35.20,39.50	39.90,43.80	43.90,39.70
path	61.60,34.50	72.30,18.60	76.60,21.90
path	73.10,30.00	68.10,37.60	66.50,45.20
path	55.70,52.10	60.60,68.10	50.20,66.50
path	46.50,58.80	42.50,72.50	29.60,71.70
path	31.70,59.80	28.60,43.20
_Follow_ the path, collecting any nodes you come across
|goldcollect 224 Firebloom##4625
|goldcollect 172 Sungrass##8838
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Ghost Mushroom (Un'Goro Crater)",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{8845,152}},
maps={"Un'Goro Crater"},
},[[
step
map Un'Goro Crater
path follow loose; loop on; ants curved; dist 10
path	64.70,16.90	69.50,17.50	68.80,11.90
path	65.80,13.80
_Follow_ the path, collecting any nodes you come across
Enter the cave and collect any Ghost Mushrooms you see
|goldcollect 152 Ghost Mushroom##8845
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Ghost Mushroom (Zangarmarsh - Outland)",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=10},
items={{8845,108}},
maps={"Zangarmarsh"},
},[[
step
label "Farm 1"
Enter the cave and collect any Ghost Mushrooms you see
|goldcollect 108 Ghost Mushroom##8845 |goto Zangarmarsh/0 17.30,9.50
|goldtracker
When you have finished collecting Ghost Mushrooms from this area, click here |confirm |next "Farm 2"
Click here to sell items |confirm |next "Sell"
|next "Sell"
step
label "Farm 2"
Enter the cave and collect any Ghost Mushrooms you find
|goldcollect 108 Ghost Mushroom##8845 |goto Zangarmarsh/0 74.60,91.70
|goldtracker
When you have finished collecting Ghost Mushrooms from this area, click here |confirm |next "Farm 1"
Click here to sell items |confirm |next "Sell"
|next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Golden Sansam",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{13464,476},{13466,348}},
maps={"Swamp of Sorrows"},
},[[
step
map Swamp of Sorrows
path	follow loose; loop on; ants curved; dist 15
path	29.20,42.00	22.30,39.50	15.50,32.50
path	14.10,37.70	18.50,41.80	18.40,48.50
path	21.50,54.10	29.50,61.50	37.50,54.50
path	28.50,49.20	31.50,45.10	45.30,42.90
path	53.50,41.50	58.50,59.30	73.50,80.10
path	88.60,63.40	83.80,59.50	76.20,66.80
path	74.30,58.10	78.00,42.50	85.80,44.60
path	87.60,38.60	78.50,24.60	75.10,19.50
path	71.70,25.40	69.60,19.50	63.50,22.50
path	62.50,28.40	53.50,31.70	41.00,34.50
path	32.50,35.70
_Follow_ the path, collecting any nodes you come across
|goldcollect 476 Golden Sansam##13464
|goldcollect 348 Sorrowmoss##13466
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Grave Moss",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=10},
items={{3369,32}},
maps={"Duskwood"},
},[[
step
label "Farm 1"
map Duskwood
path	follow loose; loop on; ants curved; dist 15
path	16.50,48.50	14.90,43.50	18.00,39.60
path	22.50,35.00	24.50,37.80	22.50,47.00
_Follow_ the path, collecting any nodes you come across
|goldcollect 32 Grave Moss##3369
|goldtracker
Click here when you have finished farming this spot |confirm |next "Farm 2"
Click here to sell items |confirm
|next "Sell"
step
label "Farm 2"
map Duskwood
path	follow loose; loop on; ants curved; dist 15
path	78.80,68.60	81.50,68.10	81.80,70.70
path	79.70,73.50	78.20,70.70
_Follow_ the path, collecting any nodes you come across
|goldcollect 32 Grave Moss##3369
|goldtracker
Click here when you have finished farming this spot |confirm |next "Farm 1"
Click here to sell items |confirm
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Gromsblood",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{8846,368},{8831,48},{13464,184},{13463,64}},
maps={"Felwood"},
},[[
step
map Felwood
path	follow loose; loop on; ants curved; dist 25
path	51.90,81.90	56.30,88.10	50.70,84.40
path	42.40,80.50	41.80,73.00	38.30,71.80
path	40.80,67.00	36.50,60.30	38.90,56.30
path	38.70,42.40	41.10,37.50	43.40,34.80
path	40.80,30.80	41.30,21.80	45.80,16.50
path	46.90,26.10	52.70,21.00	63.70,20.70
path	53.20,29.60	49.70,34.80	44.70,35.90
path	43.10,43.10	42.70,50.10	41.10,59.50
path	45.50,67.50	46.60,74.80
_Follow_ the path, collecting any nodes you come across
|goldcollect 368 Gromsblood##8846
|goldcollect 48 Purple Lotus##8831
|goldcollect 184 Golden Sansam##13464
|goldcollect 64 Dreamfoil##13463
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Icecap",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{13467,404},{13465,44}},
maps={"Winterspring"},
},[[
step
map Winterspring/0
path	follow loose; loop on; ants curved; dist 25
path	62.40,51.30	63.90,54.30	66.40,57.10
path	65.90,65.40	64.20,69.00	60.60,73.00
path	64.30,77.50	61.20,79.70	63.90,80.00
path	60.50,85.90	57.10,82.00	58.10,69.50
path	53.80,64.70	56.30,62.30	58.60,64.30
path	62.20,61.50	59.20,55.10	54.20,59.70
path	47.40,58.20	44.50,58.50	43.70,55.30
path	39.00,55.80	34.20,57.10	27.50,55.90
path	24.20,58.00	24.00,49.80	27.70,49.50
path	45.00,51.30	48.30,53.00	51.60,54.30
path	54.30,51.50	50.00,48.10	52.50,42.60
path	57.10,39.30	56.00,34.90	54.80,29.60
path	52.00,33.50	46.70,30.20	46.30,19.50
path	45.20,14.80	50.20,19.20	52.80,23.00
path	55.40,23.70	58.90,22.50	57.00,29.30
path	61.20,31.90	65.40,30.60	65.30,38.60
path	66.70,45.00	57.00,45.70
_Follow_ the path, collecting any nodes you come across
|goldcollect 404 Icecap##13467
|goldcollect 44 Mountain Silversage##13465
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Khadgar's Whisker",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{8838,300},{3357,52},{3358,380}},
maps={"Eastern Plaguelands"},
},[[
step
map Eastern Plaguelands
path	follow loose; loop on; ants curved; dist 25
path	72.70,56.60	72.00,65.50	61.80,63.80
path	60.50,67.50	68.30,74.80	62.70,74.50
path	56.50,79.70	50.50,68.20	40.70,72.80
path	35.50,76.80	26.10,76.70	22.80,75.50
path	19.90,78.90	17.20,71.90	10.20,71.70
path	16.50,61.50	19.50,64.70	26.50,63.20
path	37.10,64.50	41.50,61.80	43.90,55.50
path	51.70,45.60	44.00,34.30	46.30,21.30
path	52.90,14.80	62.60,24.00	70.00,31.00
path	60.00,35.00	65.80,37.80	66.20,44.80
_Follow_ the path, collecting any nodes you come across
|goldcollect 300 Sungrass##8838
|goldcollect 52 Liferoot####3357
|goldcollect 380 Khadgar's Whisker##3358
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Kingsblood",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=10},
items={{3356,448},{2453,28},{3355,28}},
maps={"Northern Stranglethorn"},
},[[
step
map Northern Stranglethorn
path	follow loose; loop on; ants curved; dist 25
path	39.90,23.00	34.20,20.70	29.80,30.50
path	37.70,27.50	38.50,36.60	35.30,43.50
path	42.10,47.00	41.10,51.50	46.10,50.00
path	48.50,44.10	53.80,47.50	50.10,55.90
path	55.80,56.50	56.50,63.80	63.20,61.50
path	60.90,51.50	61.30,40.20	63.50,34.90
path	61.50,27.30	55.90,31.10	52.70,22.10
path	48.10,33.60
_Follow_ the path, collecting any nodes you come across
|goldcollect 448 Kingsblood##3356
|goldcollect 28 Bruiseweed##2453
|goldcollect 28 Wild Steelbloom##3355
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Liferoot",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{3357,336},{8838,184},{3358,92}},
maps={"Eastern Plaguelands"},
},[[
step
map Eastern Plaguelands/0
path	follow loose; loop on; ants curved; dist 25
path	65.90,45.50	71.00,51.70	66.30,61.60
path	60.70,75.60	54.00,69.70	52.90,59.20
path	45.70,64.10	45.50,43.10	58.50,46.70
path	65.40,26.40	67.50,31.50
_Follow_ the path, collecting any nodes you come across
|goldcollect 336 Liferoot##3357
|goldcollect 184 Sungrass##8838
|goldcollect 92 Khadgar's Whisker##3358
|goldtracker
Click here to sell items |confirm always
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Mageroyal",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=7},
items={{785,452},{2452,140},{2450,388},{2453,20}},
maps={"Hillsbrad Foothills"},
},[[
step
map Hillsbrad Foothills
path	follow loose; loop on; ants curved; dist 10
path	56.50,34.50	56.20,38.40	61.70,49.20
path	61.10,60.80	65.60,52.20	73.80,59.20
path	67.80,66.80	61.50,65.90	66.10,72.10
path	63.70,76.30	56.10,70.60	48.80,61.80
path	41.90,70.50	35.50,74.00	34.90,69.50
path	30.30,69.50	31.60,62.50	34.70,54.40
path	31.10,46.70	37.50,39.80	39.30,48.30
path	44.50,50.30	49.20,47.60	50.10,42.50
_Follow_ the path, collecting any nodes you come across
|goldcollect 452 Mageroyal##785
|goldcollect 140 Swiftthistle##2452
|goldcollect 388 Briarthorn##2450
|goldcollect 20 Bruiseweed##2453
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Mountain Silversage",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{13467,112},{13465,280}},
maps={"Winterspring"},
},[[
step
map Winterspring/0
path	follow loose; loop on; ants curved; dist 10
path	63.20,48.80	66.90,52.70	67.70,69.70
path	64.30,70.70	66.00,73.10	66.70,84.00
path	63.90,83.10	62.20,80.20	56.00,78.80
path	55.20,73.20	60.30,70.30	61.10,67.00
path	54.00,69.30	52.00,64.10	47.20,61.50
path	43.00,53.20	42.20,57.10	34.10,59.80
path	26.90,58.30	24.60,62.80	22.00,62.80
path	22.90,58.70	24.80,45.70	27.60,47.70
path	35.60,47.10	40.70,46.50	43.80,47.10
path	48.80,44.30	55.30,44.70	46.20,33.20
path	44.50,24.30	44.80,19.50	44.90,13.50
path	48.50,14.50	50.40,18.30	55.30,19.50
path	57.60,17.80	60.50,22.90	60.90,28.00
path	65.90,25.60	67.50,35.40	69.20,44.90
path	60.60,39.10	58.90,45.50
_Follow_ the path, collecting any nodes you come across
|goldcollect 112 Icecap##13467
|goldcollect 280 Mountain Silversage##13465
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Purple Lotus/Wildvine",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{8153,12},{8831,144},{13463,36},{8846,256},{13464,220}},
maps={"Felwood"},
},[[
step
map Felwood
path	follow loose; loop on; ants curved; dist 10
path	58.10,86.50	38.00,68.00	40.50,66.30
path	41.80,62.50	39.70,45.10	42.60,36.20
path	49.60,31.60	46.10,44.90	43.80,61.70
path	45.40,69.00
_Follow_ the path, collecting any nodes you come across
|goldcollect 12 Wildvine##8153
|goldcollect 144 Purple Lotus##8831
|goldcollect 36 Dreamfoil##13463
|goldcollect 256 Gromsblood##8846
|goldcollect 220 Golden Sansam##13464
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Sorrowmoss",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{13466,440},{13464,300}},
maps={"Swamp of Sorrows"},
},[[
step
map Swamp of Sorrows/0
path	follow loose; loop on; ants curved; dist 25
path	26.60,38.10	27.60,45.20	30.80,54.60
path	34.60,47.50	35.90,53.50	41.30,51.10
path	47.30,44.50	53.30,43.50	56.00,58.40
path	59.50,56.50	59.10,45.60	61.20,37.90
path	71.60,29.70	76.50,35.60	85.00,43.50
path	85.90,38.00	81.20,31.00	76.80,16.50
path	67.80,21.80	61.60,25.70	55.00,33.50
path	48.90,33.10	37.20,33.80	29.60,38.10
_Follow_ the path, collecting any nodes you come across
|goldcollect 440 Sorrowmoss##13466
|goldcollect 300 Golden Sansam##13464
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Stranglekelp",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{3820,360}},
maps={"Thousand Needles"},
},[[
step
map Thousand Needles/0
path	follow loose; loop on; ants curved; dist 25
path	75.30,78.90	70.70,75.60	69.80,65.30
path	61.90,60.60	59.50,55.00	51.60,55.80
path	43.90,59.40	32.90,51.50	16.90,36.70
path	9.00,19.20	8.80,12.00	13.50,16.00
path	15.80,23.50	23.10,32.40	23.10,22.20
path	32.50,25.50	30.80,39.30	36.60,44.60
path	37.00,36.50	36.40,28.20	41.20,35.90
path	45.60,43.50	48.10,47.60	53.20,44.60
path	56.60,48.80	63.60,47.20	72.10,56.10
path	83.90,59.40	88.00,66.20	81.20,68.00
_Follow_ the path, collecting any nodes you come across
|goldcollect 360 Stranglekelp##3820
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Stranglekelp (Speedbarge Diving Helm)",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{3820,460}},
maps={"Thousand Needles"},
},[[
step
map Thousand Needles/0
path	follow loose; loop on; ants curved; dist 25
path	75.30,78.90	70.70,75.60	69.80,65.30
path	61.90,60.60	59.50,55.00	51.60,55.80
path	43.90,59.40	32.90,51.50	16.90,36.70
path	9.00,19.20	8.80,12.00	13.50,16.00
path	15.80,23.50	23.10,32.40	23.10,22.20
path	32.50,25.50	30.80,39.30	36.60,44.60
path	37.00,36.50	36.40,28.20	41.20,35.90
path	45.60,43.50	48.10,47.60	53.20,44.60
path	56.60,48.80	63.60,47.20	72.10,56.10
path	83.90,59.40	88.00,66.20	81.20,68.00
_Follow_ the path, collecting any nodes you come across
|goldcollect 460 Stranglekelp##3820
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Sungrass",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=15},
items={{8838,398},{3357,54},{3358,317}},
maps={"Eastern Plaguelands"},
},[[
step
map Eastern Plaguelands
path	follow loose; loop on; ants curved; dist 25
path	73.70,57.10	65.00,73.70	61.80,63.00
path	54.80,67.00	50.60,72.60	45.50,71.30
path	39.50,70.60	26.70,75.50	15.50,71.10
path	14.50,62.50	19.80,63.90	33.60,62.10
path	37.50,62.80	44.60,57.50	44.80,54.50
path	50.80,46.30	42.80,32.80	44.80,24.00
path	51.30,28.60	58.60,29.50	63.50,28.20
path	64.90,36.60	64.80,45.00	58.90,50.70
path	62.60,56.00	70.30,47.10
_Follow_ the path, collecting any nodes you come across
|goldcollect 398 Sungrass##8838
|goldcollect 54 Liferoot####3357
|goldcollect 317 Khadgar's Whisker##3358
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Swiftthistle/Briarthorn",{
meta={goldtype="route",skillreq={herbalism=1},levelreq=7},
items={{785,264},{2452,160},{2450,320},{2453,64}},
maps={"Hillsbrad Foothills"},
},[[
step
map Hillsbrad Foothills
path	follow loose; loop on; ants curved; dist 10
path	62.30,45.50	69.10,55.80	74.90,59.10
path	65.50,75.50	57.70,69.50	63.00,59.90
path	58.40,57.80	51.40,62.90	42.50,68.50
path	30.60,68.70	32.50,60.50	45.20,50.60
path	37.50,44.80	35.60,29.50	48.20,11.10
path	53.90,17.00	57.50,25.00	54.70,39.80
_Follow_ the path, collecting any nodes you come across
|goldcollect 264 Mageroyal##785
|goldcollect 160 Swiftthistle##2452
|goldcollect 320 Briarthorn##2450
|goldcollect 64 Bruiseweed##2453
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Wildvine (Kill Only)",{
meta={goldtype="route",levelreq=10},
items={{8153,3},{4306,656},{2592,180},{4338,8}},
maps={"Northern Stranglethorn"},
},[[
step
map Northern Stranglethorn
path	follow loose; loop on; ants curved; dist 10
path	55.80,66.60	57.40,71.00	59.80,72.60
path	63.80,69.40	62.00,67.40	58.40,68.40
kill Skullsplitter Witch Doctor##670+, Skullsplitter Hunter##669+, Skullsplitter Scout##782+, Skullsplitter Berserker##783+, Skullsplitter Spiritchaser##672+, Skullsplitter Headhunter##781+
|goldcollect 3 Wildvine##8153
|goldcollect 656 Silk Cloth##4306
|goldcollect 180 Wool Cloth##2592
|goldcollect 8 Mageweave Cloth##4338
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Ancient Lichen",{
meta={goldtype="route",skillreq={outland_herbalism=1},levelreq=15},
items={{22790,122}},
maps={"Mana-Tombs"},
},[[
step
map Mana-Tombs
path	follow loose; loop off; ants curved; dist 20
path	41.10,34.80	46.60,33.40	61.00,18.80
path	57.60,36.60	63.50,35.50	60.60,57.50
path	52.50,63.60	58.50,69.70	62.60,85.10
path	55.50,81.60	54.70,89.70	50.10,83.70
path	39.00,85.10	30.50,56.90
_Follow_ the path, collecting any nodes you come across
|goldcollect 122 Ancient Lichen##22790
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Dreaming Glory",{
meta={goldtype="route",skillreq={outland_herbalism=1},levelreq=15},
items={{22786,168},{22785,80},{22575,76},{22793,12},{22794,4}},
maps={"Nagrand"},
},[[
step
map Nagrand/0
path	follow loose; loop on; ants curved; dist 20
path	74.80,72.10	75.20,62.50	68.70,65.30
path	71.80,55.00	67.80,51.50	59.70,62.20
path	58.70,57.80	54.40,60.00	55.30,53.80
path	65.60,40.00	66.80,35.50	62.40,34.20
path	52.90,20.00	49.30,19.50	40.50,34.50
path	35.80,18.30	29.30,31.30	15.00,33.90
path	11.60,39.60	7.10,43.60	18.90,53.60
path	24.80,48.80	30.10,47.70	25.60,59.00
path	29.10,66.30	31.00,72.10	26.60,73.70
path	30.30,81.00	40.30,83.50	41.90,80.20
path	42.70,73.20	37.10,61.00	34.30,55.70
path	39.10,45.90	42.80,51.50	40.50,59.60
path	50.50,77.00	60.40,81.60	62.70,72.60
_Follow_ the path, collecting any nodes you come across
|goldcollect 168 Dreaming Glory##22786
|goldcollect 80 Felweed##22785
|goldcollect 76 Mote of Life##22575
|goldcollect 12 Mana Thistle##22793
|goldcollect 4 Fel Lotus##22794
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Felweed",{
meta={goldtype="route",skillreq={outland_herbalism=1},levelreq=10},
items={{22785,260},{13464,60},{13463,64},{13465,32},{22786,8},{22575,12}},
maps={"Hellfire Peninsula"},
},[[
step
map Hellfire Peninsula/0
path	follow loose; loop on; ants curved; dist 25
path	47.70,46.50	51.60,52.50	48.80,59.10
path	45.20,65.60	56.10,71.60	61.50,69.30
path	66.70,77.10	69.20,65.90	66.90,51.30
path	72.10,53.50	73.40,37.80	63.10,37.90
path	65.00,31.80	55.80,31.00	53.70,29.40
path	38.60,35.10	29.50,41.00	17.30,44.60
path	13.50,38.70	13.10,46.00	13.50,57.10
path	23.60,55.00	22.90,67.50	32.10,60.80
path	40.00,65.00	42.20,51.20
_Follow_ the path, collecting any nodes you come across
|goldcollect 260 Felweed##22785
|goldcollect 60 Golden Sansam##13464
|goldcollect 64 Dreamfoil##13463
|goldcollect 32 Mountain Silversage##13465
|goldcollect 8 Dreaming Glory##22786
|goldcollect 12 Mote of Life##22575
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Mana Thistle",{
meta={goldtype="route",skillreq={outland_herbalism=1},levelreq=15},
items={{22793,76},{22786,104},{22575,20}},
maps={"Shadowmoon Valley","Terokkar Forest"},
},[[
step
label "Path 1"
map Terokkar Forest/0
path	follow loose; loop on; ants curved; dist 20
path	27.10,10.50	22.10,6.50	20.20,14.20
path	23.90,10.50
_Follow_ the path, collecting any nodes you come across
|goldcollect 76 Mana Thistle##22793
|goldcollect 104 Dreaming Glory##22786
|goldcollect 20 Mote of Life##22575
|goldtracker
When you have finished with this area, click here to proceed to another |confirm |next "Path 2"
Click here to sell items |confirm |next "Sell"
step
label "Path 2"
map Terokkar Forest/0
path	follow loose; loop on; ants curved; dist 20
path	62.40,73.60	65.70,79.20	68.70,85.70
path	72.20,88.50	74.90,87.50	72.30,82.00
path	69.30,74.60	62.40,73.60
_Follow_ the path, collecting any nodes you come across
|goldcollect 76 Mana Thistle##22793
|goldcollect 104 Dreaming Glory##22786
|goldcollect 20 Mote of Life##22575
|goldtracker
When you have finished with this area, click here to proceed to another |confirm |next "Path 3"
Click here to sell items |confirm |next "Sell"
step
label "Path 3"
map Shadowmoon Valley
path	follow loose; loop on; ants curved; dist 20
path	65.80,80.60	70.20,79.10	74.30,80.80
path	79.20,87.50	77.50,88.40	74.30,88.90
path	71.10,88.30	68.30,87.50	70.20,83.90
path	72.00,85.90	74.60,86.40
_Follow_ the path, collecting any nodes you come across
|goldcollect 76 Mana Thistle##22793
|goldcollect 104 Dreaming Glory##22786
|goldcollect 20 Mote of Life##22575
|goldtracker
When you have finished with this area, click here to proceed to another |confirm |next "Path 1"
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Netherbloom",{
meta={goldtype="route",skillreq={outland_herbalism=1},levelreq=25},
items={{22791,212},{22786,84},{22576,24},{22794,8},{22575,10}},
maps={"Netherstorm"},
},[[
step
map Netherstorm
path	follow loose; loop on; ants curved; dist 20
path	31.50,51.40	25.60,63.50	19.50,67.70
path	20.30,77.10	40.20,77.20	46.20,82.60
path	48.00,86.90	58.90,88.80	61.40,79.40
path	51.60,75.70	46.00,72.10	34.50,55.80
path	40.10,52.90	50.20,69.00	67.10,60.70
path	50.80,54.80	46.50,47.10	55.00,39.90
path	58.50,47.20	62.70,50.30	73.40,40.50
path	73.20,35.20	62.10,30.50	55.60,31.60
path	49.80,35.90	48.80,25.50	57.10,24.30
path	55.50,17.30	49.70,17.40	48.90,12.50
path	44.90,19.80	42.50,16.20	39.50,15.70
path	35.70,19.80	32.10,29.20	38.50,42.40
path	31.10,38.10	23.50,35.40	22.90,44.10
path	30.20,43.30
_Follow_ the path, collecting any nodes you come across
|goldcollect 212 Netherbloom##22791
|goldcollect 84 Dreaming Glory##22786
|goldcollect 24 Mote of Mana##22576
|goldcollect 8 Fel Lotus##22794
|goldcollect 10 Mote of Life##22575
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Nightmare Vine",{
meta={goldtype="route",skillreq={outland_herbalism=1},levelreq=25},
items={{22792,168},{22794,4},{22785,116},{22789,52},{22786,32}},
maps={"Shadowmoon Valley"},
},[[
step
map Shadowmoon Valley
path	follow smart; loop on; ants curved; dist 20
path	42.50,59.00	43.40,65.10	43.30,72.40
path	47.70,69.60	47.30,51.70	51.50,59.00
path	51.40,66.40	56.90,73.90	61.20,68.10
path	57.80,57.20	62.00,56.20	65.20,61.50
path	70.60,60.70	68.50,58.00	67.90,47.20
path	72.10,47.50	71.50,40.80	66.30,39.30
path	58.50,45.30	49.90,33.90	53.10,33.50
path	59.60,37.30	67.10,28.90	66.00,21.80
path	58.00,23.60	55.60,16.80	52.50,15.60
path	52.50,21.60	45.50,15.10	42.30,38.20
path	38.30,32.10	31.20,34.60	24.90,29.60
path	22.00,34.70	22.00,40.80	29.70,47.80
path	27.20,52.60	31.60,53.80
_Follow_ the path, collecting any nodes you come across
|goldcollect 168 Nightmare Vine##22792
|goldcollect 4 Fel Lotus##22794
|goldcollect 116 Felweed##22785
|goldcollect 52 Terocone##22789
|goldcollect 32 Dreaming Glory##22786
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Ragveil",{
meta={goldtype="route",skillreq={outland_herbalism=1},levelreq=10},
items={{22787,180},{22785,44},{22786,16},{24401,48},{13464,60},{13463,44},{22575,48},{8839,20}},
maps={"Zangarmarsh"},
},[[
step
map Zangarmarsh
path	follow loose; loop on; ants curved; dist 20
path	78.80,68.00	82.40,70.40	83.30,76.50
path	83.10,80.70	85.10,83.80	86.10,86.30
path	83.70,89.70	79.80,84.90	73.30,84.80
path	68.70,80.30	70.50,79.40	70.90,72.40
path	69.20,66.20	64.60,61.80	61.00,68.80
path	57.20,69.10	54.40,69.00	50.00,63.30
path	43.60,60.10	37.90,56.60	31.40,61.50
path	25.70,56.90	20.10,60.80	17.40,63.30
path	13.00,65.00	13.30,61.50	9.80,61.30
path	12.80,57.20	17.10,54.60	22.70,52.30
path	25.70,49.00	26.10,41.20	28.10,40.80
path	27.00,32.10	24.20,28.60	24.10,22.70
path	29.10,24.40	37.70,28.40	41.70,33.80
path	46.90,33.50	57.40,35.40	59.00,36.00
path	61.20,35.40	69.90,39.50	73.90,33.50
path	75.00,30.70	80.90,32.40	84.70,36.40
path	85.60,42.30	81.70,47.70	80.20,58.50
_Follow_ the path, collecting any nodes you come across
|goldcollect 180 Ragveil##22787
|goldcollect 44 Felweed##22785
|goldcollect 16 Dreaming Glory##22786
|goldcollect 48 Unidentified Plant Parts##24401
|goldcollect 60 Golden Sansam##13464
|goldcollect 44 Dreamfoil##13463
|goldcollect 48 Mote of Life##22575
|goldcollect 20 Blindweed##8839
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Terocone",{
meta={goldtype="route",skillreq={outland_herbalism=1},levelreq=15},
items={{22789,200},{22785,100},{22786,28},{22575,52}},
maps={"Terokkar Forest"},
},[[
step
map Terokkar Forest
path	follow loose; loop on; ants curved; dist 20
path	37.10,29.20	38.70,39.10	31.90,43.80
path	25.20,55.50	18.00,69.40	18.90,77.60
path	23.10,67.50	25.60,79.20	30.90,80.40
path	49.60,83.50	53.90,69.60	56.50,58.30
path	61.30,59.50	55.30,33.80	66.60,47.50
path	66.90,39.80	71.30,30.10	65.90,30.90
path	61.20,23.60	56.30,29.50	48.00,24.50
path	40.70,23.50	42.70,32.20
_Follow_ the path, collecting any nodes you come across
|goldcollect 200 Terocone##22789
|goldcollect 100 Felweed##22785
|goldcollect 28 Dreaming Glory##22786
|goldcollect 52 Mote of Life##22575
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Adder's Tongue",{
meta={goldtype="route",skillreq={northrend_herbalism=1},levelreq=20},
items={{37704,232},{36903,416},{36904,136},{36901,112},{37921,96},{36908,20}},
maps={"Sholazar Basin"},
},[[
step
map Sholazar Basin
path	follow loose; loop on; ants curved; dist 20
path	22.60,59.10	21.60,55.10	25.70,55.90
path	27.60,49.50	30.00,53.10	28.50,60.10
path	29.80,66.80	31.90,70.10	34.70,70.10
path	34.60,66.70	35.50,58.70	41.20,58.80
path	43.50,59.50	46.70,55.50	46.50,49.20
path	51.30,53.30	53.50,44.00	56.50,31.50
path	62.70,33.90	58.80,38.00	57.00,45.60
path	55.60,49.90	56.60,54.50	52.30,56.80
path	46.30,66.50	41.90,65.10	41.80,77.00
path	41.90,86.50	39.60,87.10	37.50,83.30
path	35.20,83.40	35.20,87.10	28.80,84.80
path	28.50,79.50	26.60,77.60	30.40,75.70
path	26.30,69.10
_Follow_ the path, collecting any nodes you come across
|goldcollect 232 Crystallized Life##37704
|goldcollect 416 Adder's Tongue##36903
|goldcollect 136 Tiger Lily##36904
|goldcollect 112 Goldclover##36901
|goldcollect 96 Deadnettle##37921
|goldcollect 20 Frost Lotus##36908
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Fire Leaf",{
meta={goldtype="route",skillreq={northrend_herbalism=1},levelreq=10},
items={{39970,330},{37702,72},{36908,12},{36901,30},{37921,12}},
maps={"Borean Tundra"},
},[[
step
map Borean Tundra
path	follow smart; loop on; ants curved; dist 15
path	58.70,28.60	59.20,20.30	58.20,15.80
path	60.80,14.00	66.20,19.00	67.30,15.40
path	68.30,23.70	73.70,24.20	69.80,29.70
path	73.30,30.80	71.80,34.20	75.00,39.90
path	72.30,41.20	68.70,38.40	67.50,34.70
path	65.60,36.70	62.10,40.60	59.50,41.90
path	58.50,39.00	60.30,30.80
_Follow_ the path, collecting any nodes you come across
|goldcollect 330 Fire Leaf##39970
|goldcollect 72 Crystallized Fire##37702
|goldcollect 12 Frost Lotus##36908
|goldcollect 30 Goldclover##36901
|goldcollect 12 Deadnettle##37921
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Goldclover/Deadnettle",{
meta={goldtype="route",skillreq={northrend_herbalism=1},levelreq=10},
items={{36901,344},{36904,16},{37921,68},{37704,108},{36908,12}},
maps={"Howling Fjord"},
},[[
step
map Howling Fjord/0
path	follow loose; loop on; ants curved; dist 20
path	54.90,19.70	50.20,16.60	48.20,18.10
path	48.70,21.20	48.60,30.00	44.60,29.70
path	40.90,31.20	29.20,12.00	26.50,8.00
path	25.20,11.80	26.90,14.60	29.00,22.30
path	27.10,29.60	34.80,34.10	37.00,39.90
path	37.00,44.90	34.90,46.20	35.70,53.60
path	38.90,54.30	40.90,40.20	43.40,44.10
path	51.10,41.80	51.00,48.30	45.90,50.10
path	46.40,54.30	45.00,59.50	52.50,60.50
path	48.70,62.70	46.80,71.60	49.20,72.10
path	53.40,76.50	60.00,76.80	60.50,81.30
path	62.60,80.50	65.80,72.50	67.10,74.90
path	69.50,74.50	70.60,66.00	76.40,67.90
path	76.70,63.90	69.90,51.10	70.10,47.30
path	72.50,47.10	75.50,50.80	79.20,49.70
path	80.50,46.20	76.30,42.80	72.80,42.30
path	70.30,40.60	66.50,33.50	70.50,32.50
path	69.80,19.20	65.80,26.80	61.80,28.50
path	56.50,21.30
_Follow_ the path, collecting any nodes you come across
|goldcollect 344 Goldclover##36901
|goldcollect 16 Tiger Lily##36904
|goldcollect 68 Deadnettle##37921
|goldcollect 108 Crystallized Life##37704
|goldcollect 12 Frost Lotus##36908
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Icethorn/Lichbloom",{
meta={goldtype="route",skillreq={northrend_herbalism=1},levelreq=25},
items={{36905,336},{36906,280},{37704,128},{36908,12}},
maps={"The Storm Peaks"},
},[[
step
map The Storm Peaks
path	follow loose; loop on; ants curved; dist 20
path	39.50,88.90	33.50,89.50	32.50,86.90
path	31.40,83.10	35.70,82.20	37.30,74.30
path	32.80,74.50	29.10,68.00	27.00,72.40
path	24.60,72.50	26.70,67.60	27.80,60.00
path	25.40,58.60	22.60,62.80	21.60,55.70
path	23.90,55.40	30.40,50.50	34.60,40.40
path	40.90,38.00	44.80,40.50	39.60,44.80
path	35.50,43.00	35.70,47.10	38.80,48.50
path	36.80,64.30	41.20,62.50	45.20,55.00
path	48.60,60.90	47.00,66.70	56.80,63.10
path	56.50,56.60	56.00,50.90	59.70,47.80
path	59.90,45.00	65.60,40.60	65.90,43.80
path	64.10,54.10	68.60,47.70	72.90,49.80
path	70.30,54.90	72.50,65.00	65.30,59.30
path	61.30,61.90	58.60,63.50	56.70,66.00
path	56.90,71.00	52.20,69.50	48.30,77.40
path	43.60,77.00	41.50,79.20	39.90,76.30
path	38.40,80.80
_Follow_ the path, collecting any nodes you come across
|goldcollect 336 Lichbloom##36905
|goldcollect 280 Icethorn##36906
|goldcollect 128 Crystallized Life##37704
|goldcollect 12 Frost Lotus##36908
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Talandra's Rose",{
meta={goldtype="route",skillreq={northrend_herbalism=1},levelreq=20},
items={{36907,344},{37921,120},{36908,12},{37704,80}},
maps={"Zul'Drak"},
},[[
step
map Zul'Drak
path	follow loose; loop on; ants curved; dist 20
path	20.30,85.10	22.60,78.80	27.10,76.80
path	31.60,87.20	39.30,86.20	38.60,80.20
path	35.20,69.50	28.70,68.80	29.40,64.30
path	37.10,62.40	40.20,69.80	44.30,74.90
path	45.00,82.00	52.90,82.60	58.20,81.50
path	56.70,71.30	50.70,62.40	44.40,65.00
path	42.60,54.00	44.60,51.00	44.30,43.00
path	37.50,42.00	29.80,41.50	29.70,57.10
path	22.40,50.50
_Follow_ the path, collecting any nodes you come across
|goldcollect 344 Talandra's Rose##36907
|goldcollect 120 Deadnettle##37921
|goldcollect 12 Frost Lotus##36908
|goldcollect 80 Crystallized Life##37704
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Tiger Lily/Deadnettle",{
meta={goldtype="route",skillreq={northrend_herbalism=1},levelreq=20},
items={{36904,388},{36903,128},{36908,20},{37921,152},{37704,208},{36901,24}},
maps={"Sholazar Basin"},
},[[
step
map Sholazar Basin
path	follow loose; loop on; ants curved; dist 20
path	25.30,59.00	22.70,61.50	29.10,63.70
path	32.70,64.50	46.20,63.10	48.50,68.80
path	46.20,72.80	43.60,75.50	47.20,75.50
path	51.60,86.50	54.50,85.60	59.70,86.50
path	57.70,83.30	69.40,68.50	69.60,57.40
path	63.90,48.90	44.60,49.10	48.50,51.60
path	50.20,55.90	50.10,65.00	47.90,60.10
path	32.40,60.40
_Follow_ the path, collecting any nodes you come across
|goldcollect 388 Tiger Lily##36904
|goldcollect 128 Adder's Tongue##36903
|goldcollect 20 Frost Lotus##36908
|goldcollect 152 Deadnettle##37921
|goldcollect 208 Crystallized Life##37704
|goldcollect 24 Goldclover##36901
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Azshara's Veil",{
meta={goldtype="route",skillreq={cataclysm_herbalism=1},levelreq=30},
items={{52985,332},{52984,112},{52329,152},{63122,12}},
maps={"Shimmering Expanse"},
},[[
step
map Shimmering Expanse
path	follow smart; loop off; ants curved; dist 10
path	61.20,87.50	60.80,82.80	58.10,81.80
path	53.20,79.70	50.20,78.20	48.10,80.90
path	38.90,73.50	39.20,69.10	37.50,64.00
path	37.60,59.50	32.90,54.40	41.00,53.70
path	47.40,60.90	53.80,66.10	58.00,69.50
path	61.60,69.00	64.00,67.20	67.30,51.20
path	64.50,44.60	61.80,38.90	52.60,44.90
path	46.00,34.50	42.80,32.10	40.60,31.40
path	40.40,36.50	41.60,39.60
Completing the quest "Sea Legs" will allow you to move 60% faster and grant Underwater Breathing while in Vashj'ir.
Completing the quest "The Abyssal Ride" will grant you the _Vashj'ir Seahorse_ mount, increasing underwater speed while mounted by 450%
_Follow_ the path, collecting any nodes you come across
|goldcollect 332 Azshara's Veil##52985
|goldcollect 112 Stormvine##52984
|goldcollect 152 Volatile Life##52329
|goldcollect 12 Lifegiving Seed##63122
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Heartblossom/Cinderbloom",{
meta={goldtype="route",skillreq={cataclysm_herbalism=1},levelreq=30},
items={{52986,168},{52983,180},{52329,88},{63122,8}},
maps={"Deepholm"},
},[[
step
map Deepholm
path	follow smart; loop on; ants curved; dist 10
path	45.50,28.50	42.00,29.40	39.50,33.50
path	37.60,30.90	32.40,30.10	29.80,34.80
path	26.90,39.00	24.50,35.10	26.30,29.80
path	28.80,30.90	27.80,26.40	30.50,21.90
path	32.40,24.50	33.50,17.10	36.80,21.80
path	37.80,15.40	41.30,20.70	42.30,16.00
path	42.20,11.90	44.60,11.70	45.70,15.10
path	47.90,12.60	50.00,13.10	48.40,16.00
path	46.70,20.60	48.20,25.80
_Follow_ the path, collecting any nodes you come across
|goldcollect 168 Heartblossom##52986
|goldcollect 180 Cinderbloom##52983
|goldcollect 88 Volatile Life##52329
|goldcollect 8 Lifegiving Seed##63122
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Stormvine",{
meta={goldtype="route",skillreq={cataclysm_herbalism=1},levelreq=30},
items={{52984,200},{52329,76},{52983,52}},
maps={"Mount Hyjal"},
},[[
step
map Mount Hyjal
path	follow loose; loop on; ants curved; dist 15
path	61.80,28.30	59.20,31.60	55.70,30.60
path	50.90,32.30	57.00,39.00	43.50,42.60
path	36.20,44.90	33.10,65.20	27.90,51.50
path	16.90,46.60	14.30,47.10	11.50,36.30
path	11.80,31.60	13.50,34.00	25.50,33.40
path	26.50,30.00	33.10,27.40	35.70,19.50
path	51.50,16.90	50.50,22.50	52.70,23.20
To harvest the maximum amount of Stormvine, you will need to quest through Hyjal and unlock each phase
_Follow_ the path, collecting any nodes you come across
|goldcollect 200 Stormvine##52984
|goldcollect 76 Volatile Life##52329
|goldcollect 52 Cinderbloom##52983
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Twilight Jasmine",{
meta={goldtype="route",skillreq={cataclysm_herbalism=1},levelreq=30},
items={{52987,352},{52329,116},{52983,48},{63122,8}},
maps={"Twilight Highlands"},
},[[
step
map Twilight Highlands
path	follow loose; loop on; ants curved; dist 15
path	32.80,51.00	39.90,52.60	46.20,44.40
path	48.70,54.50	42.20,58.50	44.00,75.20
path	54.10,77.80	58.20,73.70	47.50,70.20
path	46.90,64.60	53.40,67.60	56.50,62.20
path	58.70,67.20	60.80,62.90	66.60,63.60
path	73.70,72.20	74.30,66.20	66.60,56.30
path	65.10,52.50	61.00,58.70	51.30,53.00
path	53.00,45.20	62.40,45.60	59.20,41.60
path	61.50,33.50	71.70,48.90	69.30,36.70
path	72.10,30.90	68.50,22.70	68.10,30.90
path	63.70,27.50	60.20,6.50	58.20,11.50
path	50.10,8.90	53.20,16.80	57.50,27.20
path	51.50,35.00	51.60,24.80	47.00,24.20
path	45.50,27.90	49.50,33.60	44.80,34.60
path	47.40,38.30	39.50,43.10
_Follow_ the path, collecting any nodes you come across
|goldcollect 352 Twilight Jasmine##52987
|goldcollect 116 Volatile Life##52329
|goldcollect 48 Cinderbloom##52983
|goldcollect 8 Lifegiving Seed##63122
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Whiptail",{
meta={goldtype="route",skillreq={cataclysm_herbalism=1},levelreq=30},
items={{52988,640},{52329,208},{63122,12}},
maps={"Uldum"},
},[[
step
map Uldum
path	follow loose; loop on; ants curved; dist 15
path	59.00,30.50	57.00,20.90	59.30,14.90
path	61.50,14.00	61.20,25.60	62.30,35.40
path	57.10,44.70	60.50,58.30	67.90,72.90
path	69.80,76.50	64.30,77.60	61.20,82.10
path	59.40,64.50	56.20,50.00	54.30,45.90
path	51.50,44.60	45.90,29.00	53.40,35.90
_Follow_ the path, collecting any nodes you come across
|goldcollect 640 Whiptail##52988
|goldcollect 208 Volatile Life##52329
|goldcollect 12 Lifegiving Seed##63122
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Fool's Cap",{
meta={goldtype="route",skillreq={pandaria_herbalism=1},levelreq=30},
items={{72234,68},{79011,172},{89640,8},{89641,4}},
maps={"Dread Wastes"},
},[[
step
map Dread Wastes
path	follow loose; loop on; ants curved; dist 15
path	36.30,54.80	29.80,54.50	31.60,61.80
path	33.80,57.80	39.50,60.10	33.10,64.40
path	37.90,65.90	41.00,71.30	41.40,63.80
path	45.90,61.60	55.60,63.20	64.90,62.80
path	66.70,66.20	67.90,59.30	65.60,54.10
path	62.60,59.40	54.30,54.60	42.40,57.10
_Follow_ the path, collecting any nodes you come across
|goldcollect 68 Green Tea Leaf##72234
|goldcollect 172 Fool's Cap##79011
|goldcollect 8 Life Spirit##89640
|goldcollect 4 Water Spirit##89641
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Green Tea Leaf",{
meta={goldtype="route",skillreq={pandaria_herbalism=1},levelreq=10},
items={{72234,740},{72237,60},{89640,80},{72238,12}},
maps={"The Jade Forest"},
},[[
step
map The Jade Forest
path	follow loose; loop on; ants curved; dist 20
path	42.70,82.50	39.50,74.20	45.30,71.40
path	46.00,78.70	48.90,81.50	50.50,75.00
path	48.40,66.70	34.30,61.60	37.50,56.90
path	37.80,53.20	29.80,52.50	32.10,51.00
path	30.30,46.90	31.00,41.60	31.70,35.30
path	35.00,34.90	37.60,36.70	34.30,43.70
path	38.20,44.70	42.50,36.50	37.90,27.10
path	29.70,30.60	25.60,27.70	31.30,21.20
path	30.50,16.50	34.60,12.30	40.50,10.00
path	44.60,17.10	49.80,18.00	47.80,28.00
path	48.00,38.30	55.20,30.40	53.50,38.50
path	53.30,47.40	51.80,54.00	52.50,65.00
path	60.60,71.00	64.20,78.90	66.40,84.60
path	62.80,92.30	56.70,91.80	59.60,88.60
path	55.50,85.10	54.50,79.40	51.60,86.70
path	45.10,92.60	43.70,90.40
_Follow_ the path, collecting any nodes you come across
|goldcollect 740 Green Tea Leaf##72234
|goldcollect 60 Rain Poppy##72237
|goldcollect 80 Life Spirit##89640
|goldcollect 12 Golden Lotus##72238
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Silkweed",{
meta={goldtype="route",skillreq={pandaria_herbalism=1},levelreq=15},
items={{72235,520},{72234,204},{89640,52}},
maps={"Valley of the Four Winds"},
},[[
step
map Valley of the Four Winds
path	follow smart; loop on; ants curved; dist 10
path	76.80,24.50	83.70,18.30	81.70,24.70
path	88.50,25.70	88.40,31.40	84.80,37.50
path	79.90,40.30	75.70,46.50	74.20,54.40
path	70.40,52.20	70.20,57.50	66.90,60.30
path	68.10,64.20	65.00,64.50	62.50,67.50
path	61.00,71.80	58.60,70.60	55.40,73.50
path	55.10,69.50	55.50,68.60	47.10,68.20
path	47.20,70.60	43.60,69.10	41.20,66.70
path	42.00,73.50	35.60,75.70	32.00,76.80
path	23.50,43.50	27.30,46.60	32.70,52.50
path	36.20,41.90	35.70,33.50	38.60,30.50
path	42.50,38.10	47.10,28.80	52.20,27.60
path	55.50,39.70	58.50,44.10	60.40,37.50
path	58.50,35.60	58.00,29.80	62.60,28.20
path	63.70,32.50	68.30,29.50
_Follow_ the path, collecting any nodes you come across
|goldcollect 520 Silkweed##72235
|goldcollect 204 Green Tea Leaf##72234
|goldcollect 52 Life Spirit##89640
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Snow Lily",{
meta={goldtype="route",skillreq={pandaria_herbalism=1},levelreq=20},
items={{79010,736},{89640,20},{89641,40}},
maps={"Kun-Lai Summit"},
},[[
step
map Kun-Lai Summit
path	follow loose; loop on; ants curved; dist 20
path	48.70,72.70	41.10,72.00	46.90,68.50
path	53.20,62.30	49.10,58.00	40.80,59.80
path	33.80,57.80	34.90,53.10	40.80,46.70
path	37.90,37.20	45.00,38.00	44.20,44.30
path	46.90,45.50	54.70,42.20	59.70,47.80
path	50.50,51.60	55.00,57.50	60.70,54.20
path	56.80,63.50	55.00,69.50
_Follow_ the path, collecting any nodes you come across
|goldcollect 736 Snow Lily##79010
|goldcollect 20 Life Spirit##89640
|goldcollect 40 Water Spirit##89641
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Frostweed",{
meta={goldtype="route",skillreq={draenor_herbalism=1},levelreq=10},
items={{109124,302},{109127,236}},
maps={"Shadowmoon Valley D"},
},[[
step
map Shadowmoon Valley D
path	follow loose; loop on; ants curved; dist 20
path	26.60,8.00	27.40,12.70	27.40,15.60
path	26.20,17.10	26.80,19.80	27.50,22.10
path	29.30,27.40	31.40,26.30	32.30,23.80
path	34.60,27.20	36.00,24.10	37.20,21.60
path	39.50,19.90	40.60,23.30	40.60,24.90
path	41.50,26.70	42.80,28.10	45.00,28.80
path	47.50,28.10	48.70,26.80	50.70,28.80
path	53.30,31.10	54.50,32.70	56.00,35.50
path	58.60,36.00	62.30,32.00	63.50,31.00
path	65.90,31.70	66.30,34.20	65.00,36.00
path	63.10,36.60	62.30,39.40	60.20,42.40
path	59.10,45.20	58.00,47.70	58.80,50.80
path	62.50,53.00	64.70,55.50	65.90,56.70
path	65.70,57.40	64.70,59.40	61.40,57.70
path	59.60,58.00	58.80,58.60	59.90,61.40
path	60.50,63.90	62.00,62.20	62.70,64.20
path	61.60,65.30	61.90,67.40	61.40,69.30
path	59.80,67.00	58.10,64.10	57.90,63.40
path	57.40,59.50	55.30,59.00	54.50,61.80
path	53.30,63.70	53.00,65.60	52.20,67.00
path	54.00,69.90	56.00,70.20	56.00,72.40
path	55.00,74.40	54.00,74.30	52.70,72.90
path	51.70,70.80	51.10,68.70	49.10,68.30
path	45.60,68.30	42.90,73.00	41.60,74.70
path	38.20,73.40	37.00,71.50	38.30,67.70
path	38.10,66.40	37.40,60.80	36.40,59.60
path	36.90,56.80	40.70,57.60	42.90,57.00
path	43.20,54.80	41.70,53.60	41.20,50.10
path	42.00,48.60	43.10,46.70	42.60,43.60
path	40.20,43.40	39.00,39.80	37.00,35.70
path	34.70,32.40	32.90,31.00	31.10,32.40
path	28.30,32.90	26.40,31.70	25.40,28.80
path	24.10,26.70	22.70,26.10	21.40,24.80
path	22.30,24.20	23.70,23.10	25.10,20.80
path	24.30,19.00	23.40,18.10	23.40,16.30
path	22.80,14.50	23.70,10.20
_Follow_ the path, collecting any nodes you come across
|goldcollect 302 Frostweed##109124
|goldcollect 236 Starflower##109127
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Starflower",{
meta={goldtype="route",skillreq={draenor_herbalism=1},levelreq=10},
items={{109124,302},{109127,236}},
maps={"Shadowmoon Valley D"},
},[[
step
map Shadowmoon Valley D
path	follow smart; loop on; ants curved; dist 10
path	26.60,8.00	27.40,12.70	27.40,15.60
path	26.20,17.10	26.80,19.80	27.50,22.10
path	29.30,27.40	31.40,26.30	32.30,23.80
path	34.60,27.20	36.00,24.10	37.20,21.60
path	39.50,19.90	40.60,23.30	40.60,24.90
path	41.50,26.70	42.80,28.10	45.00,28.80
path	47.50,28.10	48.70,26.80	50.70,28.80
path	53.30,31.10	54.50,32.70	56.00,35.50
path	58.60,36.00	62.30,32.00	63.50,31.00
path	65.90,31.70	66.30,34.20	65.00,36.00
path	63.10,36.60	62.30,39.40	60.20,42.40
path	59.10,45.20	58.00,47.70	58.80,50.80
path	62.50,53.00	64.70,55.50	65.90,56.70
path	65.70,57.40	64.70,59.40	61.40,57.70
path	59.60,58.00	58.80,58.60	59.90,61.40
path	60.50,63.90	62.00,62.20	62.70,64.20
path	61.60,65.30	61.90,67.40	61.40,69.30
path	59.80,67.00	58.10,64.10	57.90,63.40
path	57.40,59.50	55.30,59.00	54.50,61.80
path	53.30,63.70	53.00,65.60	52.20,67.00
path	54.00,69.90	56.00,70.20	56.00,72.40
path	55.00,74.40	54.00,74.30	52.70,72.90
path	51.70,70.80	51.10,68.70	49.10,68.30
path	45.60,68.30	42.90,73.00	41.60,74.70
path	38.20,73.40	37.00,71.50	38.30,67.70
path	38.10,66.40	37.40,60.80	36.40,59.60
path	36.90,56.80	40.70,57.60	42.90,57.00
path	43.20,54.80	41.70,53.60	41.20,50.10
path	42.00,48.60	43.10,46.70	42.60,43.60
path	40.20,43.40	39.00,39.80	37.00,35.70
path	34.70,32.40	32.90,31.00	31.10,32.40
path	28.30,32.90	26.40,31.70	25.40,28.80
path	24.10,26.70	22.70,26.10	21.40,24.80
path	22.30,24.20	23.70,23.10	25.10,20.80
path	24.30,19.00	23.40,18.10	23.40,16.30
path	22.80,14.50	23.70,10.20
_Follow_ the path, collecting any nodes you come across
|goldcollect 302 Frostweed##109124
|goldcollect 236 Starflower##109127
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Fireweed",{
meta={goldtype="route",skillreq={draenor_herbalism=1},levelreq=10},
items={{109125,24},{109124,124}},
maps={"Frostfire Ridge"},
},[[
step
map Frostfire Ridge
path	follow smart; loop on; ants curved; dist 20
path	31.10,53.30	26.10,53.70	24.20,49.00
path	23.20,45.20	20.70,39.50	22.20,33.90
path	21.80,29.70	20.90,25.40	23.10,23.60
path	25.10,24.60	27.20,22.30	29.70,21.40
path	31.20,22.00	32.80,21.70	35.10,19.50
path	36.90,24.30	38.10,26.80	40.80,28.90
path	41.60,30.60	42.80,29.90	42.90,31.10
path	44.40,31.10	46.20,31.70	48.90,34.40
path	51.60,36.90	53.70,35.10	54.50,30.30
path	56.50,26.10	59.10,28.40	60.00,31.90
path	61.20,34.90	63.10,40.90	63.40,45.00
path	60.90,46.90	62.20,52.40	60.30,55.30
path	57.90,57.50	53.80,55.80	50.60,54.70
path	47.70,55.60	45.90,58.90	43.10,60.80
path	40.30,62.10	37.70,58.70	36.50,56.50
path	35.50,53.30	33.60,49.20	31.10,51.20
_Follow_ the path, collecting any nodes you come across
|goldcollect 24 Fireweed##109125
|goldcollect 124 Frostweed##109124
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Gorgrond Flytrap",{
meta={goldtype="route",skillreq={draenor_herbalism=1},levelreq=15},
items={{109126,240}},
maps={"Gorgrond"},
},[[
step
map Gorgrond
path	follow smart; loop on; ants curved; dist 10
path	50.50,76.10	52.70,75.60	54.10,72.50
path	53.70,68.10	55.10,65.20	56.30,64.10
path	59.30,64.10	61.10,62.60	60.40,59.20
path	59.20,57.60	57.50,57.80	56.20,60.20
path	55.90,62.50	54.00,62.60	52.40,62.40
path	52.10,64.40	50.80,64.80	50.50,67.30
path	49.40,68.90	48.30,70.60	47.20,70.40
path	45.40,71.20	44.50,72.20	44.70,74.20
path	45.00,75.90	45.60,77.00	47.70,76.00
_Follow_ the path, collecting any nodes you come across
|goldcollect 240 Gorgrond Flytrap##109126
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Nagrand Arrowbloom",{
meta={goldtype="route",skillreq={draenor_herbalism=1},levelreq=35},
items={{109128,404}},
maps={"Nagrand D"},
},[[
step
map Nagrand D
path	follow smart; loop on; ants curved; dist 20
path	87.80,65.20	87.40,63.10	86.40,61.40
path	84.70,60.50	84.30,60.10	84.40,58.10
path	83.90,57.80	83.70,56.60	83.30,53.80
path	84.00,51.90	84.60,50.10	82.50,47.70
path	81.30,46.10	80.80,43.40	80.20,38.60
path	77.60,35.90	76.10,35.00	76.50,32.10
path	76.40,30.30	75.70,29.80	74.20,29.70
path	73.50,29.70	73.00,28.50	73.20,27.00
path	74.20,25.10	74.30,22.70	73.90,21.60
path	73.20,20.80	71.60,19.00	70.80,19.30
path	69.50,21.10	69.20,22.10	66.40,23.40
path	66.40,26.10	65.70,29.50	65.00,32.50
path	64.10,35.10	64.30,35.60	65.30,36.40
path	65.20,37.20	64.00,40.00	64.30,38.90
path	63.30,41.80	62.70,42.50	60.40,43.00
path	58.90,42.70	58.70,44.50	58.10,47.00
path	56.50,48.70	54.10,49.10	51.80,46.60
path	50.80,47.00	50.80,48.70	49.50,50.20
path	47.80,49.40	46.70,48.40	45.90,49.00
path	44.30,50.00	43.00,51.40	43.60,54.00
path	44.50,54.40	46.00,55.30	47.20,54.80
path	49.20,54.20	50.80,53.70	53.00,55.00
path	53.80,58.10	53.30,60.30	53.30,63.00
path	53.30,66.50	53.30,67.50	53.80,68.20
path	55.90,69.60	56.70,69.10	57.30,67.10
path	59.80,66.30	60.80,64.10	60.70,60.80
path	60.30,56.80	59.10,53.10	59.10,50.80
path	60.20,50.30	61.10,50.30	62.00,52.20
path	62.80,51.80	63.80,49.70	63.60,47.60
path	63.40,46.20	65.80,44.40	68.50,45.30
path	68.50,46.70	71.50,48.50	72.80,49.50
path	71.30,53.70	71.00,56.50	72.40,57.60
path	75.40,57.50	77.20,58.60	78.20,63.40
path	80.40,66.20	84.10,68.10	86.30,67.50
_Follow_ the path, collecting any nodes you come across
|goldcollect 404 Nagrand Arrowbloom##109128
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Talador Orchid",{
meta={goldtype="route",skillreq={draenor_herbalism=1},levelreq=20},
items={{109129,576}},
maps={"Talador"},
},[[
step
map Talador
path	follow smart; loop on; ants curved; dist 20
path	57.70,46.90	56.30,49.80	54.20,52.00
path	52.70,50.30	51.20,51.50	49.40,54.80
path	46.70,52.60	44.50,53.20	41.50,54.40
path	39.60,53.60	40.70,57.40	40.50,61.50
path	39.70,63.20	39.20,67.90	39.40,72.90
path	41.00,76.80	39.40,81.70	40.30,86.70
path	42.50,88.40	46.00,87.50	48.10,85.90
path	52.40,85.10	56.00,84.40	57.90,78.80
path	59.30,77.50	58.80,74.00	60.30,65.70
path	63.30,64.90	62.80,59.10	61.30,56.60
path	59.50,53.00	59.10,48.60
_Follow_ the path, collecting any nodes you come across
|goldcollect 576 Talador Orchid##109129
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Dusky Pigment/Verdant Pigment",{
meta={goldtype="route",skillreq={herbalism=1,inscription=1},levelreq=7},
items={{785,452},{2452,140},{2450,388},{2453,20},{39334,532},{43103,52}},
maps={"Hillsbrad Foothills"},
},[[
step
map Hillsbrad Foothills
path	follow loose; loop on; ants curved; dist 10
path	56.50,34.50	56.20,38.40	61.70,49.20
path	61.10,60.80	65.60,52.20	73.80,59.20
path	67.80,66.80	61.50,65.90	66.10,72.10
path	63.70,76.30	56.10,70.60	48.80,61.80
path	41.90,70.50	35.50,74.00	34.90,69.50
path	30.30,69.50	31.60,62.50	34.70,54.40
path	31.10,46.70	37.50,39.80	39.30,48.30
path	44.50,50.30	49.20,47.60	50.10,42.50
_Follow_ the path, collecting any nodes you come across
|goldcollect 452 Mageroyal##785 |n
|goldcollect 140 Swiftthistle##2452 |n
|goldcollect 388 Briarthorn##2450 |n
|goldcollect 20 Bruiseweed##2453 |n
Mill the herbs you've gathered into Dusky Pigment and Verdant Pigment |cast Milling##51005
|goldcollect 532 Dusky Pigment##39334
|goldcollect 52 Verdant Pigment##43103
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Golden Pigment/Burnt Pigment",{
meta={goldtype="route",skillreq={herbalism=1,inscription=1},levelreq=10},
items={{3356,448},{2453,28},{3355,28},{39338,296},{43104,80}},
maps={"Northern Stranglethorn"},
},[[
step
map Northern Stranglethorn
path	follow loose; loop on; ants curved; dist 25
path	39.90,23.00	34.20,20.70	29.80,30.50
path	37.70,27.50	38.50,36.60	35.30,43.50
path	42.10,47.00	41.10,51.50	46.10,50.00
path	48.50,44.10	53.80,47.50	50.10,55.90
path	55.80,56.50	56.50,63.80	63.20,61.50
path	60.90,51.50	61.30,40.20	63.50,34.90
path	61.50,27.30	55.90,31.10	52.70,22.10
path	48.10,33.60
_Follow_ the path, collecting any nodes you come across
|goldcollect 448 Kingsblood##3356 |n
|goldcollect 28 Bruiseweed##2453 |n
|goldcollect 28 Wild Steelbloom##3355 |n
Mill the herbs you've gathered into Golden Pigment and Burnt Pigment |cast Milling##51005
|goldcollect 296 Golden Pigment##39338
|goldcollect 80 Burnt Pigment##43104
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Emerald Pigment/Indigo Pigment",{
meta={goldtype="route",skillreq={herbalism=1,inscription=1},levelreq=15},
items={{8838,300},{3357,52},{3358,380},{39339,280},{43105,80},{39340,120,'crap'},{29338,48,'crap'},{43106,12,'crap'},{43104,8,'crap'}},
maps={"Eastern Plaguelands"},
},[[
step
map Eastern Plaguelands
path	follow loose; loop on; ants curved; dist 25
path	72.70,56.60	72.00,65.50	61.80,63.80
path	60.50,67.50	68.30,74.80	62.70,74.50
path	56.50,79.70	50.50,68.20	40.70,72.80
path	35.50,76.80	26.10,76.70	22.80,75.50
path	19.90,78.90	17.20,71.90	10.20,71.70
path	16.50,61.50	19.50,64.70	26.50,63.20
path	37.10,64.50	41.50,61.80	43.90,55.50
path	51.70,45.60	44.00,34.30	46.30,21.30
path	52.90,14.80	62.60,24.00	70.00,31.00
path	60.00,35.00	65.80,37.80	66.20,44.80
_Follow_ the path, collecting any nodes you come across
|goldcollect 300 Sungrass##8838 |n
|goldcollect 52 Liferoot####3357 |n
|goldcollect 380 Khadgar's Whisker##3358 |n
Mill the herbs you've gathered into Emerald Pigment and Indigo Pigment |cast Milling##51005
|goldcollect 280 Emerald Pigment##39339
|goldcollect 80 Indigo Pigment##43105
meta crap_items_follow=1
|goldcollect 120 Violet Pigment##39340
|goldcollect 48 Golden Pigment##29338
|goldcollect 12 Ruby Pigment##43106
|goldcollect 8 Burnt Pigment##43104
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Violet Pigment/Ruby Pigment",{
meta={goldtype="route",skillreq={herbalism=1,inscription=1},levelreq=15},
items={{3818,68},{8839,332},{3358,56},{39340,200},{43106,60},{39339,72,'crap'},{43105,4,'crap'}},
maps={"Feralas"},
},[[
step
map Feralas
path	follow loose; loop on; ants curved; dist 25
path	52.90,15.40	53.90,7.30	49.70,4.90
path	48.50,6.80	50.10,9.90	47.70,11.90
path	44.00,12.70	47.90,15.50	46.50,20.10
path	49.40,23.90	49.30,24.90	51.50,13.50
_Follow_ the path, collecting any nodes you come across
|goldcollect 68 Fadeleaf##3818 |n
|goldcollect 332 Blindweed##8839 |n
|goldcollect 56 Khadgar's Whisker##3358 |n
Mill the herbs you've gathered into Violet Pigment and Ruby Pigment |cast Milling##51005
|goldcollect 200 Violet Pigment##39340
|goldcollect 60 Ruby Pigment##43106
meta crap_items_follow=1
|goldcollect 72 Emerald Pigment##39339
|goldcollect 4 Indigo Pigment##43105
|goldcollect 40 Ruby Pigment##43106
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Silvery Pigment/Sapphire Pigment",{
meta={goldtype="route",skillreq={herbalism=1,inscription=1},levelreq=15},
items={{13467,404},{13465,44},{39341,284},{43107,60}},
maps={"Winterspring"},
},[[
step
map Winterspring/0
path	follow loose; loop on; ants curved; dist 25
path	62.40,51.30	63.90,54.30	66.40,57.10
path	65.90,65.40	64.20,69.00	60.60,73.00
path	64.30,77.50	61.20,79.70	63.90,80.00
path	60.50,85.90	57.10,82.00	58.10,69.50
path	53.80,64.70	56.30,62.30	58.60,64.30
path	62.20,61.50	59.20,55.10	54.20,59.70
path	47.40,58.20	44.50,58.50	43.70,55.30
path	39.00,55.80	34.20,57.10	27.50,55.90
path	24.20,58.00	24.00,49.80	27.70,49.50
path	45.00,51.30	48.30,53.00	51.60,54.30
path	54.30,51.50	50.00,48.10	52.50,42.60
path	57.10,39.30	56.00,34.90	54.80,29.60
path	52.00,33.50	46.70,30.20	46.30,19.50
path	45.20,14.80	50.20,19.20	52.80,23.00
path	55.40,23.70	58.90,22.50	57.00,29.30
path	61.20,31.90	65.40,30.60	65.30,38.60
path	66.70,45.00	57.00,45.70
_Follow_ the path, collecting any nodes you come across
|goldcollect 404 Icecap##13467 |n
|goldcollect 44 Mountain Silversage##13465 |n
Mill the herbs you've gathered into Silvery Pigment and Sapphire Pigment |cast Milling##51005
|goldcollect 284 Silvery Pigment##39341
|goldcollect 60 Sapphire Pigment##43107
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Nether Pigment/Ebon Pigment",{
meta={goldtype="route",skillreq={outland_herbalism=1,outland_inscription=1},levelreq=25},
items={{22792,168},{22785,116},{22789,52},{22786,32},{22794,4,'crap'},{39342,228,'crap'},{43108,32,'crap'}},
maps={"Shadowmoon Valley"},
},[[
step
map Shadowmoon Valley
path	follow smart; loop on; ants curved; dist 20
path	42.50,59.00	43.40,65.10	43.30,72.40
path	47.70,69.60	47.30,51.70	51.50,59.00
path	51.40,66.40	56.90,73.90	61.20,68.10
path	57.80,57.20	62.00,56.20	65.20,61.50
path	70.60,60.70	68.50,58.00	67.90,47.20
path	72.10,47.50	71.50,40.80	66.30,39.30
path	58.50,45.30	49.90,33.90	53.10,33.50
path	59.60,37.30	67.10,28.90	66.00,21.80
path	58.00,23.60	55.60,16.80	52.50,15.60
path	52.50,21.60	45.50,15.10	42.30,38.20
path	38.30,32.10	31.20,34.60	24.90,29.60
path	22.00,34.70	22.00,40.80	29.70,47.80
path	27.20,52.60	31.60,53.80
_Follow_ the path, collecting any nodes you come across
|goldcollect 168 Nightmare Vine##22792 |n
|goldcollect 116 Felweed##22785 |n
|goldcollect 52 Terocone##22789 |n
|goldcollect 32 Dreaming Glory##22786 |n
meta crap_items_follow=1
|goldcollect 4 Fel Lotus##22794 |n
Mill the herbs you've gathered into Nether Pigment and Ebon Pigment |cast Milling##51005
|goldcollect 228 Nether Pigment##39342
|goldcollect 32 Ebon Pigment##43108
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Azure Pigment/Icy Pigment",{
meta={goldtype="route",skillreq={northrend_herbalism=1,northrend_inscription=1},levelreq=25},
items={{36905,336},{36906,280},{37704,128,'crap'},{36908,12,'crap'},{39343,396,'crap'},{43109,88,'crap'}},
maps={"The Storm Peaks"},
},[[
step
map The Storm Peaks
path	follow loose; loop on; ants curved; dist 20
path	39.50,88.90	33.50,89.50	32.50,86.90
path	31.40,83.10	35.70,82.20	37.30,74.30
path	32.80,74.50	29.10,68.00	27.00,72.40
path	24.60,72.50	26.70,67.60	27.80,60.00
path	25.40,58.60	22.60,62.80	21.60,55.70
path	23.90,55.40	30.40,50.50	34.60,40.40
path	40.90,38.00	44.80,40.50	39.60,44.80
path	35.50,43.00	35.70,47.10	38.80,48.50
path	36.80,64.30	41.20,62.50	45.20,55.00
path	48.60,60.90	47.00,66.70	56.80,63.10
path	56.50,56.60	56.00,50.90	59.70,47.80
path	59.90,45.00	65.60,40.60	65.90,43.80
path	64.10,54.10	68.60,47.70	72.90,49.80
path	70.30,54.90	72.50,65.00	65.30,59.30
path	61.30,61.90	58.60,63.50	56.70,66.00
path	56.90,71.00	52.20,69.50	48.30,77.40
path	43.60,77.00	41.50,79.20	39.90,76.30
path	38.40,80.80
_Follow_ the path, collecting any nodes you come across
|goldcollect 336 Lichbloom##36905 |n
|goldcollect 280 Icethorn##36906 |n
meta crap_items_follow=1
|goldcollect 128 Crystallized Life##37704
|goldcollect 12 Frost Lotus##36908
Mill the herbs you've gathered into Azure Pigment and Icy Pigment |cast Milling##51005
|goldcollect 396 Azure Pigment##39343
|goldcollect 88 Icy Pigment##43109
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Ashen Pigment/Burning Embers",{
meta={goldtype="route",skillreq={cataclysm_herbalism=1,cataclysm_inscription=1},levelreq=30},
items={{52988,640},{52329,208,'crap'},{63122,12,'crap'},{61979,404,'crap'},{61980,60,'crap'}},
maps={"Uldum"},
},[[
step
map Uldum
path	follow loose; loop on; ants curved; dist 15
path	59.00,30.50	57.00,20.90	59.30,14.90
path	61.50,14.00	61.20,25.60	62.30,35.40
path	57.10,44.70	60.50,58.30	67.90,72.90
path	69.80,76.50	64.30,77.60	61.20,82.10
path	59.40,64.50	56.20,50.00	54.30,45.90
path	51.50,44.60	45.90,29.00	53.40,35.90
_Follow_ the path, collecting any nodes you come across
|goldcollect 640 Whiptail##52988 |n
meta crap_items_follow=1
|goldcollect 208 Volatile Life##52329
|goldcollect 12 Lifegiving Seed##63122
Mill the herbs you've gathered into Ashen Pigment and Burning Embers |cast Milling##51005
|goldcollect 404 Ashen Pigment##61979
|goldcollect 60 Burning Embers##61980
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Misty Pigment/Shadow Pigment",{
meta={goldtype="route",skillreq={pandaria_herbalism=1,pandaria_inscription=1},levelreq=10},
items={{72234,740},{72237,60},{89640,80,'crap'},{72238,12,'crap'},{79251,408,'crap'},{79253,36,'crap'}},
maps={"The Jade Forest"},
},[[
step
map The Jade Forest
path	follow loose; loop on; ants curved; dist 20
path	42.70,82.50	39.50,74.20	45.30,71.40
path	46.00,78.70	48.90,81.50	50.50,75.00
path	48.40,66.70	34.30,61.60	37.50,56.90
path	37.80,53.20	29.80,52.50	32.10,51.00
path	30.30,46.90	31.00,41.60	31.70,35.30
path	35.00,34.90	37.60,36.70	34.30,43.70
path	38.20,44.70	42.50,36.50	37.90,27.10
path	29.70,30.60	25.60,27.70	31.30,21.20
path	30.50,16.50	34.60,12.30	40.50,10.00
path	44.60,17.10	49.80,18.00	47.80,28.00
path	48.00,38.30	55.20,30.40	53.50,38.50
path	53.30,47.40	51.80,54.00	52.50,65.00
path	60.60,71.00	64.20,78.90	66.40,84.60
path	62.80,92.30	56.70,91.80	59.60,88.60
path	55.50,85.10	54.50,79.40	51.60,86.70
path	45.10,92.60	43.70,90.40
_Follow_ the path, collecting any nodes you come across
|goldcollect 740 Green Tea Leaf##72234 |n
|goldcollect 60 Rain Poppy##72237 |n
meta crap_items_follow=1
|goldcollect 80 Life Spirit##89640
|goldcollect 12 Golden Lotus##72238
Mill the herbs you've gathered into Shadow Pigment and Misty Pigment |cast Milling##51005
|goldcollect 408 Shadow Pigment##79251
|goldcollect 36 Misty Pigment##79253
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Cerulean Pigment",{
meta={goldtype="route",skillreq={draenor_herbalism=1,draenor_inscription=1},levelreq=20},
items={{109129,576},{114931,248}},
maps={"Talador"},
},[[
step
map Talador
path	follow smart; loop on; ants curved; dist 20
path	57.70,46.90	56.30,49.80	54.20,52.00
path	52.70,50.30	51.20,51.50	49.40,54.80
path	46.70,52.60	44.50,53.20	41.50,54.40
path	39.60,53.60	40.70,57.40	40.50,61.50
path	39.70,63.20	39.20,67.90	39.40,72.90
path	41.00,76.80	39.40,81.70	40.30,86.70
path	42.50,88.40	46.00,87.50	48.10,85.90
path	52.40,85.10	56.00,84.40	57.90,78.80
path	59.30,77.50	58.80,74.00	60.30,65.70
path	63.30,64.90	62.80,59.10	61.30,56.60
path	59.50,53.00	59.10,48.60
_Follow_ the path, collecting any nodes you come across
|goldcollect 576 Talador Orchid##109129 |n
Mill the herbs you've gathered into Cerulean Pigment |cast Milling##51005
|goldcollect 248 Cerulean Pigment##114931
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Tigerseye, Malachite",{
meta={goldtype="route",skillreq={mining=1,jewelcrafting=1},levelreq=5},
items={{2770,1},{2835,1},{774,96},{818,72},{1210,76}},
maps={"Durotar","Darkshore"},
},[[
step
Click Here to Farm in Durotar |confirm |next "Durotar"
Click Here to Farm in Darkshore |confirm |next
step
talk Zidormi##141489
Select _"Can you show me what Darkshore was like before the battle?"_
Travel to the Past |complete ZGV.InPhase('Old Darnassus') |goto Darkshore/0 48.86,24.46
step
map Darkshore/0
path follow smart; loop on; ants curved; dist 20
path	56.30,17.40	59.40,9.30	65.60,4.40	63.30,16.20	60.20,25.30
path	54.40,33.60	50.60,27.70	48.90,38.70	47.30,50.90	45.50,59.20
path	46.20,71.40	46.60,79.10	40.00,86.40	35.30,88.90	32.50,83.50
path	36.80,72.40	40.10,59.00	39.70,44.80	37.90,32.40	42.70,31.90
path	44.60,20.00	54.70,20.70
Use the Prospecting ability |cast Prospecting##31252
|tip Use it on the Ore in your bags.
|goldcollect Copper Ore##2770 |n
|goldcollect Rough Stone##2835 |n
|goldcollect 96 Malachite##774
|goldcollect 72 Tigerseye##818
|goldcollect 76 Shadowgem##1210 |n
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Durotar"
map Durotar/0
path follow smart; loop on; ants curved; dist 20
path	55.10,10.20	53.80,18.50	56.30,24.60	52.70,29.30	54.00,39.80
path	58.70,41.50	59.50,54.30	55.70,56.00	56.10,69.40	50.80,74.20
path	52.30,66.70	49.80,49.20	39.40,51.80	37.90,30.40	39.60,17.60
path	42.80,19.70	44.60,24.60	48.00,36.60	49.60,32.10	50.50,27.30
path	50.00,22.60	49.80,16.80
Use the Prospecting ability |cast Prospecting##31252
|tip Use it on the Ore in your bags.
|goldcollect Copper Ore##2770 |n
|goldcollect Rough Stone##2835 |n
|goldcollect 80 Malachite##774
|goldcollect 56 Tigerseye##818
|goldcollect 36 Shadowgem##1210 |n
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Sell_Items"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Shadowgem, Moss Agate, Lesser Moonstone, Jade",{
meta={goldtype="route",skillreq={mining=1,jewelcrafting=1},levelreq=10},
items={{2771,1},{2836,1},{1210,36},{1206,28},{1705,48},{1529,4},{3864,4},{7909,4},{2775,40}},
maps={"Northern Stranglethorn","Ashenvale"},
},[[
step
Click Here to Farm in Northern Stranglethorn |confirm |next "Northern_Stranglethorn"
Click Here to Farm in Ashenvale |confirm |next
step
map Ashenvale/0
path follow loose; loop on; ants curved
path	41.80,40.30	41.60,32.50	31.30,38.30	33.70,21.50	24.90,30.00
path	26.00,18.00	15.00,14.10	17.30,28.20	20.90,42.20	20.90,55.50
path	29.70,50.80	33.70,69.80	42.30,62.60	45.30,71.60	59.60,77.80
path	56.50,64.80	67.00,69.10	76.70,73.70	87.50,79.70	79.50,47.10
path	66.00,56.50	61.90,42.60	54.30,36.70	50.90,54.50
Use the Prospecting ability |cast Prospecting##31252
|tip Use it on the Ore in your bags.
|goldcollect Tin Ore##2771 |n
|goldcollect Coarse Stone##2836 |n
|goldcollect 36 Shadowgem##1210
|goldcollect 28 Moss Agate##1206
|goldcollect 48 Lesser Moonstone##1705
|goldcollect 4 Jade##1529
|goldcollect 4 Citrine##3864
|goldcollect 4 Aquamarine##7909
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Northern_Stranglethorn"
map Northern Stranglethorn/0
path follow loose; loop on; ants curved
path	40.40,45.00	36.30,44.10	34.00,38.80	31.10,34.10	27.00,31.80
path	21.40,25.20	21.80,18.70	26.60,21.90	31.10,22.40	34.60,20.90
path	33.80,17.20	38.50,17.90	46.30,19.10	52.50,20.50	58.60,16.80
path	63.50,17.50	63.20,22.10	60.30,24.30	57.20,28.20	60.80,34.60
path	66.10,40.90	62.90,47.10	56.20,50.40	48.00,55.20	44.30,55.50
path	48.70,47.20	47.70,39.20	50.20,28.60	44.60,28.20	42.90,34.70
path	41.40,41.20
Use the Prospecting ability |cast Prospecting##31252
|tip Use it on the Ore in your bags.
|goldcollect 40 Silver Ore##2775
|goldcollect Tin Ore##2771 |n
|goldcollect Coarse Stone##2836 |n
|goldcollect 40 Shadowgem##1210
|goldcollect 36 Moss Agate##1206
|goldcollect 60 Lesser Moonstone##1705
|goldcollect 4 Jade##1529
|goldcollect 4 Citrine##3864
|goldcollect 4 Aquamarine##7909
|goldtracker
Click Here to Sell Items |confirm
step
label "Sell_Items"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Citrine, Aquamarine",{
meta={goldtype="route",skillreq={mining=1,jewelcrafting=1},levelreq={15}},
items={{7911,52},{3858,1},{2776,1},{7912,1},{7909,84},{3864,64},{7910,72},{12361,12},{12799,8}},
maps={"Burning Steppes","Badlands"},
},[[
step
Click Here to Farm in Badlands |confirm |next "Badlands"
Click Here to Farm in Burning Steppes |confirm |next
step
map Burning Steppes/0
path follow loose; loop on; ants curved
path	31.30,59.80	21.50,62.00	15.60,62.10	7.80,56.40	9.30,45.80
path	21.60,47.00	31.20,43.60	39.20,33.40	46.40,28.10	52.80,29.00
path	50.30,44.60	59.20,38.80	59.90,27.50	68.20,25.20	74.60,27.10
path	81.60,30.40	71.20,36.00	65.50,42.10	66.90,49.50	72.20,50.10
path	73.70,43.50	80.10,41.00	81.70,54.60	81.60,62.60	76.20,58.40
path	72.60,67.50	68.60,61.90	61.50,60.50	56.20,49.00	51.50,60.00
path	44.20,65.50	37.50,60.00
Use the Prospecting ability |cast Prospecting##31252
|tip Use it on the Ore in your bags.
|goldcollect 52 Truesilver Ore##7911
|goldcollect Mithril Ore##3858 |n
|goldcollect Gold Ore##2776 |n
|goldcollect Solid Stone##7912 |n
|goldcollect 84 Aquamarine##7909
|goldcollect 64 Citrine##3864
|goldcollect 72 Star Ruby##7910
|goldcollect 12 Blue Sapphire##12361
|goldcollect 8 Large Opal##12799
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Badlands"
map Badlands/0
path follow smart; loop on; ants curved
path	70.20,28.80	72.00,25.60	73.50,31.00	72.60,38.10	73.70,43.20
path	75.00,48.50	69.50,53.70	66.50,57.20	62.50,46.50	59.00,42.50
path	56.50,47.20	57.50,59.80	50.10,65.30	44.60,57.20	41.20,66.60
path	32.70,62.60	26.30,63.60	14.00,69.90	13.60,77.30	11.40,78.50
path	12.70,58.20	11.70,49.40	10.70,38.70	15.20,35.90	25.00,38.60
path	35.90,32.20	45.00,24.50	50.00,12.20	52.80,21.80	59.80,29.70
Use the Prospecting ability |cast Prospecting##31252
|tip Use it on the Ore in your bags.
|goldcollect 36 Truesilver Ore##7911
|goldcollect Mithril Ore##3858 |n
|goldcollect Gold Ore##2776 |n
|goldcollect Solid Stone##7912 |n
|goldcollect 56 Aquamarine##7909
|goldcollect 48 Citrine##3864
|goldcollect 52 Star Ruby##7910
|goldcollect 8 Blue Sapphire##12361
|goldcollect 4 Large Opal##12799
|goldtracker
Click Here to Sell Items |confirm
step
label "Sell_Items"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Huge Emerald, Large Opal, Azerothian Diamond, Blue Sapphire, Star Ruby",{
meta={goldtype="route",skillreq={jewelcrafting=1,mining=1},levelreq={15}},
items={{7911,28},{10620,1},{12365,1},{12363,16},{12800,24},{7910,24},{12364,32},{12799,60},{12361,56},{7909,8},{3864,4}},
maps={"Winterspring","Silithus"},
},[[
step
Click Here to Farm in Winterspring |confirm |next "Winterspring"
Click Here to Farm in Silithus |confirm |next
step
talk Zidormi##128607
|tip She is at the top of the ramp leading from Un'Goro Crater to Silithus.
Select _"Can you show me what Silithus was like before the Wound in the World?"_
Travel to the Past |complete ZGV.InPhase('Old Silithus') |goto Silithus/0 78.93,21.97
step
map Silithus/0
path follow loose; loop on; ants curved
path	47.90,18.40	58.60,11.10	67.50,15.40	68.70,23.60	71.90,28.50
path	72.50,39.50	66.70,44.70	62.30,35.40	53.40,45.00	66.90,54.10
path	67.30,63.00	68.90,71.50	66.30,83.00	56.40,83.00	48.50,79.10
path	40.50,80.90	24.50,78.80	28.30,68.00	34.00,65.10	25.60,57.10
path	27.80,43.50	27.20,32.60	28.50,16.20	28.80,10.20	35.00,12.00
path	35.50,24.00	43.90,15.20
Use the Prospecting ability |cast Prospecting##31252
|tip Use it on the Ore in your bags.
|goldcollect 28 Truesilver Ore##7911
|goldcollect Thorium Ore##10620 |n
|goldcollect Dense Stone##12365 |n
|goldcollect 16 Arcane Crystal##12363
|goldcollect 24 Azerothian Diamond##12800
|goldcollect 24 Star Ruby##7910
|goldcollect 32 Huge Emerald##12364
|goldcollect 60 Large Opal##12799
|goldcollect 56 Blue Sapphire##12361
|goldcollect 8 Aquamarine##7909
|goldcollect 4 Citrine##3864
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Winterspring"
map Winterspring
path follow smart; loop on; ants curved
path	58.10,44.20	60.10,36.20	59.60,28.50	58.80,19.80	54.50,21.20
path	49.90,18.30	44.90,14.00	46.00,24.60	48.30,37.10	49.80,44.50
path	42.00,48.30	33.50,47.20	29.10,52.20	23.50,46.10	22.30,62.40
path	28.00,58.40	37.10,58.40	45.30,57.40	48.90,60.70	53.70,63.60
path	55.60,74.40	56.60,80.10	62.60,80.90	63.20,72.10	67.50,62.30
path	60.50,61.50
Use the Prospecting ability |cast Prospecting##31252
|tip Use it on the Ore in your bags.
|goldcollect 56 Truesilver Ore##7911
|goldcollect Thorium Ore##10620 |n
|goldcollect Dense Stone##12365 |n
|goldcollect 20 Arcane Crystal##12363
|goldcollect 28 Azerothian Diamond##12800
|goldcollect 24 Star Ruby##7910
|goldcollect 40 Huge Emerald##12364
|goldcollect 64 Large Opal##12799
|goldcollect 68 Blue Sapphire##12361
|goldcollect 8 Aquamarine##7909
|goldcollect 4 Citrine##3864
|goldtracker
Click Here to Sell Items |confirm
step
label "Sell_Items"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Golden Draenite, Azure Moonstone, Blood Garnet, Deep Peridot, Flame Spessarite, Shadow Draenite",{
meta={goldtype="route",skillreq={outland_jewelcrafting=1,outland_mining=1},levelreq={10}},
items={{23427,16},{23424,1},{23425,1},{22573,1},{22574,1},{23112,12},{23077,4},{23079,8},{23117,28},{21929,16},{23107,12}},
maps={"Zangarmarsh","Hellfire Peninsula"},
},[[
step
Click Here to Farm in Hellfire Peninsula |confirm |next "Hellfire_Peninsula"
Click Here to Farm in Zangarmarsh |confirm |next
step
map Zangarmarsh/0
path follow loose; loop on; ants curved
path	49.50,66.90	58.80,70.50	66.60,74.90	69.10,87.00	72.20,87.30
path	74.80,91.80	86.30,90.70	85.70,79.00	82.20,69.50	81.80,62.00
path	83.50,58.90	87.40,55.70	87.00,46.20	88.50,36.90	86.30,27.80
path	77.60,29.50	72.10,32.70	70.20,36.50	63.90,33.10	54.70,32.80
path	46.20,29.50	41.00,30.20	34.60,14.80	31.50,20.90	20.70,16.60
path	20.20,8.90	20.80,4.00	16.50,5.80	16.20,14.70	14.80,30.60
path	10.00,44.80	7.10,49.80	10.50,63.90	15.90,64.40	17.60,70.00
path	25.50,69.10	27.70,60.20	36.80,67.00
Use the Prospecting ability |cast Prospecting##31252
|tip Use it on the Ore in your bags.
|goldcollect 16 Eternium Ore##23427
|goldcollect Fel Iron Ore##23424 |n
|goldcollect Adamantite Ore##23425 |n
|goldcollect Mote of Earth##22573 |n
|goldcollect Mote of Fire##22574
|goldcollect 12 Golden Draenite##23112
|goldcollect 4 Blood Garnet##23077
|goldcollect 8 Deep Peridot##23079
|goldcollect 28 Azure Moonstone##23117
|goldcollect 16 Flame Spessarite##21929
|goldcollect 12 Shadow Draenite##23107
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Hellfire_Peninsula"
map Hellfire Peninsula/0
path follow smart; loop on; ants curved; dist 20
path	69.30,47.50	74.50,38.70	68.20,37.70	62.00,31.00	58.00,32.80
path	54.00,26.70	46.00,29.30	34.10,29.10	32.00,34.50	38.50,38.20
path	35.70,40.70	33.40,49.80	30.30,48.60	32.50,43.30	28.50,39.30
path	26.50,45.50	22.60,45.10	18.00,38.30	12.50,36.10	17.90,46.30
path	11.80,41.90	12.00,47.00	06.20,49.50	15.40,62.40	20.30,52.90
path	24.00,61.10	21.20,62.70	28.10,80.80	27.70,69.50	30.50,72.80
path	30.30,59.90	34.80,66.60	37.70,53.30	46.90,46.30	49.30,49.50
path	60.30,48.60	60.80,52.80	52.10,52.70	47.20,57.70	45.90,75.50
path	33.50,89.60	33.10,92.60	49.10,77.50	44.60,86.20	55.50,82.80
path	58.70,78.80	56.50,72.30	65.80,63.60	67.10,71.70	63.00,73.30
path	65.80,77.90	68.70,77.60	71.00,71.70	70.10,68.60	65.00,59.80
path	65.60,56.00	75.00,63.90	78.40,80.20	80.70,77.50	77.30,63.70
path	72.70,60.20	71.50,53.10	68.30,52.00
Use the Prospecting ability |cast Prospecting##31252
|tip Use it on the Ore in your bags.
|goldcollect 16 Eternium Ore##23427
|goldcollect Fel Iron Ore##23424 |n
|goldcollect Mote of Earth##22573 |n
|goldcollect Mote of Fire##22574
|goldcollect 8 Golden Draenite##23112
|goldcollect 12 Blood Garnet##23077
|goldcollect 4 Deep Peridot##23079
|goldcollect 32 Azure Moonstone##23117
|goldcollect 12 Flame Spessarite##21929
|goldcollect 20 Shadow Draenite##23107
|goldtracker
Click Here to Sell Items |confirm
step
label "Sell_Items"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Adamantite Powder, Living Ruby, Talasite, Nightseye, Star Of Elune, Dawnstone, Noble Topaz",{
meta={goldtype="route",skillreq={outland_jewelcrafting=1,outland_mining=1},levelreq={15}},
items={{23426,12},{23427,64},{23424,1},{23425,1},{22573,1},{22574,1},{24243,88},{23436,8},{23441,4},{23437,4},{23438,12},{23440,12},{23439,4}},
maps={"Nagrand"},
},[[
step
map Nagrand/0
path follow smart; loop on; ants curved; dist 20
path	44.50,66.00	43.50,78.50	38.50,83.30	31.90,81.90	27.80,76.50
path	28.30,71.70	25.20,61.10	32.20,60.30	34.10,44.30	24.30,48.50
path	18.20,39.30	10.50,43.70	7.10,39.90	17.70,31.70	25.60,39.50
path 	26.80,23.60	25.70,16.50	38.80,37.00	39.10,27.50	42.80,19.50
path	49.30,24.10	57.00,24.50	60.50,31.60	67.50,35.50	73.50,44.80
path	66.10,51.90	76.30,62.20	69.80,72.50	70.10,83.30	63.00,73.10
path	59.80,62.00	56.00,54.70	48.00,57.50
Use the Prospecting ability |cast Prospecting##31252
|tip Use it on the Ore in your bags.
|goldcollect 12 Khorium Ore##23426
|goldcollect 64 Eternium Ore##23427
|goldcollect Fel Iron Ore##23424 |n
|goldcollect Adamantite Ore##23425 |n
|goldcollect Mote of Earth##22573 |n
|goldcollect Mote of Fire##22574 |n
|goldcollect 88 Adamantite Powder##24243
|goldcollect 8 Living Ruby##23436
|goldcollect 4 Nightseye##23441
|goldcollect 4 Talasite##23437
|goldcollect 12 Star of Elune##23438
|goldcollect 12 Dawnstone##23440
|goldcollect 4 Noble Topaz##23439
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Huge Citrine, Shadow Crystal, Chalcedony, Bloodstone, Sun Crystal, Dark Jade",{
meta={goldtype="route",skillreq={northrend_jewelcrafting=1,northrend_mining=1},levelreq={20}},
items={{36909,1},{36912,1},{37701,28},{37705,32},{36929,12},{36926,4},{36923,12},{36917,8},{36920,8},{36932,24}},
maps={"Zul'Drak"},
},[[
step
map Zul'Drak/0
path follow smart; loop on; ants curved; dist 20
path	31.20,76.20	20.00,76.50	11.60,78.10	14.00,68.30	23.70,69.50
path	25.20,63.20	16.10,57.60	20.90,47.50	24.30,54.80	36.00,62.40
path	34.30,55.00	35.70,46.20	31.90,39.20	41.50,41.60	44.00,51.60
path	47.60,40.10	54.00,33.00	53.50,50.50	69.20,32.70	70.70,24.60
path	78.90,22.50	78.50,41.90	75.00,50.90	69.90,49.10	61.50,58.80
path	78.80,70.60	74.10,73.90	60.10,84.30	55.10,72.50	49.10,66.90
path	44.50,75.40	45.00,84.90	37.20,84.20
Use the Prospecting ability |cast Prospecting##31252
|tip Use it on the Ore in your bags.
|goldcollect Cobalt Ore##36909 |n
|goldcollect Saronite Ore##36912 |n
|goldcollect 28 Crystallized Earth##37701
|goldcollect 32 Crystallized Water##37705
|goldcollect 12 Huge Citrine##36929
|goldcollect 4 Shadow Crystal##36926
|goldcollect 12 Chalcedony##36923
|goldcollect 8 Bloodstone##36917
|goldcollect 8 Sun Crystal##36920
|goldcollect 24 Dark Jade##36932
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Hessonite, Alicite, Carnelian, Nightstone, Jasper, Zephyrite",{
meta={goldtype="route",skillreq={cataclysm_jewelcrafting=1,cataclysm_mining=1},levelreq={30}},
items={{53038,1},{52327,12},{52181,8},{52179,4},{52177,12},{52180,16},{52182,4},{52178,8},{52185,1},{52326,4}},
maps={"Deepholm ","Mount Hyjal"},
},[[
step
Click Here to Farm in Deepholm |confirm |next "Deepholm"
Click Here to Farm in Mount Hyjal |confirm |next
step
map Mount Hyjal/0
path follow loose; loop on; ants curved
path	57.80,14.50	50.50,17.00	44.90,25.50	40.50,33.60	33.50,23.70
path	27.80,38.60	13.90,34.80	15.50,52.50	25.40,60.70	36.00,51.00
path	38.50,61.60	32.90,66.00	31.50,82.30	36.60,95.50	51.50,80.50
path	60.60,82.50	56.70,66.50	50.50,56.50	59.70,56.30	72.70,65.00
path	84.30,64.90	85.90,48.50	76.80,57.50	67.50,50.60	65.50,32.50
path	65.70,18.50
Use the Prospecting ability |cast Prospecting##31252
|tip Use it on the Ore in your bags.
|goldcollect Obsidium Ore##53038 |n
|goldcollect 12 Volatile Earth##52327
|goldcollect 8 Hessonite##52181
|goldcollect 4 Alicite##52179
|goldcollect 12 Carnelian##52177
|goldcollect 16 Nightstone##52180
|goldcollect 4 Jasper##52182
|goldcollect 8 Zephyrite##52178
|goldtracker
Click Here to Sell Items |confirm |next "Sell_Items"
step
label "Deepholm"
map Deepholm/0
path follow loose; loop on; ants curved
path	54.70,53.60	57.90,40.50	59.80,31.50	62.50,23.70	64.30,17.10
path	68.10,27.50	65.20,36.10	69.70,35.30	77.10,37.20	78.60,49.80
path	63.30,46.10	61.00,56.30	64.60,61.60	69.90,55.60	74.70,60.70
path	75.30,68.40	65.60,65.00	61.30,72.40	70.90,71.80	67.70,79.60
path	62.00,85.50	53.20,75.10	53.30,85.70	47.90,89.80	37.50,87.40
path	30.10,81.50	33.10,74.60	25.20,73.10	20.80,62.00	19.60,49.10
path	24.50,38.30	26.00,28.80	31.30,27.80	28.90,20.50	36.60,14.80
path	46.50,10.50	44.10,23.20	50.00,20.10	47.70,32.90	39.90,38.90
path	34.60,32.50	30.20,44.60	29.70,57.40	34.40,64.30	37.80,54.70
path	43.50,67.40	36.50,69.20	40.60,74.90	42.40,80.80	47.10,71.50
path	48.70,68.80	47.70,62.00
Use the Prospecting ability |cast Prospecting##31252
|tip Use it on the Ore in your bags.
|goldcollect Obsidium Ore##53038 |n
|goldcollect Elementium Ore##52185 |n
|goldcollect 16 Volatile Earth##52327
|goldcollect 4 Volatile Water##52326
|goldcollect 8 Hessonite##52181
|goldcollect 4 Alicite##52179
|goldcollect 12 Carnelian##52177
|goldcollect 24 Nightstone##52180
|goldcollect 8 Jasper##52182
|goldcollect 12 Zephyrite##52178
|goldtracker
Click Here to Sell Items |confirm
step
label "Sell_Items"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Alexandrite, Sparkling Shard, Pandarian Garnet, Roguestone, Sunstone, Lapis Lazuli, Tiger Opal, Imperial Amethyst, Primordial Ruby, River's Heart, Wild Jade, Sun's Raidance, Vermilion Onyx",{
meta={goldtype="route",skillreq={pandaria_mining=1,pandaria_jewelcrafting=1},levelreq={10}},
items={{72092,1},{90407,160},{76137,32},{76136,36},{76135,36},{76134,40},{76133,32},{76130,32},{76141,4},{76131,8},{76138,4},{76139,4},{76142,8},{76140,12}},
maps={"The Jade Forest"},
},[[
step
map The Jade Forest/0
path follow smart; loop on; ants curved
path	29.30,8.50	34.90,17.80	38.50,8.00	56.30,29.30	51.30,51.70
path	69.10,85.80	54.00,81.00	44.90,94.50	38.90,62.70	33.60,42.50
path	42.80,39.80	25.00,26.00
Use the Prospecting ability |cast Prospecting##31252
|tip Use it on the Ore in your bags.
|goldcollect Ghost Iron Ore##72092 |n
|goldcollect 160 Sparkling Shard##90407
|goldcollect 32 Alexandrite##76137
|goldcollect 36 Pandarian Garnet##76136
|goldcollect 36 Roguestone##76135
|goldcollect 40 Sunstone##76134
|goldcollect 32 Lapis Lazuli##76133
|goldcollect 32 Tiger Opal##76130
|goldcollect 4 Imperial Amethyst##76141
|goldcollect 8 Primordial Ruby##76131
|goldcollect 4 River's Heart##76138
|goldcollect 4 Wild Jade##76139
|goldcollect 8 Sun's Radiance##76142
|goldcollect 12 Vermilion Onyx##76140
|goldtracker
Click Here to Sell Items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Gold Ore",{
meta={goldtype="route",skillreq={mining=1},levelreq=15},
items={{2776,116},{3858,640},{7912,600},{7909,12},{3864,12}},
maps={"Felwood"},
},[[
step
map Felwood
path	follow loose; loop on; ants curved; dist 20
path	50.50,86.50	48.10,92.80	43.20,82.30
path	40.30,77.50	40.70,72.90	37.80,73.40
path	37.40,69.30	36.30,67.70	36.60,65.30
path	41.80,62.60	40.70,59.70	35.30,60.60
path	35.50,58.10	39.00,57.50	37.60,47.90
path	38.60,37.40	41.00,27.50	42.00,24.10
path	40.50,22.00	42.50,17.10	44.70,18.20
path	45.10,14.90	52.70,12.70	54.60,12.80
path	56.60,8.40	57.50,14.40	59.80,16.90
path	62.10,8.70	63.00,17.70	63.50,24.40
path	56.60,18.80	57.40,23.20	59.30,26.90
path	51.90,34.30	49.70,37.50	46.00,43.70
path	44.50,48.60	43.10,53.10	43.10,59.40
path	44.20,63.20	48.00,72.50	49.60,76.50
path	55.00,80.90
_Follow_ the path, mining any nodes you come across
|goldcollect 116 Gold Ore##2776
|goldcollect 640 Mithril Ore##3858
|goldcollect 600 Solid Stone##7912
|goldcollect 12 Aquamarine##7909
|goldcollect 12 Citrine##3864
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Iron Ore/Heavy Stone",{
meta={goldtype="route",skillreq={mining=1},levelreq=35},
items={{2775,16},{2838,860},{2772,728},{3858,20},{7912,20},{1529,8},{3864,8}},
maps={"Feralas"},
},[[
step
map Feralas
path	follow loose; loop on; ants curved; dist 20
path	 84.90,39.90	81.80,39.30	79.20,37.20
path	75.30,35.50	71.50,34.70	68.40,39.70
path	68.10,46.10	70.00,48.60	68.70,52.00
path	65.50,52.50	63.80,54.90	61.50,50.50
path	58.20,51.40	53.80,49.40	48.60,44.00
path	48.60,38.80	49.70,34.90	51.60,33.80
path	49.50,26.10	51.70,25.50	51.30,19.00
path	52.70,16.50	54.90,8.10	53.40,5.50
path	51.60,4.80	48.50,11.50	46.10,7.20
path	42.00,8.20	40.00,7.70	37.10,12.10
path	38.20,18.60	37.00,25.60	41.20,25.50
path	41.50,17.20	45.20,21.10	46.00,15.70
path	47.70,22.10	46.20,26.60	47.20,34.70
path	46.70,44.90	50.30,52.70	54.80,53.90
path	55.00,59.80	54.60,64.00	52.90,66.20
path	53.60,73.70	55.50,75.70	61.50,75.00
path	61.60,68.90	64.00,68.90	61.90,66.20
path	61.00,59.10	64.10,58.70	63.70,61.00
path	65.80,63.50	68.10,61.50	71.60,65.10
path	77.20,62.10	75.90,53.50	76.20,49.60
path	79.50,46.20	84.00,45.60	82.50,43.10
_Follow_ the path, mining any nodes you come across
|goldcollect 16 Silver Ore##2775
|goldcollect 860 Heavy Stone##2838
|goldcollect 728 Iron Ore##2772
|goldcollect 20 Mithril Ore##3858
|goldcollect 20 Solid Stone##7912
|goldcollect 8 Jade##1529
|goldcollect 8 Citrine##3864
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Mithril Ore/Solid Stone",{
meta={goldtype="route",skillreq={mining=1},levelreq=15},
items={{7912,620},{3858,604},{7911,40},{2776,40},{3864,16},{7910,8}},
maps={"Badlands"},
},[[
step
map Badlands
path	follow loose; loop on; ants curved; dist 20
path	25.70,52.50	21.90,51.40	23.10,60.50
path	26.10,64.90	22.70,66.00	17.60,62.00
path	14.00,69.90	11.10,68.70	13.60,59.70
path	9.80,52.00	14.50,48.00	10.70,38.70
path	13.20,35.80	21.50,36.50	29.50,37.80
path	37.70,31.90	46.90,21.80	47.80,13.00
path	50.80,13.20	51.30,22.00	58.20,23.20
path	72.80,28.00	72.60,38.10	75.00,48.50
path	66.50,57.20	60.60,43.70	57.00,37.70
path	58.20,33.10	48.10,34.30	47.50,39.50
path	52.20,46.90	56.50,47.20	57.50,59.80
path	50.90,63.70	43.90,64.60	38.10,64.90
path	34.30,62.70	38.70,55.60	44.60,57.20
path	45.90,47.20
_Follow_ the path, mining any nodes you come across
|goldcollect 620 Solid Stone##7912
|goldcollect 604 Mithril Ore##3858
|goldcollect 40 Truesilver Ore##7911
|goldcollect 40 Gold Ore##2776
|goldcollect 16 Citrine##3864
|goldcollect 8 Star Ruby##7910
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Thorium Ore/Dense Stone/Truesilver Ore",{
meta={goldtype="route",skillreq={mining=1},levelreq=15},
items={{7910,16},{12365,944},{10620,744},{12363,24},{12800,8},{12361,4},{12364,4},{12799,8},{7911,44},{2776,24}},
maps={"Winterspring"},
},[[
step
map Winterspring
path	follow loose; loop on; ants curved; dist 20
path	68.00,54.30
path	65.00,63.10	67.90,64.20	67.00,68.50
path	62.60,73.70	65.30,75.50	62.60,80.90
path	63.30,87.40	58.40,83.20	58.90,81.50
path	56.50,78.50	55.20,68.90	51.20,69.60
path	53.30,64.30	46.60,60.10	42.20,54.30
path	40.20,57.90	31.80,57.90	26.60,57.60
path	23.20,61.90	24.00,46.70	27.30,48.00
path	30.00,53.30	31.50,53.50	31.30,48.00
path	36.00,48.90	36.00,52.40	37.80,48.30
path	39.90,49.90	42.80,48.50	45.40,45.80
path	47.60,52.70	49.80,42.80	45.20,29.50
path	45.60,13.80	49.30,15.50	54.50,21.20
path	58.30,18.40	60.60,21.50	60.80,37.20
path	60.00,42.80	54.30,46.00
_Follow_ the path, mining any nodes you come across
|goldcollect 16 Star Ruby##7910
|goldcollect 944 Dense Stone##12365
|goldcollect 744 Thorium Ore##10620
|goldcollect 24 Arcane Crystal##12363
|goldcollect 8 Azerothian Diamond##12800
|goldcollect 4 Blue Sapphire##12361
|goldcollect 4 Huge Emerald##12364
|goldcollect 8 Large Opal##12799
|goldcollect 44 Truesilver Ore##7911
|goldcollect 24 Gold Ore##2776
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Tin Ore/Silver Ore/Coarse Stone",{
meta={goldtype="route",skillreq={mining=1},levelreq=10},
items={{2836,312},{2838,116},{2771,340},{2775,100},{2772,108},{1210,8},{1705,4},{1206,8}},
maps={"Northern Stranglethorn"},
},[[
step
map Northern Stranglethorn
path	follow loose; loop on; ants curved; dist 20
path	47.20,18.20	44.50,18.50	43.20,15.60
path	34.60,15.50	30.60,20.60	30.60,25.90
path	28.70,29.40	23.00,24.30	21.70,20.10
path	19.30,21.60	23.90,35.60	33.60,33.10
path	34.90,24.50	42.00,30.20	38.50,33.50
path	39.50,44.60	42.80,38.60	43.80,50.10
path	44.60,55.70	55.70,55.40	53.10,62.60
path	52.90,71.10	56.50,71.80	56.40,66.40
path	60.30,65.60	61.60,74.70	63.80,71.40
path	63.50,64.50	58.80,61.30	62.00,58.50
path	58.60,52.40	56.20,48.60	57.90,44.30
path	66.10,52.80	68.90,48.10	67.30,41.50
path	61.90,39.70	62.60,35.60	58.00,30.20
path	53.70,27.50	59.60,24.50	64.10,23.50
path	65.50,12.20	63.00,18.60	60.30,15.70
path	59.50,18.00	57.20,16.00	55.60,21.70
path	53.20,17.00	51.40,16.80	51.10,22.50
_Follow_ the path, mining any nodes you come across
|goldcollect 312 Coarse Stone##2836
|goldcollect 116 Heavy Stone##2838
|goldcollect 340 Tin Ore##2771
|goldcollect 100 Silver Ore##2775
|goldcollect 108 Iron Ore##2772
|goldcollect 8 Shadowgem##1210
|goldcollect 4 Lesser Moonstone##1705
|goldcollect 8 Moss Agate##1206
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Adamantite Ore/Eternium Ore/Khorium Ore",{
meta={goldtype="route",skillreq={outland_mining=1},levelreq=15},
items={{23427,20},{23425,252},{22573,160},{23424,76},{22574,40},{23426,32}},
maps={"Nagrand"},
},[[
step
map Nagrand
path	follow smart; loop on; ants curved; dist 10
path	48.40,72.20	49.70,66.20	56.30,59.40
path	56.00,54.80	49.60,57.50	45.00,54.70
path	43.10,58.90	46.40,75.50	41.90,77.00
path	35.70,79.30	31.10,75.30	27.30,63.00
path	33.40,57.50	33.70,49.40	24.00,47.40
path	19.70,46.70	11.40,43.00	11.30,36.60
path	19.90,32.10	25.00,32.80	28.20,31.80
path	26.50,20.50	30.00,18.10	36.30,23.00
path	40.50,35.40	43.10,22.80	50.80,23.50
path	57.00,29.00	65.00,37.60	70.30,42.60
path	68.80,51.10	72.30,58.10	73.80,67.90
path	69.80,78.10	57.90,75.50	49.00,79.00
_Follow_ the path, mining any nodes you come across
|goldcollect 20 Eternium Ore##23427
|goldcollect 252 Adamantite Ore##23425
|goldcollect 160 Mote of Earth##22573
|goldcollect 76 Fel Iron Ore##23424
|goldcollect 40 Mote of Fire##22574
|goldcollect 32 Khorium Ore##23426
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Fel Iron Ore",{
meta={goldtype="route",skillreq={outland_mining=1},levelreq=10},
items={{23424,320},{22573,64},{22574,56},{23427,4}},
maps={"Hellfire Peninsula"},
},[[
step
map Hellfire Peninsula
path	follow loose; loop on; ants curved; dist 15
path	69.30,47.50	74.50,38.70	68.20,37.70
path	62.00,31.00	58.00,32.80	54.00,26.70
path	46.00,29.30	34.10,29.10	32.00,34.50
path	38.50,38.20	35.70,40.70	33.40,49.80
path	30.30,48.60	32.50,43.30	28.50,39.30
path	26.50,45.50	22.60,45.10	18.00,38.30
path	12.50,36.10	17.90,46.30	11.80,41.90
path	12.00,47.00	06.20,49.50	15.40,62.40
path	20.30,52.90	24.00,61.10	21.20,62.70
path	28.10,80.80	27.70,69.50	30.50,72.80
path	30.30,59.90	34.80,66.60	37.70,53.30
path	46.90,46.30	49.30,49.50	60.30,48.60
path	60.80,52.80	52.10,52.70	47.20,57.70
path	45.90,75.50	33.50,89.60	33.10,92.60
path	49.10,77.50	44.60,86.20	55.50,82.80
path	58.70,78.80	56.50,72.30	65.80,63.60
path	67.10,71.70	63.00,73.30	65.80,77.90
path	68.70,77.60	71.00,71.70	69.30,64.00
path	65.00,59.80	65.60,56.00	75.00,63.90
path	78.40,80.20	80.70,77.50	77.30,63.70
path	74.70,58.70	68.30,52.00
_Follow_ the path, mining any nodes you come across
|goldcollect 320 Fel Iron Ore##23424
|goldcollect 64 Mote of Earth##22573
|goldcollect 56 Mote of Fire##22574
|goldcollect 4 Eternium Ore##23427
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Cobalt Ore",{
meta={goldtype="route",skillreq={northrend_mining=1},levelreq=20},
items={{37701,20},{36909,320},{37705,56}},
maps={"Zul'Drak"},
},[[
step
map Zul'Drak
path	follow loose; loop on; ants curved; dist 20
path	46.10,82.30	45.00,84.90	37.20,84.20
path	37.20,78.80	35.30,72.60	31.90,83.10
path	31.20,76.20	33.40,68.10	29.80,71.50
path	26.00,68.10	20.40,72.00	20.00,76.40
path	14.80,76.70	11.10,77.50	11.20,74.90
path	12.10,70.70	14.10,70.00	13.50,64.60
path	16.10,57.60	19.80,55.00	24.40,54.70
path	22.50,63.70	24.20,65.70	25.30,63.20
path	30.10,64.60	36.00,62.40	32.00,56.10
path	37.00,55.50	34.50,41.80	34.10,40.10
path	35.60,45.10	39.30,43.30	42.90,41.80
path	41.50,47.90	44.00,51.60	45.50,51.00
path	47.60,40.10	54.00,33.00	54.80,37.00
path	52.90,43.00	52.80,51.00	53.90,53.40
path	55.40,51.00	56.10,47.90	55.40,44.90
path	57.80,34.70	70.10,26.80	70.90,34.00
path	73.20,34.70	73.90,27.00	78.90,22.50
path	80.60,25.50	78.60,27.30	78.50,41.90
path	76.60,46.90	69.80,49.10	71.40,51.90
path	75.00,50.90	78.80,70.60	74.90,74.90
path	60.20,74.80	49.10,66.90	52.20,73.30
path	54.90,74.40	59.00,80.50	54.80,79.70
path	50.30,79.10	49.00,73.40	47.80,76.60
path	45.30,76.50
_Follow_ the path, mining any nodes you come across
|goldcollect 20 Crystallized Earth##37701
|goldcollect 320 Cobalt Ore##36909
|goldcollect 56 Crystallized Water##37705
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Saronite Ore",{
meta={goldtype="route",skillreq={northrend_mining=1},levelreq=20},
items={{36912,440},{36910,12},{37701,104},{37703,100},{37705,16}},
maps={"Sholazar Basin"},
},[[
step
map Sholazar Basin
path	follow loose; loop on; ants curved; dist 20
path	35.90,40.20	33.70,35.50	31.10,36.50
path	28.50,42.80	26.80,43.60	25.00,46.20
path	23.90,47.30	22.20,53.20	20.80,56.30
path	20.80,64.70	20.70,72.20	20.70,78.60
path	23.80,85.70	26.70,84.10	29.00,86.00
path	34.60,88.90	35.40,85.20	35.70,79.30
path	34.20,78.30	33.50,75.90	34.20,72.00
path	35.80,67.60	40.90,70.20	39.30,75.50
path	38.10,88.50	40.00,88.50	46.50,88.50
path	53.50,87.60	59.00,87.00	60.20,85.00
path	59.70,81.40	63.10,78.90	62.30,74.30
path	57.70,76.80	55.80,81.40	54.10,83.50
path	51.50,82.10	51.30,78.10	48.50,76.80
path	47.20,73.00	55.50,66.50	57.90,67.30
path	60.00,60.20	58.90,53.90	56.50,57.10
path	53.30,62.20	51.60,60.60	51.60,63.10
path	47.40,67.00	46.30,65.50	46.00,60.90
path	40.00,50.80	38.10,55.00	35.10,59.50
path	35.20,54.70	30.60,55.50	30.90,50.80
path	33.60,45.70	35.80,49.90
_Follow_ the path, mining any nodes you come across
|goldcollect 440 Saronite Ore##36912
|goldcollect 12 Titanium Ore##36910
|goldcollect 104 Crystallized Earth##37701
|goldcollect 100 Crystallized Shadow##37703
|goldcollect 16 Crystallized Water##37705
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Titanium Ore",{
meta={goldtype="route",skillreq={northrend_mining=1},levelreq=25},
items={{36912,312},{36910,96},{37701,176},{37703,80},{37705,48},{37700,24},{37702,24}},
maps={"Icecrown"},
},[[
step
map Icecrown
path	follow loose; loop on; ants curved; dist 20
path	82.10,70.30	81.60,64.00	75.70,68.50
path	70.80,68.10	67.60,69.10	66.10,62.70
path	72.10,63.30	77.60,56.30	77.80,49.80
path	74.10,39.60	70.20,39.20	67.50,46.70
path	65.50,57.10	63.80,55.50	62.70,47.70
path	64.70,41.60	63.00,37.90	60.60,32.30
path	57.90,38.20	58.90,43.60	52.50,45.10
path	49.10,30.60	46.60,37.60	43.50,39.70
path	41.90,34.10	39.90,34.50	36.60,43.50
path	33.80,47.20	30.90,56.30	28.00,65.70
path	31.20,71.30	35.10,70.00	33.40,66.60
path	42.90,61.50	36.70,55.30	39.60,48.90
path	43.80,45.50	46.90,46.80	48.50,52.20
path	49.50,63.80	47.50,70.40	47.80,81.20
path	51.50,86.90	56.50,90.00	54.80,77.90
path	60.10,74.00	67.50,72.90
_Follow_ the path, mining any nodes you come across
|goldcollect 312 Saronite Ore##36912
|goldcollect 96 Titanium Ore##36910
|goldcollect 176 Crystallized Earth##37701
|goldcollect 80 Crystallized Shadow##37703
|goldcollect 48 Crystallized Water##37705
|goldcollect 24 Crystallized Air##37700
|goldcollect 24 Crystallized Fire##37702
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Elementium Ore/Pyrite Ore",{
meta={goldtype="route",skillreq={cataclysm_mining=1},levelreq=30},
items={{52185,444},{52327,52},{52183,84},{52325,8}},
maps={"Twilight Highlands"},
},[[
step
map Twilight Highlands
path	follow loose; loop on; ants curved; dist 20
path	59.30,76.60	55.50,79.50	55.90,84.80
path	52.10,81.20	48.60,77.80	43.30,87.60
path	39.90,88.90	34.90,87.30	37.60,81.60
path	37.10,76.20	33.20,71.10	28.90,68.40
path	26.60,69.50	25.90,62.90	39.70,70.50
path	38.20,62.90	38.00,57.40	35.90,52.40
path	29.80,54.60	21.90,58.50	19.70,57.60
path	29.20,49.50	31.40,47.10	29.70,40.00
path	25.50,39.10	29.60,35.10	32.20,30.50
path	31.90,37.50	33.10,38.80	34.60,48.00
path	37.80,43.30	37.50,40.30	36.60,34.50
path	37.90,32.50	37.60,26.20	35.50,22.40
path	37.50,18.10	39.30,21.50	49.00,20.50
path	52.00,19.70	57.50,25.50	58.30,21.60
path	57.90,15.60	60.70,11.50	67.20,18.30
path	62.00,28.10	64.70,35.20	69.50,35.60
path	75.00,46.30	70.80,48.80	69.40,45.00
path	66.10,39.80	63.50,39.00	58.00,34.90
path	53.50,35.40	47.60,40.20	46.50,44.30
path	40.70,45.30	40.60,47.80	46.30,51.10
path	49.40,48.20	52.00,42.80	54.80,39.70
path	58.50,39.80	63.00,44.50	65.50,48.40
path	67.00,54.10	59.10,49.10	56.70,49.20
path	51.80,50.90	50.50,56.10	48.90,62.00
path	53.80,59.70	57.90,55.20
_Follow_ the path, mining any nodes you come across
|goldcollect 444 Elementium Ore##52185
|goldcollect 52 Volatile Earth##52327
|goldcollect 84 Pyrite Ore##52183
|goldcollect 8 Volatile Fire##52325
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Obsidium Ore",{
meta={goldtype="route",skillreq={cataclysm_mining=1},levelreq=30},
items={{53038,488},{52327,58}},
maps={"Deepholm"},
},[[
step
map Deepholm
path	follow smart; loop on; ants curved; dist 10
path	47.60,58.90	48.30,64.60	52.10,63.30
path	53.40,58.10	57.70,53.50	57.70,47.90
path	55.80,46.70	56.60,44.60	55.20,39.60
path	57.50,39.70	59.80,46.10	63.40,45.20
path	63.60,49.60	61.60,49.60	60.30,55.30
path	62.10,57.60	63.70,54.40	64.70,57.00
path	64.60,61.60	62.90,64.90	65.60,65.00
path	66.00,71.20	65.40,74.60	65.50,77.50
path	65.30,83.20	64.00,85.30	60.10,85.20
path	58.80,88.10	56.40,90.10	54.30,86.30
path	57.30,79.40	54.60,77.80	53.60,80.90
path	51.90,78.50	51.40,79.80	46.20,72.20
path	44.40,75.90	43.30,80.10	41.50,80.20
path	41.50,75.60	38.30,73.40	37.90,70.60
path	35.20,68.20	34.40,64.30	31.80,60.20
path	29.20,56.70	28.00,53.70	29.50,53.10
path	32.10,56.90	36.90,55.40	37.10,52.50
path	29.40,45.50	29.60,42.50	31.60,38.50
path	33.90,36.40	34.90,31.90	35.40,30.10
path	37.80,35.10	38.90,39.00	42.70,36.60
path	44.70,33.90	46.60,38.00	42.70,42.80
path	43.00,54.00
_Follow_ the path, mining any nodes you come across
|goldcollect 488 Obsidium Ore##53038
|goldcollect 58 Volatile Earth##52327
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Black Trillium Ore/White Trillium Ore",{
meta={goldtype="route",skillreq={pandaria_mining=1},levelreq=25},
items={{72092,552},{72093,40},{72094,44},{72103,44}},
maps={"Townlong Steppes"},
},[[
step
map Townlong Steppes
path	follow smart; loop on; ants curved; dist 20
path	64.60,36.10	66.50,36.80	66.40,41.10
path	69.10,42.00	72.20,47.00	72.60,49.80
path	72.40,58.50	73.00,61.20	77.60,64.90
path	81.50,67.60	83.60,71.20	85.40,72.10
path	84.40,75.20	79.90,75.20	75.80,72.80
path	75.30,75.20	79.00,81.00	83.70,80.50
path	81.60,87.30	81.00,89.20	79.40,90.80
path	76.00,87.50	71.80,84.70	70.90,78.10
path	70.90,73.70	67.20,70.60	64.70,71.40
path	61.20,72.70	61.50,70.20	64.50,66.30
path	66.70,64.40	67.60,60.30	69.50,54.80
path	69.90,48.40	67.70,43.70	65.00,41.00
path	63.10,44.10	67.40,52.30	65.70,56.50
path	64.10,53.70	62.40,46.10	58.40,50.10
path	59.30,56.30	58.80,63.40	52.40,61.90
path	51.00,56.50	53.40,53.60	55.40,49.00
path	57.70,46.30	57.60,43.40	60.40,43.70
path	62.50,36.70
_Follow_ the path, mining any nodes you come across
|goldcollect 552 Ghost Iron Ore##72092
|goldcollect 40 Kyparite##72093
|goldcollect 44 Black Trillium Ore##72094
|goldcollect 44 White Trillium Ore##72103
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Ghost Iron Ore",{
meta={goldtype="route",skillreq={pandaria_mining=1},levelreq=10},
items={{72092,724}},
maps={"The Jade Forest"},
},[[
step
map The Jade Forest
path	follow smart; loop on; ants curved; dist 20
path	54.90,93.50	58.50,93.90	60.60,91.60
path	62.20,91.50	64.70,88.90	60.90,86.50
path	61.90,83.10	64.00,82.20	67.70,85.40
path	65.80,78.50	64.80,76.10	62.10,76.60
path	62.90,71.70	60.00,70.10	59.70,78.80
path	57.90,79.50	57.50,76.10	54.50,71.20
path	58.60,63.50	60.50,61.80	61.70,57.90
path	59.10,52.90	56.70,53.90	50.50,52.50
path	47.90,51.60	49.90,49.40	52.00,43.80
path	54.50,39.20	55.00,35.10	56.20,30.00
path	52.90,26.70	52.80,21.20	50.60,19.10
path	48.30,24.70	45.60,27.70	43.50,28.60
path	45.20,33.80	43.30,35.70	41.50,43.20
path	39.10,51.40	37.70,54.00	37.80,57.40
path	38.00,63.50	37.60,68.70	39.00,72.00
path	40.30,70.40	42.60,72.90	39.90,78.80
path	41.30,84.80	42.50,90.00	44.20,94.40
path	49.50,94.00	50.70,88.80	53.30,89.60
_Follow_ the path, mining any nodes you come across
|goldcollect 724 Ghost Iron Ore##72092
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Kyparite",{
meta={goldtype="route",skillreq={pandaria_mining=1},levelreq=30},
items={{72092,92},{72093,212}},
maps={"Dread Wastes"},
},[[
step
map Dread Wastes
path	follow smart; loop on; ants curved; dist 20
path	65.00,46.10	61.10,44.10	55.30,42.20
path	50.30,41.20	49.20,35.90	54.20,36.00
path	56.30,35.50	56.30,32.30	53.80,31.70
path	48.90,32.30	49.70,26.50	53.20,21.40
path	57.60,18.70	63.60,16.10	68.20,14.90
path	67.10,11.20	63.20,12.30	59.00,11.20
path	54.50,14.90	50.50,18.30	48.40,22.90
path	46.30,25.30	46.60,31.80	47.10,36.60
path	46.80,46.10	51.20,46.30	51.20,51.70
path	54.20,50.50	57.60,49.20	63.40,51.20
path	67.20,51.90
_Follow_ the path, mining any nodes you come across
|goldcollect 92 Ghost Iron Ore##72092
|goldcollect 212 Kyparite##72093
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Blackrock/True Iron Ore",{
meta={goldtype="route",skillreq={draenor_mining=1},levelreq=10},
items={{109119,212},{109118,216}},
maps={"Shadowmoon Valley D"},
},[[
step
map Shadowmoon Valley D
path	follow loose; loop on; ants curved; dist 20
path	36.80,39.60	38.70,39.10	40.20,43.10
path	39.20,47.30	43.20,49.60	43.50,53.90
path	47.30,54.90	49.90,59.10	50.10,61.90
path	53.40,60.80	52.20,56.90	53.90,54.60
path	58.50,53.40	57.20,48.80	52.30,50.20
path	53.90,48.00	54.10,45.00	57.20,40.90
path	60.20,44.30	64.10,36.60	66.30,35.50
path	65.80,30.30	60.70,32.60	51.90,40.00
path	48.80,40.70	44.30,44.40	42.50,40.00
path	43.90,34.80	45.70,31.20	49.70,29.70
path	54.10,28.90	52.90,26.90	50.40,26.90
path	50.40,23.00	48.50,25.70	45.20,29.00
path	41.30,25.10	41.20,22.90	43.90,20.00
path	40.90,18.30	38.30,19.90	38.30,22.50
path	39.40,25.20	38.70,27.40	36.10,26.70
path	33.30,26.70	24.10,24.80	24.10,29.30
path	26.00,29.30	29.30,33.60	34.70,33.90
path	36.10,30.30	38.70,31.00
_Follow_ the path, mining any nodes you come across
|goldcollect 212 True Iron Ore##109119
|goldcollect 216 Blackrock Ore##109118
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Deviate Scale/Perfect Deviate Scale",{
meta={goldtype="route",skillreq={skinning=1},levelreq=5},
items={{6470,40},{6471,16},{2319,24},{4232,4},{2318,280},{783,12}},
maps={"Northern Barrens"},
},[[
step
label "route_1"
map Northern Barrens/20
path	follow smart; loop off; ants curved; dist 15
path	22.70,88.90	22.40,79.80	28.50,68.90
path	25.80,58.20	25.30,49.50	21.20,39.30
path	24.50,25.10	36.10,23.60	44.00,31.20
path	55.60,25.40	62.20,23.90	71.70,20.40
path	78.00,34.90	76.80,45.60	67.80,52.30
path	52.70,59.70	50.00,40.20
kill Deviate Creeper##3632+, Deviate Stalker##3634+, Deviate Slayer##3633+, Deviate Lurker##3641+
Follow the path, killing any Deviate mobs you see |goto Northern Barrens/20 50.00,40.20 < 20 |noway |c |next "route_2" |or
|goldcollect 40 Deviate Scale##6470 |next "Sell" |or
|goldcollect 16 Perfect Deviate Scale##6471
|goldcollect 24 Medium Leather##2319
|goldcollect 4 Medium Hide##4232
|goldcollect 280 Light Leather##2318
|goldcollect 12 Light Hide##783
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_2"
map Northern Barrens/20
path	follow smart; loop off; ants curved; dist 15
path	50.00,40.20	48.80,28.70	44.00,31.20
path	36.10,23.60	24.50,25.10	21.20,39.30
path	25.30,49.50	25.30,54.80	18.50,52.10
kill Deviate Creeper##3632+, Deviate Stalker##3634+, Deviate Slayer##3633+, Deviate Lurker##3641+
Follow the path, killing any Deviate mobs you see |goto Northern Barrens/20 18.50,52.10 < 20 |noway |c |next "route_3" |or
|goldcollect 40 Deviate Scale##6470 |next "Sell" |or
|goldcollect 16 Perfect Deviate Scale##6471
|goldcollect 24 Medium Leather##2319
|goldcollect 4 Medium Hide##4232
|goldcollect 280 Light Leather##2318
|goldcollect 12 Light Hide##783
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_3"
map Northern Barrens/20
path	follow smart; loop off; ants curved; dist 15
path	18.50,52.10	23.20,55.20	28.50,68.30
path	21.80,81.40
kill Deviate Creeper##3632+, Deviate Stalker##3634+, Deviate Slayer##3633+, Deviate Lurker##3641+
Follow the path, killing any Deviate mobs you see |goto Northern Barrens/20 21.80,81.40 |noway |c |next "route_1" |or
|goldcollect 40 Deviate Scale##6470 |next "Sell" |or
|goldcollect 16 Perfect Deviate Scale##6471
|goldcollect 24 Medium Leather##2319
|goldcollect 4 Medium Hide##4232
|goldcollect 280 Light Leather##2318
|goldcollect 12 Light Hide##783
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Heavy Leather/Heavy Hide",{
meta={goldtype="route",skillreq={skinning=1},levelreq=15},
items={{4235,12},{4234,288},{4304,80},{4306,208},{4338,28}},
maps={"Feralas"},
},[[
step
label "route_1"
map Feralas/0
path	follow loose; loop off; ants curved; dist 8
path	50.90,32.90	51.80,32.10	52.30,31.20
path	52.90,30.10
kill Rage Scar Yeti##40224+, Feral Scar Yeti##39896+
Follow the path, killing any yetis you see |goto Feralas/0 52.90,30.10 |noway |c |next "route_2" |or
|goldcollect 12 Heavy Hide##4235 |next "Sell" |or
|goldcollect 288 Heavy Leather##4234
|goldcollect 80 Thick Leather##4304
|goldcollect 208 Silk Cloth##4306
|goldcollect 28 Mageweave Cloth##4338
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_2"
map Feralas/0
path	follow loose; loop off; ants curved; dist 8
path	52.90,30.10	52.10,31.60	53.10,31.80
path	53.60,32.00	54.10,32.60	55.00,32.40
path	54.60,32.00
kill Rage Scar Yeti##40224+, Feral Scar Yeti##39896+
Follow the path, killing any yetis you see |goto Feralas/0 54.60,32.00 < 7 |noway |c |next "route_3" |or
|goldcollect 12 Heavy Hide##4235 |next "Sell" |or
|goldcollect 288 Heavy Leather##4234
|goldcollect 80 Thick Leather##4304
|goldcollect 208 Silk Cloth##4306
|goldcollect 28 Mageweave Cloth##4338
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_3"
map Feralas/0
path	follow loose; loop off; ants curved; dist 8
path	54.60,32.00	55.00,32.30	55.30,33.50
path	55.80,33.30	55.50,32.90	54.80,33.10
path	54.40,33.10	54.50,33.40	54.90,33.60
path	54.60,33.90
kill Rage Scar Yeti##40224+, Feral Scar Yeti##39896+
Follow the path, killing any yetis you see |goto Feralas/0 54.60,33.90 < 7 |noway |c |next "route_4" |or
|goldcollect 12 Heavy Hide##4235 |next "Sell" |or
|goldcollect 288 Heavy Leather##4234
|goldcollect 80 Thick Leather##4304
|goldcollect 208 Silk Cloth##4306
|goldcollect 28 Mageweave Cloth##4338
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_4"
map Feralas/0
path	follow loose; loop off; ants curved; dist 8
path	54.60,33.90	54.90,33.60	54.40,33.30
path	54.50,33.00	54.90,33.00	55.50,32.90
path	55.80,33.30	55.50,33.50	55.20,33.20
path	55.00,32.50	54.10,32.50	53.70,32.00
path	53.10,31.80	52.20,31.80	51.80,32.10
path	50.90,32.90
kill Rage Scar Yeti##40224+, Feral Scar Yeti##39896+
Follow the path, killing any yetis you see |goto Feralas/0 50.90,32.90 < 15 |noway |c |next "route_1" |or
|goldcollect 12 Heavy Hide##4235 |next "Sell" |or
|goldcollect 288 Heavy Leather##4234
|goldcollect 80 Thick Leather##4304
|goldcollect 208 Silk Cloth##4306
|goldcollect 28 Mageweave Cloth##4338
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Thick Leather",{
meta={goldtype="route",skillreq={skinning=1},levelreq=15},
items={{4304,420},{8170,104},{8169,8}},
maps={"Badlands"},
},[[
step
map Badlands
path	follow smart; loop on; ants curved; dist 15
path	9.40,45.50	8.60,42.50	9.00,38.30
path	10.80,36.40	12.30,39.00	10.70,40.10
path	10.40,43.70
kill Nyxondra's Broodling##46916+, Nyxondra##46861
|goldcollect 420 Thick Leather##4304
|goldcollect 104 Rugged Leather##8170
|goldcollect 8 Thick Hide##8169
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Rugged Leather/Rugged Hide (Onyxia's Lair)",{
meta={goldtype="route",skillreq={skinning=1},levelreq=30,elitemobs=1},
items={{8170,244},{8171,158},{33470,10}},
maps={"Onyxia's Lair","Dustwallow Marsh"},
},[[
step
label "route_1"
map Onyxia's Lair/1
path follow smart; loop off; ants curved; dist 15
path	34.30,20.90	40.10,31.60	43.20,37.00
path	43.60,56.60	54.00,76.80	63.50,85.40
kill Onyxian Warder##12129+
Follow the path and kill the 4 Onyxian Warders. DO NOT KILL ONYXIA |goto Onyxia's Lair/1 63.50,85.40 |noway |c |next "route_2" |or
|goldcollect 244 Rugged Leather##8170 |next "Sell" |or
|goldcollect 158 Rugged Hide##8171 |n
|goldcollect 10 Frostweave Cloth##33470 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_2"
map Onyxia's Lair/1
path follow smart; loop off; ants curved; dist 15
path	63.50,85.40	54.00,76.80	43.60,56.60
path	43.20,37.00	37.90,29.70	39.50,15.90
path	45.20,14.50	45.80,21.70	33.10,20.60
Leave Onyxia's Lair. DO NOT KILL ONYXIA |goto Dustwallow Marsh/0 52.90,77.60 |noway |c |next "route_3" |or
|goldcollect 288 Rugged Leather##8170 |next "Sell" |or
|goldcollect 12 Rugged Hide##8171
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_3"
Right-click your player's unit frame and select "_Reset all instances_"
After resetting Onyxia's Lair, re-enter the instance |goto Onyxia's Lair/1 34.30,20.90 |noway |c |next "route_1" |or
|goldcollect 288 Rugged Leather##8170 |next "Sell" |goto Onyxia's Lair/1 34.30,20.90 |or
|goldcollect 12 Rugged Hide##8171 |goto Onyxia's Lair/1 34.30,20.90
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Rugged Leather",{
meta={goldtype="route",skillreq={skinning=1},levelreq=15},
items={{4304,28},{8170,416}},
maps={"Blasted Lands"},
},[[
step
label "route_1"
talk Zidormi##88206
Tell her: "_Show me the Blasted Lands before the Invasion._" |complete ZGV.InPhase('Old Blasted Lands') |goto Blasted Lands 48.20,7.30
step
label "route_2"
map Blasted Lands/0
path	follow smart; loop on; ants curved; dist 15
path	55.20,24.00	52.50,28.10	58.90,35.30
path	58.30,40.40	55.50,46.20	51.80,46.20
path	52.20,41.10	48.60,35.30	44.30,33.70
path	48.70,32.10	48.80,28.20	47.50,23.30
path	44.00,20.30	42.50,22.90	41.40,20.70
path	43.50,16.90	44.90,14.70	47.10,12.40
path	48.70,12.40	48.10,17.00	48.30,21.00
path	52.30,24.30
kill Ashmane Boar##5992+, Snickerfang Hyena##5985+, Felhound##6010+, Redstone Basilisk##5990+
Follow the path, killing and skinning beasts |complete not ZGV.InPhase('Old Blasted Lands') |next "route_1" |or
|goldcollect 28 Thick Leather##4304 |or
|goldcollect 416 Rugged Leather##8170
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "route_3"
use Imperfect Draenethyst Fragment##10593 |only if itemcount(10593) > 0 |repeatable
accept One Draenei's Junk##25771 |only if itemcount(10593) > 0 |repeatable
|next "route_4"
step
label "route_4"
talk Kum'isha the Collector##7363
turnin One Draenei's Junk...##25771 |goto Blasted Lands/0 48.76,31.88 |repeatable |only if haveq(25771)
|next "route_5" |only if itemcount(10593) < 1
|next "route_3"
step
label "route_5"
use Flawless Draenethyst Sphere##8244 |only if itemcount(8244) > 0
accept Kum'isha's Endeavors##25772 |repeatable |only if itemcount(8244) > 0
|next "route_6"
step
label "route_6"
talk Kum'isha the Collector##7363
turnin Kum'isha's Endeavors##25772 |goto Blasted Lands/0 48.76,31.88 |repeatable |only if haveq(25772)
|next "Sell" |only if itemcount(8244) < 1
|next "route_5"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Turtle Scale/Thick Leather",{
meta={goldtype="route",skillreq={skinning=1},levelreq=15},
items={{8167,192},{4304,148},{8170,44},{8169,6}},
maps={"Swamp of Sorrows"},
},[[
step
label "Path 1"
map Swamp of Sorrows/0
path	follow smart; loop on; ants curved; dist 20
path	71.10,73.10	73.30,70.10	75.70,72.50
path	78.20,69.00	79.00,63.60	83.30,63.70
path	83.00,68.80	78.90,71.90	77.40,75.70
path	76.00,79.80
kill Sorrowmurk Snapjaw##45950+
Follow the path, killing and skinning any turtles you see
|goldcollect 192 Turtle Scale##8167
|goldcollect 148 Thick Leather##4304
|goldcollect 44 Rugged Leather##8170
|goldcollect 6 Thick Hide##8169 |n
|goldtracker
Click here to sell items |confirm |next
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Black Whelp Scale",{
meta={goldtype="route",skillreq={skinning=1},levelreq=10},
items={{7286,148},{2318,108,'crap'},{2319,144,'crap'},{783,8,'crap'},{4232,16,'crap'}},
maps={"Wetlands"},
},[[
step
map Wetlands
path	follow loose; loop on; ants curved; dist 10
path	63.90,37.90	65.40,40.50	67.40,43.20
path	68.70,43.70	70.20,43.90	71.30,46.30
path	71.90,48.60	69.90,49.80	68.20,51.00
path	67.70,53.40	66.50,54.40	65.00,54.10
path	64.10,52.70	64.30,50.40	63.40,48.80
path	62.10,48.30	62.70,44.90	62.40,43.10
path	60.60,41.50	61.40,39.60	61.70,37.40
kill Ebon Whelp##42042+
|goldcollect 148 Black Whelp Scale##7286
|meta crap_items_follow=1
|goldcollect 108 Light Leather##2318
|goldcollect 144 Medium Leather##2319
|goldcollect 8 Light Hide##783
|goldcollect 16 Medium Hide##4232
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Warbear Leather",{
meta={goldtype="route",skillreq={skinning=1},levelreq=15},
items={{15419,40},{8170,192,'crap'},{8171,24,'crap'}},
maps={"Blasted Lands"},
},[[
step
talk Zidormi##88206
Tell her: "_Show me the Blasted Lands before the Invasion._" |complete ZGV.InPhase('Old Blasted Lands') |goto Blasted Lands 48.20,7.30
step
map Blasted Lands
path	follow loose; loop on; ants curved; dist 10
path	38.20,62.30	36.20,58.90	35.20,55.40
path	36.10,52.80	38.10,53.50	39.90,53.20
path	40.60,56.00	41.20,58.10	39.70,59.00
kill Tainted Black Bear##42336+
|goldcollect 40 Warbear Leather##15419
|meta crap_items_follow=1
|goldcollect 192 Rugged Leather##8170
|goldcollect 24 Rugged Hide##8171
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Scorpid Scale",{
meta={goldtype="route",skillreq={skinning=1},levelreq=15},
items={{8154,112},{4234,24,'crap'},{4304,100,'crap'},{8170,4,'crap'}},
maps={"Tanaris"},
},[[
step
map Tanaris
path	follow smart; loop on; ants curved; dist 20
path	41.20,22.60	44.00,24.20	46.20,24.60
path	44.60,29.60	49.80,34.00	51.80,34.60
path	51.20,39.60	53.60,43.20	58.00,50.60
path	61.40,54.40	60.80,60.60	55.60,53.60
path	52.40,56.60	51.60,60.60	49.40,56.60
path	50.20,45.20	46.80,42.60	46.80,38.60
path	43.20,33.40	39.00,23.00
kill Dune Rattler##44568+, Duneclaw Stalker##44587+, Basking Cobra##40657+, Duneclaw Burrower##44546+, Duneclaw Matriarch##40656+, Duneclaw Lasher##40717+
|goldcollect 112 Scorpid Scale##8154
|meta crap_items_follow=1
|goldcollect 24 Heavy Leather##4234
|goldcollect 100 Thick Leather##4304
|goldcollect 4 Rugged Leather##8170
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Devilsaur Leather",{
meta={goldtype="route",skillreq={skinning=1},levelreq=15,elitemobs=1},
items={{15417,240}},
maps={"Un'Goro Crater"},
},[[
step
kill Devilsaur Queen##38346+ |goto Un'Goro Crater 35.00,81.50
|tip It spawns once every 32 seconds
|goldcollect 240 Devilsaur Leather##15417
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Heavy Scorpid Scale/Thick Leather/Rugged Leather/Rugged Hide",{
meta={goldtype="route",skillreq={skinning=1},levelreq=15},
items={{15408,52},{4304,76,'crap'},{8170,48,'crap'},{8171,8,'crap'}},
maps={"Silithus"},
},[[
step
map Silithus
path	follow smart; loop on; ants curved; dist 10
path	39.40,33.50	40.50,37.10	40.90,42.60
path	40.20,53.00	39.20,59.00	38.60,65.80
path	40.70,72.10	46.10,66.50	50.40,65.70
path	52.30,63.50	53.70,59.80	55.60,58.00
path	60.40,57.80	64.70,59.70	65.30,55.00
path	58.10,50.80	53.70,49.30	50.20,46.20
path	47.50,44.50
kill Stonelash Scorpid##11735+,Stonelash Pincer##11736+,Stonelash Flayer##11737+
|goldcollect 52 Heavy Scorpid Scale##15408
|meta crap_items_follow=1
|goldcollect 76 Thick Leather##4304
|goldcollect 48 Rugged Leather##8170
|goldcollect 8 Rugged Hide##8171
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Deepsea Scale/Savage Leather",{
meta={goldtype="route",skillreq={skinning=1},levelreq=15},
items={{52982,116},{52976,220,'crap'}},
maps={"Feralas"},
},[[
step
map Feralas
path	follow loose; loop on; ants curved
path	75.80,68.20	75.80,74.00	71.60,75.60
path	68.40,75.60	66.00,71.60	66.60,69.00
path	72.00,69.00
kill King Crawler##51714
|goldcollect 116 Deepsea Scale##52982
|meta crap_items_follow=1
|goldcollect 220 Savage Leather##52976
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Knothide Leather (Karazhan)",{
meta={goldtype="route",skillreq={outland_skinning=1},levelreq=30},
items={{21887,1204},{25649,420},{25707,60},{31952,8,'crap'}},
maps={"Deadwind Pass","Karazhan"},
},[[
step
Enter Karazhan |goto Karazhan/1 58.80,76.10 |c
step
label "Start"
map Karazhan/1
path	follow smart; loop off; ants curved; dist 8
path	58.80,76.10	57.40,72.40	60.90,67.70
path	57.80,60.30	58.10,55.40	54.10,50.00
path	54.10,44.40	51.20,39.60	51.40,28.50
path	60.20,29.50	60.80,17.30	73.30,20.50
kill Vampiric Shadowbat##16175+, Shadowbat##16173+, Greater Shadowbat##16174+, Phase Hound##16178+, Dreadbeast##16177+, Shadowbeast##16176+
Follow the path avoiding the spiders, killing and skinning any bats and hounds you see |goto Karazhan/1 73.30,20.50 < 10 |noway |c |next "Return" |or
|goldcollect 1204 Knothide Leather##21887 |next "Sell" |or
|goldcollect 420 Knothide Leather Scraps##25649
|goldcollect 60 Fel Hide##25707
|meta crap_items_follow=1
|goldcollect 8 Khorium Lockbox##31952 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Return"
map Karazhan/1
path	follow smart; loop off; ants curved; dist 8
path	73.30,20.50	60.40,20.40	59.60,29.60
path	59.10,37.00	56.10,49.50	57.90,56.90
path	60.50,67.90	57.30,73.60	59.80,78.30
kill Vampiric Shadowbat##16175+, Shadowbat##16173+, Greater Shadowbat##16174+, Phase Hound##16178+, Dreadbeast##16177+, Shadowbeast##16176+
Follow the path and leave Karazhan |goto Deadwind Pass/0 46.90,74.80 |noway |c |next "Reset" |or
|goldcollect 1204 Knothide Leather##21887 |next "Sell" |or
|goldcollect 420 Knothide Leather Scraps##25649
|goldcollect 60 Fel Hide##25707
|meta crap_items_follow=1
|goldcollect 8 Khorium Lockbox##31952 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Reset"
Right-click your player's unit frame and select "_Reset all instances_"
After resetting Karazhan, re-enter the instance |goto Karazhan/1 58.80,76.10 |noway |c |next "Start"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Knothide Leather",{
meta={goldtype="route",skillreq={outland_skinning=1},levelreq=15},
items={{21887,484},{31952,4,'crap'},{27674,244,'crap'},{21877,56,'crap'}},
maps={"Terokkar Forest"},
},[[
step
label "Start"
map Terokkar Forest/0
path	follow smart; loop off; ants curved; dist 20
path	45.90,4.70	48.10,7.40	50.20,10.10
path	52.70,12.50	54.80,13.00	56.90,13.10
path	58.40,13.10	60.80,10.40
kill Razorthorn Ravager##24922+
Follow the path killing and skinning any Ravagers you see |goto Terokkar Forest/0 60.80,10.40 < 10 |noway |c |next "Return" |or
|goldcollect 484 Knothide Leather##21887 |next "Sell" |or
|meta crap_items_follow=1
|goldcollect 4 Khorium Lockbox##31952 |n
|goldcollect 244 Ravager Flesh##27674 |n
|goldcollect 56 Netherweave Cloth##21877 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Return"
map Terokkar Forest/0
path	follow smart; loop off; ants curved; dist 20
path	60.80,10.40	58.40,13.10	56.90,13.10
path	54.80,13.00	52.70,12.50	50.20,10.10
path	48.10,7.40	45.90,4.70
kill Razorthorn Ravager##24922
Follow the path killing and skinning any Ravagers you see |goto Terokkar Forest/0 45.90,4.70 |noway |c |next "Start" |or
|goldcollect 484 Knothide Leather##21887 |next "Sell" |or
|meta crap_items_follow=1
|goldcollect 4 Khorium Lockbox##31952 |n
|goldcollect 244 Ravager Flesh##27674 |n
|goldcollect 56 Netherweave Cloth##21877 |n
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Wind Scale/Knothide Leather",{
meta={goldtype="route",skillreq={outland_skinning=1},levelreq=20},
items={{29547,72},{21887,116,'crap'}},
maps={"Blade's Edge Mountains"},
},[[
step
map Blade's Edge Mountains
path	follow loose; loop on; ants curved; dist 10
path	61.60,54.60	65.00,50.60	67.20,52.80
path	68.20,61.60	68.60,74.60	67.40,70.00
path	67.00,60.60
kill Scalewing Serpent##20749+
|goldcollect 72 Wind Scales##29547
|meta crap_items_follow=1
|goldcollect 116 Knothide Leather##21887
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Nether Dragonscales",{
meta={goldtype="route",skillreq={outland_skinning=1},levelreq=25},
items={{29548,64},{21887,148,'crap'}},
maps={"Netherstorm"},
},[[
step
map Netherstorm
path	follow smart; loop on; ants curved; dist 10
path	71.40,35.40	71.50,38.50	71.90,43.10
path	73.50,42.40	74.20,39.50	73.20,38.30
path	73.70,35.80	72.60,34.50
kill Nether Drake##18877+, Nether Dragon##20332+
|goldcollect 64 Nether Dragonscales##29548
|meta crap_items_follow=1
|goldcollect 148 Knothide Leather##21887
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Thick Clefthoof Leather",{
meta={goldtype="route",skillreq={outland_skinning=1},levelreq=15},
items={{25708,56},{21887,104,'crap'}},
maps={"Nagrand"},
},[[
step
map Nagrand
path	follow smart; loop on; ants curved; dist 10
path	40.00,24.20	44.20,24.80	50.80,28.20
path	53.60,31.60	50.60,36.00	51.80,39.20
path	56.60,43.60	60.00,41.40	69.60,45.00
path	72.60,40.60	71.60,47.60	70.00,53.00
path	62.60,50.40	60.60,47.60	57.60,46.80
path	53.60,51.60	48.80,40.40	46.60,31.20
kill Clefthoof Bull##17132+, Clefthoof##18205+
|goldcollect 56 Thick Clefthoof Leather##25708
|meta crap_items_follow=1
|goldcollect 104 Knothide Leather##21887
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Fel Scales/Crystal Infused Leather",{
meta={goldtype="route",skillreq={outland_skinning=1},levelreq=10},
items={{25700,36},{25699,30},{21887,66,'crap'}},
maps={"Zangarmarsh"},
},[[
step
map Zangarmarsh
path	follow smart; loop on; ants curved; dist 10
path	87.80,37.60	88.80,33.40	88.20,27.80
path	83.00,27.20	79.00,28.80	74.60,29.60
path	82.00,31.40	86.80,30.60
kill Marshrock Stomper##20283+, Marshrock Threshalisk##19706+
|goldcollect 36 Fel Scales##25700
|goldcollect 30 Crystal Infused Leather##25699
|meta crap_items_follow=1
|goldcollect 66 Knothide Leather##21887
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Cobra Scale",{
meta={goldtype="route",skillreq={outland_skinning=1},levelreq={25}},
items={{29539,12},{21887,68,'crap'}},
maps={"Shadowmoon Valley"},
},[[
step
map Shadowmoon Valley
path	follow smart; loop on; ants curved; dist 10
path	60.40,21.00	68.20,22.20	68.60,29.40
path	73.40,28.60	73.60,31.20	65.00,29.60
path	65.40,24.80	62.60,22.80
kill Shadow Serpent##23020+
|goldcollect 12 Cobra Scales##29539
|meta crap_items_follow=1
|goldcollect 68 Knothide Leather##21887
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Fel Hide",{
meta={goldtype="route",skillreq={outland_skinning=1},levelreq=25},
items={{25707,56},{21887,188,'crap'}},
maps={"Netherstorm"},
},[[
step
map Netherstorm
path	follow loose; loop on; ants curved
path	68.00,65.40	68.60,63.00	68.00,60.20
path	67.00,58.80	63.20,58.40	59.80,58.40
path	56.80,56.60	54.20,60.20	61.20,61.60
path	62.20,62.60	63.20,65.60	65.00,68.60
kill Warp Chaser##18884+
|tip Kill Warp Chasers along and in the center of the path
|goldcollect 56 Fel Hide##25707
|meta crap_items_follow=1
|goldcollect 188 Knothide Leather##21887
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Borean Leather (Gundrak)",{
meta={goldtype="route",skillreq={northrend_skinning=1},levelreq=20},
items={{33568,450}},
maps={"Zul'Drak","Gundrak"},
},[[
step
Enter Gundrak |goto Gundrak/1 59.00,30.90 |c
step
label "Start"
map Gundrak/0
path	follow smart; loop off; ants curved; dist 20
path	59.00,30.90	57.80,35.20	58.80,40.70
path	58.80,58.90	58.10,67.50	53.10,73.50
kill Unyielding Constrictor##29768+, Spitting Cobra##29774+,
Follow the path killing and skinning any snakes you see |goto Gundrak/1 53.10,73.50 < 10 |noway |c |next "Return" |or
|goldcollect 450 Borean Leather##33568 |next "Sell" |or
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Return"
map Gundrak/0
path	follow smart; loop off; ants curved; dist 20
path	53.10,73.50	58.10,67.50	58.80,58.90
path	58.80,40.70	57.60,36.10	59.80,36.00
path	59.90,39.70	57.80,39.80	57.80,34.90
path	59.00,30.30	56.20,28.40
Follow the path and leave Gundrak |goto Zul'Drak/0 76.40,21.40 |noway |c |next "Reset" |or
|goldcollect 450 Borean Leather##33568 |next "Sell" |or
|goldtracker
Click here to sell items |confirm |next "Sell"
step
label "Reset"
Right-click your player's unit frame and select "_Reset all instances_"
After resetting Gundrak, re-enter the instance |goto Gundrak/1 59.00,30.90 |noway |c |next "Start"
step
label "Sell"
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Borean Leather",{
meta={goldtype="route",skillreq={northrend_skinning=1},levelreq=20},
items={{33568,596},{44128,4}},
maps={"Zul'Drak"},
},[[
step
map Zul'Drak/0
path	follow smart; loop on; ants curved; dist 25
path	77.90,21.30	77.00,18.00	73.20,19.60
path	71.60,25.00	71.20,29.80	71.30,32.90
path	75.20,37.30	77.80,42.40	79.20,38.00
path	81.00,32.50	85.20,27.90	81.80,26.90
path	75.50,30.30
kill Gundrak Raptor##29334+
Follow the path killing and skinning any raptors you see
|goldcollect 596 Borean Leather##33568
|goldcollect 4 Arctic Fur##44128
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Savage Leather/Pristine Hide (Tol Barad)",{
meta={goldtype="route",skillreq={northrend_skinning=1},levelreq=30},
items={{52976,532},{52980,4}},
maps={"Tol Barad Peninsula"},
},[[
step
map Tol Barad Peninsula
path	follow smart; loop on; ants curved; dist 10
path	60.50,52.70	56.90,50.10	54.10,48.10
path	52.30,50.10	54.10,56.00	57.80,60.10
path	61.00,57.20
kill Darkwood Lurker##46508+, Darkwood Broodmother##46507+
|goldcollect 532 Savage Leather##52976
|goldcollect 4 Pristine Hide##52980
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Icy Dragonscale/Arctic Fur",{
meta={goldtype="route",skillreq={northrend_skinning=1},levelreq=20},
items={{44128,4},{33568,200,'crap'},{38557,76,'crap'},{43013,144,'crap'}},
maps={"Sholazar Basin"},
},[[
step
map Sholazar Basin
path	follow loose; loop on; ants curved
path	42.40,28.60	45.80,31.20	48.20,30.60
path	48.80,27.40	49.00,23.20	46.80,23.20
path	45.20,23.60
kill Primordial Drake##28378+
|goldcollect 4 Arctic Fur##44128
|meta crap_items_follow=1
|goldcollect 200 Borean Leather##33568
|goldcollect 76 Icy Dragonscale##38557
|goldcollect 144 Chilled Meat##43013
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Nerubian Chitin",{
meta={goldtype="route",skillreq={northrend_skinning=1},levelreq=20},
items={{38558,44},{33568,140,'crap'},{33470,8,'crap'}},
maps={"Zul'Drak"},
},[[
step
map Zul'Drak
path	follow loose; loop on; ants curved
path	58.60,74.40	56.80,78.60	54.40,81.80
path	56.40,85.40	59.20,81.60	60.80,80.20
path	61.60,79.20
kill Hath'ar Skimmer##28258+, Hath'ar Necromagus##28257+
|goldcollect 44 Nerubian Chitin##38558
|meta crap_items_follow=1
|goldcollect 140 Borean Leather##33568
|goldcollect 8 Frostweave Cloth##33470
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Jormungar Scale",{
meta={goldtype="route",skillreq={northrend_skinning=1},levelreq=25},
items={{38561,20},{33568,80,'crap'},{43013,40,'crap'}},
maps={"The Storm Peaks"},
},[[
step
Enter the cave here |goto The Storm Peaks 56.00,64.20 < 20 |c
step
map The Storm Peaks
path	follow loose; loop on; ants curved
path	55.10,63.40	53.80,62.90	53.50,62.10
path	54.60,60.70	55.40,60.60	55.70,62.00
path	55.60,63.00
kill Ravenous Jormungar##29605+
|goldcollect 20 Jormungar Scale##38561
|meta crap_items_follow=1
|goldcollect 80 Borean Leather##33568
|goldcollect 40 Chilled Meat##43013
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Savage Leather/Pristine Hide (Twilight Highlands)",{
meta={goldtype="route",skillreq={cataclysm_skinning=1},levelreq=30},
items={{52976,390},{52980,4}},
maps={"Twilight Highlands"},
},[[
step
map Twilight Highlands/0
path	follow smart; loop on; ants curved; dist 10
path	52.50,26.70	54.20,28.60	58.00,27.10
path	61.30,30.80	62.10,37.50	66.30,42.10
path	69.10,41.10	68.10,31.70	71.60,30.50
path	67.10,21.60	65.70,14.60	62.30,9.30
path	57.30,10.00	52.00,10.20	53.40,18.90
kill Highland Worg##46153+, Highland Elk##46970+, Tawny Owl##46162+, Untamed Gryphon##46158+
|goldcollect 390 Savage Leather##52976
|goldcollect 4 Pristine Hide##52980
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Blackened Dragonscale",{
meta={goldtype="route",skillreq={cataclysm_skinning=1},levelreq=30},
items={{52979,96},{52976,216,'crap'}},
maps={"Twilight Highlands"},
},[[
step
map Twilight Highlands
path	follow smart; loop on; ants curved; dist 10
path	66.30,69.00	68.40,73.00	67.40,77.50
path	64.40,81.80	61.90,83.20	60.20,84.60
path	58.10,85.10	58.70,82.00	59.90,79.70
path	61.30,76.30	61.50,72.50	63.40,69.30
path	65.80,72.10
kill Obsidian Charscale##47797+, Obsidian Viletongue##47796+
|goldcollect 96 Blackened Dragonscale##52979
|meta crap_items_follow=1
|goldcollect 216 Savage Leather##52976
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Exotic Leather",{
meta={goldtype="route",skillreq={pandaria_skinning=1},levelreq=15},
items={{72120,824},{79101,24},{72201,68,'crap'},{89112,64,'crap'}},
maps={"Valley of the Four Winds"},
},[[
step
map Valley of the Four Winds
path	follow smart; loop on; ants curved; dist 15
path	28.70,30.90	27.40,32.30	27.80,37.40
path	29.40,41.70	30.00,44.90	31.60,32.60
kill Stout Shaghorn##59139+, Skyrange Mushan##64309+
|goldcollect 824 Exotic Leather##72120
|goldcollect 24 Prismatic Scale##79101
|meta crap_items_follow=1
|goldcollect 68 Plump Intestines##72201
|goldcollect 64 Mote of Harmony##89112
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Prismatic Scale",{
meta={goldtype="route",skillreq={pandaria_skinning=1},levelreq={10}},
items={{79101,84},{72120,252,'crap'}},
maps={"The Jade Forest"},
},[[
step
map The Jade Forest
path	follow smart; loop on; ants curved; dist 10
path	63.80,33.20	68.20,33.00	69.00,30.00
path	69.00,26.20	66.60,26.00	65.60,28.00
kill Saltback Yearling##58219+
|goldcollect 84 Prismatic Scale##79101
|meta crap_items_follow=1
|goldcollect 252 Exotic Leather##72120
|goldtracker
Click here to sell items |confirm
step
#include "auctioneer"
]])
ZygorGuidesViewer:RegisterGuide("GOLD\\Gathering\\Raw Beast Hide",{
meta={goldtype="route",skillreq={draenor_skinning=1},levelreq=35},
items={{110609,254},{111557,264},{109131,132}},
maps={"Nagrand D"},
},[[
step
kill Tamed Clefthoof##79034+
These Clefthoof mobs will respawn instantly when you kill them
|goldcollect 254 Raw Beast Hide##110609 |goto Nagrand D/0 78.60,72.20
|goldcollect 264 Sumptuous Fur##111557 |goto Nagrand D/0 78.60,72.20
|goldcollect 132 Raw Clefthoof Meat##109131 |goto Nagrand D/0 78.60,72.20
Click here to sell items |confirm
step
#include "auctioneer"
]])
