local ADDON_NAME = ...
local DB_DEFAULTS = {
    global = {
        options = {
            autoShow = true,
            includeSoulbound = true,
            includeBOE = true,
            deMaxQuality = 4,
        },
        ignorePermanent = {},
        minimap = { hide = false, minimapPos = 220, radius = 80 },
    }
}

local function DeepCopy(tbl)
    if type(tbl) ~= "table" then return tbl end
    local copy = {}
    for k, v in pairs(tbl) do
        copy[k] = DeepCopy(v)
    end
    return copy
end

if not DisenchantBuddyDB then
    DisenchantBuddyDB = DeepCopy(DB_DEFAULTS)
end

local sessionIgnore = {}
local frame
local itemList = {}
local nonDE = {}
local pendingLoad = {}
local refreshQueued = false
-- Forward declaration so functions defined earlier can reference it
local RefreshList

-- Cache the localized Disenchant spell name outside of any secure handlers.
-- In retail this information is accessed via `C_Spell.GetSpellInfo` while
-- older clients expose `GetSpellInfo`.  The cached value is then used inside
-- the secure button's `PreClick` handler where calling these APIs is not
-- permitted.
local DISENCHANT_NAME
do
    local name
    if C_Spell and C_Spell.GetSpellInfo then
        local info = C_Spell.GetSpellInfo(13262)
        if type(info) == "table" then
            -- Retail clients return a table with the spell information
            name = info.name
        else
            -- Older clients return multiple values, with the name first
            name = info
        end
    elseif GetSpellInfo then
        -- Pre-9.0 API which returns multiple values
        name = GetSpellInfo(13262)
    end
    DISENCHANT_NAME = name or "Disenchant"
end

-- Non-disenchantable items list
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
    local armorClass = (Enum and Enum.ItemClass and Enum.ItemClass.Armor) or _G.LE_ITEM_CLASS_ARMOR or 4
    local weaponClass = (Enum and Enum.ItemClass and Enum.ItemClass.Weapon) or _G.LE_ITEM_CLASS_WEAPON or 2
    if classID ~= armorClass and classID ~= weaponClass then return false end
    if quality < 2 or quality > DisenchantBuddyDB.global.options.deMaxQuality then return false end
    return true
end

local function IsItemBindOnEquip(loc, itemID)
    -- Prefer the C_Item API which works reliably across game versions. Fall
    -- back to GetItemInfo when unavailable.
    local bindType
    if C_Item and C_Item.GetItemBindType and loc then
        bindType = C_Item.GetItemBindType(loc)
    else
        bindType = select(14, GetItemInfo(itemID))
    end

    if not bindType then
        -- Item information not yet available. Request it similar to how we
        -- handle missing data elsewhere so the scan will pick it up once the
        -- client loads the data.
        if itemID and not pendingLoad[itemID] then
            pendingLoad[itemID] = true
            if C_Item and C_Item.RequestLoadItemDataByID then
                C_Item.RequestLoadItemDataByID(itemID)
            end
        end
        return false
    end

    local boe = (Enum and Enum.ItemBindType and Enum.ItemBindType.OnEquip) or _G.LE_ITEM_BIND_ON_EQUIP or 2
    return bindType == boe
end

local function ScanBags()
    wipe(itemList)
    -- Include the reagent bag (index 5) on modern clients just like TSM does
    for bag = 0, 5 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.itemID then
                local itemID = info.itemID
                local quality = info.quality

                -- Build an ItemLocation for the slot so we can query data via the
                -- C_Item API which handles asynchronous item information.
                local loc = ItemLocation:CreateFromBagAndSlot(bag, slot)

                -- Attempt to pull item class information from the instant cache.
                local _, _, _, _, _, classID = GetItemInfoInstant(itemID)
                if not classID then
                    -- Data not available yet, request it and skip processing this slot
                    if not pendingLoad[itemID] then
                        pendingLoad[itemID] = true
                        C_Item.RequestLoadItemDataByID(itemID)
                    end
                else
                    -- We have the class ID so run the usual filtering logic
                    local isBound = (C_Item and C_Item.IsBound and C_Item.IsBound(loc)) or info.isBound
                    local skip = false
                    if not DisenchantBuddyDB.global.options.includeSoulbound and isBound then
                        skip = true
                    elseif not DisenchantBuddyDB.global.options.includeBOE and not isBound and IsItemBindOnEquip(loc, itemID) then
                        skip = true
                    end

                    if not skip and IsDisenchantable(itemID, quality, classID) and not IsIgnored(itemID) then
                        local link = (C_Item.GetItemLink and C_Item.GetItemLink(loc)) or info.hyperlink
                        tinsert(itemList, {
                            bag    = bag,
                            slot   = slot,
                            itemID = itemID,
                            link   = link,
                            count  = info.stackCount,
                        })
                    end
                end
            end
        end
    end
