local addonName, Smartbot = ...
Smartbot.Equip = Smartbot.Equip or {}

local function isValidLink(link)
    return Smartbot.API and Smartbot.API.IsValidItemLink and Smartbot.API.IsValidItemLink(link)
end

local slots = {
    HEAD = {_G.GetInventorySlotInfo('HeadSlot')},
    NECK = {_G.GetInventorySlotInfo('NeckSlot')},
    SHOULDER = {_G.GetInventorySlotInfo('ShoulderSlot')},
    CHEST = {_G.GetInventorySlotInfo('ChestSlot')},
    WAIST = {_G.GetInventorySlotInfo('WaistSlot')},
    LEGS = {_G.GetInventorySlotInfo('LegsSlot')},
    FEET = {_G.GetInventorySlotInfo('FeetSlot')},
    WRIST = {_G.GetInventorySlotInfo('WristSlot')},
    HAND = {_G.GetInventorySlotInfo('HandsSlot')},
    FINGER = {_G.GetInventorySlotInfo('Finger0Slot'), _G.GetInventorySlotInfo('Finger1Slot')},
    TRINKET = {_G.GetInventorySlotInfo('Trinket0Slot'), _G.GetInventorySlotInfo('Trinket1Slot')},
    CLOAK = {_G.GetInventorySlotInfo('BackSlot')},
    MAINHAND = {_G.GetInventorySlotInfo('MainHandSlot')},
    OFFHAND = {_G.GetInventorySlotInfo('SecondaryHandSlot')},
}

local invTypeToSlots = {
    INVTYPE_HEAD = slots.HEAD,
    INVTYPE_NECK = slots.NECK,
    INVTYPE_SHOULDER = slots.SHOULDER,
    INVTYPE_CHEST = slots.CHEST,
    INVTYPE_WAIST = slots.WAIST,
    INVTYPE_LEGS = slots.LEGS,
    INVTYPE_FEET = slots.FEET,
    INVTYPE_WRIST = slots.WRIST,
    INVTYPE_HAND = slots.HAND,
    INVTYPE_FINGER = slots.FINGER,
    INVTYPE_TRINKET = slots.TRINKET,
    INVTYPE_CLOAK = slots.CLOAK,
    INVTYPE_WEAPON = {slots.MAINHAND[1], slots.OFFHAND[1]},
    INVTYPE_WEAPONMAINHAND = slots.MAINHAND,
    INVTYPE_WEAPONOFFHAND = slots.OFFHAND,
    INVTYPE_2HWEAPON = {slots.MAINHAND[1], slots.OFFHAND[1]},
    INVTYPE_SHIELD = slots.OFFHAND,
    INVTYPE_HOLDABLE = slots.OFFHAND,
    INVTYPE_RANGED = slots.MAINHAND,
    INVTYPE_RANGEDRIGHT = slots.MAINHAND,
    INVTYPE_THROWN = slots.MAINHAND,
}

Smartbot.Equip.invTypeToSlots = invTypeToSlots

local AMBIG = { INVTYPE_FINGER = true, INVTYPE_TRINKET = true, INVTYPE_WEAPON = true }

local lastEquipTime = {}

local function getEquippedScore(slot)
    local link = _G.GetInventoryItemLink('player', slot)
    if isValidLink(link) and Smartbot.ItemScore:IsAllowed(link) then
        return Smartbot.ItemScore:GetScore(link), link
    end
    return 0, link
end

function Smartbot.Equip.GetEquippedScore(slot)
    return getEquippedScore(slot)
end

function Smartbot.Equip:PickWeakerSlot(itemLink, equipLoc)
    local slotsGroup = invTypeToSlots[equipLoc]
    if not slotsGroup then return end
    local weakest, minScore
    for _, slot in ipairs(slotsGroup) do
        local s = self.GetEquippedScore(slot)
        if not minScore or s < minScore then
            minScore = s
            weakest = slot
        end
    end
    return weakest
end

function Smartbot.Equip:Validate(itemLink, slot)
    local equipLoc = select(4, _G.GetItemInfoInstant(itemLink))
    local slotsGroup = invTypeToSlots[equipLoc]
    if not slotsGroup then return false end
    local delta
    local minDelta = Smartbot.db.profile.minDelta or 0
    if equipLoc == 'INVTYPE_FINGER' or equipLoc == 'INVTYPE_TRINKET' then
        local newScore = Smartbot.ItemScore:GetScore(itemLink)
        local currentScore = getEquippedScore(slot)
        delta = newScore - currentScore
    elseif equipLoc == 'INVTYPE_2HWEAPON' then
        local mh, oh = slots.MAINHAND[1], slots.OFFHAND[1]
        local current = select(1, getEquippedScore(mh)) + select(1, getEquippedScore(oh))
        delta = Smartbot.ItemScore:GetScore(itemLink) - current
    else
        local currentScore = getEquippedScore(slot)
        delta = Smartbot.ItemScore:GetScore(itemLink) - currentScore
    end
    return delta and delta >= minDelta
