-- Smartbot: A simple addon to evaluate gear upgrades based on user-defined stat weights.
-- The addon detects the player's specialization and lets users assign stat weights
-- per specialization. It can optionally auto-equip items considered upgrades
-- by scanning the player's bags periodically.

local Smartbot = {}
Smartbot.name = ...

-- Runtime state guarded by event-driven logic. Initialized on ADDON_LOADED.
Smartbot.isScanning = false
Smartbot.equipQueue = {}
Smartbot.equipInFlight = nil -- {slot=slotId, itemID=itemID, link=itemLink, timeout=timerObj}
Smartbot.rescanRequested = false
Smartbot.debounceHandle = nil
Smartbot.failedUpgrades = {}

local Segment = SmartbotSegment
local FeatureSampler = SmartbotFeatureSampler
local Model = SmartbotModel
Smartbot.playerGUID = nil
Smartbot.currentPetGUID = nil
Smartbot.activeSegment = nil
Smartbot.lastSegment = nil
Smartbot.featureSampler = nil
Smartbot.featureTicker = nil
Smartbot.lastYHat = nil

-- API references with fallbacks for different game versions.
-- In Dragonflight (and later) most item API functions moved under C_Item.
-- Older clients still expose them as globals.  Using locals here avoids
-- repeatedly resolving globals and prevents errors when a function is absent.
local GetItemStatsFunc = C_Item and C_Item.GetItemStats or _G.GetItemStats
local CanEquipItemFunc = C_PlayerInfo and C_PlayerInfo.CanEquipItem or nil
local CanDualWieldFunc = _G.CanDualWield or function()
    return IsSpellKnown and IsSpellKnown(674) -- dual wield spell in classic
end