end


--[[-------------------------------------------------------------------------
TSM style destroying support
-------------------------------------------------------------------------]]

-- Frame used to listen for spellcast and loot events while destroying
local destroyMonitor = CreateFrame("Frame")
local destroying = false
local castInProgress, spellSucceeded, lootClosed, bagUpdated = false, false, false, false
local startBag, startSlot, startQuantity

-- Check whether the original item stack has been removed from the bags and
-- finish the destroy process once it is. This mirrors the extra validation
-- performed in TSM's destroying thread to ensure the cast fully completed
-- before re-enabling the button.
local function TryFinish()
    if not destroying or not spellSucceeded or not lootClosed or not bagUpdated then
        return
    end

    local info = C_Container.GetContainerItemInfo(startBag, startSlot)
    local count = info and info.stackCount or 0
    if count ~= startQuantity then
        FinishDestroy()
    else
        -- Item count hasn't updated yet so try again shortly
        C_Timer.After(0.05, TryFinish)
    end
end

-- Refresh the list once the disenchant attempt finishes
local function FinishDestroy()
    destroyMonitor:UnregisterAllEvents()
    destroying = false
    castInProgress, spellSucceeded, lootClosed, bagUpdated = false, false, false, false
    startBag, startSlot, startQuantity = nil, nil, nil
    if frame and frame.disenchantBtn then
        -- Re-enable the button and reset the pressed state so holding the
        -- key/mouse button will immediately trigger the next disenchant just
        -- like TSM's implementation.
        frame.disenchantBtn:Enable()
        frame.disenchantBtn:SetButtonState("NORMAL", false)
        frame.disenchantBtn:SetText(frame.disenchantBtn.prevText or "Disenchant Next")
        frame.disenchantBtn:SetAttribute("*macrotext1", nil)
        frame.disenchantBtn:SetAttribute("bag", nil)
        frame.disenchantBtn:SetAttribute("slot", nil)
        -- Clear the macro attributes so the next click will set up a new
        -- disenchant. The button itself stays enabled the entire time so the
        -- user can keep clicking even while waiting for the cast to finish.
    end
    if frame and frame.scroll and RefreshList then
        -- Delay slightly to allow the bag update events to propagate before we
        -- rescan and redraw the list. We defensively check RefreshList in case
        -- something prevented it from being defined (e.g. a load error).
        C_Timer.After(0.1, function()
            if RefreshList then
                RefreshList(frame.scroll)
            end
        end)
    end
end

