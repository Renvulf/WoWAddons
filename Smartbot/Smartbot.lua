-- Smartbot - main
local Smartbot = {}
Smartbot.name = "Smartbot"

-- forward decls
local GetCurrentModel

-- module aliases (globals set by other files)
local Segment = SmartbotSegment
local Model = SmartbotModel
local Features = SmartbotFeatures

-- SavedVariables
SmartbotDB = SmartbotDB or {}

-- event frame
local f = CreateFrame and CreateFrame("Frame")
if f then f:Hide() end

-- utility
local function now() return (GetTime and GetTime()) or 0 end

local function ensureDB()
    SmartbotDB.models = SmartbotDB.models or {} -- key: specID|ROLE -> exported model table
    SmartbotDB.settings = SmartbotDB.settings or {
        enable = true, autoEquip = true, tooltip = true,
        learnEnabled = true, minSamples = 15, learnWorld = true, learnParty = true, learnRaid = true,
        ignorePvP = true, allowNegative = false,
    }
end

local function specRoleKey()
    local spec = GetSpecialization and GetSpecialization()
    if not spec then return "0|DPS" end
    local _,_,_,_,_,_,specID = GetSpecializationInfo(spec)
    local role = GetSpecializationRole(spec) or "DAMAGER"
    local r = (role == "HEALER") and "HEALER" or "DPS"
    return (tostring(specID or 0).."|"..r), r, (specID or 0)
end

local function getOrMakeModel()
    ensureDB()
    local key, role = specRoleKey()
    local t = SmartbotDB.models[key]
    if t then return Model.Import(t) end
    local m = Model:New(Features.FEATURE_ORDER)
    m.minSamples = SmartbotDB.settings.minSamples or 15
    SmartbotDB.models[key] = m:Export()
    return m
end

local function saveModel(m)
    local key = specRoleKey()
    SmartbotDB.models[key] = m:Export()
end

function GetCurrentModel()
    return getOrMakeModel()
end

-- SEGMENT LIFE-CYCLE ---------------------------------------------------------
Smartbot.activeSegment = nil
Smartbot.lastSegment = nil

local DAMAGE_EVENTS = {
    SWING_DAMAGE=true, RANGE_DAMAGE=true, SPELL_DAMAGE=true,
    SPELL_PERIODIC_DAMAGE=true, DAMAGE_SPLIT=true, DAMAGE_SHIELD=true,
}
local HEAL_EVENTS = { SPELL_HEAL=true, SPELL_PERIODIC_HEAL=true }

function Smartbot:LearnCombatStart()
    self.activeSegment = Segment and Segment:New(now()) or {segStart=now(), targetTimes={}, targetSum=0, events=0}
    -- capture feature snapshot from equipped gear
    local vec = Features and Features.BuildEquippedVector and Features.BuildEquippedVector() or {}
    self.activeSegment.features = vec
end

function Smartbot:LearnCombatEnd()
    if not self.activeSegment then return end
    if self.activeSegment.Finish then
        self.activeSegment:Finish(now())
    elseif Segment and Segment.Finish then
        Segment.Finish(self.activeSegment, now())
    else
        -- fallback compute
        self.activeSegment.dps = (self.activeSegment.totalDamage or 0) / math.max(self.activeSegment.activeTime or 0, 1)
        self.activeSegment.hps = (self.activeSegment.totalHealing or 0) / math.max(self.activeSegment.activeTime or 0, 1)
    end
    self.lastSegment = self.activeSegment
    if SmartbotDB.settings.learnEnabled then
        self:LearnProcessSegment(self.lastSegment)
    end
    self.activeSegment = nil
end

function Smartbot:HandleCombatLogEvent(...)
    if not SmartbotDB.settings.learnEnabled then return end
    if not self.activeSegment then return end
    local timestamp, subevent, _, srcGUID, _,_,_, dstGUID, _, dstFlags = ...
    local fromPlayer = (srcGUID == (UnitGUID("player") or "")) or (srcGUID == (UnitGUID("pet") or ""))
    if not fromPlayer then return end
    local isDamage = DAMAGE_EVENTS[subevent] and true or false
    local isHeal = HEAL_EVENTS[subevent] and true or false
    if not isDamage and not isHeal then return end

    local amount
    if subevent == "SWING_DAMAGE" then
        amount = select(12, ...)
    elseif isDamage then
        amount = select(15, ...)
    elseif isHeal then
        amount = select(15, ...)
    end
    amount = tonumber(amount or 0) or 0

    if self.activeSegment.AddEvent then
        self.activeSegment:AddEvent(timestamp, dstGUID, amount, isHeal)
    elseif Segment and Segment.AddEvent then
        Segment.AddEvent(self.activeSegment, timestamp, dstGUID, amount, isHeal)
    else
        -- fallback accumulate if Segment methods missing
        self.activeSegment.events = (self.activeSegment.events or 0) + 1
        if isHeal then
            self.activeSegment.totalHealing = (self.activeSegment.totalHealing or 0) + amount
        else
            self.activeSegment.totalDamage = (self.activeSegment.totalDamage or 0) + amount
        end
    end
