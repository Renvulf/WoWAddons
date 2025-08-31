local name,ZGV = ...

ZGV.TalentAdvisor = {}

local TA = ZGV.TalentAdvisor
local CHAIN = ZGV.ChainCall

local currency_to_build = {
	[1] = "tclass",
	[2] = "tspec",
	--"thleft","thright" are set up later, since they can be any combination of 3,4,5
}


function TA.Initialise()
	if TA.Initialised then return end
	-- hook functions
	PlayerSpellsFrame.SpecFrame:HookScript("OnShow",TA.SetSpec)
	PlayerSpellsFrame.TalentsFrame:HookScript("OnShow",function() TA.SetTalents() end)
	PlayerSpellsFrame.TalentsFrame.SelectionChoiceFrame:HookScript("OnShow",TA.SetSelectionTalents)
	--ZGV:AddEventHandler("TRAIT_NODE_CHANGED",TA.DelayedSetTalents)
	ZGV:AddEventHandler("TRAIT_TREE_CURRENCY_INFO_UPDATED",TA.DelayedSetTalents)

	-- set up icons
	TA.IconPool = CreateFramePool("BUTTON",nil,"ZygorTalentIconButton")
	TA.IconSelectionPool = CreateFramePool("BUTTON",nil,"ZygorTalentIconButton")

	TA.SpecIcon  = CHAIN(CreateFrame("Button"))
		:SetSize(30,30)
		:SetPoint("TOPRIGHT")
		:SetNormalTexture(ZGV.DIR.."\\Skins\\zygor-round")
		:SetFrameStrata("HIGH")
		:SetFrameLevel(76)	
		:SetScript("OnEnter", function() TA.ShowTooltip(TA.SpecIcon) end)
		:SetScript("OnLeave", function() GameTooltip:Hide() end)
		:Hide()
	.__END
	TA.SpecIcon:GetNormalTexture():SetTexCoord(0,0,0,1/2 , 1,0,1,1/2)

	-- add menu button
	local mapbuttonsize=20

	TA.MenuButton = ZGV.ChainCall(CreateFrame("BUTTON",nil,PlayerSpellsFrame.TalentsFrame,"ZygorSpecialButton_Template"))
		:ApplySkin()
		:SetSize(32,32)
		:SetPoint("RIGHT",PlayerSpellsFrame.TalentsFrame.ApplyButton,"LEFT", -20, 0)
		:SetFrameLevel(611)

		:SetScript("OnClick", function() TA:ShowMenu() end)
		:Show()
	.__END

	-- record class
	TA.PlayerClass = select(2,UnitClass("player"))
	TA.ClassBuilds = TA.Builds[TA.PlayerClass]

	TA.Initialised = true

	-- strip TalentNodes, do reverse mapping
	TA.TalentNodes = TA.TalentNodes[TA.PlayerClass]
	TA.TalentNodesLookup = {}
	for spec,trees in pairs(TA.TalentNodes) do
		TA.TalentNodesLookup[spec] = {}
		for tree,nodes in pairs(trees) do
			TA.TalentNodesLookup[spec][tree]={}
			for name,node in pairs(nodes) do
				if TA.TalentNodesLookup[spec][tree][node] then ZGV:Debug("&talentadvisor duplicate %s %s %s",spec,tree,node) end
				TA.TalentNodesLookup[spec][tree][node]=name
			end
		end
	end

	ZGV:ScheduleRepeatingTimer(function() 
		if TA.Learning then
			TA:LearnNextTalent()
		end
	end,0.1)
end

function TA.ShowTooltip(object)
	GameTooltip:SetOwner(object,"ANCHOR_TOP")
	GameTooltip:SetText("Zygor recommendation")
	GameTooltip:Show()
end

function TA.SetSpec()
	if not ZGV.db.profile.talenton then return end

	local suggested_spec = TA.SuggestedSpec[TA.PlayerClass]
	
	for frame in PlayerSpellsFrame.SpecFrame.SpecContentFramePool:EnumerateActive() do
		if frame.specIndex == suggested_spec then
			TA.SpecIcon:SetParent(frame)
			TA.SpecIcon:ClearAllPoints()
			TA.SpecIcon:SetPoint("TOPRIGHT",frame.SpecImage)
			TA.SpecIcon:Show()
		end
	end
