local ADDON_NAME = ...
local DB_DEFAULTS = {
    global = {
        options = {
            autoShow = true,
            autoStack = true,
            includeSoulbound = true,
            deMaxQuality = 4,
        },
        ignorePermanent = {},
    }
}

DisenchantBuddyDB = DisenchantBuddyDB or DB_DEFAULTS

local sessionIgnore = {}
local frame
local itemList = {}
local combineList = {}
local nonDE = {}

-- Non-disenchantable items copied from TSM
nonDE = {
	["i:38"] = true,
	["i:45"] = true,
	["i:49"] = true,
	["i:53"] = true,
	["i:127"] = true,
	["i:148"] = true,
	["i:154"] = true,
	["i:2105"] = true,
	["i:2575"] = true,
	["i:2576"] = true,
	["i:2577"] = true,
	["i:2579"] = true,
	["i:2587"] = true,
	["i:3426"] = true,
	["i:3427"] = true,
	["i:3428"] = true,
	["i:4330"] = true,
	["i:4332"] = true,
	["i:4333"] = true,
	["i:4334"] = true,
	["i:4335"] = true,
	["i:4336"] = true,
	["i:4344"] = true,
	["i:5107"] = true,
	["i:6096"] = true,
	["i:6097"] = true,
	["i:6117"] = true,
	["i:6120"] = true,
	["i:6125"] = true,
	["i:6134"] = true,
	["i:6136"] = true,
	["i:6384"] = true,
	["i:6385"] = true,
	["i:6795"] = true,
	["i:6796"] = true,
	["i:6833"] = true,
	["i:10034"] = true,
	["i:10052"] = true,
	["i:10054"] = true,
	["i:10055"] = true,
	["i:10056"] = true,
	["i:11287"] = true,
	["i:11288"] = true,
	["i:11289"] = true,
	["i:11290"] = true,
	["i:13347"] = true,
	["i:16059"] = true,
	["i:16060"] = true,
	["i:17723"] = true,
	["i:18231"] = true,
	["i:20406"] = true,
	["i:20407"] = true,
	["i:20408"] = true,
	["i:20897"] = true,
	["i:20901"] = true,
	["i:21766"] = true,
	["i:23345"] = true,
	["i:23473"] = true,
	["i:23476"] = true,
	["i:24143"] = true,
	["i:31279"] = true,
	["i:41248"] = true,
	["i:41249"] = true,
	["i:41250"] = true,
	["i:41251"] = true,
	["i:41252"] = true,
	["i:41253"] = true,
	["i:41254"] = true,
	["i:41255"] = true,
	["i:42360"] = true,
	["i:42361"] = true,
	["i:42363"] = true,
	["i:42365"] = true,
	["i:42368"] = true,
	["i:42369"] = true,
	["i:42370"] = true,
	["i:42371"] = true,
	["i:42372"] = true,
	["i:42373"] = true,
	["i:42374"] = true,
	["i:42375"] = true,
	["i:42376"] = true,
	["i:42377"] = true,
	["i:42378"] = true,
	["i:44693"] = true,
	["i:44694"] = true,
	["i:45664"] = true,
	["i:45666"] = true,
	["i:45667"] = true,
	["i:45668"] = true,
	["i:45669"] = true,
	["i:45670"] = true,
	["i:45671"] = true,
	["i:45672"] = true,
	["i:45673"] = true,
	["i:45674"] = true,
	["i:48663"] = true,
	["i:49567"] = true,
	["i:52252"] = true,
	["i:52485"] = true,
	["i:52486"] = true,
	["i:52487"] = true,
	["i:52488"] = true,
	["i:52548"] = true,
	["i:53852"] = true,
	["i:60223"] = true,
	["i:68611"] = true,
	["i:75274"] = true,
	["i:84661"] = true,
	["i:89586"] = true,
	["i:97826"] = true,
	["i:97827"] = true,
	["i:97828"] = true,
	["i:97829"] = true,
	["i:97830"] = true,
	["i:97831"] = true,
	["i:97832"] = true,
	["i:109262"] = true,
	["i:122604"] = true,
	["i:127842"] = true,
	["i:128023"] = true,
	["i:128024"] = true,
	["i:141408"] = true,
	["i:151607"] = true,
	["i:151771"] = true,
	["i:151772"] = true,
	["i:152632"] = true,
	["i:152633"] = true,
	["i:152635"] = true,
	["i:152637"] = true,
	["i:167081"] = true,
	["i:167082"] = true,
	["i:167177"] = true,
	["i:167178"] = true,
	["i:167179"] = true,
	["i:167180"] = true,
	["i:167181"] = true,
	["i:167182"] = true,
	["i:167183"] = true,
	["i:167184"] = true,
	["i:167185"] = true,
	["i:167186"] = true,
	["i:167187"] = true,
	["i:167188"] = true,
	["i:167189"] = true,
	["i:167190"] = true,
	["i:167191"] = true,
	["i:167192"] = true,
	["i:167193"] = true,
	["i:167194"] = true,
	["i:167195"] = true,
	["i:167196"] = true,
	["i:167197"] = true,
	["i:186056"] = true,
	["i:186058"] = true,
	["i:186163"] = true,
	["i:231955"] = true,
	["i:231956"] = true,
	["i:231957"] = true,
	["i:231958"] = true,
	["i:231959"] = true,
	["i:231960"] = true,
	["i:231961"] = true,
	["i:231962"] = true,
	["i:231963"] = true,
	["i:231964"] = true,
	["i:231965"] = true,
	["i:231966"] = true,
	["i:231967"] = true,
	["i:231968"] = true,
	["i:231969"] = true,
	["i:231970"] = true,
	["i:234830"] = true,
	["i:234831"] = true,
	["i:234832"] = true,
	["i:234833"] = true,
	["i:234834"] = true,
	["i:234835"] = true,
	["i:234836"] = true,
	["i:234837"] = true,
	["i:234881"] = true,
	["i:234882"] = true,
	["i:234883"] = true,
	["i:234884"] = true,
	["i:234885"] = true,
	["i:234886"] = true,
	["i:234887"] = true,
	["i:234888"] = true,
	["i:234924"] = true,
	["i:234925"] = true,
	["i:234926"] = true,
	["i:234927"] = true,
	["i:234928"] = true,
	["i:234929"] = true,
	["i:234930"] = true,
	["i:234931"] = true,
}

