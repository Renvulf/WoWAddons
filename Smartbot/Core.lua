local addonName, Smartbot = ...
_G.Smartbot = Smartbot

Smartbot.SCHEMA_VERSION = 1

local API = Smartbot.API
local CreateFrame = API:Resolve('CreateFrame') or CreateFrame
local InCombatLockdown = API:Resolve('InCombatLockdown') or InCombatLockdown
local UnitAffectingCombat = API:Resolve('UnitAffectingCombat') or UnitAffectingCombat
local EquipItemByName = API:Resolve('EquipItemByName') or EquipItemByName
local C_Timer_After = API:Resolve('C_Timer.After') or (C_Timer and C_Timer.After)

local eventFrame = CreateFrame("Frame")
local equipQueue = {}

Smartbot.db = SmartbotDB or {}
local defaults = {
    version = Smartbot.SCHEMA_VERSION,
    profile = {
        autoEquip = false,
        minDelta = 10,
        verbosity = 1,
    },
    weights = {},
    modelMeta = {},
}

local function copyDefaults(dst, src)
    for k, v in pairs(src) do
        if type(v) == "table" then
            if type(dst[k]) ~= "table" then dst[k] = {} end
            copyDefaults(dst[k], v)
        elseif dst[k] == nil then
            dst[k] = v
        end
    end
end

local function migrate(db, old)
    old = old or 0
    if old < 1 then
        -- initial version
    end
    db.version = Smartbot.SCHEMA_VERSION
end

local function processQueue()
    if InCombatLockdown() or UnitAffectingCombat("player") then return end
    if #equipQueue == 0 then return end
    local entry = table.remove(equipQueue, 1)
    if entry then
        local item, slot = entry.item, entry.slot
        if item then
            if Smartbot.Equip and Smartbot.Equip.Validate and not Smartbot.Equip:Validate(item, slot) then
                -- skip invalid or outdated entry
            else
                local ok, err = pcall(EquipItemByName, item, slot)
                if not ok and Smartbot.Logger then
                    Smartbot.Logger:Log("WARN", "Equip failed", item, err)
                end
            end
        end
    end
    if #equipQueue > 0 then
        C_Timer_After(0.5, processQueue)
    end
end

function Smartbot:QueueEquip(item, slot)
    if not item then return end
    table.insert(equipQueue, {item = item, slot = slot})
    if not InCombatLockdown() then
        processQueue()
    end
end

local function onAddonLoaded(name)
    if name ~= addonName then return end
    SmartbotDB = SmartbotDB or {}
    Smartbot.db = SmartbotDB
    local prev = Smartbot.db.version or 0
    if prev < Smartbot.SCHEMA_VERSION then
        migrate(Smartbot.db, prev)
    end
    copyDefaults(Smartbot.db, defaults)
end

local function onPlayerLogin()
    processQueue()
end

eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "ADDON_LOADED" then
        onAddonLoaded(...)
    elseif event == "PLAYER_LOGIN" then
        onPlayerLogin(...)
    elseif event == "PLAYER_REGEN_ENABLED" then
        processQueue()
    end
end)

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

SLASH_SMARTBOT1 = "/smartbot"
SlashCmdList.SMARTBOT = function(msg)
    if Smartbot.Options and Smartbot.Options:HandleSlash(msg) then
        return
    end
    if Smartbot.Logger then
        Smartbot.Logger:Log('INFO', 'Command:', msg or '')
    else
        print('Smartbot:', msg)
    end
end