-- Event handler modeled after TSM's DestroyThread logic. It waits for the
-- player to finish disenchanting and refreshes the UI when done or if the cast
-- fails/interupts.
destroyMonitor:SetScript("OnEvent", function(self, event, unit, _, spellID)
    if unit ~= "player" then return end

    if event == "UNIT_SPELLCAST_START" and spellID == 13262 then
        castInProgress, spellSucceeded, lootClosed, bagUpdated = true, false, false, false
    elseif (event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_FAILED_QUIET" or event == "UNIT_SPELLCAST_INTERRUPTED") and spellID == 13262 then
        FinishDestroy()
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" and castInProgress and spellID == 13262 then
        spellSucceeded = true
        TryFinish()
    elseif event == "LOOT_READY" and castInProgress then
        -- ignored but ensures LOOT_CLOSED will indicate a valid disenchant
    elseif event == "LOOT_CLOSED" and castInProgress then
        lootClosed = true
        TryFinish()
    elseif event == "BAG_UPDATE_DELAYED" and castInProgress then
        bagUpdated = true
        TryFinish()
    end
end)

-- Starts monitoring for disenchant events. Called right before executing the
-- macro which casts Disenchant on the selected item.
--
-- Starts monitoring the disenchant spellcast similar to how TSM does.
-- Exposed globally so the secure button PreClick handler can access it.
--
--[[
    Starts monitoring the disenchant process and sets the macro text on the
    button.  This mirrors how TSM's Destroying module initiates the disenchant
    action which ensures the macro executes properly from a secure environment.

    @param button The SecureActionButton being clicked
]]
local function StartDestroy(button)
    if destroying then
        -- If a disenchant is already in progress just clear the macro so we
        -- don't attempt to cast on an empty slot. This mirrors the protection
        -- in TSM's Destroying module where the button is disabled while
        -- destroying.
        button:SetAttribute("*macrotext1", nil)
        return
    end

    local bag = button:GetAttribute("bag")
    local slot = button:GetAttribute("slot")
    if not bag or not slot then return end

    -- Record the starting stack information so we can detect when the item is
    -- removed from the bags after disenchanting.
    local info = C_Container.GetContainerItemInfo(bag, slot)
    startBag, startSlot = bag, slot
    startQuantity = info and info.stackCount or 0

    destroying = true
    castInProgress, spellSucceeded, lootClosed, bagUpdated = false, false, false, false

    -- Disable the button and show it pressed while the cast is in progress so
    -- holding the key or mouse button will queue the next disenchant just like
    -- TSM's Destroying UI.
    button.prevText = button.prevText or button:GetText()
    button:SetText("Disenchanting")
    button:SetButtonState("PUSHED", true)
    button:Disable()

    -- Subsequent clicks while the cast is underway are ignored via the
    -- `destroying` flag above which mimics the protection in TSM's destroying
    -- module.

    -- Set the macro which casts Disenchant on the selected bag slot.  The
    -- localized spell name is used so that the macro works on all clients.
    button:SetAttribute("*macrotext1", string.format("/cast %s;\n/use %d %d", DISENCHANT_NAME, bag, slot))

    destroyMonitor:RegisterEvent("UNIT_SPELLCAST_START")
    destroyMonitor:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    destroyMonitor:RegisterEvent("UNIT_SPELLCAST_FAILED")
    destroyMonitor:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET")
    destroyMonitor:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    destroyMonitor:RegisterEvent("LOOT_READY")
    destroyMonitor:RegisterEvent("LOOT_CLOSED")
    destroyMonitor:RegisterEvent("BAG_UPDATE_DELAYED")

    -- Safety timeout in case something goes wrong and we never see the expected
    -- events.  This prevents the button from getting stuck in a disabled state.
    C_Timer.After(3, function()
        if destroying then
            FinishDestroy()
        end
    end)
end

-- Export for the secure environment
_G.DisenchantBuddy_StartDestroy = StartDestroy

local function CreateRow(parent, index)
    local row = CreateFrame("Button", nil, parent.content)
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
    -- Use a standard close button texture so it's clear this removes the item
    row.hide:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
    row.hide:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")

    -- Highlight texture to indicate the selected row similar to TSM
    row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
    row:GetHighlightTexture():SetBlendMode("ADD")

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

    -- Show item tooltip on hover similar to TSM's destroying list
    row:SetScript("OnEnter", function(self)
        if self.data and self.data.link then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink(self.data.link)
            GameTooltip:Show()
        end
    end)
    row:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    function row:SetData(data)
        self.data = data
        -- Retrieve the item icon from GetItemInfoInstant (5th return value)
        local texture = select(5, GetItemInfoInstant(data.itemID))
        -- Fallback to a question mark icon if the texture isn't known yet
        self.icon:SetTexture(texture or 134400)
        self.text:SetText(data.link or "Unknown Item")
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

    -- Preserve the currently selected item if it's still in the list. We compare
    -- by bag and slot instead of table identity since the itemList is rebuilt on
    -- every refresh with new tables.
    local prevSelected = scroll.selected
    scroll.selected = nil
    for _, data in ipairs(itemList) do
        if prevSelected and data.bag == prevSelected.bag and data.slot == prevSelected.slot then
            scroll.selected = data
            break
        end
    end
    if not scroll.selected then
        scroll.selected = itemList[1]
    end

    if frame and frame.disenchantBtn then
        if scroll.selected then
            frame.disenchantBtn:SetAttribute("bag", scroll.selected.bag)
            frame.disenchantBtn:SetAttribute("slot", scroll.selected.slot)
        else
            frame.disenchantBtn:SetAttribute("bag", nil)
            frame.disenchantBtn:SetAttribute("slot", nil)
        end
    end

    for i, data in ipairs(itemList) do
        local row = rows[i]
        if not row then
            row = CreateRow(scroll, i)
            rows[i] = row
        end
        row:SetData(data)
        row:SetWidth(scroll:GetWidth())
        if scroll.selected == data then
            row:LockHighlight()
        else
            row:UnlockHighlight()
        end
        row:Show()
    end

    scroll.content:SetHeight(#itemList * 20)
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

    -- tabs setup
    -- The Blizzard tab templates changed in Dragonflight and no longer work
    -- reliably when created dynamically via Lua (the `OnShow` handler runs
    -- before the template's child regions such as `Text` are available which
    -- results in errors inside `PanelTemplates_TabResize`).  To avoid these
    -- issues we create simple buttons styled like tabs and handle the
    -- highlighting ourselves.

    frame:SetClampedToScreen(true)

    local function CreateTabButton(name, label, id)
        local btn = CreateFrame("Button", name, frame, "UIPanelButtonTemplate")
        btn:SetText(label)
        btn:SetSize(btn:GetFontString():GetStringWidth() + 20, 22)
        btn.id = id
        return btn
    end

    local listTab = CreateTabButton("DisenchantBuddyFrameTab1", "Items", 1)
    listTab:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 5, 7)

    local optionsTab = CreateTabButton("DisenchantBuddyFrameTab2", "Options", 2)
    optionsTab:SetPoint("LEFT", listTab, "RIGHT", 4, 0)

    -- list frame
    local listFrame = CreateFrame("Frame", nil, frame)
    listFrame:SetPoint("TOPLEFT", 10, -30)
    listFrame:SetPoint("BOTTOMRIGHT", -30, 50)

    local scroll = CreateFrame("ScrollFrame", nil, listFrame, "UIPanelScrollFrameTemplate")
    scroll:SetAllPoints()
    scroll.rows = {}
    scroll.Refresh = RefreshList
    frame.scroll = scroll

    local content = CreateFrame("Frame", nil, scroll)
    scroll.content = content -- assign before scripts to avoid nil access
    content:SetSize(scroll:GetWidth(), 1)
    scroll:SetScrollChild(content)
    -- Guard against OnSizeChanged firing before 'content' is assigned
    scroll:SetScript("OnSizeChanged", function(self)
        if self.content then
            self.content:SetWidth(self:GetWidth())
        end
    end)

    local disenchantBtn = CreateFrame("Button", "DisenchantBuddyDestroyBtn", listFrame, "SecureActionButtonTemplate, UIPanelButtonTemplate")
    disenchantBtn:SetPoint("BOTTOMRIGHT", 0, -40)
    disenchantBtn:SetSize(120,25)
    disenchantBtn:SetText("Disenchant Next")
    -- Register for click events respecting the ActionButtonUseKeyDown CVar like
    -- TSM's SecureMacroActionButton so the macro fires at the expected time on
    -- all clients.
    disenchantBtn:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "LeftButtonDown" or "LeftButtonUp")
    -- Use the per-button attribute names (*type1 and *macrotext1) to mirror
    -- TSM's implementation and avoid issues on some clients
    disenchantBtn:SetAttribute("*type1", "macro")
    disenchantBtn:SetAttribute("*macrotext1", "")
    disenchantBtn:SetScript("PreClick", function(btn)
        local data = scroll.selected
        if data and _G.DisenchantBuddy_StartDestroy then
            btn:SetAttribute("bag", data.bag)
            btn:SetAttribute("slot", data.slot)
            -- Use securecall to invoke the starter function so it works from a
            -- secure handler regardless of combat lockdown state.
            securecall(_G.DisenchantBuddy_StartDestroy, btn)
        else
            btn:SetAttribute("*macrotext1", nil)
        end
    end)

    frame.disenchantBtn = disenchantBtn

    -- options frame
    local optionsFrame = CreateFrame("Frame", nil, frame)
    optionsFrame:SetPoint("TOPLEFT", 10, -30)
    optionsFrame:SetPoint("BOTTOMRIGHT", -30, 50)

    local sbCheck = CreateFrame("CheckButton", nil, optionsFrame, "UICheckButtonTemplate")
    sbCheck:SetPoint("TOPLEFT", 0, -4)
    sbCheck.text = sbCheck:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    sbCheck.text:SetPoint("LEFT", sbCheck, "RIGHT", 4, 0)
    sbCheck.text:SetText("Disenchant Soulbound Items")
    sbCheck:SetChecked(DisenchantBuddyDB.global.options.includeSoulbound)
    sbCheck:SetScript("OnClick", function(self)
        DisenchantBuddyDB.global.options.includeSoulbound = self:GetChecked()
        if frame and frame.scroll then
            RefreshList(frame.scroll)
        end
    end)

    local boeCheck = CreateFrame("CheckButton", nil, optionsFrame, "UICheckButtonTemplate")
    boeCheck:SetPoint("TOPLEFT", sbCheck, "BOTTOMLEFT", 0, -8)
    boeCheck.text = boeCheck:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    boeCheck.text:SetPoint("LEFT", boeCheck, "RIGHT", 4, 0)
    boeCheck.text:SetText("Disenchant Bind on Equip Items")
    boeCheck:SetChecked(DisenchantBuddyDB.global.options.includeBOE)
    boeCheck:SetScript("OnClick", function(self)
        DisenchantBuddyDB.global.options.includeBOE = self:GetChecked()
        if frame and frame.scroll then
            RefreshList(frame.scroll)
        end
    end)

    local function UpdateTabs(selected)
        listTab:SetEnabled(selected ~= 1)
        optionsTab:SetEnabled(selected ~= 2)
        if selected == 1 then
            listFrame:Show()
            optionsFrame:Hide()
        else
            optionsFrame:Show()
            listFrame:Hide()
        end
    end

    listTab:SetScript("OnClick", function() UpdateTabs(1) end)
    optionsTab:SetScript("OnClick", function() UpdateTabs(2) end)

    UpdateTabs(1)

    frame.listFrame = listFrame
    frame.optionsFrame = optionsFrame

    scroll.Refresh(scroll)
    frame:Hide()