local function IsIgnored(itemID)
    if sessionIgnore[itemID] then return true end
    return DisenchantBuddyDB.global.ignorePermanent[itemID]
end

local function IsDisenchantable(itemID, quality, classID)
    if not itemID or not quality or not classID then return false end
    if nonDE["i:"..itemID] then return false end
    if classID ~= LE_ITEM_CLASS_ARMOR and classID ~= LE_ITEM_CLASS_WEAPON then return false end
    if quality < 2 or quality > DisenchantBuddyDB.global.options.deMaxQuality then return false end
    return true
end

local function ScanBags()
    wipe(itemList)
    wipe(combineList)
    local combineTemp = {}
    for bag=0,4 do
        for slot=1,C_Container.GetContainerNumSlots(bag) do
            local info = C_Container.GetContainerItemInfo(bag,slot)
            if info and info.hyperlink then
                local itemID = info.itemID
                local quality = info.quality
                local classID = select(6, GetItemInfoInstant(itemID))
                if IsDisenchantable(itemID, quality, classID) and not IsIgnored(itemID) then
                    tinsert(itemList, {bag=bag, slot=slot, itemID=itemID, link=info.hyperlink, count=info.stackCount})
                    if info.stackCount < info.stackCountMax then
                        combineTemp[itemID] = combineTemp[itemID] or {}
                        tinsert(combineTemp[itemID], {bag=bag, slot=slot, count=info.stackCount})
                    end
                end
            end
        end
    end
    -- Build combine list (pairs of slots)
    for _, stacks in pairs(combineTemp) do
        if #stacks > 1 then
            table.sort(stacks, function(a,b) return a.count < b.count end)
            for i=1,#stacks-1,2 do
                local s1, s2 = stacks[i], stacks[i+1]
                if s1 and s2 then
                    tinsert(combineList, {fromBag=s1.bag, fromSlot=s1.slot, toBag=s2.bag, toSlot=s2.slot})
                end
            end
        end
    end
end

local function CombineStacks()
    for _,data in ipairs(combineList) do
        C_Container.PickupContainerItem(data.fromBag, data.fromSlot)
        C_Container.PickupContainerItem(data.toBag, data.toSlot)
    end
end