end

local function shouldEquip(slot)
    local now = _G.GetTime()
    if lastEquipTime[slot] and now - lastEquipTime[slot] < 2 then
        return false
    end
    lastEquipTime[slot] = now
    return true
end

local function queueUpgrade(itemLink, slot, equipLoc)
    if not isValidLink(itemLink) or not slot then return end
    if not Smartbot.Equip:Validate(itemLink, slot) then return end
    if not Smartbot.API.IsOutOfCombat() or _G.UnitAffectingCombat('player') then return end
    if not shouldEquip(slot) then return end
    local passSlot = AMBIG[equipLoc] and slot or nil
    Smartbot:QueueEquip(itemLink, passSlot)
end

local function evaluateBasic(itemLink, slotsGroup, equipLoc)
    local minDelta = Smartbot.db.profile.minDelta or 0
    local newScore = Smartbot.ItemScore:GetScore(itemLink)
    local bestSlot, bestDelta
    for _, slot in ipairs(slotsGroup) do
        local currentScore = getEquippedScore(slot)
        local delta = newScore - currentScore
        if delta > minDelta and (not bestDelta or delta > bestDelta) then
            bestDelta = delta
            bestSlot = slot
        end
    end
    if bestSlot then
        queueUpgrade(itemLink, bestSlot, equipLoc)
    end
end

local function evaluateTwoHand(itemLink)
    local mh, oh = slots.MAINHAND[1], slots.OFFHAND[1]
    local current = select(1, getEquippedScore(mh)) + select(1, getEquippedScore(oh))
    local newScore = Smartbot.ItemScore:GetScore(itemLink)
    if newScore - current >= (Smartbot.db.profile.minDelta or 0) then
        queueUpgrade(itemLink, mh, 'INVTYPE_2HWEAPON')
    end
end

local function evaluateOneHandCandidates(candidates)
    local mhSlot, ohSlot = slots.MAINHAND[1], slots.OFFHAND[1]
    local current = select(1, getEquippedScore(mhSlot)) + select(1, getEquippedScore(ohSlot))
    table.sort(candidates, function(a, b) return a.score > b.score end)
    if #candidates >= 2 then
        local newScore = candidates[1].score + candidates[2].score
        if newScore - current >= (Smartbot.db.profile.minDelta or 0) then
            queueUpgrade(candidates[1].link, mhSlot, 'INVTYPE_WEAPON')
            queueUpgrade(candidates[2].link, ohSlot, 'INVTYPE_WEAPON')
            return
        end
    end
    for _, cand in ipairs(candidates) do
        evaluateBasic(cand.link, {mhSlot, ohSlot}, 'INVTYPE_WEAPON')
    end
end

function Smartbot.Equip:Scan()
    if not Smartbot.db or not Smartbot.db.profile then return end
    local oneHand = {}
    for bag = 0, 4 do
        local slotsCount
        if _G.C_Container and _G.C_Container.GetContainerNumSlots then
            slotsCount = _G.C_Container.GetContainerNumSlots(bag) or 0
        elseif _G.GetContainerNumSlots then
            slotsCount = _G.GetContainerNumSlots(bag) or 0
        else
            slotsCount = 0
        end
        for slot = 1, slotsCount do
            local link
            if _G.C_Container and _G.C_Container.GetContainerItemLink then
                link = _G.C_Container.GetContainerItemLink(bag, slot)
            elseif _G.GetContainerItemLink then
                link = _G.GetContainerItemLink(bag, slot)
            end
            if isValidLink(link) and Smartbot.ItemScore:IsAllowed(link) then
                local _, _, _, equipLoc = _G.GetItemInfoInstant(link)
                local group = invTypeToSlots[equipLoc]
                if group then
                    if equipLoc == 'INVTYPE_2HWEAPON' then
                        evaluateTwoHand(link)
                    elseif equipLoc == 'INVTYPE_WEAPON' then
                        table.insert(oneHand, {link = link, score = Smartbot.ItemScore:GetScore(link)})
                    elseif equipLoc == 'INVTYPE_WEAPONMAINHAND' or equipLoc == 'INVTYPE_WEAPONOFFHAND' or equipLoc == 'INVTYPE_SHIELD' or equipLoc == 'INVTYPE_HOLDABLE' then
                        evaluateBasic(link, group, equipLoc)
                    else
                        evaluateBasic(link, group, equipLoc)
                    end
                end
            end
        end
    end
    local mhLink = _G.GetInventoryItemLink('player', slots.MAINHAND[1])
    if _G.GetInventoryItemLink('player', slots.OFFHAND[1]) == nil and isValidLink(mhLink) and select(4, _G.GetItemInfoInstant(mhLink)) == 'INVTYPE_2HWEAPON' then
        if #oneHand >= 2 then
            evaluateOneHandCandidates(oneHand)
        end
    else
        if #oneHand > 0 then
            evaluateOneHandCandidates(oneHand)
        end
    end
