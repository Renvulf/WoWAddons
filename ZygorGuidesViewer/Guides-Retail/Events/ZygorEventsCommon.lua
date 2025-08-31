local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if ZGV:DoMutex("EventsC") then return end
ZygorGuidesViewer.GuideMenuTier = "CAT"
ZygorGuidesViewer:RegisterGuide("Events Guides\\Dragonflight (10-70)\\Azerothian Archives!",{
description="This guide will help you complete Azerothian Archives activities.",
startlevel=70,
patch='100205',
},[[
step
click Azerothian Archives!
|tip Inside the building.
accept To the Archives!##77325 |goto Valdrakken/0 46.60,47.61
step
talk Eadweard Dalyngrigge##206107
|tip Inside the base of the tower on the floating island.
turnin To the Archives!##77325 |goto Thaldraszus/0 61.57,31.32
accept The Big Dig: Traitor's Rest##79226 |goto Thaldraszus/0 61.57,31.32
step
talk Zenata##208355
|tip Inside the base of the tower on the floating island.
accept Technoscrying 101##77231 |goto Thaldraszus/0 61.62,31.12
step
talk Roska Rocktooth##208614
|tip Inside the base of the tower on the floating island.
accept Excavation 101##77267 |goto Thaldraszus/0 61.60,31.08
step
Meet Zenata Outside |q 77231/1 |goto Thaldraszus/0 61.26,30.75
step
use the Technoscryers##208084
Put on the Goggles |q 77231/2 |goto Thaldraszus/0 61.26,30.75
step
use the Technoscryers##208084
Activate the Auto-Adjuster |q 77231/3 |goto Thaldraszus/0 61.26,30.75
|tip Use the "Auto Adjusting..." ability on your action bar.
|tip It is highlighted in yellow.
step
use the Technoscryers##208084
Activate Scrying Mode |q 77231/4 |goto Thaldraszus/0 61.26,30.75
|tip Use the "Scrying Mode" ability on your action bar.
|tip It is highlighted in yellow.
step
use the Technoscryers##208084
Remove the Goggles |q 77231/5 |goto Thaldraszus/0 61.26,30.75
|tip Use the "Remove Goggles" ability on your action bar.
|tip It is highlighted in yellow.
step
talk Zenata##208355
turnin Technoscrying 101##77231 |goto Thaldraszus/0 61.26,30.75
accept A Practical Test##77166 |goto Thaldraszus/0 61.26,30.75
step
use the Technoscryers##202247
|tip Use the "Scrying Mode" ability on your action bar to locate a treasure nearby.
|tip Watch the bar until it fills up and the X is completely red, then find the treasure near you.
click Nirobin's Spectacles
Recover the Attunement "Relic" |q 77166/1 |goto Thaldraszus/0 61.87,29.84
step
talk Zenata##208355
turnin A Practical Test##77166 |goto Thaldraszus/0 61.69,29.87
accept I Can See Through Time!##77176 |goto Thaldraszus/0 61.69,29.87
step
Reach the Nexus Point |q 77176/1 |goto Thaldraszus/0 61.81,29.84
step
use the Technoscryers##202247
Put On the Goggles |q 77176/2 |goto Thaldraszus/0 61.81,29.84
step
use the Technoscryers##202247
Activate Observation Mode |q 77176/3 |goto Thaldraszus/0 61.81,29.84
|tip Use the "Observation Mode" ability in the second slot on your action bar.
step
Watch the dialogue
Observe the Temporal Scene |q 77176/4 |goto Thaldraszus/0 61.81,29.84
step
talk Zenata##208355
turnin I Can See Through Time!##77176 |goto Thaldraszus/0 61.69,29.87
accept Technoscrying: Observatory##77434 |goto Thaldraszus/0 61.69,29.87
step
Meet Roska Outside |q 77267/1 |goto Thaldraszus/0 61.06,30.60
step
use the Archivist's Fire Totem##210956
Place the Fire Totem |q 77267/2 |goto Thaldraszus/0 61.06,30.60
step
talk Roska Rocktooth##208614
Select _"I'm ready to start digging!"_
Speak to Roska to Start the Dig |q 77267/3 |goto Thaldraszus/0 61.06,30.60
step
use the Archivist's Fire Totem##210956
|tip Use it next to the smoking dirt patch on the ground.
clicknpc Roska's Fire Totem##208853
|tip It appears after using the totem.
Watch the dialogue
Unearth the First Find |q 77267/4 |goto Thaldraszus/0 61.16,30.48
step
use the Archivist's Fire Totem##210956
|tip Use it next to the smoking dirt patch on the ground.
clicknpc Roska's Fire Totem##208853
|tip It appears after using the totem.
Watch the dialogue
|tip You will be attacked by an elemental shortly.
Unearth the Second Find |q 77267/5 |goto Thaldraszus/0 61.32,30.47
step
use the Archivist's Fire Totem##210956
|tip Use it next to the smoking dirt patch on the ground.
clicknpc Roska's Fire Totem##208853
|tip It appears after using the totem.
Watch the dialogue
Unearth the Third Find |q 77267/6 |goto Thaldraszus/0 61.34,30.22
step
talk Roska Rocktooth##208614
turnin Excavation 101##77267 |goto Thaldraszus/0 61.39,30.22
accept Your First Find##78762 |goto Thaldraszus/0 61.39,30.22
step
use the Archivist's Fire Totem##210956
clicknpc Roska's Fire Totem##208853
|tip It appears after using the totem.
Use the Fire Totem to Increase Heat |q 78762/1 |goto Thaldraszus/0 61.34,30.22
step
Step Through Spontaneous Puddles to Lower Heat |q 78762/2 |goto Thaldraszus/0 61.34,30.22
|tip Run through the swirling water patches to lower the heat and move the bar toward water.
step
use the Archivist's Fire Totem##210956
clicknpc Roska's Fire Totem##208853
|tip It appears after using the totem.
|tip Alternate between this and stepping in water puddles to keep the indicator in the colored section of the bar.
|tip Small arrows on the left or right of the indicator mark indicate if the progress is towards heat or water.
click Outdated Geology Textbook
|tip While the indicator is in the colored area, click the textbook to fill the progress bar.
Fully Excavate the Find |q 78762/3 |goto Thaldraszus/0 61.34,30.21
step
talk Roska Rocktooth##208614
turnin Your First Find##78762 |goto Thaldraszus/0 61.38,30.23
accept Hands-On Experience##77268 |goto Thaldraszus/0 61.38,30.23
step
use the Archivist's Fire Totem##210956
clicknpc Roska's Fire Totem##208853
|tip It appears after using the totem.
Unearth the Major Find |q 77268/1 |goto Thaldraszus/0 61.50,30.04
step
use the Archivist's Fire Totem##210956
clicknpc Roska's Fire Totem##208853
|tip It appears after using the totem.
|tip Alternate between this and stepping in water puddles to keep the indicator in the colored section of the bar.
|tip Small arrows on the left or right of the indicator mark indicate if the progress is towards heat or water.
click Scholar's Chest
|tip While the indicator is in the colored area, click the textbook to fill the progress bar.
Excavate the Scholar's Chest |q 77268/2 |goto Thaldraszus/0 61.50,30.04
step
talk Roska Rocktooth##208614
turnin Hands-On Experience##77268 |goto Thaldraszus/0 61.58,30.02
accept Excavation: Riverbed##77433 |goto Thaldraszus/0 61.58,30.02
step
talk Zenata##204835
turnin Technoscrying: Observatory##77434 |goto The Waking Shores/0 56.38,43.95
accept Attune to the Observer##75729 |goto The Waking Shores/0 56.38,43.95
step
use the Technoscryers##202247
|tip Use the "Scrying Mode" ability on your action bar to locate a treasure nearby.
|tip Watch the bar until it fills up and the X is completely red, then find the treasure near you.
|tip You will sometimes see a light trail indicating a nearby relic.
click Weathered Staff
|tip Inside the building.
|tip Make sure the light cone is pointing at the relic to make it clickable.
Recover the Attunement Relic |q 75729/1 |goto The Waking Shores/0 56.00,45.40 |count 33 |noordinal
step
use the Technoscryers##202247
|tip Use the "Scrying Mode" ability on your action bar to locate a treasure nearby.
|tip Watch the bar until it fills up and the X is completely red, then find the treasure near you.
|tip You will sometimes see a light trail indicating a nearby relic.
click Tattered Hood
|tip Inside the building.
|tip Make sure the light cone is pointing at the relic to make it clickable.
Recover the Attunement Relic |q 75729/1 |goto The Waking Shores/0 57.85,44.55 |count 66 |noordinal
step
use the Technoscryers##202247
|tip Use the "Scrying Mode" ability on your action bar to locate a treasure nearby.
|tip Watch the bar until it fills up and the X is completely red, then find the treasure near you.
|tip You will sometimes see a light trail indicating a nearby relic.
click Cracked Epaulet
|tip Inside the building.
|tip Make sure the light cone is pointing at the relic to make it clickable.
Recover the Attunement Relic |q 75729/1 |goto The Waking Shores/0 56.83,41.91
step
talk Zenata##204835
turnin Attune to the Observer##75729 |goto The Waking Shores/0 56.38,43.95
accept A Link to the Past##75867 |goto The Waking Shores/0 56.38,43.95
step
Reach the Nexus Point |q 75867/1 |goto The Waking Shores/0 56.35,43.68
step
use the Technoscryers##202247
Put On the Goggles |q 75867/2 |goto The Waking Shores/0 56.35,43.68
step
use the Technoscryers##202247
|tip Use the "Observation Mode" ability in the second slot on your action bar.
Activate Observation Mode |q 75867/3 |goto The Waking Shores/0 56.35,43.68
step
Watch the dialogue
Observe the Temporal Scene |q 75867/4 |goto The Waking Shores/0 56.36,43.69
step
talk Zenata##204835
turnin A Link to the Past##75867 |goto The Waking Shores/0 56.37,43.95
accept A Window into the Future##75868 |goto The Waking Shores/0 56.37,43.95
step
click Dreadsquall Nest##404849+
|tip They look like giant bird nests in high locations around this area.
kill Agitated Dreadsquall##208141+
|tip They will sometimes attack you after investigating a nest.
|tip Loot them and the nests until you find the lens.
Search Dreadsquall Nests for the Lens |q 75868/1 |goto The Waking Shores/0 55.32,44.35
You can find more around:
[57.86,44.39]
[56.30,46.25]
[56.37,45.47]
[55.59,45.38]
[55.54,46.31]
[56.82,48.08]
step
talk Zenata##204835
turnin A Window into the Future##75868 |goto The Waking Shores/0 56.38,43.95
step
talk Roska Rocktooth##204094
turnin Excavation: Riverbed##77433 |goto Ohn'ahran Plains/0 67.34,47.55
accept Surveying the Riverbed##75493 |goto Ohn'ahran Plains/0 67.34,47.55
step
talk Roska Rocktooth##204094
Select _"I'm ready to start digging!"_
Watch the dialogue
Tell Roska to Start the Dig |q 75493/1 |goto Ohn'ahran Plains/0 67.34,47.55
step
use the Archivist's Water Totem##210435
clicknpc Roska's Water Totem##204704
|tip It appears after using the totem.
|tip Alternate between this and clicking Sturdy Earth to keep the indicator in the colored section of the bar.
click Sturdy Earth
|tip They look like piles of dirt on the ground around this area.
|tip Small arrows on the left or right of the indicator mark indicate if the progress is towards earth or water.
|tip While the indicator is in the colored area, click the textbook to fill the progress bar.
Unearth the Find |q 75493/2 |goto Ohn'ahran Plains/0 66.20,47.98 |count 1
step
use the Archivist's Water Totem##210435
clicknpc Roska's Water Totem##204704
|tip It appears after using the totem.
|tip Alternate between this and clicking Sturdy Earth to keep the indicator in the colored section of the bar.
click Sturdy Earth
|tip They look like piles of dirt on the ground around this area.
|tip Small arrows on the left or right of the indicator mark indicate if the progress is towards earth or water.
|tip While the indicator is in the colored area, click the relic to fill the progress bar.
Unearth the Find |q 75493/2 |goto Ohn'ahran Plains/0 64.91,48.22 |count 2
step
use the Archivist's Water Totem##210435
clicknpc Roska's Water Totem##204704
|tip It appears after using the totem.
Watch the dialogue
Unearth the Major Find |q 75493/3 |goto Ohn'ahran Plains/0 66.46,46.17
step
talk Ancient Centaur Corpse##204245
accept The Body on the Banks##75518 |goto Ohn'ahran Plains/0 66.45,46.23
step
talk Roska Rocktooth##204094
Select _"Let's start excavating!"_
Tell Roska to Start the Dig |q 75518/1 |goto Ohn'ahran Plains/0 66.40,46.00
step
use the Archivist's Water Totem##210435
clicknpc Roska's Water Totem##204704
|tip It appears after using the totem.
|tip Alternate between this and clicking Sturdy Earth to keep the indicator in the colored section of the bar.
click Sturdy Earth
|tip They look like piles of dirt on the ground around this area.
|tip Small arrows on the left or right of the indicator mark indicate if the progress is towards earth or water.
clicknpc Ancient Centaur Corpse##204245
|tip While the indicator is in the colored area, click the corpse to fill the progress bar.
Excavate the Body |q 75518/2 |goto Ohn'ahran Plains/0 66.47,46.22
step
talk Roska Rocktooth##204094
turnin Surveying the Riverbed##75493 |goto Ohn'ahran Plains/0 66.40,46.00
turnin The Body on the Banks##75518 |goto Ohn'ahran Plains/0 66.40,46.00
accept Do Rites by Her##75603 |goto Ohn'ahran Plains/0 66.40,46.00
step
talk Farrier Rondare##195547
Select _"<Share your archaeological finds.>"_
Inform Farrier Rondare |q 75603/2 |goto Ohn'ahran Plains/0 62.54,42.47
step
talk Storykeeper Jaru##195888
Select _"<Share your archaeological finds.>"_
Inform Storykeeper Jaru |q 75603/1 |goto Ohn'ahran Plains/0 60.97,39.18
step
talk Tigari Khan##187092
|tip Inside the building.
Select _"<Share your archaeological finds.>"_
Inform Tigari Khan |q 75603/3 |goto Ohn'ahran Plains/0 62.96,33.61
step
talk Tigari Khan##204383
Select _"Let's finally put her to rest."_
Meet Tigari Khan at the Riverbed Site |q 75603/4 |goto Ohn'ahran Plains/0 66.57,45.96
step
talk Roska Rocktooth##204643
turnin Do Rites by Her##75603 |goto Ohn'ahran Plains/0 66.39,46.00
accept Nirobin and the Office##77327 |goto Ohn'ahran Plains/0 66.39,46.00
step
talk Nirobin##205967
|tip Inside the building.
turnin Nirobin and the Office##77327 |goto Thaldraszus/0 58.48,36.75
accept Living History##76217 |goto Thaldraszus/0 58.48,36.75
step
click Hourglass of Time
|tip Inside the building.
Analyze the Relic's Time Era |q 76217/1 |goto Thaldraszus/0 58.52,36.75
step
click Compass of Placement
|tip Inside the building.
Analyze Relic's Origin |q 76217/2 |goto Thaldraszus/0 58.55,36.76
step
click Specimens of Inspiration
|tip Inside the building.
Analyze Relic's Context |q 76217/3 |goto Thaldraszus/0 58.57,36.79
step
click Intriguing Dracthyr Goblet
|tip Inside the building.
Analyze the Relic |q 76217/4 |goto Thaldraszus/0 58.52,36.81
step
talk Nirobin##205967
|tip Inside the building.
turnin Living History##76217 |goto Thaldraszus/0 58.48,36.75
accept Lab Partners with a Squirrel##76241 |goto Thaldraszus/0 58.48,36.75
step
talk Reese##205975
turnin Lab Partners with a Squirrel##76241 |goto The Forbidden Reach/5 53.66,47.56
accept A Research Thesis Worth Publishing##76242 |goto The Forbidden Reach/5 53.66,47.56
step
Watch the dialogue
Watch Reese Activate Clues |q 76242/1 |goto The Forbidden Reach/5 53.66,47.56
step
extraaction Gain Clue##412948
|tip Search around for groups of purple and blue ghostly animals and stand in the middle of them.
|tip Use the button that appears on the screen to collect the information from them.
clicknpc Juicy Clue##206895+
|tip They look like a white and blue animals running around this area.
Collect Information |q 76242/2 |goto The Forbidden Reach/5 54.98,42.32
step
Return to Nirobin's Office |q 76242/3 |goto Thaldraszus/0 58.48,36.76
|tip Inside the building.
step
extraaction Transmute Information##417012
|tip Inside the building.
|tip Stand with Reese and use the ability that appears on the screen.
Transmute Reese's Information |q 76242/4 |goto Thaldraszus/0 58.49,36.86
step
click Tome of Archived Isels Research
|tip Inside the building.
Read the Research Tome |q 76242/5 |goto Thaldraszus/0 58.47,36.73
step
talk Nirobin##205967
|tip Inside the building.
turnin A Research Thesis Worth Publishing##76242 |goto Thaldraszus/0 58.48,36.76
accept Back to Headquarters!##77328 |goto Thaldraszus/0 58.48,36.76
step
talk Eadweard Dalyngrigge##206107
|tip Inside the base of the tower on the floating island.
turnin Back to Headquarters!##77328 |goto Thaldraszus/0 61.57,31.32
accept Finally, An Archivist!##79223 |goto Thaldraszus/0 61.57,31.32
step
talk Provisioner Aristta##209192
|tip Inside the base of the tower on the floating island.
buy 1 Archivist's Buckled Cap##208451 |q 79223/1 |goto Thaldraszus/0 61.37,31.40
step
talk Eadweard Dalyngrigge##206107
|tip Inside the base of the tower on the floating island.
turnin Finally, An Archivist!##79223 |goto Thaldraszus/0 61.57,31.32
step
talk Zenata##208355
|tip Inside the base of the tower on the floating island.
accept Technoscrying: Dragonskull Island##77483 |goto Thaldraszus/0 61.62,31.12
accept Technoscrying: Igira's Watch##77484 |goto Thaldraszus/0 61.62,31.12
step
talk Roska Rocktooth##208614
|tip Inside the base of the tower on the floating island.
accept Excavation: Gaze of Neltharion##77486 |goto Thaldraszus/0 61.60,31.08
accept Excavation: Winglord's Perch##77487 |goto Thaldraszus/0 61.60,31.08
step
talk Zenata##207311
turnin Technoscrying: Dragonskull Island##77483 |goto The Forbidden Reach/5 77.14,38.37
accept The Fate of Scalecommander Abereth##76448 |goto The Forbidden Reach/5 77.14,38.37
step
use the Technoscryers##202247
|tip Use the "Scrying Mode" ability on your action bar to locate a treasure nearby.
|tip Watch the bar until it fills up and the X is completely red, then find the treasure near you.
|tip You will sometimes see a light trail indicating a nearby relic.
click Drakonid Blade
|tip Inside the cave.
|tip Make sure the light cone is pointing at the relic to make it clickable.
Recover the Attunement Relics |q 76448/1 |goto Dragonskull Island/0 70.56,71.32 |count 33 |noordinal
step
Enter the side cave |goto Dragonskull Island/0 54.73,19.80 < 10 |walk
use the Technoscryers##202247
|tip Use the "Scrying Mode" ability on your action bar to locate a treasure nearby.
|tip Watch the bar until it fills up and the X is completely red, then find the treasure near you.
|tip You will sometimes see a light trail indicating a nearby relic.
click Pitted Blade
|tip Inside the cave.
|tip Make sure the light cone is pointing at the relic to make it clickable.
Recover the Attunement Relics |q 76448/1 |goto Dragonskull Island/0 69.42,22.47 |count 66 |noordinal
step
Enter the side cave |goto Dragonskull Island/0 33.29,36.23 < 10 |walk
use the Technoscryers##202247
|tip Use the "Scrying Mode" ability on your action bar to locate a treasure nearby.
|tip Watch the bar until it fills up and the X is completely red, then find the treasure near you.
|tip You will sometimes see a light trail indicating a nearby relic.
click Drakonid Spyglass
|tip Inside the cave.
|tip Make sure the light cone is pointing at the relic to make it clickable.
Recover the Attunement Relics |q 76448/1 |goto Dragonskull Island/0 29.39,29.81
step
talk Zenata##207311
turnin The Fate of Scalecommander Abereth##76448 |goto The Forbidden Reach/5 77.14,38.37
accept Without Honor##76557 |goto The Forbidden Reach/5 77.14,38.37
step
Reach the Nexus Point |q 76557/1 |goto The Forbidden Reach/5 76.92,38.59
step
use the Technoscryers##202247
Put On the Goggles |q 76557/2 |goto The Forbidden Reach/5 76.92,38.59
step
Activate Observation Mode |q 76557/3 |goto The Forbidden Reach/5 76.92,38.59
|tip Use the "Observation Mode" ability in the second slot on your action bar.
step
Watch the dialogue
Observe the Temporal Scene |q 76557/4 |goto The Forbidden Reach/5 76.92,38.59
step
talk Zenata##207311
turnin Without Honor##76557 |goto The Forbidden Reach/5 77.14,38.37
accept The Hidden Hand##77415 |goto The Forbidden Reach/5 77.14,38.37
step
click Drakonid Scroll Case##405944
|tip Inside and outside the cave near piles of treasure.
|tip They appear on your minimap as yellow dots.
|tip You can run the elites out of the cave to despawn them for a short period of time.
Recover the Neltharion Agent Instructions |q 77415/1 |goto The Forbidden Reach/5 67.78,45.09
step
talk Zenata##207311
turnin The Hidden Hand##77415 |goto The Forbidden Reach/5 77.14,38.37
step
talk Roska Rocktooth##208362
turnin Excavation: Winglord's Perch##77487 |goto The Forbidden Reach/5 17.19,16.29
accept Surveying the Cliffside##77100 |goto The Forbidden Reach/5 17.19,16.29
step
talk Roska Rocktooth##208362
Select _"I'm ready to start digging!"_
Tell Roska to Start the Dig |q 77100/1 |goto The Forbidden Reach/5 17.19,16.29
step
use the Archivist's Wind Totem##210778
|tip Use it near rumbling earth areas around this area.
|tip They appear on your minimap as yellow dots.
clicknpc Roska's Wind Totem##208951
|tip It appears after using the totem.
|tip Alternate between this and stepping in water spouts to keep the indicator in the colored section of the bar.
|tip Small arrows on the left or right of the indicator mark indicate if the progress is towards air or water.
click Rustic Dragonkin Pottery
|tip While the indicator is in the colored area, click the relic to fill the progress bar.
Unearth #2# Finds |q 77100/2 |goto The Forbidden Reach/5 16.39,14.98
step
use the Archivist's Wind Totem##210778
clicknpc Roska's Wind Totem##208951
|tip It appears after using the totem.
Watch the dialogue
Unearth the Major Find |q 77100/3 |goto The Forbidden Reach/5 14.06,14.69
step
click Intact Dragonkin Cache
accept The Cache in the Crag##77151 |goto The Forbidden Reach/5 14.07,14.67
step
talk Roska Rocktooth##208398
|tip She parachutes to this location.
Select _"Let's start excavating!"_
Speak to Ruska to Start the Excavation |q 77151/1 |goto The Forbidden Reach/5 14.19,14.96
step
use the Archivist's Wind Totem##210778
clicknpc Roska's Wind Totem##208951
|tip It appears after using the totem.
click Salty Waterspout
|tip Alternate between this and stepping in water spouts to keep the indicator in the colored section of the bar.
|tip Small arrows on the left or right of the indicator mark indicate if the progress is towards air or water.
click Intact Dragonkin Cache
|tip While the indicator is in the colored area, click the relic to fill the progress bar.
Excavate the Cache |q 77151/2 |goto The Forbidden Reach/5 14.07,14.66
step
talk Roska Rocktooth##208398
turnin Surveying the Cliffside##77100 |goto The Forbidden Reach/5 14.19,14.95
turnin The Cache in the Crag##77151 |goto The Forbidden Reach/5 14.19,14.95
accept A Taste of the Past##77154 |goto The Forbidden Reach/5 14.19,14.95
step
talk Atrenosh Hailstone##200010
Select _"<Share your archaeological finds.>"_
Inform Atrenosh Hailstone |q 77154/1 |goto The Forbidden Reach/5 34.65,57.56
step
click Intact Dragonkin Cache
Open the Intact Dragonkin Cache |q 77154/2 |goto The Forbidden Reach/5 17.28,16.41
step
talk Roska Rocktooth##208362
turnin A Taste of the Past##77154 |goto The Forbidden Reach/5 17.19,16.28
step
talk Roska Rocktooth##205413
turnin Excavation: Gaze of Neltharion##77486 |goto Zaralek Cavern/0 48.69,48.36
accept Surveying the Tower##76026 |goto Zaralek Cavern/0 48.69,48.36
step
talk Roska Rocktooth##205413
Select _"I'm ready to start digging!"_
Tell Roska to Start the Dig |q 76026/1 |goto Zaralek Cavern/0 48.69,48.36
step
use Archivist's Earth Totem##210834
|tip Use it near rumbling earth areas around this area.
|tip They appear on your minimap as yellow dots.
clicknpc Roska's Earth Totem##208059
|tip It appears after using the totem.
|tip Alternate between this and stepping on small lava oozes to keep the indicator in the colored section of the bar.
|tip Small arrows on the left or right of the indicator mark indicate if the progress is towards fire or earth.
click Antique Niffen Salvage
|tip While the indicator is in the colored area, click the relic to fill the progress bar.
Unearth #2# Finds |q 76026/2 |goto Zaralek Cavern/0 47.66,47.41
step
use Archivist's Earth Totem##210834
clicknpc Roska's Earth Totem##208059
|tip It appears after using the totem.
Watch the dialogue
Unearth the Major Find |q 76026/3 |goto Zaralek Cavern/0 47.56,48.57
step
click Defaced Dragon Statue
accept Hidden in the Midden##76032 |goto Zaralek Cavern/0 47.55,48.58
step
talk Roska Rocktooth##208055
|tip She eventually parachutes to this location.
Select _"Let's start excavating!"_
Speak to Roska to Start the Excavation |q 76032/1 |goto Zaralek Cavern/0 47.66,48.64
step
use Archivist's Earth Totem##210834
clicknpc Roska's Earth Totem##208059
|tip It appears after using the totem.
|tip Alternate between this and stepping on small lava oozes to keep the indicator in the colored section of the bar.
|tip Small arrows on the left or right of the indicator mark indicate if the progress is towards fire or earth.
click Defaced Dragon Statue
|tip While the indicator is in the colored area, click the statue to fill the progress bar.
Unearth the Find |q 76032/2 |goto Zaralek Cavern/0 47.55,48.58
step
talk Roska Rocktooth##208055
turnin Surveying the Tower##76026 |goto Zaralek Cavern/0 47.66,48.64
turnin Hidden in the Midden##76032 |goto Zaralek Cavern/0 47.66,48.64
accept Antiquated Antics##75604 |goto Zaralek Cavern/0 47.66,48.64
step
talk Kiln-Singer Malraka##204215
Select _"<Share your archaeological finds.>"_
Inform Kiln-Singer Malraka |q 75604/2 |goto Zaralek Cavern/0 57.80,54.35
step
talk Archivist Edress##215736
Select _"<Share your archaeological finds.>"_
Inform Archivist Edress |q 75604/1 |goto Zaralek Cavern/0 52.68,26.35
step
talk Roska Rocktooth##208055
turnin Antiquated Antics##75604 |goto Zaralek Cavern/0 47.66,48.65
step
Enter the cave |goto Zaralek Cavern/0 38.57,50.28 < 7 |walk
talk Zenata##207763
|tip Inside the cave.
turnin Technoscrying: Igira's Watch##77484 |goto Zaralek Cavern/0 38.14,49.85
accept The Tools of the Dragonkillers##76564 |goto Zaralek Cavern/0 38.14,49.85
step
use the Technoscryers##202247
|tip Use the "Scrying Mode" ability on your action bar to locate a treasure nearby.
|tip Watch the bar until it fills up and the X is completely red, then find the treasure near you.
|tip You will sometimes see a light trail indicating a nearby relic.
click Dragonkiller Harpoon
|tip Make sure the light cone is pointing at the relic to make it clickable.
Recover the Attunement Relic |q 76564/1 |goto Zaralek Cavern/0 39.38,51.44 |count 33 |noordinal
step
use the Technoscryers##202247
|tip Use the "Scrying Mode" ability on your action bar to locate a treasure nearby.
|tip Watch the bar until it fills up and the X is completely red, then find the treasure near you.
|tip You will sometimes see a light trail indicating a nearby relic.
click Gnawed Fish Kebab
|tip Make sure the light cone is pointing at the relic to make it clickable.
Recover the Attunement Relic |q 76564/1 |goto Zaralek Cavern/0 40.94,48.81 |count 66 |noordinal
step
use the Technoscryers##202247
|tip Use the "Scrying Mode" ability on your action bar to locate a treasure nearby.
|tip Watch the bar until it fills up and the X is completely red, then find the treasure near you.
|tip You will sometimes see a light trail indicating a nearby relic.
click Tuskarr Scaling Knife
|tip Make sure the light cone is pointing at the relic to make it clickable.
Recover the Attunement Relic |q 76564/1 |goto Zaralek Cavern/0 42.15,51.12
step
Enter the cave |goto Zaralek Cavern/0 38.57,50.28 < 7 |walk
talk Zenata##207763
|tip Inside the cave.
turnin The Tools of the Dragonkillers##76564 |goto Zaralek Cavern/0 38.14,49.85
accept An Unlikely Proposal##76576 |goto Zaralek Cavern/0 38.14,49.85
step
Reach the Nexus Point |q 76576/1 |goto Zaralek Cavern/0 38.25,49.75
|tip Inside the cave.
step
use the Technoscryers##202247
|tip Inside the cave.
Put on the Goggles |q 76576/2 |goto Zaralek Cavern/0 38.25,49.75
step
use the Technoscryers##202247
|tip Inside the cave.
|tip Use the "Observation Mode" ability in the second slot on your action bar.
Activate Observation Mode |q 76576/3 |goto Zaralek Cavern/0 38.25,49.75
step
Watch the dialogue
|tip Inside the cave.
Observe the Temporal Scene |q 76576/4 |goto Zaralek Cavern/0 38.25,49.75
step
talk Zenata##207763
|tip Inside the cave.
turnin An Unlikely Proposal##76576 |goto Zaralek Cavern/0 38.14,49.86
accept The Scale of it All##77425 |goto Zaralek Cavern/0 38.14,49.86
step
click Ancient Zaqali Trade-bond Tablet##405996
Recover the Trade-Bonded Tablet |q 77425/1 |goto Zaralek Cavern/0 42.08,34.88
step
Enter the cave |goto Zaralek Cavern/0 38.57,50.28 < 7 |walk
talk Zenata##207763
|tip Inside the cave.
turnin The Scale of it All##77425 |goto Zaralek Cavern/0 38.14,49.85
accept Back to Headquarters! Again!##79231 |goto Zaralek Cavern/0 38.14,49.85
step
talk Eadweard Dalyngrigge##206107
|tip Inside the base of the tower on the floating island.
turnin Back to Headquarters! Again!##79231 |goto Thaldraszus/0 61.53,31.29
accept Graduation Day##77331 |goto Thaldraszus/0 61.53,31.29
step
talk Eadweard Dalyngrigge##206107
|tip Inside the base of the tower on the floating island.
Select _"Thank you."_
Speak with Eadweard |q 77331/5 |goto Thaldraszus/0 61.53,31.29
step
talk Eadweard Dalyngrigge##206107
|tip Inside the base of the tower on the floating island.
turnin Graduation Day##77331 |goto Thaldraszus/0 61.53,31.29
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Dragonflight (10-70)\\The Big Dig: Traitor's Rest",{
description="This guide will help you complete the Azerothian Archives big dig in Traitor's Rest.",
startlevel=70,
patch='100205',
areapoiid=7657,
areapoitype="BigDig",
},[[
step
label "Begin_Scenario"
talk Eadweard Dalyngrigge##209134
accept The Big Dig: Traitor's Rest##79226 |goto The Azure Span/0 26.96,46.46
step
Wait for the Scenario to Begin |complete areapoi(2024,7657) and inscenario() |goto The Azure Span/0 26.96,46.46
|tip The scenario starts every hour on the half hour. |only if not inscenario()
|tip Steps that have progress bars are currently bugged and may complete early. |only if not inscenario()
|tip This scenario has been heavily bugged. |only if not inscenario()
step
Stand Near Eadweard for Instructions |scenariogoal 1/60758 |goto Traitor's Rest/0 55.33,51.34
|only if scenariostage(1)
step
click Wild Restweed+
|tip They look like small plants on the ground around this area.
Clear #6# Restweed |scenariogoal 2/60772 |goto Traitor's Rest/0 58.21,46.77
|only if scenariostage(2)
step
click Wild Traitor's Bramble+
|tip They look like large red bushes around the bones.
Clear #5# Traitor's Bramble |scenariogoal 3/65236 |goto Traitor's Rest/0 53.85,49.04
|only if scenariostage(3)
step
click Wild Restweed+
|tip They look like small plants on the ground around this area.
Clear #6# Restweed |scenariogoal 4/65237 |goto Traitor's Rest/0 51.93,45.29
|only if scenariostage(4)
step
click Wild Boneclover+
|tip They look like small plants on the ground around this area.
Clear #5# Boneclover |scenariogoal 5/65239 |goto Traitor's Rest/0 56.37,49.07
|only if scenariostage(5)
step
click Wild Boneclover+
|tip They look like small plants on the ground around this area.
Clear #6# Boneclover |scenariogoal 6/65238 |goto Traitor's Rest/0 50.99,47.79
|only if scenariostage(6)
step
click Traitor's Bramble+
|tip They look like bushy plants on the ground around this area.
Clear #7# Traitor's Bramble |scenariogoal 7/65240 |goto Traitor's Rest/0 51.09,51.19
|only if scenariostage(7)
step
Scenario Stage Coming Soon! |confirm
|only if scenariostage(8)
step
Scenario Stage Coming Soon! |confirm
|only if scenariostage(9)
step
Scenario Stage Coming Soon! |confirm
|only if scenariostage(10)
step
Scenario Stage Coming Soon! |confirm
|only if scenariostage(11)
step
extraaction Analysis##398015
|tip Run to yellow dots on the minimap and use the button that appears on the screen.
Uncover and Analyze Hidden Runes Around the Site |scenariogoal 12/0 |goto Traitor's Rest/0 54.43,49.91
|only if scenariostage(12)
step
extraaction Analysis##398015
|tip Run to yellow dots on the minimap and use the button that appears on the screen.
Uncover and Analyze Hidden Runes Around the Site |scenariogoal 13/0 |goto Traitor's Rest/0 53.93,50.06
|only if scenariostage(13)
step
extraaction Analysis##398015
|tip Run to yellow dots on the minimap and use the button that appears on the screen.
Uncover and Analyze Hidden Runes Around the Site |scenariogoal 14/0 |goto Traitor's Rest/0 54.54,49.71
|only if scenariostage(14)
step
extraaction Analysis##398015
|tip Run to yellow dots on the minimap and use the button that appears on the screen.
|tip Relics look like small sparkling patches on the ground.
Uncover and Analyze Ancient Relics Around the Site |scenariogoal 15/0 |goto Traitor's Rest/0 52.36,49.04
|only if scenariostage(15)
step
extraaction Analysis##398015
|tip Run to yellow dots on the minimap and use the button that appears on the screen.
|tip Relics look like small sparkling patches on the ground.
Uncover and Analyze Ancient Relics Around the Site |scenariogoal 16/0 |goto Traitor's Rest/0 52.36,49.04
|only if scenariostage(16)
step
extraaction Analysis##398015
|tip Run to yellow dots on the minimap and use the button that appears on the screen.
|tip Relics look like small sparkling patches on the ground.
Uncover and Analyze Ancient Relics Around the Site |scenariogoal 17/0 |goto Traitor's Rest/0 52.98,50.15
|only if scenariostage(17)
step
extraaction Roska's Fire Totem##427611
|tip Use the button on the screen to summon Roska's Fire Totem.
clicknpc Roska's Fire Totem##208853
|tip Click the fire totem to excavate smoky rumbling areas of earth on the ground around this area.
|tip They appear on your minimap as yellow dots.
Survey Disturbed Earth |scenariogoal 18/0 |goto Traitor's Rest/0 53.80,46.86
|only if scenariostage(18)
step
extraaction Roska's Fire Totem##427611
|tip Use the button on the screen to summon Roska's Fire Totem.
clicknpc Roska's Fire Totem##208853
|tip Click the fire totem to start it channeling on the rubble.
click Warped Dragon Bone
|tip While the elemental is channeling, excavate the bone.
Excavate Dragon Bones |scenariogoal 19/0 |goto Traitor's Rest/0 52.29,45.83
|only if scenariostage(19)
step
Scenario Stage Coming Soon! |confirm
|only if scenariostage(20)
step
click Promising Rock+
|tip They look like half-buried rocks.
Inspect Stones Around the Site for Achaelogical Value |scenariogoal 21/0 |goto Traitor's Rest/0 50.92,47.75
|only if scenariostage(21)
step
click Promising Rock+
|tip They look like half-buried rocks.
Inspect Stones Around the Site for Achaelogical Value |scenariogoal 22/0 |goto Traitor's Rest/0 53.02,53.39
|only if scenariostage(22)
step
click Promising Rock+
|tip They look like half-buried rocks.
Inspect Stones Around the Site for Achaelogical Value |scenariogoal 23/0 |goto Traitor's Rest/0 54.83,42.01
|only if scenariostage(23)
step
click Promising Rock+
|tip They look like half-buried rocks.
Inspect Stones Around the Site for Achaelogical Value |scenariogoal 24/0 |goto Traitor's Rest/0 59.45,47.34
|only if scenariostage(24)
step
click Pile of Unsorted Rocks
|tip Run them to the nearby highlighted flag each time you click the pile.
Sort Significant Stones |scenariogoal 25/0 |goto Traitor's Rest/0 52.40,45.92
|only if scenariostage(25)
step
click Pile of Unsorted Rocks
|tip Run them to the nearby highlighted flag each time you click the pile.
Sort Significant Stones |scenariogoal 26/0 |goto Traitor's Rest/0 57.62,53.73
|only if scenariostage(26)
step
click Pile of Unsorted Rocks
|tip Run them to the nearby highlighted flag each time you click the pile.
Sort Significant Stones |scenariogoal 27/0 |goto Traitor's Rest/0 48.52,48.75
|only if scenariostage(27)
step
click Broken Shovel+
Repair #3# Shovels |scenariogoal 28/61195 |goto Traitor's Rest/0 53.09,47.25
|only if scenariostage(28)
step
Scenario Stage Coming Soon! |confirm
|only if scenariostage(29)
step
clicknpc Clue-Compiling Familiar##209451
|tip It appears on your minimap as a yellow dot.
|tip Stand still while channeling.
Release the Otters! |scenariogoal 30/0 |goto Traitor's Rest/0 51.86,50.59
|only if scenariostage(30)
step
kill Information-Stuffed Clue##210079 |scenariogoal 31/64388 |goto Traitor's Rest/0 52.38,53.25
|tip It walks all over this area.
|only if scenariostage(31)
step
kill Clue Morsel##210080
Morsel Clues |scenariogoal 31/61900 |goto Traitor's Rest/0 54.77,46.68
|only if scenariostage(31)
step
click Azerothian Tome+
|tip They look like books scattered all over the ground.
Return Scattered Tomes |scenariogoal 32/0 |goto Traitor's Rest/0 52.35,51.84
|only if scenariostage(32)
step
click Pot of Azer-Broth
Pick up Azer-Broth |scenariogoal 33/61288 |goto Traitor's Rest/0 55.82,51.83
|only if scenariostage(33)
step
extraaction Deliver That Lunch!##420139
|tip It appears on the screen when you are near hungry workers.
Feed #3# Hungry Archivists |scenariogoal 33/61287 |goto Traitor's Rest/0 58.11,50.92
|only if scenariostage(33)
step
Scenario Stage Coming Soon! |confirm
|only if scenariostage(34)
step
Scenario Stage Coming Soon! |confirm
|only if scenariostage(35)
step
Click objects around this area
|tip Click the four objects to set up the dig.
Set up a Satellite Dig |scenariogoal 36/0 |goto Traitor's Rest/0 47.65,45.10
|only if scenariostage(36)
step
extraaction Gain Clue##421550
|tip Use the ability that appears on the screen near clue spots.
|tip They look like small blue creatures running around this area.
|tip They appear on your minimap as yellow dots.
|tip You may need to dismount to get the button to appear.
Discover #3# Clue spots |scenariogoal 37/61898 |goto Traitor's Rest/0 53.09,47.70
|only if scenariostage(37)
step
clicknpc Juicy Clue##210076+
|tip They look like small blue creatures running around this area.
|tip They appear on your minimap as yellow dots.
Discover the First Juicy Clue |scenariogoal 38/61899 |goto Traitor's Rest/0 26.82,46.75 |count 1
|only if scenariostage(38)
step
clicknpc Juicy Clue##210076+
|tip They look like small blue creatures running around this area.
|tip They appear on your minimap as yellow dots.
Discover the Second Juicy Clue |scenariogoal 38/61899 |goto Traitor's Rest/0 26.50,45.79 |count 2
|only if scenariostage(38)
step
clicknpc Juicy Clue##210076+
|tip They look like small blue creatures running around this area.
|tip They appear on your minimap as yellow dots.
Discover the Third Juicy Clue |scenariogoal 38/61899 |goto Traitor's Rest/0 25.74,46.72 |count 3
|only if scenariostage(38)
step
click Crate of Crchaeologist Hats
|tip They look like large brown crates around the bones.
clicknpc Sun-baked Archeologist##210146+
|tip They look like dizzy NPCs in beams of light.
|tip Use the Hat Toss ability on screen while targeting them.
|tip Return to a crate for another hat after each NPC.
extraaction Hat Toss##421669
Throw Hats at Archivists |scenariogoal 39/0 |goto Traitor's Rest/0 53.23,49.56
|only if scenariostage(39)
step
click Crate of Archivist Hats
|tip Click the wooden crate to pick up a hat for each elemental.
|tip Return to the crate after using it to get another.
extraaction Recruit an Elemental##422145
|tip Use the ability on the screen to toss a hat on the targeted elemental.
clicknpc Eager Elemental##210408
Recruit Eager Elementals |scenariogoal 40/0 |goto Traitor's Rest/0 52.48,45.42
|only if scenariostage(40)
step
talk Eadweard Dalyngrigge##209134
Select _"Do you have that thing Zenata needed?"_
Retrieve Supplies for Zenata's Study |havebuff Artifact Delivery for Zenata!##428891 |goto Traitor's Rest/0 55.33,51.36
|only if scenariostage(41)
step
Resupply Zenata's Study |scenariogoal 41/64341 |goto Traitor's Rest/0 56.40,45.73
|only if scenariostage(41)
step
talk Eadweard Dalyngrigge##209134
Select _"Do you have that thing Roksa needed?"_
Retrieve Supplies for Roska |havebuff Artifact Delivery for Roska!##429291 |goto Traitor's Rest/0 55.33,51.36
|only if scenariostage(42)
step
Deliver Supplies to Roska! |scenariogoal 42/0 |goto Traitor's Rest/0 53.26,46.68
|only if scenariostage(42)
step
talk Eadweard Dalyngrigge##209134
Select _"Do you have that thing Nirobin needed?"_
Retrieve Supplies for Nirobin |havebuff Artifact Delivery for Nirobin!##429293 |goto Traitor's Rest/0 55.33,51.35
|only if scenariostage(43)
step
Deliver a Crate of Artifacts to Nirobin to Study |scenariogoal 43/64412 |goto Traitor's Rest/0 51.59,51.80
|only if scenariostage(43)
step
click Archivist's Bone Brush+
|tip They look like tiny brushes moving on the big bones.
Brush the Bones |scenariogoal 44/0 |goto Traitor's Rest/0 55.46,50.35
|only if scenariostage(44)
step
Stomp Book Beetles |scenariogoal 45/0 |goto Traitor's Rest/0 55.23,50.73
|tip Walk over the beetles around the camp.
|only if scenariostage(45)
step
talk Roska Rocktooth##209133
Select _"Do you have that thing Eadweard needed?"_
Speak to Roska to Get shovels |havebuff Shovels for Eadweard!##430028 |goto Traitor's Rest/0 53.27,46.72
|only if scenariostage(46)
step
Deliver Shovels to Eadweard |scenariogoal 46/64615 |goto Traitor's Rest/0 55.33,51.35
|only if scenariostage(46)
step
talk Zenata##209132
Select _"Do you have that thing Eadweard needed?"_
Talk to Zenata to Get runes |havebuff Runes for Eadweard!##430344 |goto Traitor's Rest/0 56.32,46.08
|only if scenariostage(47)
step
Deliver them to Eadweard |scenariogoal 47/64614 |goto Traitor's Rest/0 55.32,51.38
|only if scenariostage(47)
step
talk Nirobin##209135
Select _"Do you have that thing Eadweard needed?"_
Talk to Nirobin to Get Books |havebuff Books for Eadweard!##430033 |goto Traitor's Rest/0 51.60,51.77
|only if scenariostage(48)
step
Deliver the Books |scenariogoal 48/64616 |goto Traitor's Rest/0 55.33,51.34
|only if scenariostage(48)
step
Scenario Stage Coming Soon! |confirm
|only if scenariostage(49)
step
Stand by Eadweard for Instructions |scenariogoal 50/64424 |goto Traitor's Rest/0 55.33,51.34
|only if scenariostage(50)
step
kill Doomshadow##208029 |scenariogoal 51/63299 |goto Traitor's Rest/0 59.69,49.72
|tip Move out of areas targeted on the ground.
|only if scenariostage(51)
step
Wait for a New Scenario Stage |complete areapoi(2024,7657) and inscenario() |goto Traitor's Rest/0 55.33,51.36 |next "Begin_Scenario" |notravel
|only if inscenario()
step
talk Eadweard Dalyngrigge##209134
turnin The Big Dig: Traitor's Rest##79226 |goto The Azure Span/0 26.96,46.46
|only if readyq(79226)
step
talk Eadweard Dalyngrigge##206107
|tip Inside the base of the tower on the floating island.
turnin Curious Find: Hole-Punched Bakar Tooth##77766 |goto Thaldraszus/0 61.53,31.29 |only if haveq(77766)
turnin Curious Find: Dragonhorn Flute##77760 |goto Thaldraszus/0 61.53,31.29 |only if haveq(77760)
turnin Curious Find: Waterlogged Ledger##77763 |goto Thaldraszus/0 61.53,31.29 |only if haveq(77763)
|only if haveq(77766,77760,77763)
step
Wait for the Dig to Begin |complete areapoi(2024,7657) and inscenario() |goto The Azure Span/0 26.96,46.46 |next "Begin_Scenario"
|tip The scenario starts every hour on the half hour.
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Dragonflight (10-70)\\Emerald Dreamsurge (Thaldraszus)",{
description="This guide will help you complete the Emerald Dreamsurge in Thaldraszus.",
startlevel=70,
patch='100107',
areapoiid=7588,
areapoitype="Dreamsurge",
},[[
step
talk Archdruid Hamuul Runetotem##211031
accept Surging Dreams##77423 |goto Valdrakken/0 50.64,57.48
step
talk Gearweaver##208649
turnin Surging Dreams##77423 |goto Thaldraszus/0 51.21,43.34
accept Shaping the Dreamsurge##77251 |goto Thaldraszus/0 51.21,43.34
accept Dreamsurge Investigation##77414 |goto Thaldraszus/0 51.21,43.34 |only if not completedq(77414)
stickystart "Collect_Dreamsurge_Coalescence"
stickystart "Slay_a_Rare_Elite"
step
Complete #3# World Quests in the Dreamsurge |q 77414/1
|tip Click world quest icons on the map to load their guides and complete them.
|only if not completedq(77414)
step
label "Slay_a_Rare_Elite"
Slay a Rare elite Empowered by the Dreamsurge |q 77414/2
|tip Click a rare elite icon on the map to load its guide.
|tip Rare elite enemies might not always be active.
|only if not completedq(77414)
step
Wait for a Dreamsurge to Begin |complete vignette(5751)
|tip Dreamsurges start every half hour.
step
Join the Fight |scenariostart |goto Thaldraszus/0 60.78,23.55
step
Kill enemies around this area
|tip You can also fly through birds in the air on your mount.
click Burning Root+
|tip They look like flame-topped roots growing out of the ground around this area.
Fight Back Against the Druids of the Flame Incursion |scenariogoal 1/0 |goto Thaldraszus/0 60.78,23.55
|only if not completedq(77414)
step
Defeat the Dreamsurge Champion |scenariostage 2 |goto Thaldraszus/0 61.84,26.37
|tip This enemy is elite and will require a group.
|only if not completedq(77414)
step
Close a Waking Dream Portal |q 77414/3
|tip Loot the corpse of the Allied Cinderrager.
|only if not completedq(77414)
step
label "Collect_Dreamsurge_Coalescence"
click Dreaming Growth+
|tip They look like large green and purple plants growing all over the zone.
|tip You can also fly through green orbs scattered all over the zone.
|tip Enemies also drop Coalescence.
Collect #100# Dreamsurge Coalescence |q 77251/1
step
talk Naralex##207962
Vote for a Dreamsurge Effect |q 77414/4 |goto Thaldraszus/0 51.19,43.39
|only if not completedq(77414)
step
talk Gearweaver##208649
turnin Shaping the Dreamsurge##77251 |goto Thaldraszus/0 51.21,43.34
turnin Dreamsurge Investigation##77414 |goto Thaldraszus/0 51.21,43.34 |only if not completedq(77414)
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Dragonflight (10-70)\\Emerald Dreamsurge (The Waking Shores)",{
description="This guide will help you complete the Emerald Dreamsurge in The Waking Shores.",
startlevel=70,
patch='100107',
areapoiid=7587,
areapoitype="Dreamsurge",
},[[
step
talk Archdruid Hamuul Runetotem##211031
accept Surging Dreams##77423 |goto Valdrakken/0 50.64,57.48
step
talk Archdruid Hamuul Runetotem##208649
turnin Surging Dreams##77423 |goto The Waking Shores/0 58.39,67.74
accept Shaping the Dreamsurge##77251 |goto The Waking Shores/0 58.39,67.74
accept Dreamsurge Investigation##77414 |goto The Waking Shores/0 58.39,67.74 |only if not completedq(77414)
stickystart "Collect_Dreamsurge_Coalescence"
stickystart "Slay_a_Rare_Elite"
step
Complete #3# World Quests in the Dreamsurge |q 77414/1 |goto The Waking Shores/0 51.11,42.66
|tip Click world quest icons on the map to load their guides and complete them.
|only if not completedq(77414)
step
label "Slay_a_Rare_Elite"
Slay a Rare Elite Empowered By the Dreamsurge |q 77414/2 |goto The Waking Shores/0 51.11,42.66
|tip Click a rare elite icon on the map to load its guide.
|tip Rare elite enemies might not always be active.
|only if not completedq(77414)
step
Wait for a Dreamsurge to Begin |complete vignette(5751)
|tip Dreamsurges start every half hour.
step
Join the Fight |scenariostart |goto The Waking Shores/0 41.14,76.74
step
Kill enemies around this area
|tip You can also fly through birds in the air on your mount.
click Burning Root+
|tip They look like flame-topped roots growing out of the ground around this area.
Fight Back Against the Druids of the Flame Incursion |scenariogoal 1/0 |goto The Waking Shores/0 41.14,76.74
|only if not completedq(77414)
step
Defeat the Dreamsurge Champion |scenariostage 2 |goto The Waking Shores/0 41.18,77.46
|tip This enemy is elite and will require a group.
|only if not completedq(77414)
step
Close a Waking Dream Portal |q 77414/3
|tip Loot the corpse of the Molten General.
|only if not completedq(77414)
step
label "Collect_Dreamsurge_Coalescence"
click Dreaming Growth+
|tip They look like large green and purple plants growing all over the zone.
|tip You can also fly through green orbs scattered all over the zone.
|tip Enemies also drop Coalescence.
Collect #100# Dreamsurge Coalescence |q 77251/1
step
talk Naralex##207962
Vote for a Dreamsurge Effect |q 77414/4 |goto The Waking Shores/0 58.43,67.79
|only if not completedq(77414)
step
talk Archdruid Hamuul Runetotem##208649
turnin Shaping the Dreamsurge##77251 |goto The Waking Shores/0 58.39,67.74
turnin Dreamsurge Investigation##77414 |goto The Waking Shores/0 58.39,67.74 |only if not completedq(77414)
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Dragonflight (10-70)\\Emerald Dreamsurge (Ohn'ahran Plains)",{
description="This guide will help you complete the Emerald Dreamsurge in Ohn'ahran Plains.",
startlevel=70,
patch='100107',
areapoiid=7586,
areapoitype="Dreamsurge",
},[[
step
talk Archdruid Hamuul Runetotem##211031
accept Surging Dreams##77423 |goto Valdrakken/0 50.64,57.48
step
talk Archdruid Hamuul Runetotem##208649
turnin Surging Dreams##77423 |goto Ohn'ahran Plains/0 64.11,41.73
accept Shaping the Dreamsurge##77251 |goto Ohn'ahran Plains/0 64.11,41.73
accept Dreamsurge Investigation##77414 |goto Ohn'ahran Plains/0 64.11,41.73 |only if not completedq(77414)
stickystart "Collect_Dreamsurge_Coalescence"
stickystart "Slay_a_Rare_Elite"
step
Complete #3# World Quests in the Dreamsurge |q 77414/1
|tip Click world quest icons on the map to load their guides and complete them.
|only if not completedq(77414)
step
label "Slay_a_Rare_Elite"
Slay a Rare Elite Empowered By the Dreamsurge |q 77414/2
|tip Click a rare elite icon on the map to load its guide.
|tip Rare elite enemies might not always be active.
|only if not completedq(77414)
step
Wait for a Dreamsurge to Begin |complete vignette(5751)
|tip Dreamsurges start every half hour.
step
Kill enemies around this area
|tip You can also fly through birds in the air on your mount.
click Burning Root+
|tip They look like flame-topped roots growing out of the ground around this area.
Fight Back Against the Druids of the Flame Incursion |scenariogoal 1/0 |goto Ohn'ahran Plains/0 25.18,60.95
|only if not completedq(77414)
step
Defeat the Dreamsurge Champion |scenariostage 2 |goto Ohn'ahran Plains/0 24.29,60.98
|tip This enemy is elite and will require a group.
|only if not completedq(77414)
step
Close a Waking Dream Portal |q 77414/3
|tip Loot the corpse of the Planesborn Annihilator.
|only if not completedq(77414)
step
label "Collect_Dreamsurge_Coalescence"
click Dreaming Growth+
|tip They look like large green and purple plants growing all over the zone.
|tip You can also fly through green orbs scattered all over the zone.
|tip Enemies also drop Coalescence.
Collect #100# Dreamsurge Coalescence |q 77251/1
step
talk Naralex##207962
Vote for a Dreamsurge Effect |q 77414/4
|only if not completedq(77414)
step
talk Archdruid Hamuul Runetotem##208649
turnin Shaping the Dreamsurge##77251 |goto Ohn'ahran Plains/0 64.11,41.73
turnin Dreamsurge Investigation##77414 |goto Ohn'ahran Plains/0 64.11,41.73 |only if not completedq(77414)
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Dragonflight (10-70)\\Emerald Dreamsurge (The Azure Span)",{
description="This guide will help you complete the Emerald Dreamsurge in The Azure Span.",
startlevel=70,
patch='100107',
areapoiid=7585,
areapoitype="Dreamsurge",
},[[
step
talk Archdruid Hamuul Runetotem##211031
accept Surging Dreams##77423 |goto Valdrakken/0 50.64,57.48
step
talk Archdruid Hamuul Runetotem##208649
turnin Surging Dreams##77423 |goto The Azure Span/0 45.55,39.81
accept Shaping the Dreamsurge##77251 |goto The Azure Span/0 45.55,39.81
accept Dreamsurge Investigation##77414 |goto The Azure Span/0 45.55,39.81 |only if not completedq(77414)
stickystart "Collect_Dreamsurge_Coalescence"
stickystart "Slay_a_Rare_Elite"
step
Complete #3# World Quests in the Dreamsurge |q 77414/1
|tip Click world quest icons on the map to load their guides and complete them.
|only if not completedq(77414)
step
label "Slay_a_Rare_Elite"
Slay a Rare Elite Empowered By the Dreamsurge |q 77414/2
|tip Click a rare elite icon on the map to load its guide.
|tip Rare elite enemies might not always be active.
|only if not completedq(77414)
step
Wait for a Dreamsurge to Begin |complete vignette(5751)
|tip Dreamsurges start every half hour.
step
Kill enemies around this area
|tip You can also fly through birds in the air on your mount.
click Burning Root+
|tip They look like flame-topped roots growing out of the ground around this area.
Fight Back Against the Druids of the Flame Incursion |scenariogoal 1/0 |goto The Azure Span/0 32.68,39.72
|only if not completedq(77414)
step
Defeat the Dreamsurge Champion |scenariostage 2 |goto The Azure Span/0 32.64,39.63
|tip This enemy is elite and will require a group.
|only if not completedq(77414)
step
Close a Waking Dream Portal |q 77414/3
|tip Loot the corpse of the Planesborn Annihilator.
|only if not completedq(77414)
step
label "Collect_Dreamsurge_Coalescence"
click Dreaming Growth+
|tip They look like large green and purple plants growing all over the zone.
|tip You can also fly through green orbs scattered all over the zone.
|tip Enemies also drop Coalescence.
Collect #100# Dreamsurge Coalescence |q 77251/1
step
talk Naralex##207962
Vote for a Dreamsurge Effect |q 77414/4 |goto The Azure Span/0 45.57,39.76
|only if not completedq(77414)
step
talk Archdruid Hamuul Runetotem##208649
turnin Shaping the Dreamsurge##77251 |goto The Azure Span/0 45.55,39.81
turnin Dreamsurge Investigation##77414 |goto The Azure Span/0 45.55,39.81 |only if not completedq(77414)
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Secrets of Azeroth\\Secrets of Azeroth",{
condition_suggested=function() return isevent("Secrets of Azeroth") end,
description="\nThis guide section will walk you through completing the quests for the Secrets of Azeroth event.",
},[[
step
talk Preservationist Kathos##206864
|tip Inside the building.
accept Preserving Rarities##77203 |goto Valdrakken/0 47.35,48.21
step
talk Preservationist Kathos##206864
Select _"I'm ready!"_
|tip Inside the building.
collect 1 A Mystery Box##208054 |goto Valdrakken/0 47.35,48.21 |q 77203 |future
step
use A Mystery Box##208054
collect Golden Chalice##208056 |q 77203 |future
step
click Golden Chalice
|tip Inside the building.
Select _"<Sneak the chalice into the hoard.>"_
Solve the Mystery |q 77203/1 |goto Valdrakken/0 58.87,54.15
step
talk Preservationist Kathos##206864
|tip Inside the building.
turnin Preserving Rarities##77203 |goto Valdrakken/0 47.35,48.21
step
talk Preservationist Kathos##206864
|tip Inside the building.
'|accept Rise in Relic Theft##76735 |n
collect Tuskarr Ceremonial Spear##207105 |goto Valdrakken/0 47.35,48.21 |q 76987 |future
step
talk Elder Ko'nani##26194
|tip Inside the building.
Select _"Someone stole this ceremonial spear from the tuskarr. Do you know where it was taken from?"_
collect Shomko's Unyielding Spear##207580 |goto Dragonblight/0 48.01,74.87 |q 76987 |future
step
click Shomko's Unyielding Spear
Select _"<Place the spear on the weapon rack.>"_
Place Shomko's Unyielding Spear |q 76987 |goto Borean Tundra/0 33.62,58.43 |future
step
talk Bobby Carlisle##207696
|tip Inside the building.
'|accept A Secretive Contact##77165 |n
collect Bobby Carlisle's Thinking Cap Notes##207802 |goto Valdrakken/0 47.95,46.78 |q 77230 |future
step
|script DoEmote("Bow")
clicknpc Odd Statue##189827
|tip Inside the building.
|tip Target the statue before bowing.
Bow Before the Odd Statue |complete subzone("The Dragon's Hoard") |goto Valdrakken/0 46.87,45.04 |q 77237 |future
step
talk Kritha##192814
Select _"I would like to talk to you about Shakey Flatlap."_
Settle Shakey's Tab |complete completedq(77230) or completedq(77237) |goto Valdrakken/0 47.34,41.12
step
Leave The Dragon's Hoard Bar |complete not subzone("The Dragon's Hoard") |goto Valdrakken/0 47.33,49.72
step
talk Shakey Flatlap##198586
Select _"I settled your tab with Kritha. He says you have to pay up front from now on."_
collect Crystal Ocular Lenses##207816 |goto Valdrakken/0 39.06,61.85 |q 77237 |future
step
talk Gorgonzormu##196729
buy 5 Apexis Asiago##201419 |goto Valdrakken/0 29.03,65.02 |q 77237 |future
step
kill Hungering Tyranha##191451+
collect Fresh Tyranha##207812 |goto Thaldraszus/0 38.70,68.45 |q 77237 |future
step
talk Agurahl the Butcher##194152
buy 5 Thunderspine Tenders##198441 |goto Ohn'ahran Plains/0 85.17,23.48 |q 77237 |future
step
talk Sniktak##204371
buy 5 Latticed Stinkhorn##205693 |goto Zaralek Cavern/0 54.08,56.66 |q 77237 |future
step
talk Erugosa##185556
|tip Inside the building.
Select _"I have the ingredients for the thunderspine nest."_
collect Thunderspine Nest##207956 |goto Valdrakken/0 46.51,46.23 |q 77237 |future
step
talk Gryffin##197781
Select  _"<Hold up the fresh tyranha to Gryffin.>"_
collect Downy Helmet Liner##207813 |goto Valdrakken/0 42.48,49.47 |q 77237 |future
step
talk Clinkyclick Shatterboom##185548
Select _"What do you know about a Thinking Cap?"_
collect Thought Calculating Apparatus##207814 |goto Valdrakken/0 42.25,48.64 |q 77237 |future
step
use the Thought Calculating Apparatus##207814
accept Unfinished Thinking Cap##77237
step
talk Fangli Hoot##207697
turnin Unfinished Thinking Cap##77237 |goto Valdrakken/0 26.65,53.87
step
use the Tricked Out THinking Cap##206696
Collect the Tricked-Out Thinking Cap |toy Tricked-Out Thinking Cap##206696
step
use the Tricked Out THinking Cap##206696
Put on Your Thinking Cap |havebuff Tricked-Out Thinking Cap##414103 |goto Valdrakken/0 26.65,53.89
step
talk Fangli Hoot##207697
accept The Tricked-Out Thinking Cap##76504 |goto Valdrakken/0 26.67,53.89
step
click Riddle Solved!
Solve the Riddle |q 76504/1 |goto Valdrakken/0 64.65,53.72
step
talk Fangli Hoot##207697
turnin The Tricked-Out Thinking Cap##76504 |goto Valdrakken/0 26.67,53.89
step
talk Bobby Carlisle##207696
|tip Inside the building.
accept An Inside Job?##77276 |goto Valdrakken/0 47.96,46.85 |or
'|complete completedq(77397) |or
step
talk Fangli Hoot##207697
turnin An Inside Job?##77276 |goto Valdrakken/0 26.67,53.88 |or
'|complete completedq(77397) |or
step
click Preservationist's Locker
|tip Upstairs inside the building.
Select _"<Take the item.>"_
collect Maruuk Burial Banner##208130 |goto Valdrakken/0 48.83,47.81 |q 77276 |or
'|complete completedq(77397) |or
step
talk "Appraiser" Sazsel Stickyfingers##208620
|tip Inside the building.
Select _"Fangli said you could appraise this item to see if it is genuine."_
Talk to Stickyfingers About the Banner |q 77397 |goto Valdrakken/0 62.81,72.87 |future
step
talk "Appraiser" Sazsel Stickyfingers##208620
|tip Inside the building.
accept Preservationist Cleared##77277 |goto Valdrakken/0 62.81,72.87
step
click Preservationist's Locker
|tip Upstairs inside the building.
Select _"<Return the burial banner.>"_
Return the Burial Banner |q 77277/1 |goto Valdrakken/0 48.81,47.82
step
talk Fangli Hoot##207697
turnin Preservationist Cleared##77277 |goto Valdrakken/0 26.67,53.89
step
talk Tithris##185562
|tip Inside the building.
'|accept Securing an Artifact##77281 |n
collect Preservationist's Dispatch##208131 |goto Valdrakken/0 47.47,46.19 |q 77403 |future
step
use the Tricked Out Thinking Cap##206696
Put on Your Thinking Cap |havebuff Tricked-Out Thinking Cap##414103 |goto The Waking Shores/0 56.99,25.51 |q 77403 |future
step
click Ancient Lever
Throw the Lever |q 77403 |goto The Waking Shores/0 56.99,25.51 |future
step
click Ancient Lever
|tip Inside the tower.
Throw the Lever |q 77402 |goto The Waking Shores/0 57.77,23.82 |future
step
click Ancient Lever
|tip Inside the building.
Throw the Lever |q 77401 |goto The Waking Shores/0 56.61,20.31 |future
step
click Torch of Pyrreth
|tip Inside the building.
accept Artifact Secured##77282 |goto The Waking Shores/0 54.57,20.39
step
talk Preservationist Kathos##206864
|tip Inside the building.
turnin Artifact Secured##77282 |goto Valdrakken/0 47.33,48.22
accept The Torch of Pyrreth##77263 |goto Valdrakken/0 47.33,48.22
step
use the Torch of Pyrreth##208092
Collect the Torch of Pyrreth |toy Torch of Pyrreth##208092
step
use the Torch of Pyrreth##208092
|tip Inside the building.
Use the Torch |havebuff Flame Bearer##419127 |goto Valdrakken/0 58.48,23.61 |q 77263 |future
step
click Enchanted Box
|tip Inside the building.
collect 1 Kathos' Field Glasses##208107 |q 77263/1 |goto Valdrakken/0 58.48,23.61
step
talk Preservationist Kathos##206864
|tip Inside the building.
turnin The Torch of Pyrreth##77263 |goto Valdrakken/0 47.33,48.21
step
talk Bobby Carlisle##207696
|tip Inside the building.
'|accept A Chilling Ascent##77284 |n
collect The Clerk's Notes##208137 |goto Valdrakken/0 47.93,46.83
step
use the Torch of Pyrreth##208092
Use the Torch |havebuff Flame Bearer##419127 |goto The Azure Span/0 78.88,32.45 |q 77286 |future
step
click Unveiled Tablet
Select _"<Use paper and charcoal to make an etching.>"_
accept A Knowledgeable Descent##77286 |goto The Azure Span/0 78.88,32.45
step
talk Bobby Carlisle##207696
|tip Inside the building.
turnin A Knowledgeable Descent##77286 |goto Valdrakken/0 47.95,46.83
step
talk Tithris##185562
|tip Inside the building.
'|accept Idol Searching##77303 |n
collect 1 Preservationist's Dispatch Two##208144 |goto Valdrakken/0 47.46,46.22
step
Enter the building |goto Ohn'ahran Plains/0 31.67,70.45 < 7 |walk
use the Torch of Pyrreth##208092
|tip Inside the mound.
Light the Brazier |q 77405 |goto Ohn'ahran Plains/0 31.08,70.79 |future
step
Enter the building |goto Ohn'ahran Plains/0 32.58,68.29 < 7 |walk
use the Torch of Pyrreth##208092
|tip Inside the mound.
Light the Brazier |q 77406 |goto Ohn'ahran Plains/0 32.37,67.95 |future
step
Enter the building |goto Ohn'ahran Plains/0 35.28,66.05 < 7 |walk
use the Torch of Pyrreth##208092
|tip Inside the mound.
Light the Brazier |q 77407 |goto Ohn'ahran Plains/0 35.19,65.74 |future
step
Enter the building |goto Ohn'ahran Plains/0 40.30,59.43 < 7 |walk
use the Torch of Pyrreth##208092
|tip Inside the mound.
Light the Brazier |q 77404 |goto Ohn'ahran Plains/0 39.55,58.92 |future
step
click Idol of Ohn'ahra
|tip Inside the mound.
accept An Idol in Hand##77304 |goto Ohn'ahran Plains/0 39.56,58.89
step
talk Preservationist Kathos##206864
|tip Inside the building.
turnin An Idol in Hand##77304 |goto Valdrakken/0 47.34,48.21
accept Using the Idol##76456 |goto Valdrakken/0 47.34,48.21
step
use the Idol of Ohn'ahra##207730
Collect the Idol of Ohn'ahra |toy Idol of Ohn'ahra##207730
step
use the Idol of Ohn'ahra##207730
Activate the Idol of Ohn'ahra |havebuff Idol of Ohn'ahra##414338 |q 76456
step
click Hidden Gem
Loot the Hidden Gem |q 76456/1 |goto Valdrakken/0 49.00,51.23 |count 1
step
click Hidden Gem
Loot the Hidden Gem |q 76456/1 |goto Valdrakken/0 45.70,59.37 |count 2
step
click Hidden Gem
Loot the Hidden Gem |q 76456/1 |goto Valdrakken/0 55.15,64.62 |count 3
step
talk Preservationist Kathos##206864
|tip Inside the building.
turnin Using the Idol##76456 |goto Valdrakken/0 47.34,48.21
step
talk Preservationist Kathos##206864
|tip Inside the building.
'|accept Into the Sands##76509 |n
collect 1 A Clue: The Shifting Sands##206948 |goto Valdrakken/0 47.32,48.22
step
use the Idol of Ohn'ahra##207730
Activate the Idol of Ohn'ahra |havebuff Idol of Ohn'ahra##414338 |q 77305 |future
step
click Time-Lost Fragment##404319
collect 1 Time-Lost Fragment##208191 |goto Thaldraszus/0 58.51,78.43 |q 77305 |future
step
click Time-Lost Fragment##404319
collect 2 Time-Lost Fragment##208191 |goto Thaldraszus/0 58.79,78.24 |q 77305 |future
step
click Time-Lost Fragment##404319
collect 3 Time-Lost Fragment##208191 |goto Thaldraszus/0 59.30,78.82 |q 77305 |future
step
use the Time-Lost Fragment##208191
accept Out of the Sands##77305
step
talk Preservationist Kathos##206864
|tip Inside the building.
turnin Out of the Sands##77305 |goto Valdrakken/0 47.33,48.20
step
talk Bobby Carlisle##207696
|tip Inside the building.
accept A Key Story##77653 |goto Valdrakken/0 47.95,46.81 |or
'|q 77406 |future |or
step
talk Weaponsmith Koref##195769
|tip Inside the building.
turnin A Key Story##77653 |goto Valdrakken/0 36.19,51.94 |or
'|q 77406 |future |or
step
Enter the cave |goto Ohn'ahran Plains/0 53.31,56.85 < 7 |walk
use the Torch of Pyrreth##208092
|tip Inside the mound.
Light the Brazier |q 77406 |goto Ohn'ahran Plains/0 32.37,67.95 |future
step
click Titan Key Mold
accept A Titanic Mold##77822 |goto Ohn'ahran Plains/0 63.00,57.37
step
talk Weaponsmith Koref##195769
|tip Inside the building.
turnin A Titanic Mold##77822 |goto Valdrakken/0 36.19,51.94
step
talk Bobby Carlisle##207696
|tip Inside the building.
accept Reforging a Legend##77829 |goto Valdrakken/0 47.94,46.82 |or
'|q 77893 |future |or
step
talk Weaponsmith Koref##195769
|tip Inside the building.
turnin Reforging a Legend##77829 |goto Valdrakken/0 36.19,51.91
'|q 77893 |future |or
step
use the Idol of Ohn'ahra##207730
Activate the Idol of Ohn'ahra |havebuff Idol of Ohn'ahra##414338 |q 77831 |future
step
click Dusty Red Pellets+
|tip They look like tiny clusters of red rocks on the ground around the shore.
|tip It helps to zoom your camera in close to see them.
collect 50 Rose Gold Dust##208835 |goto The Waking Shores/0 48.24,46.28 |q 77831 |future
step
click Igneous Flux+
|tip They look like small piles of ash around areas of cooling magma.
collect 8 Igneous Flux##208836 |goto The Waking Shores/0 21.10,76.86 |q 77831 |future
step
talk Weaponsmith Koref##210837
accept A Key To Reforg(ing)##77831 |goto The Waking Shores/0 24.52,60.74
step
use the Torch of Pyrreth##208092
Use the Torch |havebuff Flame Bearer##419127 |goto The Waking Shores/0 24.52,60.74 |q 77831 |future
step
talk Weaponsmith Koref##210837
Select _"I am ready to begin."_
Talk to Weaponsmith Koref to Begin |q 77831/1 |goto The Waking Shores/0 24.52,60.74
step
extraaction Add Dusty Red Pellets##422252
Add the Dusty Red Pellets |q 77831/2 |goto The Waking Shores/0 24.52,60.74
step
extraaction Add Igneous Flux##422255
Add the Igneous Flux |q 77831/3 |goto The Waking Shores/0 24.52,60.74
step
use the Torch of Pyrreth##208092
Infuse the Key with the Torch of Pyrreth |q 77831/4 |goto The Waking Shores/0 24.52,60.74
step
click Reforged Titan Key
collect 1 Reforged Titan Key##208830 |q 77831/5 |goto The Waking Shores/0 24.54,60.90
step
talk Weaponsmith Koref##210837
turnin A Key To Reforg(ing)##77831 |goto The Waking Shores/0 24.51,60.75
step
talk Preservationist Kathos##206864
|tip Inside the building.
accept A Proper Burial##77865 |goto Valdrakken/0 47.35,48.21 |or
'|q 77578 |future |or
step
use the Torch of Pyrreth##208092
Use the Torch |havebuff Flame Bearer##419127 |goto Valdrakken/0 24.52,60.74 |q 77578 |future
step
Enter the cave |goto Ohn'ahran Plains/0 43.65,48.13 < 7 |walk
click Banner Stand
|tip In the upper part of the cave.
Select _"<Tie the burial banner back up to the stand.>"_
Plant the Banner |q 77578 |goto Ohn'ahran Plains/0 42.65,50.99 |future
step
talk Bobby Carlisle##207696
|tip Inside the building.
'|accept A Special Book##77897 |n
collect Kirin Tor Contact's Note##208888 |goto Valdrakken/0 47.94,46.84 |q 78050 |future
step
use the Idol of Ohn'ahra##207730
|tip Kill Moroes, then do the Opera event and move on to kill The Curator.
|tip Use it in The Menagerie inside Karazhan.
Activate the Idol of Ohn'ahra |havebuff Idol of Ohn'ahra##414338 |q 78050 |future
step
click Ancient Tome
Check the Ancient Tome |q 78050 |goto Karazhan/9 32.39,49.12 |future
step
click Ancient Tome
Check the Ancient Tome |q 78051 |goto Karazhan/9 36.52,37.22 |future
step
click Ancient Tome
Check the Ancient Tome |q 78052 |goto Karazhan/9 47.39,64.63 |future
step
click Tyr's Legacy
accept A Legacy of Secrets##77908 |goto Karazhan/9 33.29,50.93
step
talk Bobby Carlisle##207696
|tip Inside the building.
turnin A Legacy of Secrets##77908 |goto Valdrakken/0 47.99,46.82
step
talk Bobby Carlisle##207696
|tip Inside the building.
accept They Are Always Listening##77928 |goto Valdrakken/0 47.95,46.81 |or
'|complete completedq(77916) |or
step
talk Fangli Hoot##207697
turnin They Are Always Listening##77928 |goto Valdrakken/0 26.67,53.90 |or
'|complete completedq(77916) |or
step
click Auction House Bill of Sale
|tip Inside the building.
Retrieve the Auction House Bill of Sale |q 78053 |goto Valdrakken/0 44.21,60.40 |future
step
click Void Storage Receipt
|tip Inside the building.
Retrieve the Void Storage Receipt |q 78054 |goto Valdrakken/0 73.96,57.48 |future
step
click Garden Supply Receipt
|tip Inside the building.
Retrieve the Garden Supply Receipt |q 78055 |goto Valdrakken/0 53.02,28.51 |future
step
click Researcher's Note
|tip Inside the building.
Retrieve the Researcher's Note |q 78056 |goto Valdrakken/0 37.61,37.16 |future
step
click Hastily Scrawled Note
|tip Inside the building.
Retrieve the Hastily Scrawled Note |q 78057 |goto Valdrakken/0 31.65,70.27 |future
step
click Researcher's Note
|tip Inside the building.
Retrieve the Researcher's Note |q 78056 |goto Valdrakken/0 37.61,37.16 |future
step
|script DoEmote("Bow")
clicknpc Odd Statue##189827 |goto Valdrakken/0 46.87,45.04
|tip Inside the building.
|tip Target the statue before bowing.
Bow Before the Odd Statue |complete subzone("The Dragon's Hoard") |goto Valdrakken/0 46.87,45.04 |q 77934 |future
step
use the Idol of Ohn'ahra##207730
|tip Inside the building.
Activate the Idol of Ohn'ahra |havebuff Idol of Ohn'ahra##414338 |q 77934 |future
step
click Note to Kritha
|tip Inside the building.
Retrieve the Note to Kritha |q 78058 |goto Valdrakken/0 46.00,41.45 |future
step
Leave The Dragon's Hoard Bar |complete not subzone("The Dragon's Hoard") |goto Valdrakken/0 47.33,49.72
step
talk Fangli Hoot##207697
turnin A Complete Inventory##77934 |goto Valdrakken/0 26.67,53.90
step
talk Tithris##185562
'|accept A Sphere in Danger##77953 |n
collect Preservationist's Dispatch Three##208942 |goto Valdrakken/0 47.48,46.18 |q 77951 |future
step
Enter the cave |goto Thaldraszus/0 47.03,78.10 < 7 |walk
use the Torch of Pyrreth##208092
|tip Inside the cave.
|tip Wait for it to reveal the tablet.
Activate the Tablet |q 78109 |goto Thaldraszus/0 46.62,77.61 |future
step
click Buried Object
collect Piece of the Orb of Rathmus##209797 |goto Thaldraszus/0 45.90,79.71 |q 78108 |future
step
Enter the cave |goto Thaldraszus/0 49.78,80.21 < 7 |walk
use the Torch of Pyrreth##208092
|tip Inside the cave.
|tip Wait for it to reveal the tablet.
Activate the Tablet |q 78108 |goto Thaldraszus/0 50.15,81.01 |future
step
click Buried Object
collect Piece of the Orb of Rathmus##209795 |goto Thaldraszus/0 49.52,79.74 |q 78111 |future
step
Enter the cave |goto Thaldraszus/0 47.91,77.83 < 7 |walk
use the Torch of Pyrreth##208092
|tip Inside the cave.
|tip Wait for it to reveal the tablet.
Activate the Tablet |q 78111 |goto Thaldraszus/0 48.69,76.32 |future
step
click Buried Object
collect Piece of the Orb of Rathmus##209799 |goto Thaldraszus/0 50.16,78.00 |q 77954 |future
step
use the Piece of the Orb of Rathmus##209799
accept A Curious Orb##77954 |goto Thaldraszus/0 50.16,78.00
step
talk Tithris##185562
|tip Inside the building.
turnin A Curious Orb##77954 |goto Valdrakken/0 47.46,46.22
step
talk Preservationist Kathos##206864
|tip Inside the building.
'|accept A Treacherous Race##77957 |n
collect Ancient Tyrhold Artifact Notes##208958 |goto Valdrakken/0 47.43,48.22
step
use the Torch of Pyrreth##208092
|tip Wait for the channeling to complete and the orb to catch fire.
Activate the Statue |q 77960 |goto Thaldraszus/0 57.25,64.53 |future
step
use the Torch of Pyrreth##208092
|tip Wait for the channeling to complete and the orb to catch fire.
Activate the Statue |q 77961 |goto Thaldraszus/0 57.06,63.03 |future
step
use the Torch of Pyrreth##208092
|tip Wait for the channeling to complete and the orb to catch fire.
Activate the Statue |q 77962 |goto Thaldraszus/0 57.85,61.98 |future
step
use the Torch of Pyrreth##208092
|tip Wait for the channeling to complete and the orb to catch fire.
Activate the Statue |q 77963 |goto Thaldraszus/0 57.85,60.51 |future
step
use the Torch of Pyrreth##208092
|tip Wait for the channeling to complete and the orb to catch fire.
Activate the Statue |q 77964 |goto Thaldraszus/0 59.79,61.04 |future
step
use the Torch of Pyrreth##208092
|tip Wait for the channeling to complete and the orb to catch fire.
Activate the Statue |q 77965 |goto Thaldraszus/0 57.85,57.03 |future
step
use the Torch of Pyrreth##208092
|tip Wait for the channeling to complete and the orb to catch fire.
Activate the Statue |q 77966 |goto Thaldraszus/0 57.93,55.93 |future
step
use the Torch of Pyrreth##208092
|tip Wait for the channeling to complete and the orb to catch fire.
Activate the Statue |q 77967 |goto Thaldraszus/0 59.77,56.32 |future
step
use the Torch of Pyrreth##208092
|tip In the back of the building in front of the giant face.
Activate the Lock |q 77975 |goto Thaldraszus/0 61.17,58.74 |future
step
click Broken Urn
|tip On the first floor from the surface.
collect Titan Cube Housing##208971 |goto Thaldraszus/0 59.95,54.69 |q 77969 |future
step
click Broken Urn
|tip On the third floor from the surface.
collect Titan Focusing Crystal##208960 |goto Thaldraszus/0 59.72,54.87 |q 77969 |future
step
click Broken Urn
|tip On the first floor from the surface.
collect Titan Energy Core##208970 |goto Thaldraszus/0 59.83,62.26 |q 77969 |future
step
click Broken Urn
|tip On the third floor from the surface.
collect Large Titan Capacitor##208973 |goto Thaldraszus/0 59.68,62.63 |q 77969 |future
step
use the Titan Energy Core##208970
collect Titan Energy Cube##208969 |q 77969 |future
step
click Broken Urn
|tip On the bottom floor.
collect Titan Block Key Fragment##208967 |goto Thaldraszus/0 61.96,61.93 |q 77969 |future
step
click Broken Urn
|tip On the bottom floor.
collect Titan Block Key Fragment##208966 |goto Thaldraszus/0 61.66,55.08 |q 77969 |future
step
use the Titan Block Key Fragment##208966
collect Titan Block Key##208965 |q 77969 |future
step
click Titan Power Relay
|tip Inside the tower.
Select _"<Install the missing component.>"_
Install the Missing Component |q 77969 |goto Thaldraszus/0 61.04,55.05 |future
step
click Titan Power Relay
|tip Inside the tower.
Select _"<Install the missing component.>"_
Install the Missing Component |q 77968 |goto Thaldraszus/0 59.33,56.89 |future
step
click Titan Power Relay
|tip Inside the tower.
Select _"<Install the missing component.>"_
Install the Missing Component |q 77970 |goto Thaldraszus/0 59.53,60.58 |future
step
click Titan Power Relay
|tip Inside the tower.
Select _"<Install the missing component.>"_
Install the Missing Component |q 77971 |goto Thaldraszus/0 61.03,62.35 |future
step
click Orb Location
accept An Ominous Artifact##77977 |goto Thaldraszus/0 60.16,58.73
step
click Orb Location
Select _"<Investigate to see if you can bypass the orb.>"_
Investigate the Orb Slot on the Console |q 77977/1 |goto Thaldraszus/0 60.16,58.73
stickystart "Kill_Amerinth"
step
kill 1 Tithris##210674 |q 77977/3 |goto Thaldraszus/0 60.41,58.74
step
label "Kill_Amerinth"
kill 1 Amerinth##210675 |q 77977/2 |goto Thaldraszus/0 60.41,58.74
step
collect 1 Orb of Rathmus##209555 |q 77977/4 |goto Thaldraszus/0 60.41,58.68
|tip Loot it from their corpse.
step
click Orb Location
Select _"<Place the Orb of Rathmus.>"_
Place the Orb of Rathmus Atop the Console |q 77977/5 |goto Thaldraszus/0 60.16,58.74
step
click Cache of Cosmic Mysteries
Secure the Mysterious Artifact |q 77977/6 |goto Thaldraszus/0 60.14,58.74
step
click Orb of Rathmus
Select _"<Retrieve the Orb of Rathmus.>"_
Retrieve the Orb of Rathmus |q 77977/7 |goto Thaldraszus/0 60.16,58.74
step
talk Preservationist Kathos##206864
turnin An Ominous Artifact##77977 |goto Thaldraszus/0 60.45,59.11
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Secrets of Azeroth\\Community Rumors",{
condition_suggested=function() return isevent("Secrets of Azeroth") end,
description="\nThis guide section will walk you through finding the community rumors for the Secrets of Azeroth event.",
},[[
step
use the Torch of Pyrreth##208092
|tip Work through the "Secrets of Azeroth" event guide to collect this toy.
|tip It is require to complete the following steps.
Collect the Torch of Pyrreth |toy Torch of Pyrreth##208092
step
use the Torch of Pyrreth##208092
Use the Torch Near the Crystal and Wait for the Dirt to Spawn |q 78152 |goto Blasted Lands/0 64.67,55.44 |future
step
click Loose Dirt Mound
Loot the Buried Satchel |q 77298 |goto Blasted Lands/0 64.67,55.44 |future
step
click Loose Dirt Mound
Loot the Buried Satchel |q 78207 |goto Western Plaguelands/0 68.81,73.21 |future
step
click Loose Dirt Mound
Loot the Buried Satchel |q 77289 |goto Eastern Plaguelands/0 55.25,59.44 |future
step
click Loose Dirt Mound
|tip At the mouth of the statue.
Loot the Buried Satchel |q 77297 |goto Northern Barrens/0 46.05,50.68 |future
step
Enter the underwater cave |goto Thousand Needles/0 44.10,37.23 < 10 |walk
click Loose Dirt Mound
|tip Inside the underwater cave.
Loot the Buried Satchel |q 77291 |goto Thousand Needles/0 42.74,30.65 |future
step
click Loose Dirt Mound
Loot the Buried Satchel |q 77288 |goto Felwood/0 42.23,48.04 |future
step
click Loose Dirt Mound
|tip on the floating island.
Loot the Buried Satchel |q 77299 |goto Nagrand/0 57.90,26.37 |future
step
use the Torch of Pyrreth##208092
|tip Three players must use each use their torch near a small crystal surrounding the bigger crystal.
click Loose Dirt Mound
Loot the Buried Satchel |q 77290 |goto Netherstorm/0 26.26,68.57 |future
step
click Loose Dirt Mound
|tip At the mouth of the statue.
Loot the Buried Satchel |q 77294 |goto Dragonblight/0 63.91,72.62 |future
step
click Loose Dirt Mound
|tip on the floating island.
Loot the Buried Satchel |q 77302 |goto Dragonblight/0 73.15,39.54 |future
step
talk Darrok##27425 |only if Horde
talk Gordun##27414 |only if Alliance
Select _"Yes, I am ready to travel to Venture Bay!"_
Begin the Log Ride |invehicle |goto Grizzly Hills/0 35.06,34.74 |only if Horde
Begin the Log Ride |invehicle |goto Grizzly Hills/0 36.81,35.73 |only if Alliance
step
Ride the Log Ride |outvehicle |goto Grizzly Hills/0 10.73,75.23 |only if Horde
Ride the Log Ride |outvehicle |goto Grizzly Hills/0 20.40,81.51 |only if Alliance
step
click Loose Dirt Mound
|tip Click it before the WHEE! buff wears off.
Loot the Buried Satchel |q 77300 |goto Grizzly Hills/0 10.98,74.90 |future |only if Horde
Loot the Buried Satchel |q 77300 |goto Grizzly Hills/0 20.29,81.35 |future |only if Alliance
step
click Loose Dirt Mound
|tip At the mouth of the statue.
Loot the Buried Satchel |q 77293 |goto Valley of the Four Winds/0 56.83,21.41 |future
step
click Loose Dirt Mound
|tip At the mouth of the statue.
Loot the Buried Satchel |q 77301 |goto Timeless Isle/0 38.70,54.94 |future
step
click Loose Dirt Mound
Loot the Buried Satchel |q 77292 |goto Shadowmoon Valley D/0 35.31,48.96 |future
step
click Loose Dirt Mound
|tip on the floating island.
Loot the Buried Satchel |q 78208 |goto Highmountain/0 53.35,87.50 |future
step
click Loose Dirt Mound
|tip on the floating island.
Loot the Buried Satchel |q 77295 |goto Tiragarde Sound/0 74.56,86.13 |future
step
use the Torch of Pyrreth##208092
|tip Walk up to the snowman with it lit a waint for it to melt.
click Loose Dirt Mound
|tip At the mouth of the statue.
Loot the Buried Satchel |q 77296 |goto The Azure Span/0 25.24,71.47 |future
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Secrets of Azeroth\\Secrets of Azeroth Mimiron's Jumpjets Mount",{
condition_suggested=function() return isevent("Secrets of Azeroth") end,
description="\nThis guide section will walk you through assembling the Mimiron's Jumpjets.",
},[[
step
use the Torch of Pyrreth##208092
|tip Work through the "Secrets of Azeroth" event guide to collect this toy.
|tip It is require to complete the following steps.
Collect the Torch of Pyrreth |toy Torch of Pyrreth##208092
step
use the Torch of Pyrreth##208092
|tip 3 people are needed, each using their Torch near a brazier to summon the Enigma Ward.
kill Enigma Ward##210398 |q 78098 |goto The Cape of Stranglethorn/0 58.99,78.25 |future
step
collect 1 First Booster Part##208984
|tip Loot it from the corpse.
step
extraaction Envelope##423412
click Mimiron's Booster Part
|tip One person needs to click the part while the other three need to use the ability that appears on-screen by the elemental.
collect Second Booster Part##209781 |goto Felwood/0 49.91,26.37 |q 78099 |future
step
click Mimiron's Booster Part
collect Third Booster Part##209055 |goto Blasted Lands/0 54.86,52.28 |q 78100 |future
step
use First Booster Part##208984
|tip The Arcane Forge must be empowered to assemble this.
|tip The icon on the map indicates the start of the next event and the number of completions required to make the forge permanent.
|tip Wait for the next event completion to assemble your mount.
collect Mimiron's Jumpjets##210022 |goto Valdrakken/0 36.47,61.98
step
use Mimiron's Jumpjets##210022
Collect the Mimiron's Jumpjets Mount |learnmount Mimiron's Jumpjets##424082
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\Dragonflight (10-70)\\The Emerald Dream Superbloom",{
description="This guide will help you complete the Superbloom event in The Emerald Dream.",
startlevel=70,
patch='100200',
viginette=5813,
areapoitype="Superbloom",
},[[
step
label "Accept_The_Superbloom"
talk Clarelle##208474
accept The Superbloom##78319 |goto The Emerald Dream/0 51.42,59.61
step
Wait for the Superbloom Event to Start |scenariostart |goto The Emerald Dream/0 51.42,59.61
|tip The event starts at the top of every hour.
stickystart "Earn_Blooms"
step
click Dreamfruit
|tip Choose from the powers available for the remainder of the Superbloom event.
|tip Depending on your reputation with the Dream Wardens, you may be able to choose more than one.
Consume Dreamfruit for the Journey |scenariogoal 1/60388 |goto The Emerald Dream/0 51.27,59.83
step
map The Emerald Dream/0
path follow smart; loop off; ants curved; dist 30
path	51.51,59.79	52.08,60.78	54.28,62.10	54.87,63.82	56.08,66.67
path	57.38,68.17	55.54,71.50	53.13,73.70
click Rain-Starved Flower+
|tip They look like large flowers surrounded by light on the ground all over the area.
|tip Each flower will increase the Bloom Quality by a small amount.
Help as Many Rain-Starved Flowers as You Can |scenariogoal 2/60395
|only if scenariostage(2)
step
Kill enemies that attack in waves
Defeat the Primalists |scenariogoal 3/0 |goto The Emerald Dream/0 53.06,73.68
|only if scenariostage(3)
step
map The Emerald Dream/0
path follow smart; loop off; ants curved; dist 30
path	52.85,74.18	51.24,77.10	49.77,76.64	47.56,76.14	46.85,74.46
path	45.74,72.83	44.72,72.09 |goto The Emerald Dream/0 44.10,71.76
clicknpc Tenacious Weed##207675+
|tip They look like small plants growing out of the ground around Sprucecrown.
click Rain-Starved Flowers
|tip They look like large flowers surrounded by light on the ground all over the area.
|tip Each flower and weed will increase the Bloom Quality by a small amount.
Pull Weeds and Help as Much as You Can |scenariogoal 4/60396
|only if scenariostage(4)
step
map The Emerald Dream/0
path follow smart; loop off; ants curved; dist 30
path	51.53,59.92	49.56,58.84	48.82,58.40	47.07,58.76	46.33,61.46
path	46.15,63.57
clicknpc Vision of Innocence##208693+
|tip They look like small creatures hopping around this area.
Shoo as Many Insect Swarms as you Can Near Sprucecrown |scenariogoal 5/60398
|only if scenariostage(5)
stickystart "Defeat_the_Western_Patrol"
step
Kill enemies that attack in waves
Defeat the Northern Patrol |scenariogoal 6/60314 |goto The Emerald Dream/0 46.46,61.21
|only if scenariostage(6)
step
label "Defeat_the_Western_Patrol"
Kill enemies that attack in waves
Defeat the Western Patrol |scenariogoal 6/60315 |goto The Emerald Dream/0 46.00,63.64
|only if scenariostage(6)
step
map The Emerald Dream/0
path follow smart; loop off; ants curved; dist 30
path	46.15,63.57	45.17,64.11	44.44,67.32	42.44,67.98	42.24,68.91
path	44.01,72.01
click Mulch Pile+
|tip THey look like piles of dirt on the ground around this area.
Dig up mulch and help as much as you can |scenariogoal 7/60397
|only if scenariostage(7)
step
Kill enemies that attack in waves
Defend Sprucecrown from All Primalist Attackers |scenariogoal 8/64358 |goto The Emerald Dream/0 44.06,71.79
step
kill 1 Verlann Timbercrush##207554 |scenariogoal 9/60311 |goto The Emerald Dream/0 43.98,72.35
step
label "Earn_Blooms"
Earn #50# Blooms |q 78319/2 |goto The Emerald Dream/0 51.42,59.61
|tip Run through Insect Swarms to disperse them.
|tip Click flowers and fruits along the way.
step
Complete the Superbloom |q 78319/3 |goto The Emerald Dream/0 51.42,59.61
step
talk Clarelle##208474
turnin The Superbloom##78319 |goto The Emerald Dream/0 44.62,71.96
|next "Accept_The_Superbloom"
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\The War Within (70-80)\\20th Anniversary Celebration\\Achievements\\No Crate Left Behind",{
startlevel=10,
patch='110005',
achieveid={40979,40873},
},[[
step
talk Nikto##143029
|tip Underwater
buy 1 Clam Digger##225996 |goto Zuldazar/0 54.28,54.50 |q 83790 |future
step
click Gerald
|tip On the rock cliff under the water.
Select _"<Hold out the clam digger carefully so the contents don't float away.>"_ |gossip 123382
Unlock the Zuldazar Dive Bar Secret |q 83790 |goto Zuldazar/0 54.24,54.23 |future
step
click Soggy Celebration Crate
|tip On the rock cliff under the water.
accept Soggy Celebration Crate##83794 |goto Zuldazar/0 54.24,54.21
step
Kill Yourself |complete isdead() or completedq(85574) |goto Desolace/0 54.12,58.05
|tip You need to be dead to see this treasure.
|tip You can fly up in the air and dismount at this location to die, then run back.
step
click Hazy Celebration Crate
accept Hazy Celebration Crate##85574 |goto Desolace/0 54.12,58.05 |zombiewalk
step
Resurrect |complete not isdead
|tip Regain your corpse.
step
Enter the underwater cave |goto Thousand Needles/0 66.08,86.21 < 15 |walk
click Water-Resistant Receipt of Sale
|tip Inside the underwater cave.
collect Water-Resistant Receipt##228768 |goto Thousand Needles/0 64.92,84.40
step
talk Vashti the Wandering Merchant##91079
|tip He patrols up and down the road between the border of Suramar and The Ruined Sanctum.
buy Sandy Celebration Crate##228767 |goto Azsuna/0 65.66,36.36 |q 84624 |future
|tip This will cost 500 gold.
step
Enter the Crypt |goto Deadwind Pass/0 39.84,73.38 < 10 |walk
Go down the tunnel |goto Deadwind Pass/0 33.52,70.72 < 10 |c |walk |q 84470 |future
step
Run down the ramp |goto Deadwind Pass/0 36.30,73.79 < 15 |walk
Swim through |goto Deadwind Pass/0 29.55,81.32
click Dirt-Caked Celebration Crate
|tip Down inside the crypt.
accept Dirt-Caked Celebration Crate##84470 |goto Deadwind Pass/0 22.44,83.74
step
click Battered Celebration Crate
accept Battered Celebration Crate##83931 |goto Howling Fjord/0 29.40,6.36
step
click Waterlogged Celebration Crate
|tip At the bottom of the water inside the upper floor of the building.
|tip Swim inside and up the elevator.
accept Waterlogged Celebration Crate##84426 |goto Tanaris/0 69.18,68.60
step
click Charred Celebration Crate
accept Charred Celebration Crate##84767 |goto Mount Hyjal/0 13.59,33.46
step
click Potion of Truth
|tip At the very top of the mountain.
Drink the Potion of Truth |havebuff Potion of Truth##463368 |goto Ashenvale/0 47.92,38.37 |q 85523 |future
step
click Mildewed Celebration
|tip You have 30 minutes before the potion wears off.
|tip Fly directly to Felwood without using any teleports, items, or portals.
|tip Using these methods will remove your buff and require you to return to Ashenvale.
accept Mildewed Celebration Crate##85523 |goto Feralas/0 60.42,35.40 |notravel
step
Enter the cave |goto Nagrand/0 35.84,67.58 < 15 |walk
click Crystallized Celebration Crate
|tip Inside Oshu'gun.
accept Crystalized Celebration Crate##84773 |goto Nagrand/0 35.28,74.70
step
Appoach the Hidden Cove |complete subzone("Ahn'Qiraj: The Fallen Kingdom") or completedq(84625) |goto Uldum/0 12.45,61.33 |only if hasbuff(317785)
Appoach the Hidden Cove |complete subzone("Ahn'Qiraj: The Fallen Kingdom") or completedq(84625) |goto Uldum New/0 5.64,60.70 |only if not hasbuff(317785)
|tip You will need some sort of dog battle pet to dig up the bones in the next step.
step
Enter the cave |goto Ahn'Qiraj: The Fallen Kingdom/0 42.09,92.95 < 15 |walk
click Mysterious Bones
|tip Summon any kind of dog battle pet and wait for it to dig up the bones here.
|tip Search for "pup" in your pet journal or use a Perky Pug from the Looking for Multitudes achievement.
collect Mysterious Bones##228772 |goto Ahn'Qiraj: The Fallen Kingdom/0 44.57,90.08 |q 84625 |future
step
use the Mysterious Bones##228772
accept Surprisingly Pristine Celebration Crate##84625 |goto Stormheim/0 37.34,47.69
step
click Ghostly Celebration Crate
|tip High up on the balcony area with the red banner on top of Bleak Redoubt.
accept Ghostly Celebration Crate##84909 |goto Maldraxxus/0 50.00,73.80
step
talk Alyx##234262
turnin Soggy Celebration Crate##83794 |goto Dornogal/0 50.34,38.71
turnin Hazy Celebration Crate##85574 |goto Dornogal/0 50.34,38.71
turnin Dirt-Caked Celebration Crate##84470 |goto Dornogal/0 50.34,38.71
turnin Sandy Celebration Crate##84624 |goto Dornogal/0 50.34,38.71
turnin Battered Celebration Crate##83931 |goto Dornogal/0 50.34,38.71
turnin Waterlogged Celebration Crate##84426 |goto Dornogal/0 50.34,38.71
turnin Charred Celebration Crate##84767 |goto Dornogal/0 50.34,38.71
turnin Mildewed Celebration Crate##85523 |goto Dornogal/0 50.34,38.71
turnin Crystalized Celebration Crate##84773 |goto Dornogal/0 50.34,38.71
turnin Surprisingly Pristine Celebration Crate##84625 |goto Dornogal/0 50.34,38.71
turnin Ghostly Celebration Crate##84909 |goto Dornogal/0 50.34,38.71
]])
ZygorGuidesViewer:RegisterGuide("Pets & Mounts Guides\\Mounts\\Ground Mounts\\Incognitro, the Indecipherable Felcycle",{
description="This guide will help you collect the Incognitro, the Indecipherable Felcycle mount.",
mounts={428013},
mounttype='Ground',
startlevel=10,
patch='110005',
},[[
step
Earn the {o}Azeroth's Greatest Detective{} Achievement |achieve 40870
|tip You must have earned the {o}Detective{} title during the 20th anniversary event to continue this guide.
|tip You cannot start the initial quest chain without being able to equip this title.
step
Save the items from this guide
|tip Items such as Pieces of Hate that you earn through secrets should be kept in your inventory until you complete this guide.
|tip Many will be used for various secrets later.
|tip Various secrets have bugs or are delayed in granting credit.
confirm
step
use the Torch of Pyrreth##208092
|tip Your torch must be active to interact.
click Inert Peculiar Key
|tip Inside the hollow stump.
collect Inert Peculiar Key##228941 |goto Un'Goro Crater/0 44.53,7.98 |q 84684 |future
step
Equip the {o}Detective{} Title |complete _G.GetCurrentTitle() == 571 |goto Dornogal/0 55.03,28.96 |q 84685 |future
|tip You must have this title active to accept the next quest.
step
talk Dalaran Survivor##230042
Select _"You can tell me, I'm a detective."_ |gossip 124145
Select _"Go on..."_ |gossip 124144
accept Ratts' Race##84684 |goto Dornogal/0 55.03,28.96
step
Enter the cave |goto Azj-Kahet/0 68.64,93.12 < 10 |walk
click Unfinished Note
|tip Inside the cave.
Find the First Clue |q 84684/1 |goto Azj-Kahet/0 69.33,93.32
step
click Hastily Scrawled Note
|tip High up on the cliff.
Find the Second Clue |q 84684/2 |goto Nerub'ar/1 31.51,20.77
step
Enter the cave |goto Hallowfall/0 49.79,85.81 < 15 |walk
click Water-Resistant Note
|tip At the bottom of the water.
Find the Third Clue |q 84684/3 |goto Hallowfall/0 50.72,86.64
step
Enter the cave |goto Azj-Kahet/0 55.11,19.21 < 10 |walk
Jump into the hole |goto Azj-Kahet/0 56.34,17.46 < 2 |walk
|tip Jump up onto the wall and into the hidden hole.
|tip It's in the folds of the landscape and very difficult to see.
Watch the dialogue
Confront Ratts |q 84684/4 |goto Azj-Kahet/0 56.18,18.05
|tip Wait for Ratts to run away.
step
click Peculiar Gem
turnin Ratts' Race##84684 |goto Azj-Kahet/0 56.13,17.99
step
use the Inert Peculiar Key##228941
collect Peculiar Key##44124
step
use the Torch of Pyrreth##208092
|tip Your torch must be active to interact.
click Humble Monument
Gain 1 Stack of The Light of Their Love Buff |havebuff 1 The Light of Their Love##153715 |goto Northern Barrens/0 55.00,40.15 |q 84677 |future
step
use the Torch of Pyrreth##208092
|tip Your torch must be active to interact.
Reach 2 Stacks of The Light of Their Love Buff |havebuff 2 The Light of Their Love##153715 |goto Maldraxxus/0 27.01,61.23 |q 84677 |future
step
use the Torch of Pyrreth##208092
|tip Your torch must be active to interact.
Reach 3 Stacks of The Light of Their Love Buff |havebuff 3 The Light of Their Love##153715 |goto Nagrand D/0 74.16,37.51 |q 84677 |future
Depending on your WoD progress, it might be at [Nagrand D/0 49.29,47.96]
step
Collect a {o}Perky Pug{} Pet |learnpet Perky Pug##250 |q 84677 |future
|tip The {o}Looking for Multitudes{} achievement grants this.
|tip You can also skip this step, stand around the objective area, and hope someone else completes this.
|tip Anyone within 10 yard can get the required key.
step
talk Vashti the Wandering Merchant##91079
buy "Dogg-Saron" Costume##229413 |goto Azsuna/0 63.85,34.47 |q 84677 |future
|tip This cost 25,000 gold.
|tip If you have a "Yipp-Saron" Costume, you can skip this.
|tip You can also stand around the objective area and hope someone else completes this.
|tip Anyone within 10 yard can get the required key.
You can also find him walking along the road round:
[Azsuna/0 65.63,23.03]
[Azsuna/0 63.66,28.16]
[Azsuna/0 66.28,39.18]
[Azsuna/0 66.87,44.34]
step
talk Zidormi##163463
Select _"Can you show me what the Vale was like before the Black Empire assault?"_ |gossip 51473
Travel to the Old Version of the Vale |complete ZGV.InPhase("OldVale") |goto Vale of Eternal Blossoms New/0 80.97,29.48
step
|script DoEmote("Pray")
Retrieve the Key of Shadows |q 84677 |goto Vale of Eternal Blossoms/0 83.10,30.15 |future
|tip You will need one of the following to complete this:
|tip A {o}Twitching Eyeball{} or {o}All-Seeing Eyes{} toy buff active.
|tip A {o}Perky Pug{} pet with a {o}"Dogg-Saron" Costume{} or a {o}"Yipp-Saron" Costume{} equipped.
|tip When you emote {}Pray{} in front of the idol on top of the building, everyone within 10 yard will receive the key.
|tip If you have time you could also wait for someone to come along and complete this.
|tip This quest seems to be fairly buggy and may take some time or repeated tries to collect the key.
step
use the Torch of Pyrreth##208092
|tip Your torch must be active to see the portal.
Enter the Karazhan Catacombs |scenariostart Ratts' Revenge##2635 |goto Deadwind Pass/0 46.24,69.07 |q 84757 |future
step
click Chamber Door
confirm |goto Deadwind Pass/27 49.37,71.30 |q 84757 |future
step
click Door 430
confirm |goto Deadwind Pass/27 47.27,67.94 |q 84757 |future
step
cast Fishing##131474
|tip Fish in the small Astral Soup bowl on the shelf.
collect Astral Key##228965 |goto Deadwind Pass/27 50.49,77.89 |q 84757 |future
step
click Astral Chest
collect Starry-Eyed Goggles##228966 |goto Deadwind Pass/27 48.26,79.79 |q 84757 |future
step
use the Starry-Eyed Goggles##228966
Equip the Starry-Eyed Goggles |havebuff Starry-Eyed Goggles##463749 |q 84757 |future
step
use the Starry-Eyed Goggles##228966
|tip You need these active to see the machine.
click Decryption Console
|tip Use the numbers on your action bar
|tip Enter the numbers {o}88224646{} and then the {o}Submit{} button.
|tip If you do not see the buttons on your action bar, look for them in the {o}General{} tab of of your spellbook.
|tip The {o}Number Sequences{} button located there will contain the buttons you need.
click "Property of Elder Ko'nani"
|tip To the left of the console.
Collect the Piece of Hate |q 84757 |future |goto Deadwind Pass/27 49.49,80.27
step
use the Starry-Eyed Goggles##228966
|tip You need these active to see the machine.
click Decryption Console
|tip Use the numbers on your action bar
|tip Enter the numbers {o}10638{} and then the {o}Submit{} button.
|tip If you do not see the buttons on your action bar, look for them in the {o}General{} tab of of your spellbook.
|tip The {o}Number Sequences{} button located there will contain the buttons you need.
click Encrypted Chest
|tip To the left of the console.
Collect the Piece of Hate |q 84768 |future |goto Deadwind Pass/27 49.86,64.70
step
use the Starry-Eyed Goggles##228966
|tip You need these active to see the machine.
click Decryption Console
|tip Use the numbers on your action bar
|tip Enter the numbers {o}17112317{} and then the {o}Submit{} button.
|tip If you do not see the buttons on your action bar, look for them in the {o}General{} tab of of your spellbook.
|tip The {o}Number Sequences{} button located there will contain the buttons you need.
click Encrypted Puzzle Box
|tip To the left of the console on the table.
Collect the Piece of Hate |q 84758 |future |goto Deadwind Pass/27 42.79,71.10
step
use the Starry-Eyed Goggles##228966
|tip You need these active to see the machine.
click Decryption Console
|tip Use the numbers on your action bar
|tip Enter the numbers {o}5661{} and then the {o}Submit{} button.
|tip If you do not see the buttons on your action bar, look for them in the {o}General{} tab of of your spellbook.
|tip The {o}Number Sequences{} button located there will contain the buttons you need.
click Encrypted Chest
|tip To the right of the console.
Collect the Piece of Hate |q 84769 |future |goto Deadwind Pass/27 56.15,63.10
step
use the Starry-Eyed Goggles##228966
|tip You need these active to see the machine.
click Decryption Console
|tip Use the numbers on your action bar
|tip Enter the numbers {o}19019{} and then the {o}Submit{} button.
|tip If you do not see the buttons on your action bar, look for them in the {o}General{} tab of of your spellbook.
|tip The {o}Number Sequences{} button located there will contain the buttons you need.
click Encrypted Chest
|tip To the left of the console.
Collect the Piece of Hate |q 84771 |future |goto Deadwind Pass/27 68.02,83.15
step
use the Starry-Eyed Goggles##228966
|tip You need these active to see the machine.
click Rubenstein's Console
|tip Use the numbers on your action bar
|tip Enter the numbers {o}52233{} and then the {o}Submit{} button.
|tip If you do not see the buttons on your action bar, look for them in the {o}General{} tab of of your spellbook.
|tip The {o}Number Sequences{} button located there will contain the buttons you need.
click Rubenstein's Safe
|tip Underneath the console.
Collect the Piece of Hate |q 84766 |future |goto Deadwind Pass/27 64.97,48.62
step
use the Starry-Eyed Goggles##228966
|tip You need these active to see the machine.
click Decryption Console
|tip Use the numbers on your action bar
|tip Enter the numbers {o}51567{} and then the {o}Submit{} button.
|tip If you do not see the buttons on your action bar, look for them in the {o}General{} tab of of your spellbook.
|tip The {o}Number Sequences{} button located there will contain the buttons you need.
click Encrypted Chest
|tip To the right of the console.
Collect the Piece of Hate |q 84772 |future |goto Deadwind Pass/27 70.43,54.57
step
use the Starry-Eyed Goggles##228966
|tip You need these active to see the machine.
click Decryption Console
|tip Use the numbers on your action bar
|tip Enter the numbers {o}115{} and then the {o}Submit{} button.
|tip If you do not see the buttons on your action bar, look for them in the {o}General{} tab of of your spellbook.
|tip The {o}Number Sequences{} button located there will contain the buttons you need.
click Encrypted Chest
|tip To the right of the console.
Collect the Piece of Hate |q 84770 |future |goto Deadwind Pass/27 66.21,15.88
step
talk Lenny "Fingers" McCoy##108533 |goto Stormwind City/0 28.69,27.81 |only if not completedq(42740)
talk Lenny "Fingers" McCoy##2795 |goto Stormwind City/0 72.80,58.91 |only if completedq(42740)
|tip This is an Alliance NPC. |only if Horde
|tip You can purchase these items on an Alliance character and mail/warbank them. |only if Horde
buy Lucky Shirt##138385 |q 84786 |future
|tip This costs 95 gold.
buy Lucky Rat's Tooth##138382 |q 84786 |future
|tip This costs 7 gold.
buy Lucky Charm##138384 |q 84786 |future
|tip This costs 15 gold.
step
talk Farrier Roscha##186650
Select _"I'd like to browse your goods."_ |gossip 55990
buy Lucky Horseshoe##198400 |goto Ohn'ahran Plains/0 84.40,25.01 |q 84786 |future
|tip This costs 100 gold.
step
talk Griftah##219197
buy Lucky Tortollan Charm##202046 |goto Dornogal/0 62.57,50.94 |q 84786 |future
|tip This costs 50 gold.
buy Lucky Dragon's Claw##200265 |goto Dornogal/0 62.57,50.94 |q 84786 |future
|tip This costs 5 gold.
step
use the Torch of Pyrreth##208092
|tip Your torch must be active to see the portal.
Enter the Karazhan Catacombs |scenariostart Ratts' Revenge##2635 |goto Deadwind Pass/0 46.24,69.07 |q 84786 |future
step
use the Starry-Eyed Goggles##228966
|tip You need these active to see the machine.
click "Feeling Lucky?" Slot Machine
|tip Use the numbers on your action bar
|tip Enter the numbers {o}777{} and then the {o}Submit{} button.
|tip If you do not see the buttons on your action bar, look for them in the {o}General{} tab of of your spellbook.
|tip The {o}Number Sequences{} button located there will contain the buttons you need.
|tip With all of these items in your inventory, you should get it on the first try.
Collect the Piece of Hate |q 84786 |future |goto Deadwind Pass/27 63.53,25.59
step
talk Vashti the Wandering Merchant##91079
buy Scroll of Fel Binding##228987 |goto Azsuna/0 63.85,34.47 |q 84780 |future
|tip This cost 500 gold.
|tip You must summon a doomguard in the next step to cause some text to appear.
|tip You can also stand around the objective area and hope someone else summons a doomguard.
|tip Anyone within 10 yard can read the text required while the doomguard is active.
You can also find him walking along the road round:
[Azsuna/0 65.63,23.03]
[Azsuna/0 63.66,28.16]
[Azsuna/0 66.28,39.18]
[Azsuna/0 66.87,44.34]
step
use the Scroll of Fel Binding##228987
|tip Use this if you bought it or wait for someone to summon a doomguard if not.
click Hidden Grafitti
|tip Inside the tomb in front of the altar.
|tip A doomguard must be active nearby to see this.
Read the Hidden Grafitti |q 84780 |future |goto Western Plaguelands/0 52.21,83.93
step
Assemble a Secret Battle Pet Team
|tip You need a team of 3 secret battle pets for the 5th secret.
|tip You will need to win a pet battle against an NPC with your secret pet team.
|tip Some pets that count are Spyragos, Nelthara, Wicker Pup, Taptaf, Terky, Gurgl, Glimr, Snowclaw Cub, Jenafur, Bumbles, Sun Darter Hatchling, and Baa'l.
|tip Your pet team needs to be level 25 because the opposing team are level 25 epic pets.
confirm |q 84809 |future
step
talk Zarhym##71876
|tip Inside the cave.
Select _"I'm ready to enter the spirit world."_ |gossip 41831
|tip {b}Do not click anything during the next step!{}
|tip {b}Clicking objects will prevent you from completing the next step until the next daily reset.{}
Traverse the Spirit World |havebuff Spirit World##144145 |goto Timeless Isle/22 53.36,56.89 |q 84781 |future
step
Walk up the ramp here |goto Timeless Isle/22 62.36,50.89 < 2 |walk
|tip Stay under the white ring and away from the one on your right.
Jump down to the lower ramp |goto Timeless Isle/22 62.29,45.31 < 2 |walk
|tip Don't jump down to the base floor, just the next lowest part.
Jump down to the floor |goto Timeless Isle/22 63.49,32.68 < 4 |walk
Jump very carefully along the wall |goto Timeless Isle/22 68.61,25.78 < 2 |walk
|tip Jump along the wall avoiding the white ring.
|tip Avoid the rest of the white rings along the way.
|tip {b}Do not click anything!{}
|tip {b}Clicking objects will prevent you from completing the this step until the next daily reset.{}
talk Jeremy Feasel##232048
|tip Inside the cave.
Select _"I'm ready."_ |gossip 124744
|tip His team is Magic, Mechanical, and Beast.
accept Master of Secrets##84781 |goto Timeless Isle/22 39.46,39.12
|tip After defeating Jeremy's team, this quest becomes available.
step
click Pointless Treasure Salesman
|tip Inside the upper part of the statue.
|tip Jump over the chest and behind the small spiral staircase into the hidden alove.
buy Relic of Crystal Connections##228996 |goto The Cape of Stranglethorn/0 35.60,63.44
|tip This costs 9 Pieces of Hate from torch 3, and the Golden Muffin from torch 4.
step
For the next steps, you will need to appease 5 NPCs with various pets, mounts, or toys
Blood Altar:
|tip Any pet or mount with {o}Blood{} in the name and the Throbbing Blood Orb toy.
Corrupt Altar:
|tip Any pet or mount with {o}Corrupt{} in the name, the Ring of Broken Promises toy, and any cloak transmog sharing appearances with Cloak of Overwhelming Corruption.
Lust Altar:
|tip The sister of Temptation pet, Steamy Romance novel Kit toy, being fully naked, and have the buff from Moroes' Famous Polish.
Sin Altar:
|tip The Sinheart pet, the Bondable Sinstone toy, and any Venthyr Sinstone cloak transmog.
Void Altar:
|tip A void pet such as Lesser Voicaller, Voidwiggler, Sir Shady Mrrgglthon Junior, etc., a Shadowy Disguise or Void Totem toy, and any Cloak of the Black Void transmog appearance.
confirm |q 84809 |future
|tip Other players can also appease NPCs to assist.
step
Appease the Blood Altar |q 84809 |goto Northern Stranglethorn/0 77.09,46.27 |future
|tip Any pet or mount with {o}Blood{} in the name and the Throbbing Blood Orb toy.
|tip This may take some time to complete depending on how buggy it is.
|tip You can also just AFK here and wait for someone else to eventually trigger it.
step
Appease the Lust Altar |q 84808 |goto Northern Stranglethorn/0 77.07,44.87 |future
|tip The sister of Temptation pet, Steamy Romance novel Kit toy, being fully naked, and have the buff from Moroes' Famous Polish.
|tip This may take some time to complete depending on how buggy it is.
|tip You can also just AFK here and wait for someone else to eventually trigger it.
step
Appease the Corrupt Altar |q 84807 |goto Northern Stranglethorn/0 77.47,43.90 |future
|tip Any pet or mount with {o}Corrupt{} in the name, the Ring of Broken Promises toy, and any cloak transmog sharing appearances with Cloak of Overwhelming Corruption.
|tip This may take some time to complete depending on how buggy it is.
|tip You can also just AFK here and wait for someone else to eventually trigger it.
step
Appease the Sin Altar |q 84806 |goto Northern Stranglethorn/0 78.25,44.00 |future
|tip The Sinheart pet, the Bondable Sinstone toy, and any Venthyr Sinstone cloak transmog.
|tip This may take some time to complete depending on how buggy it is.
|tip You can also just AFK here and wait for someone else to eventually trigger it.
step
Appease the Void Altar |q 84810 |goto Northern Stranglethorn/0 78.11,46.31 |future
|tip A void pet such as Lesser Voicaller, Voidwiggler, Sir Shady Mrrgglthon Junior, etc., a Shadowy Disguise or Void Totem toy, and any Cloak of the Black Void transmog appearance.
|tip This may take some time to complete depending on how buggy it is.
|tip You can also just AFK here and wait for someone else to eventually trigger it.
step
click Chest of Aquisition
Loot the Ancient Shaman Blood |q 84811 |goto Northern Stranglethorn/0 78.15,47.72 |future
step
Learn the {o}Fledgling Warden Owl{} Pet |learnpet Fledgling Warden Owl##1716
|tip Purchase it from Marin Bladewing at Revered with The Wardens or purchase it from the auction house.
step
Summon a Fledgling Warden Owl Pet |complete activepet(1716) or completedq(84916)
step
'|mapmarker Azsuna/0 44.18,72.41
'|mapmarker Azsuna/0 40.54,73.15
'|mapmarker Azsuna/0 40.52,75.19
'|mapmarker Azsuna/0 37.10,82.16
'|mapmarker Azsuna/0 43.24,85.30
'|mapmarker Azsuna/0 43.66,87.51
'|mapmarker Azsuna/0 50.45,91.67
'|mapmarker Azsuna/0 47.48,84.74
'|mapmarker Azsuna/0 45.97,84.06
Buff your Fledgling Warden Owl pet
|tip Open your map and fly to the 9 locations marked.
|tip Each location has an Owl of the Watchers statue.
|tip At any given time, 3 statues are active.
|tip Clicking an active statue creates an aura around the immediate area.
|tip With your Fledgling Warden Owl pet summoned, wait around the buff statues until it flies 3 circles, then a magnifying glass appears above your head.
|tip May need to move around a bit and repeat this several times to trigger it properly.
|tip You MUST see the magnifying glass above your character to get credit for that buff.
|tip You need to do this 4 times, one for each buff possible.
|tip When you complete all 4 buffs, your warden pet will have a permanent white smokey area above its head.
|tip The buffs are Focused Senses (red), Suppression (purple), Stasis Field (green), and Augmented Armor (blue).
|tip When your pet has the white animation over its head, you may continue to the next step.
confirm |goto Azsuna/0 45.97,84.06 |q 84916 |future
step
Summon your Buffed Fledgling Warden Owl Pet |complete activepet(1716) or completedq(84916) |goto Vault of the Wardens 2/1 19.48,77.57
|tip Clear the entire dungeon.
|tip Pick up Elune's Light from Cordana Felsong's area and carry it back to the room just before Tirathon.
|tip A room to the right will be open now.
|tip Summon your pet.
|tip You must do this while carrying Elune's Light.
|tip A Sentry Statue will appear in the middle of the room.
step
click Sentry Statue
collect Sentry Statue##229046 |goto Vault of the Wardens 2/1 19.48,77.57 |q 84916 |future
step
use the Sentry Statue##229046
|tip Drop it on the platform before the stairs in Glazer's room.
Summon the Sentry Statue |q 84916 |goto Vault of the Wardens 2/2 60.67,48.25 |future
step
click Sentry Statue
Select _"Prepare the start up sequence."_ |gossip 45785
Click Here to Show A 5x5 Puzzle Solver |popuptext ham.io/watcher-solver/
|tip You must pick an orientation to face in the room, and then map all 25 tiles in the puzzle solver based on the orientation.
|tip For example, determine which tile will be your number 1 and always keep in mind where this spot is in relation to where you are facing.
|tip Once you have the tiles mapped, the solver will tell you which statues to click.
|tip If you need to reset, talk to the statue again.
|tip Resetting will cause the statue mapping to reset as well and you will need to remap them all again.
|tip When no statues remain, a chest will spawn in front of the Sentry Statue.
click Treasure of the Wardens
Loot the Warden's Mirror |q 84823 |goto Vault of the Wardens 2/2 60.67,48.25 |future
step
use the Torch of Pyrreth##208092
|tip Your torch must be active to see the portal.
Enter the Karazhan Catacombs |scenariostart Ratts' Revenge##2635 |goto Deadwind Pass/0 46.24,69.07 |q 84829 |future
step
click Enigma Machine
Select _"<Fill the arcane catalyzer with ancient shaman blood.>"_ |gossip 124348
Add the Ancient Shaman Blood |q 84829 |goto Deadwind Pass/27 59.93,42.59 |future
step
click Enigma Machine
Select _"<Insert the Warden's Mirror into the lightbox.>"_ |gossip 124347
Add the Warden's Mirror |q 84830 |goto Deadwind Pass/27 59.93,42.59 |future
step
click Enigma Machine
Select _"<Pull the "BEGIN" lever.>"_ |gossip 124349 |noautogossip
|tip Choose this first and you will see a message about dungeon mechanisms resetting.
Select _"<Pull the "SUBMIT" lever.>"_ |gossip 124350 |noautogossip
confirm |goto Deadwind Pass/27 59.93,42.59 |q 84837 |future
step
kill Catacombs Rat##230599
clicknpc Rat##230596
|tip Run through the entire catacombs and count the number of Rat mobs.
|tip Do not include Catacombs Rats in your count.
|tip Kill every rat you encounter so they don't respawn and randomly trip pressure plates.
|tip To enter the room with the green Humming Crystal, target the purple one inside the room on the right side and use your Relic of Crystal Connections.
|tip To leave the room, target the green crystal outside and use it again.
Click to View |image text,IncognitroPressurePlates,512,1024,512,1024
|tip After your count, look at the image and move statues or players onto the correct pressure plate for the current lock number.
|tip You only need to trigger 3 pressure plates total, not 3 sets of 3.
|tip Once ONLY the correct pressure plate has statues of the correct number, submit at the enigma machine.
|tip Do this 3 times to finish.
click Enigma Machine
Select _"<Pull the "SUBMIT" lever.>"_ |gossip 124350 |noautogossip
|tip Each time you correctly choose, a magnifying glass will appear over your head.
Solve the Enigma Puzzle |q 84837 |goto Deadwind Pass/27 59.93,42.59 |future
step
Enter the cave |goto Azj-Kahet/0 55.11,19.21 < 10 |walk
Jump into the hole |goto Azj-Kahet/0 56.34,17.46 < 2 |walk
|tip Jump up onto the wall and into the hidden hole.
|tip It's in the folds of the landscape and very difficult to see.
use the Starry-Eyed Goggles##228966
|tip Look up above you.
Reveal the Hidden Platform |complete hasbuff(463749) or completedq(84854) |goto Azj-Kahet/0 56.22,17.99
step
clicknpc Humming Crystal##230383
use the Relic of Crystal Connections##228996
|tip Use it on the Humming Crystal to pull yourself up.
click Decryption Console
|tip Enter the sequence {o}84847078{} and then {o}Submit{} on your action bar.
|tip If you do not see the buttons on your action bar, look for them in the {o}General{} tab of of your spellbook.
|tip The {o}Number Sequences{} button located there will contain the buttons you need.
click Encrypted Chest
|tip Open the chest after entering the number sequence.
Loot the Chest |q 84854 |goto Azj-Kahet/0 56.16,17.97 |future
step
use the Keys to Incognitro, the Indecipherable Felcycle##229348
learnmount Incognitro, the Indecipherable Felcycle##428013
step
More Puzzle Solutions Coming Soon |complete false
|tip More puzzles in this story are likely to come at a later date.
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\The War Within (70-80)\\Revisited Horrific Vision of Orgrimmar",{
description="This guide will assist you in completing \"Horrific Visions Revisited\" questline.",
startlevel=80,
patch='110105',
},[[
step
talk Researcher Onermu##238129
|tip Inside the building.
accept Seeking Knowledge of the Past##86706 |goto Dornogal/0 42.50,28.37
step
talk Soridormi##236382
turnin Seeking Knowledge of the Past##86706 |goto Dornogal/0 34.69,68.74
accept Truly Horrific to Behold##87328 |goto Dornogal/0 34.69,68.74
step
talk Soridormi##236382
Select _"I am ready!"_ |gossip 132133
Speak to Soridormi |q 87328/1 |goto Dornogal/0 34.69,68.74
step
Collect #10# Horrific Sands of Time |q 87328/2 |goto Dornogal/0 34.54,69.84
|tip Stand in the gold swirling areas to collect the sand.
step
talk Soridormi##236382
turnin Truly Horrific to Behold##87328 |goto Dornogal/0 34.54,68.70
accept Into the Darkest Memories##87329 |goto Dornogal/0 34.54,68.70
step
label "Begin_Vision"
click Portal to Horrific Visions##238254
Select _"(Scenario) Send me to the Horrific Vision of Orgrimmar."_ |gossip 132129
Enter the Horrific Vision |scenariostart Vision of Orgrimmar##2951 |goto Dornogal/0 34.67,68.33
|tip Accept the queue that pops up.
stickystart "Scenario_Information"
step
clicknpc Altar of the Pained##234121
turnin Faceless Mask of the Pained##86154 |goto Orgrimmar Vision/0 51.47,84.72
|only if readyq(86154)
step
clicknpc Altar of the Burned Bridge##234118
turnin Faceless Mask of the Burned Bridge##86151 |goto Orgrimmar Vision/0 51.15,83.00
|only if readyq(86151)
step
clicknpc Altar of the Daredevil##234119
turnin Faceless Mask of the Daredevil##86152 |goto Orgrimmar Vision/0 52.93,82.94
|only if readyq(86152)
step
clicknpc Altar of the Dark Imagination##234117
turnin Faceless Mask of the Dark Imagination##86153 |goto Orgrimmar Vision/0 52.62,84.73
|only if readyq(86153)
step
clicknpc Altar of the Long Night##234120
turnin Faceless Mask of the Long Night##86155 |goto Orgrimmar Vision/0 52.04,82.10
|only if readyq(86155)
step
talk Bronze Hourglass##238337
accept Timely Assistance##88803 |goto Vision of Orgrimmar/0 52.00,82.81
|only if completedq(87336) and not completedq(88803)
step
click Bronze Hourglass##238337
talk Bronze Hourglass##238337
|tip Choose healing, damage, or tanking assistance based on your preference.
Use the Hourglass to Summon Aid |q 88803/1 |goto Vision of Orgrimmar/0 52.00,82.81
|only if completedq(87336) and not completedq(88803)
step
talk Bronze Hourglass##238337
turnin Timely Assistance##88803 |goto Vision of Orgrimmar/0 52.00,82.81
|only if completedq(87336) and not completedq(88803)
step
talk Image of Wrathion##155604
Select _"I am ready to enter the vision."_ |gossip 125259
Speak with the Image of Wrathion |scenariogoal 1/103871 |goto Vision of Orgrimmar/0 51.99,83.58
stickystop "Scenario_Information"
step
Follow the path |goto Vision of Orgrimmar/0 50.37,80.85 < 20 |only if walking
Run up the ramp |goto Vision of Orgrimmar/0 44.55,75.13 < 10 |only if walking
click Vision Barrier |goto Vision of Orgrimmar/0 43.05,70.42
accept Valley of Spirits##85951 |goto Vision of Orgrimmar/0 43.60,73.13 |or
|tip You will accept this quest automatically.
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
|scenarioend |next "Begin_Vision" |or
step
Kill enemies around this area
Assist Zekhan |q 85951/1 |goto Vision of Orgrimmar/0 41.88,69.68 |or
|tip Click the Vision Barrier to pass.
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
|scenarioend |next "Begin_Vision" |or
step
kill Decimator Shiq'voth##153943
Enter the tunnel |goto Vision of Orgrimmar/0 39.71,64.45 < 10 |walk
Enter the Valley of Spirits |q 85951/2 |goto Vision of Orgrimmar/0 37.08,64.69 |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
|scenarioend |next "Begin_Vision" |or
step
clicknpc Conversion Totem##153881
Free Zor Lonetree |q 85951/3 |goto Vision of Orgrimmar/0 34.50,65.19 |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
|scenarioend |next "Begin_Vision" |or
step
clicknpc Conversion Totem##153881
Free Witch Doctor Umbu |q 85951/4 |goto Vision of Orgrimmar/0 33.98,68.27 |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
|scenarioend |next "Begin_Vision" |or
step
clicknpc Conversion Totem##153881
Free Terga Earthbreaker |q 85951/5 |goto Vision of Orgrimmar/0 37.04,74.86 |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
|scenarioend |next "Begin_Vision" |or
step
clicknpc Conversion Totem##153881
Free Sian'tsu |q 85951/6 |goto Vision of Orgrimmar/0 36.18,77.69 |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
|scenarioend |next "Begin_Vision" |or
step
kill Oblivion Elemental##153244 |q 85951/7 |goto Vision of Orgrimmar/0 39.98,78.53 |or
|tip Avoid the waves of shadow that wash over the area.
|tip Run to the gold orb when you get silenced.
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|complete completedq(85951) |or
'|scenarioend |next "Begin_Vision" |or
step
Follow the path |goto Vision of Orgrimmar/0 42.06,75.83 < 20 |only if walking
Continue following the path |goto Vision of Orgrimmar/0 40.46,64.36 < 20 |only if walking
|tip Click the Vision Barrier to pass.
accept Valley of Wisdom##85952 |goto Vision of Orgrimmar/0 42.23,56.31 |or
|tip You will accept this quest automatically.
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
Kill enemies around this area
Defeat Enemies in the Valley of Wisdom |q 85952/1 |goto Vision of Orgrimmar/0 45.73,48.84 |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
kill Vez'okk the Lightless##152874 |q 85952/2 |goto Vision of Orgrimmar/0 44.36,48.80 |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|complete completedq(85952) |or
'|scenarioend |next "Begin_Vision" |or
step
click Gusting Winds Totem |goto Vision of Orgrimmar/0 43.90,47.69
Return to the Entrance |goto Vision of Orgrimmar/0 50.47,85.50 < 100 |c |noway |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
Follow the path up |goto Vision of Orgrimmar/0 52.03,75.35 < 20 |only if walking
Continue following the path |goto Vision of Orgrimmar/0 51.16,66.13 < 20 |only if walking
|tip Click the Vision Barrier to pass.
accept The Drag##85953 |goto Vision of Orgrimmar/0 53.78,64.18 |or
|tip You will accept this quest automatically.
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
kill Annihilator Lak'hal##153942 |q 85953/1 |goto Vision of Orgrimmar/0 55.13,65.11 |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
talk Garona Halforcen##152993
Select _"You have my aid. <Help Garona up>"_ |gossip 49742
Speak with Garona |q 85953/2 |goto Vision of Orgrimmar/0 54.88,64.90 |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Barricade
talk Gotri##155486
Choose _<Check pulse>_
Check Gotri's Traveling Gear |q 85953/3 |goto Vision of Orgrimmar/0 57.88,61.72 |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Barricade
kill Snang##153022
|tip Inside the building.
Check Magar's Cloth Goods |q 85953/4 |goto Vision of Orgrimmar/0 59.49,59.02 |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Barricade
Check Orgrimmar Orphanage |q 85953/5 |goto Vision of Orgrimmar/0 57.83,58.09 |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Barricade
Check Nogg's Machine Shop |q 85953/6 |goto Vision of Orgrimmar/0 57.38,56.10 |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Barricade
Check Kodohide Leatherworkers |q 85953/7 |goto Vision of Orgrimmar/0 60.15,55.25 |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
kill Inquisitor Gnshal##234035 |q 85953/8 |goto Vision of Orgrimmar/0 56.91,51.28 |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|complete completedq(85953) |or
'|scenarioend |next "Begin_Vision" |or
step
Enter the tunnel |goto Vision of Orgrimmar/0 60.54,49.70 < 15 |only if walking
|tip Click the Vision Barrier to pass.
accept Valley of Honor##85950 |goto Vision of Orgrimmar/0 62.12,48.22 |or
|tip You will accept this quest automatically.
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
Follow the path |goto Vision of Orgrimmar/0 63.60,50.91 < 15 |only if walking
Cross the bridge |goto Vision of Orgrimmar/0 67.48,44.42 < 15 |only if walking
Follow the path up |goto Vision of Orgrimmar/0 69.10,34.49 < 15 |only if walking
kill Rexxar##155098 |q 85950/1 |goto Vision of Orgrimmar/0 63.18,33.06 |or
|tip Inside the building. |or
'|goto Vision of Orgrimmar/0 49.90,75.66 < 15 |c |next "Kill_Thrall" |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
'|complete completedq(85950) |or
'|scenarioend |next "Begin_Vision" |or
step
click Gusting Winds Totem |goto Vision of Orgrimmar/0 67.63,33.00
Return to the Entrance |goto Vision of Orgrimmar/0 50.47,85.50 < 100 |c |noway |or
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |next "Collect_Rewards" |or
step
label "Kill_Thrall"
Enter the building |goto Vision of Orgrimmar/0 49.90,75.66 < 7 |walk
|tip Kill the Voidbound Honor Guard to pass.
kill Thrall##152089 |scenariogoal 2/44866 |goto Vision of Orgrimmar/0 48.40,71.47 |or
|tip Inside the building.
|tip Run to the gold orb when you get silenced.
|tip Don't stand in front of Thrall when he casts "Seismic Slam."
'|goto Vision of Orgrimmar/0 48.54,57.90 < 30 |c |or
stickystart "Scenario_Information"
step
label "Collect_Rewards"
Collect Your Rewards and Exit the Vision |scenarioend |goto Vision of Orgrimmar/0 48.46,58.91
|tip Loot the Corrupted Chests and click the Tenebrous Gateway to leave the vision.
step
talk Soridormi##236382
turnin Into the Darkest Memories##87329 |goto Dornogal/0 34.55,68.72
|only if readyq(87329)
step
talk Soridormi##236382
accept A Collection of Variables##87332 |goto Dornogal/0 34.55,68.72
|only if completedq(87329) and (not haveq(87332) and not completedq(87332))
step
talk Augermu##238136
turnin A Collection of Variables##87332 |goto Dornogal/0 35.22,68.58
|only if readyq(87332)
step
talk Soridormi##236382
accept Echoing Lessons##87335 |goto Dornogal/0 35.22,68.58
|only if completedq(87332) and (not haveq(87335) and not completedq(87335))
step
talk Augermu##238136
Select _"Obtain Echo of N'Zoth [20 Displaced Corrupted Mementos]"_ |gossip 132107
Create an Echo of N'Zoth |q 87335/1 |goto Dornogal/0 35.22,68.58
|only if haveq(87335)
step
click Hourglass of Horrific Visions##238168
Select _"Show Visions Upgrades."_ |gossip 132100
Unlock the Orb Operation Manual |q 87335/2 |goto Dornogal/0 35.08,68.34
|tip Select the top point, {o}Orb Operation Manual{}.
|only if haveq(87335)
step
talk Augermu##238136
turnin Echoing Lessons##87335 |goto Dornogal/0 35.23,68.56
|only if readyq(87335)
step
talk Augermu##238136
accept Remembering Again and Again##87336 |goto Dornogal/0 35.23,68.56
|only if completedq(87335) and (not haveq(87336) and not completedq(87336))
step
talk Soridormi##236382
turnin Remembering Again and Again##87336 |goto Dornogal/0 34.55,68.71
|only if readyq(87336)
step
talk Augermu##238136
accept Borrowing Corruption##90719 |goto Dornogal/0 35.22,68.56
|only if completedq(87336) and (not haveq(90719) and not completedq(90719))
step
talk Augermu##238136
turnin Borrowing Corruption##90719 |goto Dornogal/0 35.22,68.56
|only if readyq(90719)
step
talk Augermu##238136
accept Enhancing Corruption##90731 |goto Dornogal/0 35.22,68.56
|only if completedq(90719) and (not haveq(90731) and not completedq(90731))
step
talk Augermu##238136
turnin Enhancing Corruption##90731 |goto Dornogal/0 35.22,68.56
|only if readyq(90731)
step
label "Scenario_Information"
Your sanity meter serves as the scenario timer
|tip Mob and boss special abilities and ground effects will reduce your sanity.
|tip You will gain sanity for killing certain special mobs for objectives.
|tip The "Sanity Restoration Orb" will restore a full sanity bar upon use if you have unlocked it.
|tip At any time you can click a "Gusting Winds Totem" to complete the final objective.
|tip Totems are opened after completing each bonus objective.
|tip You can also enter the final objective chamber to load that portion of the guide.
|tip The final objective is to kill Thrall in Grommash Hold near the starting area.
|scenarioend |next "Begin_Vision"
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\The War Within (70-80)\\Revisited Horrific Vision of Stormwind",{
description="This guide will assist you in completing \"Horrific Visions Revisited\" questline.",
startlevel=80,
patch='110105',
},[[
step
talk Researcher Onermu##238129
|tip Inside the building.
accept Seeking Knowledge of the Past##86706 |goto Dornogal/0 42.50,28.37
step
talk Soridormi##236382
turnin Seeking Knowledge of the Past##86706 |goto Dornogal/0 34.69,68.74
accept Truly Horrific to Behold##87328 |goto Dornogal/0 34.69,68.74
step
talk Soridormi##236382
Select _"I am ready!"_ |gossip 132133
Speak to Soridormi |q 87328/1 |goto Dornogal/0 34.69,68.74
step
Collect #10# Horrific Sands of Time |q 87328/2 |goto Dornogal/0 34.54,69.84
|tip Stand in the gold swirling areas to collect the sand.
step
talk Soridormi##236382
turnin Truly Horrific to Behold##87328 |goto Dornogal/0 34.54,68.70
accept Into the Darkest Memories##87329 |goto Dornogal/0 34.54,68.70
step
label "Begin_Vision"
click Portal to Horrific Visions##238254
Select _"(Scenario) Send me to the Horrific Vision of Stormwind."_ |gossip 132128
Enter the Horrific Vision |scenariostart Vision of Stormwind##2950 |goto Dornogal/0 34.67,68.33
|tip Accept the queue that pops up.
stickystart "Scenario_Information"
step
clicknpc Altar of the Pained##234121
turnin Faceless Mask of the Pained##86154 |goto Vision of Stormwind/0 52.73,52.41
|only if readyq(86154)
step
clicknpc Altar of the Burned Bridge##234118
turnin Faceless Mask of the Burned Bridge##86151 |goto Vision of Stormwind/0 52.35,50.71
|only if readyq(86151)
step
clicknpc Altar of the Daredevil##234119
turnin Faceless Mask of the Daredevil##86152 |goto Vision of Stormwind/0 54.18,50.70
|only if readyq(86152)
step
clicknpc Altar of the Dark Imagination##234117
turnin Faceless Mask of the Dark Imagination##86153 |goto Vision of Stormwind/0 53.82,52.40
|only if readyq(86153)
step
clicknpc Altar of the Long Night##234120
turnin Faceless Mask of the Long Night##86155 |goto Vision of Stormwind/0 53.26,49.70
|only if readyq(86155)
step
talk Image of Wrathion##155604
Select _"I am ready to enter the vision."_
Speak with the Image of Wrathion |scenariogoal 1/44998 |goto Vision of Stormwind/0 53.28,51.18
stickystop "Scenario_Information"
step
Follow the path |goto Vision of Stormwind/0 53.04,55.48 < 20 |only if walking
Enter the tunnel |goto Vision of Stormwind/0 58.37,51.30 < 10 |only if walking
Cross the bridge |goto Vision of Stormwind/0 59.78,46.34 < 10 |only if walking
click Vision Barrier |goto Vision of Stormwind/0 59.70,40.71 < 7 |only if walking
accept Dwarven District##85829 |goto Vision of Stormwind/0 61.53,43.93 |or
|tip You will accept this quest automatically.
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
Kill the three Gnomes
Defeat the Brainwashed Gnomes |q 85829/1 |goto Vision of Stormwind/0 61.53,43.65 |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
Follow the path |goto Vision of Stormwind/0 59.52,40.95 < 10 |only if walking
|tip Click the Vision Barrier to pass.
click Bomb Location
Place the Explosives |q 85829/2 |goto Vision of Stormwind/0 61.61,38.44 |count 1 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Bomb Location
Place the Explosives |q 85829/2 |goto Vision of Stormwind/0 61.15,33.43 |count 2 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Bomb Location
Place the Explosives |q 85829/2 |goto Vision of Stormwind/0 61.70,30.65 |count 3 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Bomb Location
Place the Explosives |q 85829/2 |goto Vision of Stormwind/0 64.12,31.33 |count 4 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Bomb Location
Place the Explosives |q 85829/2 |goto Vision of Stormwind/0 65.88,33.92 |count 5 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Bomb Location
Place the Explosives |q 85829/2 |goto Vision of Stormwind/0 62.74,35.57 |count 6 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Bomb Location
Place the Explosives |q 85829/2 |goto Vision of Stormwind/0 63.31,37.87 |count 7 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Bomb Location
Place the Explosives |q 85829/2 |goto Vision of Stormwind/0 66.36,38.38 |count 8 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Detonator
Detonate the Explosives |q 85829/3 |goto Vision of Stormwind/0 65.71,39.56 |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
kill Therum Deepforge##156577 |q 85829/4 |goto Vision of Stormwind/0 67.30,42.92 |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|complete completedq(85829) |or
'|scenarioend |next "Begin_Vision" |or
step
Cross the bridge |goto Vision of Stormwind/0 68.03,50.58 < 15 |only if walking
accept Old Town##85832 |goto Vision of Stormwind/0 70.07,53.16 |or
|tip You will accept this quest automatically.
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
Watch the dialogue
Rendezvous with Valeera |q 85832/1 |goto Vision of Stormwind/0 70.07,53.16 |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
Enter the tunnel |goto Vision of Stormwind/0 70.07,53.16 < 15 |only if walking
|tip Click the Vision Barrier to pass.
kill Armsmaster Terenson##156949
Obtain Terenson's Key |q 85832/2 |goto Vision of Stormwind/0 70.48,58.43 |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
Follow the path |goto Vision of Stormwind/0 72.84,55.12 < 20 |only if walking
Continue following the path |goto Vision of Stormwind/0 76.37,59.39 < 20 |walk
kill Alx'kov the Infested##152809
Obtain Alx'kov's Key |q 85832/3 |goto Vision of Stormwind/0 75.76,63.52 |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Security Monolith
Bypass Shaw's Security |q 85832/4 |goto Vision of Stormwind/0 76.64,66.05 |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
kill Overlord Mathias Shaw##158157 |q 85832/5 |goto Vision of Stormwind/0 79.47,66.42 |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|complete completedq(85832) |or
'|scenarioend |next "Begin_Vision" |or
step
Run down the stairs |goto Vision of Stormwind/0 76.52,64.96 < 10 |only if walking
|tip Click the Gate to pass.
Enter the tunnel |goto Vision of Stormwind/0 71.67,60.39 < 10 |only if walking
Cross the bridge |goto Vision of Stormwind/0 69.09,62.18 < 10 |only if walking
accept Trade District##85830 |goto Vision of Stormwind/0 65.41,65.01 |or
|tip You will accept this quest automatically.
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
Enter the tunnel |goto Vision of Stormwind/0 65.89,64.22 < 10 |only if walking
|tip Click the Vision Barrier to pass.
kill Inquisitor Darkspeak##158136 |q 85830/1 |goto Vision of Stormwind/0 67.56,72.51 |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
Follow the path |goto Vision of Stormwind/0 64.50,70.11 < 10 |only if walking
kill Slavemaster Ul'rok##153541 |q 85830/2 |goto Vision of Stormwind/0 65.41,75.81 |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Prison Cage
Rescue the Captive |q 85830/3 |goto Vision of Stormwind/0 66.04,75.73 |count 1 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Prison Cage
Rescue the Captive |q 85830/3 |goto Vision of Stormwind/0 65.49,76.84 |count 2 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Prison Cage
Rescue the Captive |q 85830/3 |goto Vision of Stormwind/0 63.62,74.31 |count 3 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Prison Cage
Rescue the Captive |q 85830/3 |goto Vision of Stormwind/0 63.02,71.27 |count 4 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Prison Cage
Rescue the Captive |q 85830/3 |goto Vision of Stormwind/0 62.13,69.05 |count 5 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Prison Cage
Rescue the Captive |q 85830/3 |goto Vision of Stormwind/0 61.92,75.89 |count 6 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Prison Cage
Rescue the Captive |q 85830/3 |goto Vision of Stormwind/0 59.50,68.89 |count 7 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
click Prison Cage
Rescue the Captive |q 85830/3 |goto Vision of Stormwind/0 61.36,66.92 |count 8 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|complete completedq(85830) |or
'|scenarioend |next "Begin_Vision" |or
step
Enter the tunnel |goto Vision of Stormwind/0 59.88,71.73 < 10 |only if walking
Cross the bridge |goto Vision of Stormwind/0 57.32,73.60 < 10 |only if walking
accept Mage Quarter##85831 |goto Vision of Stormwind/0 55.58,76.55 |or
|tip You will accept this quest automatically.
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
Enter the tunnel |goto Vision of Stormwind/0 55.58,76.55 < 10 |only if walking
|tip Click the Vision Barrier to pass.
Follow the path |goto Vision of Stormwind/0 53.62,78.88 < 10 |only if walking
Continue following the path |goto Vision of Stormwind/0 50.33,78.57 < 10 |only if walking
Continue following the path |goto Vision of Stormwind/0 45.77,78.37 < 10 |only if walking
kill Portal Keeper##159275
Close the Void Portal |q 85831/1 |goto Vision of Stormwind/0 47.11,80.53 |count 1 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
Follow the path |goto Vision of Stormwind/0 45.61,78.51 < 10 |only if walking
kill Zardeth of the Black Claw##158371
Close the Void Portal |q 85831/1 |goto Vision of Stormwind/0 43.67,80.58 |count 2 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
Follow the path down |goto Vision of Stormwind/0 43.88,84.92 < 10 |only if walking
kill Portal Keeper##159275+
Close the Void Portal |q 85831/1 |goto Vision of Stormwind/0 47.82,87.54 |count 3 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
kill Portal Master##159266
Close the Void Portal |q 85831/1 |goto Vision of Stormwind/0 51.25,88.54 |count 4 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
Enter the building |goto Vision of Stormwind/0 51.84,84.49 < 10 |walk
Leave the building |goto Vision of Stormwind/0 52.65,83.48 < 10 |walk
kill Portal Master##159266
Close the Void Portal |q 85831/1 |goto Vision of Stormwind/0 52.48,80.78 |count 5 hidden |or
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|scenarioend |next "Begin_Vision" |or
step
Enter the building |goto Vision of Stormwind/0 52.78,83.31 < 10 |walk
Leave the building |goto Vision of Stormwind/0 51.77,84.58 < 10 |walk
Run up the ramp |goto Vision of Stormwind/0 49.99,87.62 < 10 |only if walking
kill Magister Umbric##158035 |q 85831/2 |goto Vision of Stormwind/0 48.90,87.82 |or
|tip Inside the Mage Tower beyond the portal.
'|goto Vision of Stormwind/0 53.13,51.35 < 20 |c |next "KIll_Alleria_Windrunner" |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
'|complete completedq(85831) |or
'|scenarioend |next "Begin_Vision" |or
step
click Portal to Cathedral District |goto Vision of Stormwind/0 49.97,85.93
|tip Inside the Mage Tower.
Teleport to the Cathedral District |goto Vision of Stormwind/0 54.52,54.18 < 100 |c |noway |or
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
step
label "KIll_Alleria_Windrunner"
Enter the building |goto Vision of Stormwind/0 52.95,51.01 < 10 |walk
|tip Kill the Fallen Riftwalkers.
kill Alleria Windrunner##152718 |scenariogoal 2/46474 |goto Vision of Stormwind/0 50.07,45.67 |or
|tip Inside the building.
'|goto Vision of Stormwind/0 53.16,50.35 < 3 |c |next "Collect_Rewards" |or
stickystart "Scenario_Information"
step
label "Collect_Rewards"
Collect Your Rewards and Exit the Vision |scenarioend |goto Vision of Stormwind/0 41.58,34.48
|tip Loot the Corrupted Chests and click the Tenebrous Gateway to leave the vision.
step
talk Soridormi##236382
turnin Into the Darkest Memories##87329 |goto Dornogal/0 34.55,68.72
|only if readyq(87329)
step
talk Soridormi##236382
accept A Collection of Variables##87332 |goto Dornogal/0 34.55,68.72
|only if completedq(87329) and (not haveq(87332) and not completedq(87332))
step
talk Augermu##238136
turnin A Collection of Variables##87332 |goto Dornogal/0 35.22,68.58
|only if readyq(87332)
step
talk Soridormi##236382
accept Echoing Lessons##87335 |goto Dornogal/0 35.22,68.58
|only if completedq(87332) and (not haveq(87335) and not completedq(87335))
step
talk Augermu##238136
Select _"Obtain Echo of N'Zoth [20 Displaced Corrupted Mementos]"_ |gossip 132107
Create an Echo of N'Zoth |q 87335/1 |goto Dornogal/0 35.22,68.58
|only if haveq(87335)
step
click Hourglass of Horrific Visions##238168
Select _"Show Visions Upgrades."_ |gossip 132100
Unlock the Orb Operation Manual |q 87335/2 |goto Dornogal/0 35.08,68.34
|tip Select the top point, {o}Orb Operation Manual{}.
|only if haveq(87335)
step
talk Augermu##238136
turnin Echoing Lessons##87335 |goto Dornogal/0 35.23,68.56
|only if readyq(87335)
step
talk Augermu##238136
accept Remembering Again and Again##87336 |goto Dornogal/0 35.23,68.56
|only if completedq(87335) and (not haveq(87336) and not completedq(87336))
step
talk Soridormi##236382
turnin Remembering Again and Again##87336 |goto Dornogal/0 34.55,68.71
|only if readyq(87336)
step
talk Augermu##238136
accept Borrowing Corruption##90719 |goto Dornogal/0 35.22,68.56
|only if completedq(87336) and (not haveq(90719) and not completedq(90719))
step
talk Augermu##238136
turnin Borrowing Corruption##90719 |goto Dornogal/0 35.22,68.56
|only if readyq(90719)
step
talk Augermu##238136
accept Enhancing Corruption##90731 |goto Dornogal/0 35.22,68.56
|only if completedq(90719) and (not haveq(90731) and not completedq(90731))
step
talk Augermu##238136
turnin Enhancing Corruption##90731 |goto Dornogal/0 35.22,68.56
|only if readyq(90731)
step
label "Scenario_Information"
Your sanity meter serves as the scenario timer
|tip Mob and boss special abilities and ground effects will reduce your sanity.
|tip You will gain sanity for killing certain special mobs for objectives.
|tip The "Sanity Restoration Orb" will restore a full sanity bar upon use if you have unlocked it.
|tip At any time you can click a "Portal to Cathedral District" to complete the final objective.
|tip Portals are opened after completing each bonus objective.
|tip You can also enter the final objective chamber to load that portion of the guide.
|tip The final objective is to kill Alleria in the Stormwind Cathedral near the starting area.
|scenarioend |next "Begin_Vision"
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\The War Within (70-80)\\Nightfall",{
description="This guide will assist you in completing the \"Nightfall\" scenario content.",
startlevel=80,
patch='110105',
},[[
step
accept A Radiant Call##85005 |goto Dornogal/0 44.61,32.54
|tip You should accept this quest automatically.
|tip If not, you can find it in your Adventure Guide under {o}Nightfall{}.
step
talk Mylton Wyldbraun##234774
turnin A Radiant Call##85005 |goto Hallowfall/0 28.26,56.11
step
label "Begin_Nightfall_Scenario"
Begin the {o}Nightfall{} Scenario |scenariostart |goto Hallowfall/0 28.20,56.23
|tip The scenario begins at the start of every hour and lasts for 10 minutes.
step
Wait to Begin the Counter Attack |scenariostage 1 |goto Hallowfall/0 28.10,56.27
|only if scenariostage(1)
step
Wait to Begin the Counter Attack |scenariogoal 2/69914 |goto Hallowfall/0 28.10,56.27
|only if scenariostage(2)
step
Fallback to the Rallying Point |scenariogoal 3/70842 |goto Hallowfall/0 27.19,56.68
|tip Within the first ~10 seconds of the next stage, you can use one of the abilities on your bar for a buff.
|only if scenariostage(3)
step
Prepare to Charge |scenariogoal 4/70841
|only if scenariostage(4)
step
kill Sureki Raider##232161, Sureki Jawcrawler##232160, Sureki Marauder##232087, Sureki Swarmite##232086, Sureki Needler##232097, Sureki Spiderling##232091, Sureki Weavelasher##232088
Push Back the Sureki |scenariogoal 5/70843 |goto Hallowfall/0 26.06,55.85
|only if scenariostage(5)
step
kill Azj-Tak the Behemoth##234440
kill Ahn'tak##240968
kill Anub'Ranax##240969
|tip The champion that appears is random.
|tip Avoid Standing in front of it during Poison Breath
|tip Avoid green or brown areas on the ground.
Slay the Sureki Champion |scenariogoal 6/69949 |goto Hallowfall/0 24.91,55.19
|only if scenariostage(6)
step
Discharge in the War |scenariostage 7 |goto Hallowfall/0 28.43,56.31
|tip The scenario is now complete and will end when the timer expires.
|only if scenariostage(7)
step
kill Sureki Weavelasher##232088, Sureki Venomblade##232164, Sureki Swarmite##232086, Sureki Marauder##232087, Sureki Undercrawler##232170, Sureki Spiderling##232091
Clear the Sureki from the Southern Front |scenariogoal 8/0 |goto Hallowfall/0 27.36,59.16
|only if scenariostage(8)
step
kill Sureki Jawcrawler##232160, Sureki Swarmer##232158, Sureki Burrower##232096, Sureki Raider##232161, Sureki Acolyte##232094, Sureki Needler##232097
Clear the Sureki from the Central Front |scenariogoal 9/0 |goto Hallowfall/0 26.60,55.15
|only if scenariostage(9)
step
kill Sureki Eradicator##232163, Sureki Swarmer##232093, Sureki Needler##232097, Sureki Undercrawler##235379, Sureki Acolyte##232094, Sureki Swarmite##232156
Clear the Sureki from the Northern Front |scenariogoal 10/0 |goto Hallowfall/0 26.98,52.07
|only if scenariostage(10)
step
kill Scutix the Serrated##235557 |scenariogoal 11/71743 |goto Hallowfall/0 27.47,59.37
|only if scenariostage(11)
step
kill Tarset the Fanged##235592 |scenariogoal 12/71766 |goto Hallowfall/0 24.58,57.17
|only if scenariostage(12)
step
kill Apot'kan the Claw##235595 |scenariogoal 13/71767 |goto Hallowfall/0 25.27,53.52
|only if scenariostage(13)
step
kill Bul'kan the Gorger##235799 |scenariogoal 14/71772 |goto Hallowfall/0 27.84,56.55
|only if scenariostage(14)
step
kill Wrakin the Colossus##235800 |scenariogoal 15/71773 |goto Hallowfall/0 26.67,54.73
|only if scenariostage(15)
step
kill Alatear##235801 |scenariogoal 16/69914 |goto Hallowfall/0 26.98,51.13
|only if scenariostage(16)
stickystart "Kill_Ette"
stickystart "Kill_Det"
step
kill Kilf##237363 |scenariogoal 17/102778 |goto Hallowfall/0 27.34,53.50
|tip They walk around this area.
|only if scenariostage(17)
step
label "Kill_Ette"
kill Ette##237362 |scenariogoal 17/102777 |goto Hallowfall/0 27.34,53.50
|tip They walk around this area. |notinsticky
|only if scenariostage(17)
step
label "Kill_Det"
kill Det##237364 |scenariogoal 17/102776 |goto Hallowfall/0 27.34,53.50
|tip They walk around this area. |notinsticky
|only if scenariostage(17)
stickystart "Defeat_Frenzied_Jawcralers"
step
kill Snarlspew##237450 |scenariogoal 18/102896 |goto Hallowfall/0 25.87,57.47
|only if scenariostage(18)
step
label "Defeat_Frenzied_Jawcralers"
kill 3 Frenzied Jawcrawler##237452 |scenariogoal 18/102895 |goto Hallowfall/0 25.87,57.47
|only if scenariostage(18)
stickystart "Kill_Savage_Swarmites"
step
kill 2 Vicious Swarmite##237588 |scenariogoal 19/102937 |goto Hallowfall/0 24.91,55.02
|only if scenariostage(19)
step
label "Kill_Savage_Swarmites"
kill 2 Savage Swarmite##237589 |scenariogoal 19/102938 |goto Hallowfall/0 24.91,55.02
|only if scenariostage(19)
step
kill Mighty Skitterer##237760, Swarm Skitterer##237759, kill Titan Skitterer##237761
Defeat the Skitterer Waves |scenariogoal 20/0 |goto Hallowfall/0 27.38,55.22
|only if scenariostage(20)
step
kill Sureki Fearweaver##237765, Sureki Killweaver##237766
Defend Against the Spider Waves |scenariogoal 21/0 |goto Hallowfall/0 25.71,53.29
|only if scenariostage(21)
step
kill Veteran Sureki Raider##237882, kill Veteran Sureki Shadowstalker##237884, kill Veteran Sureki Eradicator##237881
Defend Against the Waves of Veteran Sureki Attackers |scenariogoal 22/69914 |goto Hallowfall/0 25.75,56.24
|only if scenariostage(22)
step
click Sureki Ballista##237915+
|tip They look like giant siege weapons in a line around this area.
Destroy the Sureki Ballistas |scenariogoal 23/0 |goto Hallowfall/0 25.98,55.48
|only if scenariostage(23)
step
click Sureki Cage+
|tip They look like large wooden cages on the ground around this area.
|tip They appear on your minimap as yellow dots.
Free Arathi Workers |scenariogoal 24/0 |goto Hallowfall/0 26.31,56.03
|only if scenariostage(24)
step
click Bomb Pile
|tip They look like piles of round bombs stacked on the ground around this area.
|tip They appear on your minimap as yellow dots before you pick them up.
extraaction Drop Bomb##1223207
|tip When you pick a bomb up, run to a fractured dirt hole nearby and use the button on the screen on top of it.
|tip The burrows appear as yellow dots on your minimap when you are carrying a bomb.
Bomb the Burrows |scenariogoal 25/0 |goto Hallowfall/0 26.06,56.07
|only if scenariostage(25)
step
Knock Sickly Skyrazors Out of the Sky |scenariogoal 26/0 |goto Hallowfall/0 26.45,55.16
|tip Fly through themn in the air.
|tip They appear on your minimap as yellow dots.
|only if scenariostage(26)
step
click Torch |goto Hallowfall/0 27.69,56.11
|tip Click a torch to pick it up.
|tip Run quickly to nearby egg clusters to set them on fire.
|tip The torch only lasts for 15 seconds and you will drop it if you mount up or get hit by an enemy.
'|clicknpc Corrupted Sureki Egg##239594
Destroy the Corrupted Sureki Eggs |scenariogoal 27/0 |goto Hallowfall/0 26.84,56.10
|only if scenariostage(27)
step
click Radiant Remnant+
|tip They look like small yellow crystals on the ground around this area.
|tip They appear on your minimap as yellow dots.
|tip You can pick up more than one at one time.
|tip Gather all of them that are close in one trip and run them in batches.
|tip You can carry a maximum of 8 at once.
|tip Run them to the keystone.
Collect Radiant Remnants |scenariogoal 28/0 |goto Hallowfall/0 26.56,53.92
|only if scenariostage(28)
step
click Void Corrupted Remnant##240086+
|tip They look like large purple crystals on the ground around this area.
|tip They appear on your minimap as yellow dots.
|tip Run to the middle of the purple circle and jump into the crystal.
Destroy the Void Corrupted Remnants |scenariogoal 29/0 |goto Hallowfall/0 25.91,55.19
|only if scenariostage(29)
step
click Injured Recruit##240365
'|clicknpc Arathi Priest##240366
|tip They appear on your minimap as yellow dots.
|tip Run them to priests standing in big circles of yellow light.
|tip While carrying a recruit, the priests appear on your minimap as yellow dots.
Take Injured Recruits to Arathi Priests |scenariogoal 30/0 |goto Hallowfall/0 26.83,55.56
|only if scenariostage(30)
step
click Webbed Scout##240477
|tip They look like web-wrapped NPCs on the ground around this area.
|tip They appear on your minimap as yellow dots.
|tip Click them and run away to pull the webs off.
Free the Webbed Scouts |scenariogoal 31/0 |goto Hallowfall/0 24.83,55.21
|only if scenariostage(31)
step
click Sureki Shadecaster+
|tip They look like devices projecting purple images on the ground around this area.
|tip They appear on your minimap as yellow dots.
Destroy the Sureki Shadecasters |scenariogoal 32/0 |goto Hallowfall/0 26.56,55.72
|only if scenariostage(32)
step
Proceeding |complete true
|next "Begin_Nightfall_Scenario" |only if inscenario(2637)
step
The Next Scenario Starts at the Top of the Hour |complete false |or
'|complete not areapoi(2215,8175) or inscenario(2637) |next "Begin_Nightfall_Scenario" |or
]])
ZGV.BETASTART()
ZygorGuidesViewer:RegisterGuide("Achievement Guides\\Exploration\\The War Within Pathfinder",{
description="This guide will help you complete The War Within Pathfinder achievement.",
startlevel=70,
patch='100005',
achieveid={40831,40826,40825,40822,40790,40231},
},[[
step
Dornogal |achieve 40831/5 |goto Dornogal/0 49.96,57.32 |notravel
step
Tranquil Strand |achieve 40831/4 |goto Isle of Dorn/0 30.59,55.45 |notravel
step
The Orecrag |achieve 40831/6 |goto Isle of Dorn/0 35.70,75.50 |notravel
step
Wanderer's Landing |achieve 40831/7 |goto Isle of Dorn/0 54.57,78.56 |notravel
step
Boskroot Basin |achieve 40831/8 |goto Isle of Dorn/0 54,64 |notravel
step
Boulder Springs |achieve 40831/2 |goto Isle of Dorn/0 58.33,61.46 |notravel
step
Ironwold |achieve 40831/3 |goto Isle of Dorn/0 68.59,48.74 |notravel
step
Mourning Rise |achieve 40831/9 |goto Isle of Dorn/0 64.34,44.07 |notravel
step
Thunderhead Peak |achieve 40831/1 |goto Isle of Dorn/0 47.90,27.45 |notravel
step
The Three Shields |achieve 40831/10 |goto Isle of Dorn/0 71,21.34 |notravel
step
The Waterworks |achieve 40825/5 |goto The Ringing Deeps/0 41.77,43.89
step
The Living Grotto |achieve 40825/7 |goto The Ringing Deeps/0 51.52,67.17 |notravel
step
Opportunity Point |achieve 40825/8 |goto The Ringing Deeps/0 60.56,78.21 |notravel
step
Taelloch |achieve 40825/6 |goto The Ringing Deeps/0 58.15,60.25 |notravel
step
The Rumbling Wastes |achieve 40825/4 |goto The Ringing Deeps/0 59.84,51.80 |notravel
step
Shadowvein Extraction Site |achieve 40825/3 |goto The Ringing Deeps/0 57.52,41.82 |notravel
step
Lost Mines |achieve 40825/2 |goto The Ringing Deeps/0 55.21,24.56 |notravel
step
Gundargaz |achieve 40825/10 |goto The Ringing Deeps/0 42.94,33.46 |notravel
step
The Earthenworks |achieve 40825/1 |goto The Ringing Deeps/0 42.99,18.30 |notravel
step
The Hallowfall Gate |achieve 40825/9 |goto The Ringing Deeps/0 36.72,23.80 |notravel
step
The Aegis Wall |achieve 40826/2 |goto Hallowfall/0 70.72,58.71
step
Dunelle's Kindness |achieve 40826/1 |goto Hallowfall/0 68.52,44.71 |notravel
step
The Fangs |achieve 40826/3 |goto Hallowfall/0 57,48.54 |notravel
step
Light's Blooming |achieve 40826/7 |goto Hallowfall/0 63,28 |notravel
step
Lorel's Crossing |achieve 40826/4 |goto Hallowfall/0 48.51,40.45 |notravel
step
Priory of the Sacred Flame |achieve 40826/8 |goto Hallowfall/0 36.36,35.41 |notravel
step
The Undersea |achieve 40826/9 |goto Hallowfall/0 30,42 |notravel
step
Mereldar |achieve 40826/5 |goto Hallowfall/0 41.50,52.49 |notravel
step
Light's Redoubt |achieve 40826/6 |goto Hallowfall/0 40.46,71.20 |notravel
step
Ruptured Lake |achieve 40822/1 |goto Azj-Kahet/0 29.46,45.12
step
Lightless Channels |achieve 40822/2 |goto Azj-Kahet/0 46.59,36.14 |notravel
step
The Weaver's Lair |achieve 40822/4 |goto Azj-Kahet/0 56,44 |notravel
step
Crawling Chasm |achieve 40822/3 |goto Azj-Kahet/0 61.83,23.51 |notravel
step
Untamed Valley |achieve 40822/5 |goto Azj-Kahet/0 65,52 |notravel
step
Rak-Ush |achieve 40822/7 |goto Azj-Kahet/0 74.81,80.27 |notravel
step
High Hollows |achieve 40822/10 |goto Nerub'ar/1 72,48 |notravel
step
Umbral Bazaar |achieve 40822/9 |goto Nerub'ar/1 60.92,19.34 |notravel
step
The Skeins |achieve 40822/8 |goto Nerub'ar/1 31,24 |notravel
step
Twitching Gorge |achieve 40822/6 |goto Azj-Kahet/0 49.74,61.40 |notravel
step
Complete The Isle of Dorn Story Campaign |achieve 20118
|loadguide "Leveling Guides\\The War Within (70-80)\\Story Campaigns\\Intro & Isle of Dorn (Story Only)"
step
Complete The Ringing Deeps Story Campaign |achieve 19560
|loadguide "Leveling Guides\\The War Within (70-80)\\Story Campaigns\\The Ringing Deeps (Story Only)"
step
Complete the Hallowfall Story Campaign |achieve 20598
|loadguide "Leveling Guides\\The War Within (70-80)\\Story Campaigns\\Hallowfall (Story Only)"
step
Complete Azj-Kahet Story Campaign |achieve 19559
|loadguide "Leveling Guides\\The War Within (70-80)\\Story Campaigns\\Azj-Kahet (Story Only)"
]])
ZGV.BETAEND()
ZygorGuidesViewer:RegisterGuide("Events Guides\\The War Within (70-80)\\Siren Isle\\The Drain",{
description="This guide will assist you in completing \"The Drain\" excavation on Siren Isle.",
condition_valid=function() return completedq(84725) end,
condition_valid_msg="You must complete \"The Circlet Calls\" quest in the Siren Isle guide to unlock excavations.",
startlevel=80,
areapoiid={8149},
patch='110007',
},[[
step
label "Begin_Excavation"
click Siren Isle Command Map
|tip Contribute to {o}The Drain{} excavation.
|tip When enough people contribue Flame-Blessed Iron to an event and the bar reaches 100%, it becomes possible to do that event on Siren Isle.
Activate {y}The Drain{} Excavation |complete haveq(85753,85755) |goto Siren Isle/0 69.31,43.16
step
Wait for the Blasting to Finish |complete widgetactive(6327,1386) |goto Siren Isle/0 61.98,74.36
|tip It takes a few minutes for the cave opening to clear.
step
kill Gravesludge##228201 |q 85753/1 |goto Siren Isle/0 57.51,66.44 |only if haveq(85753) or completedq(85753)
kill Gravesludge##228201 |q 85755/1 |goto Siren Isle/0 57.51,66.44 |only if haveq(85755) or completedq(85755)
Excavation Complete |complete not haveq(85753,85755) |only if default |next "Begin_Excavation"
|tip Inside the cave.
|tip This enemy is elite and will require a group.
|tip Move out of areas targeted on the ground.
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\The War Within (70-80)\\Siren Isle\\The Drowned Lair",{
description="This guide will assist you in completing \"The Drowned Lair\" excavation on Siren Isle.",
condition_valid=function() return completedq(84725) end,
condition_valid_msg="You must complete \"The Circlet Calls\" quest in the Siren Isle guide to unlock excavations.",
startlevel=80,
areapoiid={8152},
patch='110007',
},[[
step
label "Begin_Excavation"
click Siren Isle Command Map
|tip Contribute to {o}The Drowned Lair{} excavation.
|tip When enough people contribue Flame-Blessed Iron to an event and the bar reaches 100%, it becomes possible to do that event on Siren Isle.
Activate {y}The Drowned Lair{} Excavation |complete areapoi(2369,8152) |goto Siren Isle/0 69.31,43.16
step
Wait for the Bombardment to Finish |complete widgetactive(6329,1388) |goto Siren Isle/0 33.03,64.87
|tip It takes a few minutes for the cave opening to clear.
step
kill Nerathor##229982 |q 85762/1 |goto Siren Isle/0 26.16,65.52 |only if haveq(85762) or completedq(85762)
kill Nerathor##229982 |q 85760/1 |goto Siren Isle/0 26.16,65.52 |only if haveq(85760) or completedq(85760)
Excavation Complete |complete not haveq(85762,85760) |only if default |next "Begin_Excavation"
|tip Inside the cave.
|tip This enemy is elite and will require a group.
]])
ZygorGuidesViewer:RegisterGuide("Events Guides\\The War Within (70-80)\\Siren Isle\\Shuddering Hollow",{
description="This guide will assist you in completing \"Shuddering Hollow\" excavation on Siren Isle.",
condition_valid=function() return completedq(84725) end,
condition_valid_msg="You must complete \"The Circlet Calls\" quest in the Siren Isle guide to unlock excavations.",
startlevel=80,
areapoiid={8150},
patch='110007',
},[[
step
label "Begin_Excavation"
click Siren Isle Command Map
|tip Contribute to the {o}Shuddering Hollow{} excavation.
|tip When enough people contribue Flame-Blessed Iron to an event and the bar reaches 100%, it becomes possible to do that event on Siren Isle.
Activate the {y}Shuddering Hollow{} Excavation |complete haveq(85764,85765) |goto Siren Isle/0 69.31,43.16
step
Wait for the Excavation to Finish |complete widgetactive(6328,1387) |goto Siren Isle/0 44.37,56.70
|tip It takes a few minutes for the cave opening to clear.
step
kill Stalagnarok##229992 |q 85764/1 |goto Siren Isle/0 36.74,55.14 |only if haveq(85764) or completedq(85764)
kill Stalagnarok##229992 |q 85765/1 |goto Siren Isle/0 36.74,55.14 |only if haveq(85765) or completedq(85765)
Excavation Complete |complete not haveq(85764,85765) |only if default |next "Begin_Excavation"
|tip Inside the cave.
|tip This enemy is elite and will require a group.
]])
