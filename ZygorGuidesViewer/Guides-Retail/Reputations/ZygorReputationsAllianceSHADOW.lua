local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if UnitFactionGroup("player")~="Alliance" then return end
if ZGV:DoMutex("ReputationsASHADOW") then return end
ZygorGuidesViewer.GuideMenuTier = "SHA"
ZygorGuidesViewer:RegisterGuide("Reputation Guides\\Shadowlands\\Kyrian Covenant of Bastion",{
keywords={"covenant"},
description="\nDeclare alegiance to the Kyrian Covenant of Bastion and rise within its ranks.",
},[[
step
confirm
]])
ZygorGuidesViewer:RegisterGuide("Reputation Guides\\Shadowlands\\Necrolords of Maldraxxus",{
keywords={"covenant"},
description="\nDeclare alegiance to the Necrolords of Maldraxxus covenant and rise within its ranks.",
},[[
step
confirm
]])
ZygorGuidesViewer:RegisterGuide("Reputation Guides\\Shadowlands\\Night Fae of Ardenweald",{
keywords={"covenant"},
description="\nDeclare alegiance to the Night Fae of Ardenweald covenant and rise within its ranks.",
},[[
step
confirm
]])
ZygorGuidesViewer:RegisterGuide("Reputation Guides\\Shadowlands\\Venthyr of Revendreth",{
keywords={"covenant"},
description="\nDeclare alegiance to the Venthyr of Revendreth covenant and rise within its ranks.",
},[[
step
confirm
]])
