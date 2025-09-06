local addonName, Smartbot = ...
Smartbot.Equip = Smartbot.Equip or {}
local Equip = Smartbot.Equip

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local GetInventoryItemLink = GetInventoryItemLink
local GetInventorySlotInfo = GetInventorySlotInfo
local GetItemInfoInstant = _G.GetItemInfoInstant or (C_Item and C_Item.GetItemInfoInstant)
local GetTime = GetTime
local UnitAffectingCombat = UnitAffectingCombat

local C_Container = C_Container
local GetContainerNumSlots = (C_Container and C_Container.GetContainerNumSlots) or GetContainerNumSlots
local GetContainerItemLink = (C_Container and C_Container.GetContainerItemLink) or GetContainerItemLink

local ItemScore = Smartbot.ItemScore

local function isValidLink(link)
    return type(link) == 'string' and string.find(link, '|Hitem:')
end

local slots = {
    HEAD = {GetInventorySlotInfo('HeadSlot')},
    NECK = {GetInventorySlotInfo('NeckSlot')},
    SHOULDER = {GetInventorySlotInfo('ShoulderSlot')},
    CHEST = {GetInventorySlotInfo('ChestSlot')},
    WAIST = {GetInventorySlotInfo('WaistSlot')},
    LEGS = {GetInventorySlotInfo('LegsSlot')},
    FEET = {GetInventorySlotInfo('FeetSlot')},
    WRIST = {GetInventorySlotInfo('WristSlot')},
    HAND = {GetInventorySlotInfo('HandsSlot')},
    FINGER = {GetInventorySlotInfo('Finger0Slot'), GetInventorySlotInfo('Finger1Slot')},
    TRINKET = {GetInventorySlotInfo('Trinket0Slot'), GetInventorySlotInfo('Trinket1Slot')},
    CLOAK = {GetInventorySlotInfo('BackSlot')},
    MAINHAND = {GetInventorySlotInfo('MainHandSlot')},
    OFFHAND = {GetInventorySlotInfo('SecondaryHandSlot')},
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

Equip.invTypeToSlots = invTypeToSlots

local lastEquipTime = {}

local function getEquippedScore(slot)
    local link = GetInventoryItemLink('player', slot)
    if isValidLink(link) and ItemScore:IsAllowed(link) then
        return ItemScore:GetScore(link), link
    end
    return 0, link
end

Equip.GetEquippedScore = getEquippedScore

function Equip:Validate(itemLink, slot)
    local _, _, _, equipLoc = GetItemInfoInstant(itemLink)
    local slotsGroup = invTypeToSlots[equipLoc]
    if not slotsGroup then return false end
    local delta
    local minDelta = Smartbot.db.profile.minDelta or 0
    if equipLoc == 'INVTYPE_FINGER' or equipLoc == 'INVTYPE_TRINKET' then
        local newScore = ItemScore:GetScore(itemLink)
        local currentScore = getEquippedScore(slot)
        delta = newScore - currentScore
    elseif equipLoc == 'INVTYPE_2HWEAPON' then
        local mh, oh = slots.MAINHAND[1], slots.OFFHAND[1]
        local current = select(1, getEquippedScore(mh)) + select(1, getEquippedScore(oh))
        delta = ItemScore:GetScore(itemLink) - current
    else
        local currentScore = getEquippedScore(slot)
        delta = ItemScore:GetScore(itemLink) - currentScore
    end
    return delta and delta >= minDelta
end

local function shouldEquip(slot)
    local now = GetTime()
    if lastEquipTime[slot] and now - lastEquipTime[slot] < 2 then
        return false
    end
    lastEquipTime[slot] = now
    return true
end

local function queueUpgrade(itemLink, slot)
    if not isValidLink(itemLink) or not slot then return end
    if not Equip:Validate(itemLink, slot) then return end
    if not Smartbot.API.IsOutOfCombat() or UnitAffectingCombat('player') then return end
    if not shouldEquip(slot) then return end
    Smartbot:QueueEquip(itemLink, slot)
end

local function evaluateBasic(itemLink, slotsGroup)
    local minDelta = Smartbot.db.profile.minDelta or 0
    local newScore = ItemScore:GetScore(itemLink)
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
        queueUpgrade(itemLink, bestSlot)
    end
end

local function evaluateTwoHand(itemLink)
    local mh, oh = slots.MAINHAND[1], slots.OFFHAND[1]
    local current = select(1, getEquippedScore(mh)) + select(1, getEquippedScore(oh))
    local newScore = ItemScore:GetScore(itemLink)
    if newScore - current >= (Smartbot.db.profile.minDelta or 0) then
        queueUpgrade(itemLink, mh)
    end
end

local function evaluateOneHandCandidates(candidates)
    local mhSlot, ohSlot = slots.MAINHAND[1], slots.OFFHAND[1]
    local current = select(1, getEquippedScore(mhSlot)) + select(1, getEquippedScore(ohSlot))
    table.sort(candidates, function(a, b) return a.score > b.score end)
    if #candidates >= 2 then
        local newScore = candidates[1].score + candidates[2].score
        if newScore - current >= (Smartbot.db.profile.minDelta or 0) then
            queueUpgrade(candidates[1].link, mhSlot)
            queueUpgrade(candidates[2].link, ohSlot)
            return
        end
    end
    -- evaluate individually against slots
    for _, cand in ipairs(candidates) do
        evaluateBasic(cand.link, {mhSlot, ohSlot})
    end
end

function Equip:Scan()
    if not Smartbot.db or not Smartbot.db.profile then return end
    local oneHand = {}
    for bag = 0, 4 do
        local slotsCount = GetContainerNumSlots(bag) or 0
        for slot = 1, slotsCount do
            local link = GetContainerItemLink(bag, slot)
            if isValidLink(link) and ItemScore:IsAllowed(link) then
                local _, _, _, equipLoc = GetItemInfoInstant(link)
                local group = invTypeToSlots[equipLoc]
                if group then
                    if equipLoc == 'INVTYPE_2HWEAPON' then
                        evaluateTwoHand(link)
                    elseif equipLoc == 'INVTYPE_WEAPON' then
                        table.insert(oneHand, {link = link, score = ItemScore:GetScore(link)})
                    elseif equipLoc == 'INVTYPE_WEAPONMAINHAND' or equipLoc == 'INVTYPE_WEAPONOFFHAND' or equipLoc == 'INVTYPE_SHIELD' or equipLoc == 'INVTYPE_HOLDABLE' then
                        evaluateBasic(link, group)
                    else
                        evaluateBasic(link, group)
                    end
                end
            end
        end
    end
    local mhLink = GetInventoryItemLink('player', slots.MAINHAND[1])
    if GetInventoryItemLink('player', slots.OFFHAND[1]) == nil and isValidLink(mhLink) and select(4, GetItemInfoInstant(mhLink)) == 'INVTYPE_2HWEAPON' then
        if #oneHand >= 2 then
            evaluateOneHandCandidates(oneHand)
        end
    else
        if #oneHand > 0 then
            evaluateOneHandCandidates(oneHand)
        end
    end
end

local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:RegisterEvent('BAG_UPDATE_DELAYED')
frame:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
frame:SetScript('OnEvent', function()
    Equip:Scan()
end)

return Equip