--
-- The list below mirrors the stat weighting options exposed by the Zygor
-- addon.  Each entry contains a display label, the token returned by
-- GetItemStats and an optional "primary" spec filter.  The filter may be a
-- single LE_UNIT_STAT_* constant or a table of constants if multiple primary
-- stats should see the value.  Domination sockets are intentionally omitted as
-- they're obsolete in modern content.
local STAT_LIST = {
    { label = "Strength",        key = "ITEM_MOD_STRENGTH_SHORT",       primary = LE_UNIT_STAT_STRENGTH },
    { label = "Agility",         key = "ITEM_MOD_AGILITY_SHORT",        primary = LE_UNIT_STAT_AGILITY },
    { label = "Intellect",       key = "ITEM_MOD_INTELLECT_SHORT",      primary = LE_UNIT_STAT_INTELLECT },
    { label = "Crit",            key = "ITEM_MOD_CRIT_RATING_SHORT",    always = true },
    { label = "Haste",           key = "ITEM_MOD_HASTE_RATING_SHORT",   always = true },
    { label = "Mastery",         key = "ITEM_MOD_MASTERY_RATING_SHORT", always = true },
    { label = "Versatility",     key = "ITEM_MOD_VERSATILITY",          always = true },
    { label = "Stamina",         key = "ITEM_MOD_STAMINA_SHORT",        always = true },
    { label = "Armor",           key = "ITEM_MOD_ARMOR_SHORT" },
    { label = "Attack Power",    key = "ITEM_MOD_ATTACK_POWER_SHORT",  primary = {LE_UNIT_STAT_STRENGTH, LE_UNIT_STAT_AGILITY} },
    { label = "Spell Power",     key = "ITEM_MOD_SPELL_POWER_SHORT",   primary = LE_UNIT_STAT_INTELLECT },
    { label = "Life Steal",      key = "ITEM_MOD_LIFESTEAL_RATING_SHORT" },
    { label = "Socket",          key = "EMPTY_SOCKET_PRISMATIC" },
    -- Weapons expose a damage-per-second stat which is important for many
    -- classes.  Zygor allows weighting this so Smartbot offers the same.
    { label = "DPS",             key = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT", primary = {LE_UNIT_STAT_STRENGTH, LE_UNIT_STAT_AGILITY} },
}

-- Helper determining if a stat entry should be shown for the player's
-- current primary stat.  "infoPrimary" may be nil (always show), a single
-- LE_UNIT_STAT_* constant, or a table of such constants.
local function StatAppliesToPrimary(infoPrimary, primaryStat)
    if not infoPrimary or not primaryStat then return true end
    if type(infoPrimary) == "table" then
        for _, stat in ipairs(infoPrimary) do
            if stat == primaryStat then return true end
        end
        return false
    end
    return infoPrimary == primaryStat
end

-- Mapping from equip location to inventory slot IDs.
local INVTYPE_SLOTS = {
    INVTYPE_HEAD        = INVSLOT_HEAD,
    INVTYPE_NECK        = INVSLOT_NECK,
    INVTYPE_SHOULDER    = INVSLOT_SHOULDER,
    INVTYPE_CLOAK       = INVSLOT_BACK,
    INVTYPE_CHEST       = INVSLOT_CHEST,
    INVTYPE_ROBE        = INVSLOT_CHEST,
    INVTYPE_WRIST       = INVSLOT_WRIST,
    INVTYPE_HAND        = INVSLOT_HAND,
    INVTYPE_WAIST       = INVSLOT_WAIST,
    INVTYPE_LEGS        = INVSLOT_LEGS,
    INVTYPE_FEET        = INVSLOT_FEET,
    INVTYPE_FINGER      = {INVSLOT_FINGER1, INVSLOT_FINGER2}, -- multiple slots
    -- Trinkets are handled specially: GetValidSlots returns nil for them and the
    -- upgrade scanner decides which trinket slot to target.  Mapping to the
    -- first slot here mirrors Zygor's data tables and simply validates that
    -- trinkets are equippable items.
    INVTYPE_TRINKET     = INVSLOT_TRINKET1,
    INVTYPE_2HWEAPON    = INVSLOT_MAINHAND,
    INVTYPE_WEAPONMAINHAND = INVSLOT_MAINHAND,
    INVTYPE_WEAPON      = {INVSLOT_MAINHAND, INVSLOT_OFFHAND}, -- one-hand weapon fits either hand
    INVTYPE_WEAPONOFFHAND = INVSLOT_OFFHAND,
    INVTYPE_SHIELD      = INVSLOT_OFFHAND,
    INVTYPE_HOLDABLE    = INVSLOT_OFFHAND,
    INVTYPE_RANGED      = INVSLOT_MAINHAND,
    INVTYPE_RANGEDRIGHT = INVSLOT_MAINHAND,
    INVTYPE_THROWN      = INVSLOT_MAINHAND,
    INVTYPE_BODY        = INVSLOT_BODY,
    INVTYPE_TABARD      = INVSLOT_TABARD,
}

-- Weapon subclasses that Subtlety rogues may only use in the offhand.  Zygor
-- keeps this table shared to avoid re-creating it every query, so Smartbot does
-- the same for minor performance wins.
local ROGUE_OFFHAND_ONLY = {
    [0] = true,  -- Axe
    [4] = true,  -- Mace
    [7] = true,  -- Sword
    [13] = true, -- Fist weapon
}

-- Database schema management.  As new features are added the schema version is
-- incremented and MigrateDB applies any missing defaults.  This keeps existing
-- SavedVariables compatible across addon updates.
local DB_SCHEMA_VERSION = 1
local DEFAULT_LEARN_PARAMS = {
    minLengthSec = 20,
    minEvents = 40,
    lr = 0.02,
    deltaHuber = 300,
    minSamples = 15,
}

local function MigrateDB()
    SmartbotDB = SmartbotDB or {}
    SmartbotDB.schemaVersion = SmartbotDB.schemaVersion or 0

    if SmartbotDB.schemaVersion < DB_SCHEMA_VERSION then
        -- Learning system defaults.  Stored per character so that each toon can
        -- opt-in separately and maintain spec-specific models.
        if SmartbotDB.learnEnabled == nil then
            SmartbotDB.learnEnabled = false
        end
        SmartbotDB.models = SmartbotDB.models or {}
        SmartbotDB.learnParams = SmartbotDB.learnParams or {}
        for k, v in pairs(DEFAULT_LEARN_PARAMS) do
            if SmartbotDB.learnParams[k] == nil then
                SmartbotDB.learnParams[k] = v
            end
        end

        SmartbotDB.schemaVersion = DB_SCHEMA_VERSION
    else
        -- Ensure any missing keys are populated even if schema versions match.
        if SmartbotDB.learnEnabled == nil then
            SmartbotDB.learnEnabled = false
        end
        SmartbotDB.models = SmartbotDB.models or {}
        SmartbotDB.learnParams = SmartbotDB.learnParams or {}
        for k, v in pairs(DEFAULT_LEARN_PARAMS) do
            if SmartbotDB.learnParams[k] == nil then
                SmartbotDB.learnParams[k] = v
            end
        end
    end
end

-- Initializes the SavedVariables table and ensures all defaults are set.
local function InitDB()
    SmartbotDB = SmartbotDB or {}
    SmartbotDB.weights = SmartbotDB.weights or {}
    SmartbotDB.autoEquip = SmartbotDB.autoEquip or false
    -- Whether auto-equip logic should consider trinkets.  Disabled by default
    -- because trinkets often have on-use/proc effects that can't be evaluated
    -- purely by stat weights.
    SmartbotDB.includeTrinkets = SmartbotDB.includeTrinkets or false
    -- When true the options panel shows all stats instead of those relevant to
    -- the player's current specialization.
    SmartbotDB.showAllStats = SmartbotDB.showAllStats or false
    -- Saved angle (in degrees) of the minimap button around the minimap's
    -- edge.  45 degrees puts it in the upper-right quadrant.
    SmartbotDB.minimapPos = SmartbotDB.minimapPos or 45

    -- Apply schema migrations after basic defaults to ensure new fields exist.
    MigrateDB()
end

-- Returns the current player's specialization ID (nil if not available).
local function GetCurrentSpec()
    local specIndex = GetSpecialization()
    if not specIndex then return nil end
    local specID = GetSpecializationInfo(specIndex)
    return specID
end

-- Combat segment handling -------------------------------------------------

local DAMAGE_EVENTS = {
    SWING_DAMAGE = true,
    RANGE_DAMAGE = true,
    SPELL_DAMAGE = true,
    SPELL_PERIODIC_DAMAGE = true,
    DAMAGE_SHIELD = true,
    DAMAGE_SPLIT = true,
}

function Smartbot:StartFeatureSampling()
    if self.featureTicker and self.featureTicker.Cancel then
        self.featureTicker:Cancel()
    end
    self.featureSampler = FeatureSampler:New()
    if C_Timer and C_Timer.NewTicker then
        self.featureTicker = C_Timer.NewTicker(1, function()
            if self.featureSampler then
                self.featureSampler:AddSample()
            end
        end)
    end
end

function Smartbot:StopFeatureSampling()
    if self.featureTicker and self.featureTicker.Cancel then
        self.featureTicker:Cancel()
        self.featureTicker = nil
    end
    if self.featureSampler and self.activeSegment then
        local vec = self.featureSampler:Average(self.activeSegment.avgTargets or 0)
        self.activeSegment.features = vec
    end
    self.featureSampler = nil
end

function Smartbot:LearnCombatStart()
    self.playerGUID = UnitGUID("player")
    self.currentPetGUID = UnitGUID("pet")
    self.activeSegment = Segment:New(GetTime())
    self:StartFeatureSampling()
end

function Smartbot:LearnCombatEnd()
    if not self.activeSegment then return end
    self.activeSegment:Finish(GetTime())
    self:StopFeatureSampling()
    self.lastSegment = self.activeSegment
    if SmartbotDB.learnEnabled then
        self:LearnProcessSegment(self.lastSegment)
    end
    self.activeSegment = nil
end

function Smartbot:LearnFlush()
    if self.activeSegment then
        self:LearnCombatEnd()
    end
end

function Smartbot:LearnProcessSegment(seg)
    if not seg or not SmartbotDB.learnEnabled then return end
    local params = SmartbotDB.learnParams or {}
    local duration = (seg.segEnd or 0) - (seg.segStart or 0)
    if duration < (params.minLengthSec or 0) or seg.events < (params.minEvents or 0)
        or (seg.activeTime or 0) < 1 or (seg.totalDamage or 0) <= 0 then
        local m = GetCurrentModel()
        if m then m.rejected = (m.rejected or 0) + 1 end
        return
    end
    if not seg.features then return end
    local m = GetCurrentModel()
    if not m then return end
    local y = seg.totalDamage / seg.activeTime
    m.accepted = (m.accepted or 0) + 1
    local yhat = m:Update(seg.features, y, seg, params)
    self.lastYHat = yhat
end

function Smartbot:HandleCombatLogEvent(...)
    if not self.activeSegment then return end
    local timestamp, subevent, _, srcGUID, _, _, _, dstGUID, _, dstFlags = ...
    if not DAMAGE_EVENTS[subevent] then return end
    if srcGUID ~= self.playerGUID and srcGUID ~= self.currentPetGUID then return end
    if bit.band(dstFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == 0 then return end
    local amount
    if subevent == "SWING_DAMAGE" then
        amount = select(12, ...)
    else
        amount = select(15, ...)
    end
    self.activeSegment:AddEvent(timestamp, dstGUID, amount or 0)
end

-- Returns whether the current player can dual wield weapons.  Some classes
-- (and even certain specializations) only gain this ability through talents or
-- passives, so we query the API each time instead of caching the result.
-- Returns whether the player can dual wield and whether two handed weapons can
-- be wielded in both hands (Titan's Grip style).  The latter isn't exposed by
-- Blizzard's API so we mirror the logic used by ZygorGuidesViewer for
-- consistency.
function Smartbot:PlayerDualWieldInfo()
    -- Determine class, spec and level every call as talents or shapeshifts may
    -- temporarily alter weapon proficiencies.  This mirrors Zygor's
    -- ItemScore:CanPlayerDualWield behaviour.
    local _, class = UnitClass("player")
    local spec = GetSpecialization()
    local level = UnitLevel("player")

    -- Base result from the native API when available.  This automatically
    -- honours temporary effects such as spells granted by equipment or auras.
    local canDualWield = CanDualWieldFunc and CanDualWieldFunc()
    local canDualTwoHand = false

    -- Fallback to explicit class/spec checks.  These mimic the logic used by
    -- ZygorGuidesViewer's ItemScore module to keep upgrade evaluations in sync.
    if level and level >= 10 then
        if class == "DEATHKNIGHT" and spec == 2 then -- Frost DK
            canDualWield = true
        elseif class == "ROGUE" then -- all rogues
            canDualWield = true
        elseif class == "DEMONHUNTER" then
            canDualWield = true
        elseif class == "WARRIOR" and spec == 2 and level >= 14 then -- Fury
            canDualWield = true
            canDualTwoHand = true -- Titan's Grip
        elseif class == "MONK" and spec == 3 then -- Windwalker
            canDualWield = true
        elseif class == "SHAMAN" and spec == 2 then -- Enhancement
            canDualWield = true
        elseif class == "DRUID" and (spec == 2 or spec == 3) then -- Feral/Guardian
            canDualWield = true
        end
    end

    return (canDualWield and true or false), canDualTwoHand
end

-- Compatibility wrapper used by older logic.  Returns only the dual wield
-- capability since callers historically expected a single boolean.
function Smartbot:PlayerCanDualWield()
    local canDualWield = self:PlayerDualWieldInfo()
    return canDualWield
end

--[[
Determines which equipment slots an item may be equipped in and whether it is
considered a true two handed item for players that cannot dual wield them.  The
logic mirrors ZygorGuidesViewer's ItemScore:GetValidSlots so that Smartbot and
Zygor evaluate gear in the same manner.

Returns: firstSlot, secondSlot, isTwoHander
 * firstSlot  - main inventory slot for the item or nil if not equippable
 * secondSlot - optional secondary slot (offhand, second ring/trinket slot)
 * isTwoHander - true if the item occupies both hands for players without
                 special dual-wield-two-hand ability
--]]
function Smartbot:GetValidSlots(link)
    if not link then return nil end

    local itemID, _, _, equipLoc, _, _, subclassID = GetItemInfoInstant(link)
    -- Bail out early if we don't recognise the equipment type.  This prevents
    -- accidentally trying to equip profession tools or other unsupported gear
    -- types.
    if not equipLoc or not INVTYPE_SLOTS[equipLoc] then return nil end

    -- Helper mirroring Zygor's internal slot resolution.  Most types map
    -- directly via INVTYPE_SLOTS but a few special cases need overriding.
    local function slotsByType(type)
        if type == "INVTYPE_WEAPON" then return INVSLOT_MAINHAND, INVSLOT_OFFHAND end
        if type == "INVTYPE_2HWEAPON" then return INVSLOT_MAINHAND, INVSLOT_OFFHAND end
        if type == "INVTYPE_FINGER" then return INVSLOT_FINGER1, INVSLOT_FINGER2 end
        if type == "INVTYPE_TRINKET" then return false, false end
        if type == "INVTYPE_RANGED" then return INVSLOT_MAINHAND, false end
        if type == "INVTYPE_RANGEDRIGHT" then return INVSLOT_MAINHAND, false end
        if type == "INVTYPE_THROWN" then return INVSLOT_OFFHAND, false end
        return INVTYPE_SLOTS[type], false
    end

    local s1, s2 = slotsByType(equipLoc)

    -- Special handling for a Fury warrior artefact which is flagged as a two
    -- hander but only occupies the main hand.
    if itemID == 128908 then
        return s1, false, true
    end

    local class = select(2, UnitClass("player"))
    local spec = GetSpecialization()
    local level = UnitLevel("player")
    local canDualWield, canDualTwoHand = self:PlayerDualWieldInfo()

    -- Subtlety rogues can only use certain weapon types in the offhand.
    if class == "ROGUE" and spec == 3 and equipLoc == "INVTYPE_WEAPON" and ROGUE_OFFHAND_ONLY[subclassID] then
        return s2, false, false
    end

    -- Outlaw rogues: daggers become offhand only once the spec is chosen.
    if class == "ROGUE" and spec == 2 and equipLoc == "INVTYPE_WEAPON" and subclassID == 15 then
        return s2, (level < 10) and s1 or false, false
    end

    -- Enhancement shamans: daggers are offhand only before level 20.
    if class == "SHAMAN" and spec == 2 and equipLoc == "INVTYPE_WEAPON" and subclassID == 15 then
        return s2, (level < 20) and s1 or false, false
    end

    if equipLoc == "INVTYPE_WEAPON" and canDualWield then
        return s1, s2, false
    end

    if equipLoc == "INVTYPE_2HWEAPON" and canDualTwoHand then
        -- Treat two handers as one handed if the player can dual wield them.
        return s1, s2, false
    end

    if equipLoc == "INVTYPE_2HWEAPON" or equipLoc == "INVTYPE_RANGED" or equipLoc == "INVTYPE_RANGEDRIGHT" then
        return s1, false, true
    end

    if equipLoc == "INVTYPE_WEAPON" and not canDualWield then
        return s1, false, false
    end

    return s1, s2, false
end

-- Retrieves the weight table for the current spec, creating one if necessary.
local function GetCurrentWeights()
    local specID = GetCurrentSpec()
    if not specID then return {} end
    SmartbotDB.weights[specID] = SmartbotDB.weights[specID] or {}
    local weights = SmartbotDB.weights[specID]
    -- Ensure a value exists for every known stat so that tables are persisted
    -- in SavedVariables even if the user leaves some fields empty.
    for _, info in ipairs(STAT_LIST) do
        if weights[info.key] == nil then weights[info.key] = 0 end
    end
    return weights
end

local function GetCurrentModel()
    local specID = GetCurrentSpec()
    if not specID then return nil end
    SmartbotDB.models = SmartbotDB.models or {}
    local m = SmartbotDB.models[specID]
    if m then
        if getmetatable(m) ~= Model then
            setmetatable(m, Model)
        end
    else
        m = Model:New()
        m.deltaHuber = SmartbotDB.learnParams and SmartbotDB.learnParams.deltaHuber or 300
        SmartbotDB.models[specID] = m
    end
    return m
end

-- Evaluates an item link and returns a score based on stat weights and item level.
function Smartbot:EvaluateItem(link)
    if not link or not GetItemStatsFunc then return 0 end
    local stats = GetItemStatsFunc(link)
    if type(stats) ~= "table" then return (select(4, GetItemInfo(link)) or 0) end
    local weights = GetCurrentWeights()
    local score = (select(4, GetItemInfo(link)) or 0)
    for stat, value in pairs(stats) do
        local w = weights[stat]
        if w and value then
            score = score + value * w
        end
    end
    return score or 0
end

function Smartbot:EvaluateItemLearned(link, slot)
    if not (SmartbotDB and SmartbotDB.learnEnabled) then return nil end
    local model = GetCurrentModel()
    local params = SmartbotDB.learnParams or {}
    if not model or model.n < (params.minSamples or 15) then return nil end
    if not link or not GetItemStatsFunc then return nil end
    local stats = GetItemStatsFunc(link)
    if type(stats) ~= "table" then return nil end
    local currentLink = slot and GetInventoryItemLink("player", slot) or nil
    local currentStats = currentLink and GetItemStatsFunc(currentLink) or {}
    local delta = {0,0,0,0,0,0,0,0,0,0}

    if GetSpecialization and GetSpecializationInfo then
        local specIndex = GetSpecialization()
        if specIndex then
            local _,_,_,_,_,primary = GetSpecializationInfo(specIndex)
            local key
            if primary == LE_UNIT_STAT_STRENGTH then key = "ITEM_MOD_STRENGTH_SHORT" end
            if primary == LE_UNIT_STAT_AGILITY then key = "ITEM_MOD_AGILITY_SHORT" end
            if primary == LE_UNIT_STAT_INTELLECT then key = "ITEM_MOD_INTELLECT_SHORT" end
            if key then
                delta[1] = (stats[key] or 0) - (currentStats[key] or 0)
            end
        end
    end

    delta[2] = (stats["ITEM_MOD_CRIT_RATING_SHORT"] or 0) - (currentStats["ITEM_MOD_CRIT_RATING_SHORT"] or 0)
    delta[3] = (stats["ITEM_MOD_HASTE_RATING_SHORT"] or 0) - (currentStats["ITEM_MOD_HASTE_RATING_SHORT"] or 0)
    delta[4] = (stats["ITEM_MOD_MASTERY_RATING_SHORT"] or 0) - (currentStats["ITEM_MOD_MASTERY_RATING_SHORT"] or 0)
    delta[5] = (stats["ITEM_MOD_VERSATILITY"] or 0) - (currentStats["ITEM_MOD_VERSATILITY"] or 0)

    local dps = (stats["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] or 0) - (currentStats["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] or 0)
    if slot == (INVSLOT_MAINHAND or 16) then
        delta[6] = dps
    elseif slot == (INVSLOT_OFFHAND or 17) then
        delta[7] = dps
    else
        local equipLoc = select(9, GetItemInfo(link))
        if equipLoc == "INVTYPE_2HWEAPON" or equipLoc == "INVTYPE_WEAPON" or equipLoc == "INVTYPE_WEAPONMAINHAND" or equipLoc == "INVTYPE_RANGED" or equipLoc == "INVTYPE_RANGEDRIGHT" then
            delta[6] = dps
        elseif equipLoc == "INVTYPE_WEAPONOFFHAND" then
            delta[7] = dps
        end
    end

    local itemLevel = select(4, GetItemInfo(link)) or 0
    local currentLevel = currentLink and (select(4, GetItemInfo(currentLink)) or 0) or 0
    delta[8] = itemLevel - currentLevel

    local ydelta = 0
    for i=1,10 do
        local sd = 0
        if model.n > 0 then
            sd = math.sqrt((model.var[i] or 0) / model.n)
        end
        if sd < 1e-6 then sd = 1e-6 end
        local dHat = delta[i] / sd
        ydelta = ydelta + (model.w[i] or 0) * dHat
    end
    return ydelta
end

-- Determines if the player can equip the provided item link.
function Smartbot:CanEquip(link)
    if not link then return false end
    if not IsEquippableItem(link) then return false end

    -- Retail provides C_PlayerInfo.CanEquipItem which performs the full set of
    -- class, race and proficiency checks.  Fall back gracefully if the API
    -- isn't available (e.g. older clients) and simply assume the item is
    -- usable as long as it passes our manual checks below.
    local itemID = GetItemInfoInstant(link)
    if CanEquipItemFunc and itemID then
        local ok = CanEquipItemFunc(itemID)
        if not ok then return false end
    end

    -- Block too-low character levels
    local reqLevel = select(5, GetItemInfo(link)) or 0
    if UnitLevel("player") < reqLevel then return false end

    -- Must map to a valid equipment slot we handle
    local equipLoc = select(9, GetItemInfo(link))
    if not equipLoc or not INVTYPE_SLOTS[equipLoc] then return false end

    -- Off-hand weapons require the ability to dual wield.  Shields and other
    -- off-hand items use different equipLoc values and are unaffected.
    if equipLoc == "INVTYPE_WEAPONOFFHAND" and not self:PlayerCanDualWield() then
        return false
    end

    return true
end

--[[
Legacy tooltip hook used on client versions that still expose the
`OnTooltipSetItem` script handler.  The heavy lifting is performed by
`Smartbot:AddOrUpdateTooltip` which safely handles asynchronous item
information retrieval and comparison logic.  This wrapper merely fetches the
item link from the tooltip and forwards it to the main handler once the item is
confirmed to be equippable by the player.
--]]
local function AddTooltipInfo(tooltip)
    if not tooltip or not tooltip.GetItem then return end
    local _, itemLink = tooltip:GetItem()
    if not itemLink or not Smartbot:CanEquip(itemLink) then return end
    Smartbot:AddOrUpdateTooltip(tooltip, itemLink)
end


-- Adds or updates Smartbot upgrade information on an item tooltip.  This is
-- used by both modern and legacy tooltip hooks and performs all necessary
-- caching and comparison of equipped items.
function Smartbot:AddOrUpdateTooltip(tooltip, itemLink)
    if not tooltip or not itemLink then return end

    -- Determine whether the item is usable now or only in the future.
    -- Zygor's tooltip logic still evaluates higher-level items and marks
    -- them as future upgrades, so we mirror that behaviour here.
    local canEquip = Smartbot:CanEquip(itemLink)
    local futureprefix, futuresuffix = "", ""
    if not canEquip then
        local reqLevel = select(5, GetItemInfo(itemLink)) or 0
        local playerLevel = UnitLevel("player")
        if IsEquippableItem(itemLink) and reqLevel > playerLevel then
            futureprefix = "Future "
            futuresuffix = "|r in " .. (reqLevel - playerLevel) .. " levels"
        else
            return
        end
    end

    -- Ensure item data is cached; if not, rescan once available.
    local itemObj = Item:CreateFromItemLink(itemLink)
    if not itemObj:IsItemDataCached() then
        itemObj:ContinueOnItemLoad(function()
            if tooltip and tooltip:IsShown() then
                Smartbot:AddOrUpdateTooltip(tooltip, itemLink)
            end
        end)
        return
    end

    -- Determine which slots the item can occupy.
    local equipLoc = select(9, GetItemInfo(itemLink))
    local slot1, slot2 = self:GetValidSlots(itemLink)
    if equipLoc == "INVTYPE_TRINKET" then
        if not SmartbotDB.includeTrinkets then
            tooltip:AddLine(" ")
            tooltip:AddLine("|cfffe6100Smartbot Gear|r")
            tooltip:AddLine("   Trinkets are not part of the Smartbot scoring system.")
            tooltip:Show()
            return
        else
            slot1, slot2 = INVSLOT_TRINKET1, INVSLOT_TRINKET2
        end
    end
    if not slot1 then return end

    -- Ensure information about currently equipped items is cached.
    local function ensureEquippedSlotCached(invSlot)
        local curLink = GetInventoryItemLink("player", invSlot)
        if not curLink then return true end
        local curObj = Item:CreateFromItemLink(curLink)
        if curObj:IsItemDataCached() then return true end
        curObj:ContinueOnItemLoad(function()
            if tooltip and tooltip:IsShown() then
                Smartbot:AddOrUpdateTooltip(tooltip, itemLink)
            end
        end)
        return false
    end
    if not ensureEquippedSlotCached(slot1) then return end
    if slot2 and not ensureEquippedSlotCached(slot2) then return end
    local learned1 = slot1 and self:EvaluateItemLearned(itemLink, slot1) or nil
    local learned2 = slot2 and self:EvaluateItemLearned(itemLink, slot2) or nil
    if learned1 or learned2 then
        tooltip:AddLine(" ")
        tooltip:AddLine("|cfffe6100Smartbot Gear|r")
        if learned1 then
            tooltip:AddLine(string.format("  Slot 1 ΔDPS: %.1f", learned1))
        end
        if learned2 then
            tooltip:AddLine(string.format("  Slot 2 ΔDPS: %.1f", learned2))
        end
        tooltip:Show()
        return
    end

    local candidateScore = Smartbot:EvaluateItem(itemLink)

    ---------------------------------------------------------------------
    -- Helpers for percentage math and icon selection mirroring Zygor. --
    ---------------------------------------------------------------------
    local function get_change(old, new)
        if old and old > 0 then
            return math.floor(((new * 100 / old) - 100) * 100) / 100
        else
            return 100
        end
    end

    local function icon_for_change(change)
        local width, height = 10, 10
        local icons = ZGV and ZGV.IconSets and ZGV.IconSets.AuctionToolsPriceIcons
        if icons then
            if change < 0 then
                return icons.DOWN1:GetFontString(width, height, nil, nil, 255, 0, 0)
            elseif change > 0 and change < 100 then
                return icons.UP1:GetFontString(width, height, nil, nil, 0, 255, 0)
            elseif change > 99 and change < 200 then
                return icons.UP2:GetFontString(width, height, nil, nil, 0, 255, 0)
            elseif change > 199 then
                return icons.UP3:GetFontString(width, height, nil, nil, 0, 255, 0)
            else
                return icons.BULLET:GetFontString(width, height, nil, nil, 155, 155, 155)
            end
        end
        if change < 0 then
            return "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up:10:10"
        elseif change > 0 then
            return "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up:10:10"
        else
            return "Interface\\FriendsFrame\\StatusIcon-Offline:10:10"
        end
    end

    -- Build tooltip lines.
    local slotinfo1 = slot2 and "Slot 1: " or ""
    local slotinfo2 = slot2 and "Slot 2: " or ""

    tooltip:AddLine(" ")
    tooltip:AddLine("|cfffe6100Smartbot Gear|r")

    -- Slot 1 comparison -------------------------------------------------
    local currentLink1 = GetInventoryItemLink("player", slot1)
    if currentLink1 and currentLink1 == itemLink then
        tooltip:AddLine("|r  " .. slotinfo1 .. "Equipped")
    else
        local currentScore1 = Smartbot:EvaluateItem(currentLink1)
        local change1 = get_change(currentScore1, candidateScore)
        local icon1 = icon_for_change(change1)
        local line1 = "|r  " .. slotinfo1 .. futureprefix .. ((change1 > 0) and
            "Upgrade: |T" .. icon1 .. "|t |cff00ff00" or
            "Downgrade: |T" .. icon1 .. "|t |cffff0000")
        line1 = line1 .. futuresuffix .. (change1 > 999 and "999+" or change1) .. "% "
        tooltip:AddLine(line1)
    end

    -- Slot 2 comparison (if applicable) --------------------------------
    if slot2 then
        local currentLink2 = GetInventoryItemLink("player", slot2)
        if currentLink2 and currentLink2 == itemLink then
            tooltip:AddLine("|r  " .. slotinfo2 .. "Equipped")
        else
            local currentScore2 = Smartbot:EvaluateItem(currentLink2)
            local change2 = get_change(currentScore2, candidateScore)
            local icon2 = icon_for_change(change2)
            local line2 = "|r  " .. slotinfo2 .. futureprefix .. ((change2 > 0) and
                "Upgrade: |T" .. icon2 .. "|t |cff00ff00" or
                "Downgrade: |T" .. icon2 .. "|t |cffff0000")
            line2 = line2 .. futuresuffix .. (change2 > 999 and "999+" or change2) .. "% "
            tooltip:AddLine(line2)
        end
    end

    tooltip:Show()
end



-- Initializes tooltip hooks in a version-safe manner. Retail removed the
-- OnTooltipSetItem script handler in Dragonflight, requiring TooltipDataProcessor
-- for item tooltips. Classic clients still use the legacy hook.  This function
-- ensures the hook is only added once and only if the relevant API exists.
function Smartbot:InitTooltipHooks()
    if self.tooltipHooked then return end

    if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
        -- Retail: hook via TooltipDataProcessor.
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
            -- Prefer the hyperlink from data, then ID->link, then tooltip:GetItem
            local link = (data and data.hyperlink)
                      or (data and data.id and select(2, GetItemInfo(data.id)))
                      or (tooltip and tooltip.GetItem and select(2, tooltip:GetItem()))
            if link then
                Smartbot:AddOrUpdateTooltip(tooltip, link)
            end
        end)
        self.tooltipHooked = true
    else
        -- Classic-era fallback: use legacy OnTooltipSetItem scripts only if they exist.
        if GameTooltip and GameTooltip.HookScript and GameTooltip.HasScript and GameTooltip:HasScript("OnTooltipSetItem") then
            GameTooltip:HookScript("OnTooltipSetItem", AddTooltipInfo)
        end
        if ItemRefTooltip and ItemRefTooltip.HookScript and ItemRefTooltip.HasScript and ItemRefTooltip:HasScript("OnTooltipSetItem") then
            ItemRefTooltip:HookScript("OnTooltipSetItem", AddTooltipInfo)
        end
        self.tooltipHooked = true
    end
end

-- Schedules a debounced bag scan. Multiple requests within the debounce window
-- coalesce into a single ScanBags call.  If an equip is currently in flight the
-- actual scan is deferred until it completes.
function Smartbot:RequestRescan()
    self.rescanRequested = true
    if not self.debounceHandle then
        self.debounceHandle = C_Timer.NewTimer(0.2, function()
            self.debounceHandle = nil
            if self.rescanRequested and not self.equipInFlight then
                self.rescanRequested = false
                self:ScanBags()
            end
        end)
    end
end

-- Processes the next queued upgrade, equipping one item at a time.  Equip
-- confirmation is handled via PLAYER_EQUIPMENT_CHANGED or a timeout.
function Smartbot:ProcessNextInQueue()
    if self.equipInFlight then return end

    local entry = table.remove(self.equipQueue, 1)
    if not entry then
        -- If more bag changes arrived while equipping, schedule a rescan now.
        if self.rescanRequested then
            self:RequestRescan()
        end
        return
    end

    EquipItemByName(entry.link, entry.targetSlot)

    self.equipInFlight = {
        slot = entry.targetSlot,
        itemID = select(1, GetItemInfoInstant(entry.link)),
        link = entry.link,
    }

    self.equipInFlight.timeout = C_Timer.NewTimer(1.0, function()
        if self.equipInFlight then
            self.failedUpgrades[self.equipInFlight.link] = true
            self.equipInFlight = nil
            self:ProcessNextInQueue()
        end
    end)
end

-- Scans the player's bags for potential upgrades based on stat weights.
function Smartbot:ScanBags(force)
    if (not force and not SmartbotDB.autoEquip)
        or InCombatLockdown()
        or self.isScanning
        or self.equipInFlight ~= nil then
        return
    end

    self.isScanning = true
    self.equipQueue = {}

    local bestBySlot = {}
    local ringCandidates = {}
    local trinketCandidates = {}
    local includeTrinkets = SmartbotDB.includeTrinkets
    local twoHandSelected = false

    self.pendingItemLoad = self.pendingItemLoad or {}

    -- Precompute current scores for ring and trinket slots.
    local currentScores = {}
    currentScores[INVSLOT_FINGER1] = self:EvaluateItem(GetInventoryItemLink("player", INVSLOT_FINGER1))
    currentScores[INVSLOT_FINGER2] = self:EvaluateItem(GetInventoryItemLink("player", INVSLOT_FINGER2))
    currentScores[INVSLOT_TRINKET1] = self:EvaluateItem(GetInventoryItemLink("player", INVSLOT_TRINKET1))
    currentScores[INVSLOT_TRINKET2] = self:EvaluateItem(GetInventoryItemLink("player", INVSLOT_TRINKET2))
    currentScores[INVSLOT_MAINHAND] = self:EvaluateItem(GetInventoryItemLink("player", INVSLOT_MAINHAND))
    currentScores[INVSLOT_OFFHAND] = self:EvaluateItem(GetInventoryItemLink("player", INVSLOT_OFFHAND))
    
    -- Determine if a two handed weapon is currently equipped.  If so, we
    -- suppress evaluation of off-hand items to avoid equip loops.
    local equippedMH = GetInventoryItemLink("player", INVSLOT_MAINHAND)
    if equippedMH then
        local _, _, mhTwoHand = self:GetValidSlots(equippedMH)
        if mhTwoHand then
            twoHandSelected = true
        end
    end

    -- Pre-seed single-slot scores so we rarely hit the lazy path
    local singles = {
        INVSLOT_HEAD, INVSLOT_NECK, INVSLOT_SHOULDER, INVSLOT_BACK,
        INVSLOT_CHEST, INVSLOT_WRIST, INVSLOT_HAND, INVSLOT_WAIST,
        INVSLOT_LEGS, INVSLOT_FEET,
    }
    for _, invSlot in ipairs(singles) do
        if currentScores[invSlot] == nil then
            currentScores[invSlot] = self:EvaluateItem(GetInventoryItemLink("player", invSlot)) or 0
        end
    end

    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemLink = C_Container.GetContainerItemLink(bag, slot)

            local skipItem = false
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.isLocked then
                skipItem = true
            end

            if itemLink then
                if self.failedUpgrades[itemLink] then
                    skipItem = true
                else
                    local name = GetItemInfo(itemLink)
                    if not name then
                        if not self.pendingItemLoad[itemLink] then
                            self.pendingItemLoad[itemLink] = true
                            local obj = Item:CreateFromItemLink(itemLink)
                            obj:ContinueOnItemLoad(function()
                                self.pendingItemLoad[itemLink] = nil
                                Smartbot:RequestRescan()
                            end)
                        end
                        skipItem = true
                    end
                end
            end

            if not skipItem and itemLink and self:CanEquip(itemLink) then
                local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(itemLink)
                local slot1, slot2, isTwoHand = self:GetValidSlots(itemLink)
                if equipLoc == "INVTYPE_TRINKET" then
                    if not includeTrinkets then
                        slot1, slot2 = nil, nil
                    else
                        slot1, slot2 = INVSLOT_TRINKET1, INVSLOT_TRINKET2
                    end
                end

                if slot1 then
                    local candidateScore = self:EvaluateItem(itemLink)

                    if slot2 and equipLoc == "INVTYPE_FINGER" then
                        local ldelta1 = self:EvaluateItemLearned(itemLink, slot1)
                        local ldelta2 = self:EvaluateItemLearned(itemLink, slot2)
                        local delta1 = ldelta1 or (candidateScore - currentScores[slot1])
                        local delta2 = ldelta2 or (candidateScore - currentScores[slot2])
                        if ringCandidates[slot1] and ringCandidates[slot1].delta >= delta1 then delta1 = -math.huge end
                        if ringCandidates[slot2] and ringCandidates[slot2].delta >= delta2 then delta2 = -math.huge end
                        local targetSlot, delta
                        if delta1 >= delta2 then
                            targetSlot, delta = slot1, delta1
                        else
                            targetSlot, delta = slot2, delta2
                        end
                        if delta > 0 then
                            ringCandidates[targetSlot] = {bag=bag, slot=slot, targetSlot=targetSlot, link=itemLink, delta=delta}
                        end
                    elseif slot2 and equipLoc == "INVTYPE_TRINKET" then
                        local ldelta1 = self:EvaluateItemLearned(itemLink, slot1)
                        local ldelta2 = self:EvaluateItemLearned(itemLink, slot2)
                        local delta1 = ldelta1 or (candidateScore - currentScores[slot1])
                        local delta2 = ldelta2 or (candidateScore - currentScores[slot2])
                        if trinketCandidates[slot1] and trinketCandidates[slot1].delta >= delta1 then delta1 = -math.huge end
                        if trinketCandidates[slot2] and trinketCandidates[slot2].delta >= delta2 then delta2 = -math.huge end
                        local targetSlot, delta
                        if delta1 >= delta2 then
                            targetSlot, delta = slot1, delta1
                        else
                            targetSlot, delta = slot2, delta2
                        end
                        if delta > 0 then
                            trinketCandidates[targetSlot] = {bag=bag, slot=slot, targetSlot=targetSlot, link=itemLink, delta=delta}
                        end
                    elseif slot2 then
                        if not twoHandSelected then
                            for _, invSlot in ipairs({slot1, slot2}) do
                                local ldelta = self:EvaluateItemLearned(itemLink, invSlot)
                                local delta = ldelta or (candidateScore - currentScores[invSlot])
                                if delta > 0 and (not bestBySlot[invSlot] or delta > bestBySlot[invSlot].delta) then
                                    bestBySlot[invSlot] = {bag=bag, slot=slot, targetSlot=invSlot, link=itemLink, delta=delta}
                                end
                            end
                        end
                    else
                        if isTwoHand then
                            local ldelta = self:EvaluateItemLearned(itemLink, INVSLOT_MAINHAND)
                            local delta = ldelta or (candidateScore - currentScores[INVSLOT_MAINHAND])
                            if delta > 0 then
                                twoHandSelected = true
                                bestBySlot[INVSLOT_MAINHAND] = {bag=bag, slot=slot, targetSlot=slot1, link=itemLink, delta=delta}
                                bestBySlot[INVSLOT_OFFHAND] = nil
                            end
                        else
                            if twoHandSelected and (slot1 == INVSLOT_MAINHAND or slot1 == INVSLOT_OFFHAND) then
                                -- ignore off-hand items when a two hander is selected
                            else
                                local currentScore = currentScores[slot1]
                                if currentScore == nil then
                                    currentScore = self:EvaluateItem(GetInventoryItemLink("player", slot1)) or 0
                                    currentScores[slot1] = currentScore
                                end
                                local ldelta = self:EvaluateItemLearned(itemLink, slot1)
                                local delta = ldelta or (candidateScore - currentScore)
                                if delta > 0 and (not bestBySlot[slot1] or delta > bestBySlot[slot1].delta) then
                                    bestBySlot[slot1] = {bag=bag, slot=slot, targetSlot=slot1, link=itemLink, delta=delta}
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    for _, entry in pairs(bestBySlot) do table.insert(self.equipQueue, entry) end
    for _, entry in pairs(ringCandidates) do table.insert(self.equipQueue, entry) end
    for _, entry in pairs(trinketCandidates) do table.insert(self.equipQueue, entry) end

    table.sort(self.equipQueue, function(a,b) return a.delta > b.delta end)

    self.isScanning = false

    self:ProcessNextInQueue()
end

-- Starts or stops the scanning ticker depending on the autoEquip setting.
function Smartbot:UpdateTicker()
    if self.ticker then
        self.ticker:Cancel()
        self.ticker = nil
    end
    if SmartbotDB.autoEquip then
        -- Periodic safety net; actual work is event driven. Throttled to keep
        -- CPU usage minimal.
        self.ticker = C_Timer.NewTicker(2, function() Smartbot:ScanBags() end)
    end
end

-- Creates a minimap button that opens the options panel when clicked.  The
-- button can be dragged around the minimap and its position is saved between
-- sessions.
function Smartbot:CreateMinimapButton()
    if self.minimapButton then
        -- Button already exists; just ensure it's in the right spot.
        self.minimapButton:UpdatePosition()
        return
    end

    local button = CreateFrame("Button", "SmartbotMinimapButton", Minimap)
    button:SetSize(32, 32)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)
    button:RegisterForClicks("LeftButtonUp")
    button:RegisterForDrag("LeftButton")
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    icon:SetSize(20, 20)
    icon:SetPoint("CENTER")

    button:SetScript("OnClick", function() Smartbot:OpenOptions() end)

    local RADIUS_ADJ = -5

    local function UpdatePosition()
        local angle = SmartbotDB.minimapPos or 45
        local minimap = Minimap
        local radius = (minimap:GetWidth() + button:GetWidth()) / 2 + RADIUS_ADJ
        local x = radius * math.cos(math.rad(angle))
        local y = radius * math.sin(math.rad(angle))
        -- Clear any previous anchors (such as those created by StartMoving) to
        -- avoid "anchor family connection" errors when reattaching to the
        -- minimap.  Without this the button could remain anchored to UIParent,
        -- causing SetPoint to fail once dragging stops.
        button:ClearAllPoints()
        button:SetPoint("CENTER", minimap, "CENTER", x, y)
    end
    button.UpdatePosition = UpdatePosition
    UpdatePosition()

    button:SetMovable(true)

    local function OnUpdate(self)
        if self.dragging then
            local minimap = self:GetParent()
            local radius = (minimap:GetWidth() + self:GetWidth()) / 2
            local width = self:GetWidth()
            local x,y = minimap:GetCenter()
            local sc = minimap:GetEffectiveScale()
            local mx,my = GetCursorPosition()
            -- Normalize cursor coordinates by the minimap's scale so dragging
            -- works regardless of UI scale settings.  Use a semicolon to
            -- explicitly separate the two assignments for clarity.
            mx = mx / sc; my = my / sc
            local dx,dy = mx-x, my-y
            local dist = (dx*dx+dy*dy)^0.5

            local radmin = radius + RADIUS_ADJ
            local radsnap = radius + width*0.2
            local radpull = radius + width*0.7
            local radfre  = radius + width

            local radclamp
            if dist<=radsnap then self.snapped=true radclamp=radmin
            elseif dist<radpull and self.snapped then radclamp=radmin
            elseif dist<radfre and self.snapped then radclamp=radmin+(dist-radpull)/2
            else self.snapped=false
            end

            if radclamp then
                dx=dx/(dist/radclamp)
                dy=dy/(dist/radclamp)
            end

            self:ClearAllPoints()
            self:SetPoint("CENTER", minimap, "CENTER", dx, dy)

            SmartbotDB.minimapPos = (math.deg(math.atan2(dy, dx)) + 360) % 360
        end
    end
    button:SetScript("OnUpdate", OnUpdate)

    button:SetScript("OnDragStart", function(self)
        self.dragging = true
        self:StartMoving()
    end)
    button:SetScript("OnDragStop", function(self)
        self.dragging = false
        self:StopMovingOrSizing()
        UpdatePosition()
    end)

    self.minimapButton = button
end

-- Creates the options panel with UI elements for stat weights and auto-equip toggle.
-- Creates an options panel and registers it with Blizzard's settings system.
-- Retail (Dragonflight+) replaced the old InterfaceOptions API with the new
-- Settings API.  To stay compatible with both versions we try the new API
-- first and fall back to the old calls if available.
function Smartbot:CreateOptions()
    -- Parent is nil so that the panel works with both InterfaceOptions and
    -- the new Settings panel.  A global name allows slash commands to open it.
    local panel = CreateFrame("Frame", "SmartbotOptionsPanel")
    panel.name = "Smartbot"

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Smartbot")

    local autoEquip = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    autoEquip:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
    autoEquip.Text:SetText("Auto equip upgrades")
    autoEquip:SetChecked(SmartbotDB.autoEquip)
    autoEquip:SetScript("OnClick", function(self)
        SmartbotDB.autoEquip = self:GetChecked()
        Smartbot:UpdateTicker()
    end)

    -- Optional checkbox to include trinkets in auto-equip logic.  Many trinkets
    -- have special effects that can't be evaluated from stats alone, so this
    -- is disabled by default and left to user discretion.
    local includeTrinkets = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    includeTrinkets:SetPoint("TOPLEFT", autoEquip, "BOTTOMLEFT", 0, -8)
    includeTrinkets.Text:SetText("Include trinkets")
    includeTrinkets:SetScript("OnClick", function(self)
        SmartbotDB.includeTrinkets = self:GetChecked()
    end)

    -- Checkbox to toggle displaying all stats.  When unchecked only stats
    -- relevant to the player's primary stat are shown, similar to Zygor's UI.
    local showAllStats = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    showAllStats:SetPoint("TOPLEFT", includeTrinkets, "BOTTOMLEFT", 0, -8)
    showAllStats.Text:SetText("Show all stats")
    showAllStats:SetScript("OnClick", function(self)
        SmartbotDB.showAllStats = self:GetChecked()
        panel.refresh()
    end)

    -- Master toggle for the learning system added in later stages.  When
    -- disabled Smartbot behaves exactly as it did before learning support.
    local learnEnabled = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    learnEnabled:SetPoint("TOPLEFT", showAllStats, "BOTTOMLEFT", 0, -8)
    learnEnabled.Text:SetText("Enable learning")
    learnEnabled:SetScript("OnClick", function(self)
        SmartbotDB.learnEnabled = self:GetChecked()
    end)

    -- Reset button for clearing the learned model for the current spec.
    local learnReset = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    learnReset:SetSize(140, 22)
    learnReset:SetPoint("LEFT", learnEnabled, "RIGHT", 10, 0)
    learnReset:SetText("Reset learning")
    learnReset:SetScript("OnClick", function()
        Smartbot:LearnReset()
        panel.refresh()
    end)

    panel.labels = {}
    local modelStats = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    modelStats:SetPoint("TOPLEFT", learnEnabled, "BOTTOMLEFT", 0, -40)
    modelStats:SetJustifyH("LEFT")
    panel.modelStats = modelStats
    panel.editBoxes = {}

    -- Create controls for every stat up front.  Their visibility and positions
    -- will be adjusted in panel.refresh based on the player's current spec.
    for _, info in ipairs(STAT_LIST) do
        local label = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        label:SetText(info.label)
        panel.labels[info.key] = label

        local box = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
        box:SetAutoFocus(false)
        box:SetWidth(60)
        box:SetHeight(20)
        panel.editBoxes[info.key] = box

        box:SetScript("OnEnterPressed", function(self)
            local num = tonumber(self:GetText()) or 0
            local weights = GetCurrentWeights()
            weights[info.key] = num
            self:ClearFocus()
        end)
        box:SetScript("OnEditFocusLost", box:GetScript("OnEnterPressed"))
    end

    panel.refresh = function()
        -- Called when the panel is shown.  Populate values for current spec and
        -- hide stats that aren't relevant to the specialization's primary stat.
        -- When "Show all stats" is unchecked we mimic Zygor's behaviour by
        -- showing only statistics appropriate for the player's current class
        -- and specialization.  Unlike the initial version which hid every stat
        -- unless it already had a positive weight, this mirrors Zygor's UI by
        -- always displaying stats tied to the spec's primary attribute while
        -- still allowing secondary/unused stats to remain hidden unless the
        -- user enables "Show all stats".
        local weights = GetCurrentWeights()
        local specIndex = GetSpecialization()
        local primaryStat = specIndex and select(6, GetSpecializationInfo(specIndex)) or nil

        learnEnabled:SetChecked(SmartbotDB.learnEnabled)
        learnReset:Disable()

        local last = learnEnabled
        for _, info in ipairs(STAT_LIST) do
            local label = panel.labels[info.key]
            local box = panel.editBoxes[info.key]

            local show
            if SmartbotDB.showAllStats then
                show = true
            else
                -- When unchecked display stats that apply to the current
                -- specialization's primary attribute or have a user supplied
                -- non-zero weight.  This matches the discrimination used by
                -- Zygor where only relevant stats appear by default but users
                -- can still reveal everything with the checkbox.
                show = (info.always and StatAppliesToPrimary(info.primary, primaryStat))
                    or (info.primary and StatAppliesToPrimary(info.primary, primaryStat))
                    or (weights[info.key] or 0) > 0
            end

            if show then
                label:Show()
                box:Show()
                label:ClearAllPoints()
                label:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -8)
                box:ClearAllPoints()
                box:SetPoint("LEFT", label, "RIGHT", 10, 0)
                last = label

                local val = weights[info.key] or 0
                box:SetText(tostring(val))
            else
                label:Hide()
                box:Hide()
            end
        end

        autoEquip:SetChecked(SmartbotDB.autoEquip)
        includeTrinkets:SetChecked(SmartbotDB.includeTrinkets)
        showAllStats:SetChecked(SmartbotDB.showAllStats)

        local model = GetCurrentModel()
        if model and model.n > 0 then
            local lines = {}
            table.insert(lines, string.format("Samples: %d (accepted %d / rejected %d)", model.n, model.accepted or 0, model.rejected or 0))
            table.insert(lines, string.format("maeEWMA: %.1f", model.maeEWMA or 0))
            local order = {}
            for i=1,#model.featureNames do order[i]=i end
            table.sort(order, function(a,b) return math.abs(model.w[a] or 0) > math.abs(model.w[b] or 0) end)
            for i=1,math.min(5,#order) do
                local idx = order[i]
                local mean = model.mean[idx] or 0
                local var = model.var[idx] and (model.var[idx]/model.n) or 0
                table.insert(lines, string.format("%s: %.3f (mean %.1f var %.1f)", model.featureNames[idx], model.w[idx] or 0, mean, var))
            end
            modelStats:SetText(table.concat(lines, "\n"))
        else
            modelStats:SetText("No learning data")
        end
    end
    panel:SetScript("OnShow", panel.refresh)

    -- Register panel with whichever options system is available.
    if Settings and Settings.RegisterCanvasLayoutCategory then
        local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
        Smartbot.optionsCategoryID = category:GetID()
        Settings.RegisterAddOnCategory(category)
    elseif InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(panel)
    else
        -- If neither API exists, still create the frame so slash commands can
        -- show it via :Show().  This shouldn't happen on Retail but guards
        -- against future API changes.
        panel:Hide()
    end
end

-- Opens the options panel using the appropriate API.
function Smartbot:OpenOptions()
    if self.optionsCategoryID and Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(self.optionsCategoryID)
    elseif InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory("Smartbot")
    elseif SmartbotOptionsPanel then
        -- As a last resort simply show the panel.
        SmartbotOptionsPanel:Show()
    end
end

-- Placeholder stubs for the learning subsystem.  These will be fleshed out in
-- later stages as functionality is implemented.
function Smartbot:LearnReset()
    local spec = GetCurrentSpec()
    if spec and SmartbotDB.models then
        SmartbotDB.models[spec] = nil
        print("Smartbot: learning data reset for spec", spec)
    else
        print("Smartbot: no learning data to reset")
    end
end

function Smartbot:LearnStats()
    local seg = self.lastSegment
    if not seg or not seg.features then
        print("Smartbot: no combat segment recorded")
        return
    end
    local y = seg.totalDamage / (seg.activeTime > 0 and seg.activeTime or 1)
    local yhat = self.lastYHat or 0
    local m = GetCurrentModel()
    local err = math.abs(y - yhat)
    local parts = {}
    for i, v in ipairs(seg.features) do parts[i] = string.format("%.2f", v) end
    print("x={" .. table.concat(parts, ",") .. "}")
    print(string.format("y=%.1f yhat=%.1f |e|=%.1f maeEWMA=%.1f", y, yhat, err, m and (m.maeEWMA or 0) or 0))
end

function Smartbot:LearnScore(arg)
    local link
    if arg and arg ~= "" then
        link = arg
    else
        local focus = GetMouseFocus()
        if focus and focus.GetItem then _, link = focus:GetItem() end
        if not link and GameTooltip and GameTooltip.GetItem then _, link = GameTooltip:GetItem() end
    end
    if not link then
        print("Smartbot: no item to score")
        return
    end
    if not self:CanEquip(link) then
        print("Smartbot: item not equippable")
        return
    end
    local slot1, slot2 = self:GetValidSlots(link)
    local d1 = slot1 and self:EvaluateItemLearned(link, slot1)
    local d2 = slot2 and self:EvaluateItemLearned(link, slot2)
    if d1 then
        print(string.format("slot %d ΔDPS %.1f", slot1, d1))
    end
    if d2 then
        print(string.format("slot %d ΔDPS %.1f", slot2, d2))
    end
    if not d1 and not d2 then
        print("Smartbot: model not ready")
    end
end

function Smartbot:LearnExport()
    local m = GetCurrentModel()
    if not m or m.n == 0 then
        print("Smartbot: no model to export")
        return
    end
    local s = m:Export()
    if s then
        print("Smartbot export:")
        print(s)
    else
        print("Smartbot: export failed")
    end
end

function Smartbot:LearnImport(data)
    if not data or data == "" then
        print("Smartbot: no data provided")
        return
    end
    local m, err = Model.Import(data)
    if not m then
        print("Smartbot: import failed", err)
        return
    end
    local spec = GetCurrentSpec()
    if not spec then
        print("Smartbot: cannot determine spec")
        return
    end
    SmartbotDB.models = SmartbotDB.models or {}
    SmartbotDB.models[spec] = m
    print(string.format("Smartbot: model imported (n=%d)", m.n or 0))
end

-- Event handler frame to catch game events.
local eventFrame = CreateFrame("Frame")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and ... == Smartbot.name then
        InitDB()
        GetCurrentWeights() -- ensure tables exist for current spec
        Smartbot:CreateOptions()
        Smartbot:UpdateTicker()
        Smartbot:CreateMinimapButton()
        Smartbot:InitTooltipHooks()
        Smartbot.failedUpgrades = {}
        Smartbot.isScanning = false
        Smartbot.equipQueue = {}
        Smartbot.equipInFlight = nil
        Smartbot.rescanRequested = false
        Smartbot.debounceHandle = nil
        Smartbot.pendingItemLoad = {}
        Smartbot.playerGUID = UnitGUID("player")
        Smartbot.currentPetGUID = UnitGUID("pet")
        Smartbot:RequestRescan()
    elseif event == "PLAYER_SPECIALIZATION_CHANGED" and ... == "player" then
        Smartbot:LearnFlush()
        GetCurrentWeights()
        if SmartbotOptionsPanel and SmartbotOptionsPanel.refresh then
            SmartbotOptionsPanel.refresh()
        end
        Smartbot.failedUpgrades = {}
        Smartbot.equipQueue = {}
        Smartbot.equipInFlight = nil
        Smartbot.pendingItemLoad = {}
        Smartbot:RequestRescan()
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        local slotId = ...
        if Smartbot.equipInFlight and slotId == Smartbot.equipInFlight.slot then
            if Smartbot.equipInFlight.timeout and Smartbot.equipInFlight.timeout.Cancel then
                Smartbot.equipInFlight.timeout:Cancel()
            end
            local haveID = GetInventoryItemID("player", slotId)
            if haveID == Smartbot.equipInFlight.itemID then
                Smartbot.equipInFlight = nil
            else
                Smartbot.failedUpgrades[Smartbot.equipInFlight.link] = true
                Smartbot.equipInFlight = nil
            end
            Smartbot:ProcessNextInQueue()
            if Smartbot.rescanRequested and not Smartbot.debounceHandle and not Smartbot.equipInFlight then
                Smartbot:RequestRescan()
            end
        end
    elseif event == "BAG_UPDATE_DELAYED" then
        if Smartbot.equipInFlight then
            Smartbot.rescanRequested = true
        else
            Smartbot:RequestRescan()
        end
    elseif event == "PLAYER_REGEN_DISABLED" then
        Smartbot:LearnCombatStart()
    elseif event == "PLAYER_REGEN_ENABLED" then
        Smartbot:LearnCombatEnd()
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        Smartbot:HandleCombatLogEvent(CombatLogGetCurrentEventInfo())
    elseif event == "UNIT_PET" and ... == "player" then
        Smartbot.currentPetGUID = UnitGUID("pet")
    elseif event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_DEAD" or event == "PLAYER_UNGHOST" then
        Smartbot:LearnFlush()
    end
end)