end

local function Toggle()
    if not frame then
        local ok, err = pcall(CreateUI)
        if not ok then
            print("DisenchantBuddy error:", err)
            return
        end
    end
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
        RefreshList(frame.scroll)
    end
end

-- Expose toggle for other files (e.g., minimap button)
DisenchantBuddy_Toggle = Toggle

SLASH_DISENCHANTBUDDY1 = "/disbuddy"
SLASH_DISENCHANTBUDDY2 = "/db"
SlashCmdList["DISENCHANTBUDDY"] = Toggle

-- Auto show on bag update if enabled
local f = CreateFrame("Frame")
f:RegisterEvent("BAG_UPDATE_DELAYED")
f:RegisterEvent("ITEM_DATA_LOAD_RESULT")
f:SetScript("OnEvent", function(_, event, ...)
    if event == "ITEM_DATA_LOAD_RESULT" then
        local itemID, success = ...
        if success and pendingLoad[itemID] then
            pendingLoad[itemID] = nil
            if frame and frame:IsShown() and not refreshQueued then
                refreshQueued = true
                C_Timer.After(0, function()
                    refreshQueued = false
                    if frame and frame:IsShown() then
                        RefreshList(frame.scroll)
                    end
                end)
            end
        end
        return
    end

    if DisenchantBuddyDB.global.options.autoShow and not (frame and frame:IsShown()) then
        ScanBags()
        if #itemList > 0 then
            Toggle()
        end
    elseif frame and frame:IsShown() then
        if not refreshQueued then
            refreshQueued = true
            C_Timer.After(0, function()
                refreshQueued = false
                if frame and frame:IsShown() then
                    RefreshList(frame.scroll)
                end
            end)
        end
    end
end)