end

function Smartbot:LearnProcessSegment(seg)
    if not seg then return end
    local key, role = specRoleKey()
    local m = getOrMakeModel()
    -- ensure avgTargets on features
    local x = seg.features or Features.BuildEquippedVector()
    x[#x+1] = seg.avgTargets or 0

    local y = (role == "HEALER") and (seg.hps or 0) or (seg.dps or 0)
    if y <= 0 or (seg.events or 0) < 5 or (seg.activeTime or 0) < 5 then return end

    local ok, why = m:Update(x, y)
    if ok then saveModel(m) end
end

-- EQUIPPING ------------------------------------------------------------------
local function isEquippable(link)
    return link and IsEquippableItem and IsEquippableItem(link)
end

local function bestUpgradeLink(m)
    if not C_Container then return nil end
    local bestLink, bestScore, bestDelta = nil, -1e30, -1e30
    for bag=0,4 do
        local num = C_Container.GetContainerNumSlots(bag) or 0
        for slot=1,num do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.hyperlink and isEquippable(info.hyperlink) then
                local v = Features.BuildItemVector(info.hyperlink)
                v[#v+1] = 1 -- conservative avgTargets
                local s = m:Predict(v)
                if s > bestScore then
                    bestScore, bestLink = s, info.hyperlink
                end
            end
        end
    end
    return bestLink, bestScore, bestDelta
end

function Smartbot:TryEquipBest()
    if InCombatLockdown and InCombatLockdown() then return end
    if not SmartbotDB.settings.autoEquip then return end
    local m = getOrMakeModel()
    if (m.n or 0) < (m.minSamples or 15) then return end
    local link = bestUpgradeLink(m)
    if not link then return end
    -- naive: let Blizzard choose slot
    C_Container.PickupItem(link)
    if CursorHasItem and CursorHasItem() then
        EquipCursorItem()
        ClearCursor()
    end
end

-- TOOLTIP --------------------------------------------------------------------
local function addTooltipLine(tooltip, link)
    if not link or not SmartbotDB.settings.tooltip then return end
    local m = getOrMakeModel()
    if (m.n or 0) < (m.minSamples or 15) then
        tooltip:AddLine("|cff00ffaaSmartbot: training... ("..tostring(m.n).."/"..tostring(m.minSamples)..")")
        return
    end
    local v = Features.BuildItemVector(link); v[#v+1] = 1
    local s = m:Predict(v)
    tooltip:AddLine("|cff00ffaaSmartbot: est. score "..string.format("%.1f", s))
end

local function hook_tooltip()
    if not TooltipDataProcessor or not TooltipDataProcessor.AddTooltipPostCall then return end
    if Smartbot._tooltipHooked then return end
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
        local link = data and data.hyperlink
        if not link and tooltip and tooltip.GetItem then
            _, link = tooltip:GetItem()
        end
        if link then addTooltipLine(tooltip, link) end
    end)
    Smartbot._tooltipHooked = true
end

-- EVENTS ---------------------------------------------------------------------
local function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" then
        local name = ...
        if name == "Smartbot" then
            ensureDB()
            hook_tooltip()
        end
    elseif event == "PLAYER_REGEN_DISABLED" then
        Smartbot:LearnCombatStart()
    elseif event == "PLAYER_REGEN_ENABLED" then
        Smartbot:LearnCombatEnd()
        Smartbot:TryEquipBest()
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        Smartbot:HandleCombatLogEvent(CombatLogGetCurrentEventInfo())
    end
end

if f then
    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("ADDON_LOADED")
    f:RegisterEvent("PLAYER_REGEN_DISABLED")
    f:RegisterEvent("PLAYER_REGEN_ENABLED")
    f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

_G.Smartbot = Smartbot
return Smartbot