-- Register events
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:RegisterEvent("UNIT_PET")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:RegisterEvent("PLAYER_DEAD")
eventFrame:RegisterEvent("PLAYER_UNGHOST")

-- Expose slash commands for manual access
SLASH_SMARTBOT1 = "/smartbot"
SLASH_SMARTBOT2 = "/sb"

SlashCmdList["SMARTBOT"] = function(msg)
    msg = msg and msg:lower() or ""
    local cmd, rest = msg:match("^(%S*)%s*(.*)$")
    if cmd == "scan" then
        Smartbot:ScanBags(true)
    elseif cmd == "auto" then
        SmartbotDB.autoEquip = not SmartbotDB.autoEquip
        print("Smartbot auto equip:", SmartbotDB.autoEquip and "enabled" or "disabled")
        Smartbot:UpdateTicker()
    elseif cmd == "options" or cmd == "config" or cmd == "" then
        Smartbot:OpenOptions()
    elseif cmd == "score" then
        Smartbot:LearnScore(rest)
    elseif cmd == "learn" then
        local sub, arg = rest:match("^(%S*)%s*(.*)$")
        if sub == "on" then
            SmartbotDB.learnEnabled = true
            print("Smartbot learning: enabled")
        elseif sub == "off" then
            SmartbotDB.learnEnabled = false
            print("Smartbot learning: disabled")
        elseif sub == "reset" then
            Smartbot:LearnReset()
        elseif sub == "stats" then
            Smartbot:LearnStats()
        elseif sub == "score" then
            Smartbot:LearnScore(arg)
        elseif sub == "export" then
            Smartbot:LearnExport()
        elseif sub == "import" then
            Smartbot:LearnImport(arg)
        else
            print("Smartbot learn commands:")
            print("/sb learn on - enable learning")
            print("/sb learn off - disable learning")
            print("/sb learn reset - reset model for current spec")
            print("/sb learn stats - show learning stats")
            print("/sb learn score - score hovered item")
            print("/sb learn export - export model")
            print("/sb learn import <data> - import model")
        end
    else
        print("Smartbot commands:")
        print("/sb scan - scan bags now")
        print("/sb auto - toggle auto equip")
        print("/sb options - open the options panel")
        print("/sb score - score hovered item with learned model")
        print("/sb learn <cmd> - learning subsystem commands")
        print("Use the options panel to set stat weights per specialization.")
    end
end

return Smartbot