end

function TA.DelayedSetTalents() 
	-- TRAIT_TREE_CURRENCY_INFO_UPDATED can now fire outside of talent frame, make sure we are loaded first
	if not (PlayerSpellsFrame and PlayerSpellsFrame.TalentsFrame:IsVisible()) then return end
	if not TA.Initialised then return end 
	C_Timer.After(0,function() TA.SetTalents()  end)
end

local function getNodeEntries(nodeInfo)
	local entries = {}
	for _,entry in ipairs(nodeInfo.entryIDs) do table.insert(entries,entry) end
	if nodeInfo.type==0 then entries[2]=nil end -- some nodes have split entries eventhough they are single talent ones

	return entries
end

function TA.SetTalents(ident) 
	if not ZGV.db.profile.talenton then return end
	if not ZGV.db.profile.ta_toggle_icons then return end
	local spec = GetSpecialization()
	if not spec then return end
	ident = ident or ZGV.db.char.talentbuilds[spec]

	-- get build
	TA.ActiveBuild = TA:GetBuild(ident) 
	if not TA.ActiveBuild then return end

	-- get build status
	local status = TA:GetBuildStatus() 

	-- map blizzard talent buttons to entryIDs
	local blizzbuttons = {}
	for _,blizzbutton in pairs(PlayerSpellsFrame.TalentsFrame.nodeIDToButton) do
		for _,entryID in ipairs(getNodeEntries(blizzbutton.nodeInfo)) do
			blizzbuttons[entryID] = blizzbutton
		end
	end

	-- for each talent in build, find node, show icons
	TA.IconPool:ReleaseAll()
	for entryID,data in pairs(status) do
		local blizzbutton = blizzbuttons[entryID]
		if blizzbutton then
			local nodeinfo = blizzbutton.nodeInfo
			local available = nodeinfo.meetsEdgeRequirements
			local value = data

			if type(data)=="table" then
				value = data[1]
				available = not data[2] and available
			end

			local zygorbutton = TA.IconPool:Acquire()
			CHAIN(zygorbutton)
				:SetParent(blizzbutton)
				:SetPoint("TOPRIGHT",blizzbutton,"TOPRIGHT",18,18)
				:SetFrameStrata("MEDIUM")
				:SetFrameLevel(1900)
				:SetValue(value)
				:Show()
			zygorbutton:SetAvailable(available)
		end
	end
end

function TA.SetSelectionTalents()
	if not ZGV.db.profile.talenton then return end
	if not ZGV.db.profile.ta_toggle_icons then return end

	local blizzbuttons = {}
	for _,blizzbutton in pairs(PlayerSpellsFrame.TalentsFrame.SelectionChoiceFrame.selectionFrameArray) do
		blizzbuttons[blizzbutton.entryID] = blizzbutton
	end

	local status = TA:GetBuildStatus() 
	TA.IconSelectionPool:ReleaseAll()
	for entryID,data in pairs(status) do
		local blizzbutton = blizzbuttons[entryID]
		if blizzbutton then
			local value = type(data)=="table" and data[1] or data
			
			local zygorbutton = TA.IconSelectionPool:Acquire()
			CHAIN(zygorbutton)
				:SetParent(blizzbutton)
				:SetPoint("TOPRIGHT",blizzbutton,"TOPRIGHT",10,10)
				:SetFrameStrata("HIGH")
				:SetFrameLevel(2000)
				:SetValue(value)
				:Show()
		end
	end
end