-- Options panel
local function CreateOptions()
    local panel = CreateFrame("Frame", "DisenchantBuddyOptions")
    panel.name = "DisenchantBuddy"

    local sbCheck = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    sbCheck:SetPoint("TOPLEFT", 16, -16)
    sbCheck.Text:SetText("Disenchant Soulbound Items")
    sbCheck:SetChecked(DisenchantBuddyDB.global.options.includeSoulbound)
    sbCheck:SetScript("OnClick", function(self)
        DisenchantBuddyDB.global.options.includeSoulbound = self:GetChecked()
        if frame and frame.scroll and frame:IsShown() then
            RefreshList(frame.scroll)
        end
    end)

    local boeCheck = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    boeCheck:SetPoint("TOPLEFT", sbCheck, "BOTTOMLEFT", 0, -8)
    boeCheck.Text:SetText("Disenchant Bind on Equip Items")
    boeCheck:SetChecked(DisenchantBuddyDB.global.options.includeBOE)
    boeCheck:SetScript("OnClick", function(self)
        DisenchantBuddyDB.global.options.includeBOE = self:GetChecked()
        if frame and frame.scroll and frame:IsShown() then
            RefreshList(frame.scroll)
        end
    end)

    InterfaceOptions_AddCategory(panel)
end

local optionsLoader = CreateFrame("Frame")
optionsLoader:RegisterEvent("ADDON_LOADED")
optionsLoader:SetScript("OnEvent", function(self, addon)
    if addon == ADDON_NAME then
        CreateOptions()
        self:UnregisterEvent("ADDON_LOADED")
    end
end)