local function CreateRow(parent, index)
    local row = CreateFrame("Button", nil, parent)
    row:SetHeight(20)
    row:SetPoint("TOPLEFT",0,-(index-1)*20)
    row:SetPoint("RIGHT",0,0)

    row.icon = row:CreateTexture(nil,"ARTWORK")
    row.icon:SetSize(18,18)
    row.icon:SetPoint("LEFT")

    row.text = row:CreateFontString(nil,"ARTWORK","GameFontNormalSmall")
    row.text:SetPoint("LEFT", row.icon, "RIGHT", 4, 0)

    row.hide = CreateFrame("Button", nil, row)
    row.hide:SetSize(16,16)
    row.hide:SetPoint("RIGHT")
    row.hide:SetNormalTexture(134400) -- X icon

    row:SetScript("OnClick", function(self)
        parent.selected = self.data
        parent:Refresh()
    end)
    row.hide:SetScript("OnClick", function(self)
        local itemID = self:GetParent().data.itemID
        if IsShiftKeyDown() then
            DisenchantBuddyDB.global.ignorePermanent[itemID] = true
        else
            sessionIgnore[itemID] = true
        end
        ScanBags()
        parent:Refresh()
    end)

    function row:SetData(data)
        self.data = data
        local texture = select(5, GetItemInfoInstant(data.itemID))
        self.icon:SetTexture(texture)
        self.text:SetText(data.link)
    end

    return row
end

local function RefreshList(scroll)
    ScanBags()
    local rows = scroll.rows
    local numRows = #rows
    for i=1,numRows do
        rows[i]:Hide()
    end
    for i,data in ipairs(itemList) do
        local row = rows[i]
        if not row then
            row = CreateRow(scroll, i)
            rows[i] = row
        end
        row:SetData(data)
        row:SetWidth(scroll:GetWidth())
        row:Show()
    end
    scroll.contentHeight = #itemList * 20
end

local function CreateUI()
    frame = CreateFrame("Frame","DisenchantBuddyFrame",UIParent,"BasicFrameTemplateWithInset")
    frame:SetSize(300,400)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame.title = frame:CreateFontString(nil,"OVERLAY","GameFontHighlight")
    frame.title:SetPoint("CENTER", frame.TitleBg, "CENTER",0,0)
    frame.title:SetText("DisenchantBuddy")

    local scroll = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 10, -30)
    scroll:SetPoint("BOTTOMRIGHT", -30, 50)
    scroll.rows = {}
    scroll.Refresh = RefreshList

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(1,1)
    scroll:SetScrollChild(content)
    scroll.content = content

    local combineBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    combineBtn:SetPoint("BOTTOMLEFT", 10, 10)
    combineBtn:SetSize(120,25)
    combineBtn:SetText("Combine Stacks")
    combineBtn:SetScript("OnClick", function()
        CombineStacks()
        C_Timer.After(0.1, function() RefreshList(scroll) end)
    end)

    local destroyBtn = CreateFrame("Button", "DisenchantBuddyDestroyBtn", frame, "SecureActionButtonTemplate, UIPanelButtonTemplate")
    destroyBtn:SetPoint("BOTTOMRIGHT", -10, 10)
    destroyBtn:SetSize(120,25)
    destroyBtn:SetText("Destroy Next")
    destroyBtn:SetAttribute("type","macro")
    destroyBtn:SetScript("PreClick", function(btn)
        local data = scroll.selected
        if data then
            btn:SetAttribute("macrotext", string.format("/cast Disenchant\n/use %d %d", data.bag, data.slot))
        else
            btn:SetAttribute("macrotext", nil)
        end
    end)

    scroll.Refresh(scroll)
    frame:Hide()
end

local function Toggle()
    if not frame then CreateUI() end
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
        RefreshList(frame.scroll or frame:GetChildren())
    end
end

SLASH_DISENCHANTBUDDY1 = "/disbuddy"
SlashCmdList["DISENCHANTBUDDY"] = Toggle

-- Auto show on bag update if enabled
local f = CreateFrame("Frame")
f:RegisterEvent("BAG_UPDATE_DELAYED")
f:SetScript("OnEvent", function()
    if DisenchantBuddyDB.global.options.autoShow and not (frame and frame:IsShown()) then
        ScanBags()
        if #itemList > 0 then
            Toggle()
        end
    elseif frame and frame:IsShown() then
        RefreshList(frame.scroll or frame:GetChildren())
    end
end)