end

local equipFailLog = {}

function Smartbot.Equip.SafeEquipLink(itemLink, srcBag, srcSlot, desiredInvSlotId)
    if not (Smartbot.API and Smartbot.API.IsOutOfCombat and Smartbot.API.IsOutOfCombat()) then
        return false, 'in_combat'
    end
    if Smartbot.API.IsPlayerBusy and Smartbot.API.IsPlayerBusy() then
        return false, 'player_busy'
    end
    if not isValidLink(itemLink) then
        return false, 'bad_link'
    end
    local ok = pcall(_G.EquipItemByName, itemLink)
    if ok then return true end
    local equipLoc = select(4, _G.GetItemInfoInstant(itemLink))
    if not equipLoc then
        if Smartbot.Logger and not equipFailLog[itemLink] then
            Smartbot.Logger:Log('WARN', 'Equip failed', itemLink, 'no_equipLoc')
            equipFailLog[itemLink] = true
        end
        return false, 'equip_failed'
    end
    if not AMBIG[equipLoc] and not desiredInvSlotId then
        if srcBag and srcSlot then
            if Smartbot.API and Smartbot.API.ClearCursorSafe then Smartbot.API.ClearCursorSafe() end
            if _G.C_Container and _G.C_Container.PickupContainerItem then
                _G.C_Container.PickupContainerItem(srcBag, srcSlot)
            elseif _G.PickupContainerItem then
                _G.PickupContainerItem(srcBag, srcSlot)
            end
            local invId = invTypeToSlots[equipLoc]
            invId = invId and invId[1]
            if invId and _G.EquipCursorItem then
                _G.EquipCursorItem(invId)
                if Smartbot.API and Smartbot.API.ClearCursorSafe then Smartbot.API.ClearCursorSafe() end
                return true
            end
            if Smartbot.API and Smartbot.API.ClearCursorSafe then Smartbot.API.ClearCursorSafe() end
        end
        if Smartbot.Logger and not equipFailLog[itemLink] then
            Smartbot.Logger:Log('WARN', 'Equip failed', itemLink, 'dstSlot_unused')
            equipFailLog[itemLink] = true
        end
        return false, 'equip_failed'
    end
    local invId = desiredInvSlotId
    if not invId then
        invId = Smartbot.Equip:PickWeakerSlot(itemLink, equipLoc)
    end
    if not invId then
        if Smartbot.Logger and not equipFailLog[itemLink] then
            Smartbot.Logger:Log('WARN', 'Equip failed', itemLink, 'no_invId')
            equipFailLog[itemLink] = true
        end
        return false, 'equip_failed'
    end
    if srcBag and srcSlot then
        if Smartbot.API and Smartbot.API.ClearCursorSafe then Smartbot.API.ClearCursorSafe() end
        if _G.C_Container and _G.C_Container.PickupContainerItem then
            _G.C_Container.PickupContainerItem(srcBag, srcSlot)
        elseif _G.PickupContainerItem then
            _G.PickupContainerItem(srcBag, srcSlot)
        end
    else
        if _G.PickupItem then
            _G.PickupItem(itemLink)
        end
    end
    if _G.EquipCursorItem then
        _G.EquipCursorItem(invId)
        if Smartbot.API and Smartbot.API.ClearCursorSafe then Smartbot.API.ClearCursorSafe() end
        return true
    end
    if Smartbot.Logger and not equipFailLog[itemLink] then
        Smartbot.Logger:Log('WARN', 'Equip failed', itemLink, 'fallback_failed')
        equipFailLog[itemLink] = true
    end
    if Smartbot.API and Smartbot.API.ClearCursorSafe then Smartbot.API.ClearCursorSafe() end
    return false, 'equip_failed'
end

local frame = _G.CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:RegisterEvent('BAG_UPDATE_DELAYED')
frame:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
frame:SetScript('OnEvent', function()
    Smartbot.Equip:Scan()
end)