function TA:ParseLines(text,spec,tree)
	local array={}
	local index=1
	local st,en,line
	text = text .. "\n"
	local count

	if not (TA.TalentNodes[spec] and TA.TalentNodes[spec][tree]) then return array end

	local TalentNodes = TA.TalentNodes[spec][tree]

	while (index<#text) do
		st,en,line=string.find(text,"(.-)\n",index)
		if not en then break end
		index = en + 1
		line = line:gsub("//.*$",""):gsub("%-%-.*$","")  -- comments away
		line = line:gsub("^[%s	]+",""):gsub("[%s	]+$","")  -- whitespace away
		line = line:gsub("||","|")
		line = line:gsub("/[0-9]+","")  -- /3 are just fluff, remove

		if line~="" then tinsert(array,line) end
	end
	return array
end

function TA:GetBuild(ident) 
	-- get current spec
	local spec = GetSpecialization()
	if not spec then return end

	-- get build data
	local build
	
	for i,v in pairs(TA.ClassBuilds) do
		if v.ident == ident then
			build = v
		end
	end
	if not build then
		for i,v in pairs(TA.ClassBuilds) do
			if v.spec == spec and v.suggested then
				build = v
			end
		end
	end

	if not build then return end
	ZGV.db.char.talentbuilds[spec] = build.ident

	-- parse build, explode to one point per entry
	local talentFrame = PlayerSpellsFrame.TalentsFrame
	local configID = talentFrame.configID
	local currencyToTree={}
	for i,v in pairs(talentFrame.treeCurrencyInfo) do currencyToTree[v.traitCurrencyID] = i end

	if not build.parsed then 
		build.tclass = TA:ParseLines(build.classtalents,build.spec,1) 
		build.tspec = TA:ParseLines(build.spectalents,build.spec,2)

		local heroPanel = PlayerSpellsFrame.TalentsFrame.HeroTalentsContainer
		local herotrees = heroPanel and heroPanel.activeSubTreeSelectionNodeInfo and heroPanel.activeSubTreeSelectionNodeInfo.entryIDs
		if herotrees then
			local left = herotrees[1]
			local right = herotrees[2]


			-- set currency_to_build to point to correct trees
			local leftEntryInfo =  C_Traits.GetEntryInfo(configID, left)
			local leftTreeInfo = C_Traits.GetSubTreeInfo(configID, leftEntryInfo.subTreeID);
			local rightEntryInfo =  C_Traits.GetEntryInfo(configID, right)
			local rightTreeInfo = C_Traits.GetSubTreeInfo(configID, rightEntryInfo.subTreeID);
		
			build.thleftnum,build.thrightnum = currencyToTree[leftTreeInfo.traitCurrencyID],currencyToTree[rightTreeInfo.traitCurrencyID]
			build.thleft = TA:ParseLines(build.herolefttalents,build.spec,build.thleftnum) 
			build.thright = TA:ParseLines(build.herorighttalents,build.spec,build.thrightnum) 
		end
	end

	-- build spell to entry mapping
	TA.NodeToEntry = {}

	for _,button in pairs(talentFrame.nodeIDToButton) do
		local nodeInfo = button.nodeInfo
		local cost = C_Traits.GetNodeCost(configID,nodeInfo.ID)
		local tree = cost and cost[1] and currencyToTree[cost[1].ID]

		if tree then
			for entryNum,entryID in pairs(getNodeEntries(nodeInfo)) do
				TA.NodeToEntry[tree] = TA.NodeToEntry[tree] or {}
				TA.NodeToEntry[tree][("%s,%s,%s"):format(nodeInfo.posX,nodeInfo.posY,entryNum)]=entryID
			end
		end
	end
	
	return build
end

local function getEntryIDbyTalent(tree,talent)
	if not TA.ActiveBuild then return false end
	local node = TA.TalentNodes[TA.ActiveBuild.spec][tree][talent]
	return TA.NodeToEntry[tree][node]
end

function TA:GetBuildStatus()
	local build = TA.ActiveBuild
	local status = {}

	if not build then return status end

	local currencyInfo = PlayerSpellsFrame.TalentsFrame.treeCurrencyInfo
	if not currencyInfo then return status end
	
	local total_points = {}
	for _,talent in ipairs(build.tclass) do
		local entryID = getEntryIDbyTalent(1,talent)
		if entryID then
			total_points[entryID] = (total_points[entryID] or 0) + 1
		end
	end
	for _,talent in ipairs(build.tspec) do
		local entryID = getEntryIDbyTalent(2,talent)
		if entryID then
			total_points[entryID] = (total_points[entryID] or 0) + 1
		end
	end
	if build.thleft then
		for _,talent in ipairs(build.thleft) do
			local entryID = getEntryIDbyTalent(build.thleftnum,talent)
			if entryID then
				total_points[entryID] = (total_points[entryID] or 0) + 1
			end
		end
	end
	if build.thright then
		for _,talent in ipairs(build.thright) do
			local entryID = getEntryIDbyTalent(build.thrightnum,talent)
			if entryID then
				total_points[entryID] = (total_points[entryID] or 0) + 1
			end
		end
	end

	-- check if nodes have correct amount of points spent
	for _,blizzbutton in pairs(PlayerSpellsFrame.TalentsFrame.nodeIDToButton) do
		local nodeInfo = blizzbutton.nodeInfo
		local activeEntry = nodeInfo.activeEntry 
		local activeEntryID = activeEntry and activeEntry.entryID
		local currentRank = activeEntry and activeEntry.rank or nodeInfo.activeRank

		if activeEntryID then
			if (nodeInfo.currentRank or 0)>(nodeInfo.ranksPurchased or 0) then
				-- talent learned automatically, cannot be unlearned
				status[activeEntryID] = "GOOD"
			elseif not total_points[activeEntryID] then
				if currentRank>0 then
					status[activeEntryID] = "BAD"
				end
			elseif total_points[activeEntryID]==currentRank then
				status[activeEntryID] = "GOOD"
			elseif total_points[activeEntryID]<currentRank then
				status[activeEntryID] = "BAD"
			else
				status[activeEntryID] = total_points[activeEntryID] - currentRank
			end
		else
			for _,entryID in ipairs(getNodeEntries(nodeInfo)) do
				if not total_points[entryID] then
					if currentRank>0 then
						status[entryID] = "BAD"
					end
				elseif total_points[entryID]==currentRank  then
					status[entryID] = "GOOD"
				elseif total_points[entryID]<currentRank then
					status[entryID] = "BAD"
				else
					status[entryID] = total_points[entryID] - currentRank
				end
			end
		end
	end

	local foundNext = false
	for _,talent in ipairs(build.tclass) do
		local entryID = getEntryIDbyTalent(1,talent)
		if entryID then
			if tonumber(status[entryID]) then
				status[entryID] = {tonumber(status[entryID]), foundNext}
				foundNext = true
			end
		end
	end

	local foundNext = false
	for _,talent in ipairs(build.tspec) do
		local entryID = getEntryIDbyTalent(2,talent)
		if entryID then
			if tonumber(status[entryID]) then
				status[entryID] = {tonumber(status[entryID]), foundNext}
				foundNext = true
			end
		end
	end

	if build.thleft then
		local foundNext = false
		for _,talent in ipairs(build.thleft) do
			local entryID = getEntryIDbyTalent(build.thleftnum,talent)
			if entryID then
				if tonumber(status[entryID]) then
					status[entryID] = {tonumber(status[entryID]), foundNext}
					foundNext = true
				end
			end
		end
	end

	if build.thright then
		local foundNext = false
		for _,talent in ipairs(build.thright) do
			local entryID = getEntryIDbyTalent(build.thrightnum,talent)
			if entryID then
				if tonumber(status[entryID]) then
					status[entryID] = {tonumber(status[entryID]), foundNext}
					foundNext = true
				end
			end
		end
	end
			

	-- return array of etries-status for current level
	return status
end

function TA:LearnBuild()
	local build = TA.ActiveBuild
	if not build then return end

	local talentsframe = PlayerSpellsFrame.TalentsFrame

	local configID = talentsframe.configID
	local treeID = talentsframe.talentTreeID
	C_Traits.ResetTree(configID,treeID)

	local currencyToTree={}
	for i,v in pairs(talentsframe.treeCurrencyInfo) do currencyToTree[v.traitCurrencyID] = i end
	currency_to_build[3]=nil
	currency_to_build[4]=nil
	currency_to_build[5]=nil

	-- Hero talents
	local heroPanel = talentsframe.HeroTalentsContainer
	if heroPanel then
		if UnitLevel("player") >= heroPanel.heroSpecsRequiredLevel then
			local heroSubtrees = heroPanel.activeSubTreeSelectionNodeInfo
			local nodeID = heroSubtrees.ID
			local left = heroSubtrees.entryIDs[1]
			local right = heroSubtrees.entryIDs[2]

			-- set currency_to_build to point to correct trees
			local leftEntryInfo =  C_Traits.GetEntryInfo(configID, left)
			local leftTreeInfo = C_Traits.GetSubTreeInfo(configID, leftEntryInfo.subTreeID);
			local rightEntryInfo =  C_Traits.GetEntryInfo(configID, right)
			local rightTreeInfo = C_Traits.GetSubTreeInfo(configID, rightEntryInfo.subTreeID);
			currency_to_build[currencyToTree[leftTreeInfo.traitCurrencyID]] = "thleft"
			currency_to_build[currencyToTree[rightTreeInfo.traitCurrencyID]] = "thright"
			
			-- pick sugested tree
			if build.hero=="left" then C_Traits.SetSelection(configID,nodeID,left) end
			if build.hero=="right" then C_Traits.SetSelection(configID,nodeID,right) end
		end
	end

	-- wait till next frame, so that blizz data for nodes refreshes into reset state
	ZGV:ScheduleTimer(function() TA.Learning = true end,0)
end

function logerror(index,name,spell,reason)
	ZGV:Debug(("&talentadvisor Failed to learn %s %s##%s : %s"):format(index,name or "?",spell or "?",reason))
end

function TA:LearnNextTalent()
	local build = TA.ActiveBuild
	if not build then return end

	local configID = PlayerSpellsFrame.TalentsFrame.configID
	local treeID = PlayerSpellsFrame.TalentsFrame.talentTreeID

	local entry_to_node = {}
	for _,blizzbutton in pairs(PlayerSpellsFrame.TalentsFrame.nodeIDToButton) do
		local nodeInfo = blizzbutton.nodeInfo
		for _,entryID in ipairs(nodeInfo.entryIDs) do
			entry_to_node[entryID] = nodeInfo
		end
	end

			
	local points_at_level = {}
	local currencyInfo = PlayerSpellsFrame.TalentsFrame.treeCurrencyInfo
	for currency,buildtype in pairs(currency_to_build) do
		local pointsMax = currencyInfo[currency].maxQuantity
		local builddata = build[buildtype]
		for i=1,pointsMax do
			if builddata[i] then
				local spellID = builddata[i]
				local entryID = spellID and getEntryIDbyTalent(currency,builddata[i])
				if spellID and entryID then
					points_at_level[entryID] = (points_at_level[entryID] or 0) + 1
					local node = entry_to_node[entryID]

					if node then 
						if not node.meetsEdgeRequirements then
							logerror(i,builddata[i].name,spellID,"requirements not met")
							TA.Learning = false
							return
						end
						local activeEntry = node.activeEntry 
						local node_entryID = activeEntry and activeEntry.entryID or node.entryIDs[1]
						local currentRank = activeEntry and activeEntry.rank or node.activeRank or 0

						if node_entryID~=entryID or points_at_level[entryID] > currentRank then
							node.activeEntry = node.activeEntry or {}
							node.activeEntry.entryID = entryID
							node.activeEntry.rank = points_at_level[entryID]
							if #node.entryIDs>1 and not node.nextEntry then
								C_Traits.SetSelection(configID,node.ID,entryID)
							else
								C_Traits.PurchaseRank(configID,node.ID)
							end
							return
						end
					else
						logerror(i,builddata[i].name,spellID,"node doesn't exist")
						TA.Learning = false
						return
					end
				else
					logerror(i,builddata[i].name,spellID,"entry doesn't exist")
					TA.Learning = false
					return
				end
			end
		end
	end
	TA.Learning = false
	return
end

function TA:Toggle(mode)
	-- show/hide icons
	if not TA.Initialised then return end

	if mode then
		TA.SetSpec()
		TA.SetTalents()
		TA.SpecIcon:Show()
		TA.MenuButton:Show()
	else
		TA.IconPool:ReleaseAll()
		TA.IconSelectionPool:ReleaseAll()
		TA.SpecIcon:Hide()
		TA.MenuButton:Hide()
	end
end

function TA:ShowMenu()
	local L=ZygorGuidesViewer_L("zta")
	local parent=TA.MenuButton
	if not TA.MenuDropdown then TA.MenuDropdown = CreateFrame("FRAME",nil,TA.MenuButton,"UIDropDownForkTemplate") end
	if DropDownForkList1 and DropDownForkList1:IsShown() and DropDownForkList1.dropdown==TA.MenuDropdown then CloseDropDownForks() return end
	UIDropDownFork_SetAnchor(TA.MenuDropdown, 0, 0, "BOTTOMLEFT", TA.MenuButton, "BOTTOMRIGHT")

	local menu = {
		{ 
			text = L['ta_toggle_icons'],
			keepShownOnClick=true, 
			checked = function() return ZGV.db.profile.ta_toggle_icons end, 
			func = function() 
				ZGV.db.profile.ta_toggle_icons = not ZGV.db.profile.ta_toggle_icons
				TA:Toggle(ZGV.db.profile.ta_toggle_icons)
				UIDropDownFork_Refresh(TA.MenuDropdown) 
			end 
		},
		{
			text = L['ta_select_suggested'],
			func = function() TA:LearnBuild() end,
			notCheckable=0,
		},
		UIDropDownFork_separatorInfo,
	}


	local spec = GetSpecialization()
	if not spec then return end

	if TA.ClassBuilds and spec then
		for _,build in ipairs(TA.ClassBuilds) do
			if build.spec==spec then
				table.insert(menu,{
					text = build.name,
					func = function() TA.SetTalents(build.ident) UIDropDownFork_RefreshAll(TA.MenuDropdown) end,
					checked = function() 
						local spec = GetSpecialization()
						if not spec then return end
						return ZGV.db.char.talentbuilds[spec]==build.ident 
					end,
					keepShownOnClick = true,
				})
			end
		end
	end

	if ZGV.DEV then
		table.insert(menu,UIDropDownFork_separatorInfo)
		table.insert(menu,{
			text = "DEV: Live record build",
			func = function() ZGV.Testing.RecordTalents() end,
			notCheckable=0,
		})
		table.insert(menu,{
			text = "DEV: Dump talents",
			func = function() ZGV.Testing.DumpTalents() end,
			notCheckable=0,
		})
		table.insert(menu,{
			text = "DEV: Export current build",
			func = function() ZGV.Testing.ExportCurrentBuild() end,
			notCheckable=0,
		})
		table.insert(menu,{
			text = "DEV: Check for talent changes",
			func = function() ZGV.Testing.CheckForChanges() end,
			notCheckable=0,
		})
	end


	

	EasyFork(menu,TA.MenuDropdown,nil,0,0,"MENU",false)
	UIDropDownFork_SetWidth(TA.MenuDropdown, 300)
end

ZygorTalentIconButton_Mixin = {}
function ZygorTalentIconButton_Mixin:SetValue(value)
	self:EnableMouse(false)	
	self.currentvalue = value
	ZGV.IconSets.TalentPoints[value]:AssignToTexture(self:GetNormalTexture())
end

function ZygorTalentIconButton_Mixin:SetAvailable(mode)
	if mode then
		if self.currentvalue=="GOOD" then
			self:SetAlpha(0.5)
		else
			self:SetAlpha(1)
		end
	else
		self:SetAlpha(0.5)
	end
	self:GetNormalTexture():SetDesaturated(not mode)
end

tinsert(ZGV.startups,{"Talent Advisor",function(self)
	EventUtil.ContinueOnAddOnLoaded("Blizzard_PlayerSpells", TA.Initialise);
end})