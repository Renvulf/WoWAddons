local addonName, Smartbot = ...
Smartbot.HealthCheck = Smartbot.HealthCheck or {}
local Health = Smartbot.HealthCheck

local API = Smartbot.API
local CreateFrame = API:Resolve('CreateFrame') or CreateFrame
local GetBuildInfo = API:Resolve('GetBuildInfo') or GetBuildInfo
local GetAddOnMetadata = API:Resolve('GetAddOnMetadata') or (C_AddOns and C_AddOns.GetAddOnMetadata)
local InCombatLockdown = API:Resolve('InCombatLockdown') or InCombatLockdown
local UnitAffectingCombat = API:Resolve('UnitAffectingCombat') or UnitAffectingCombat
local hooksecurefunc = API:Resolve('hooksecurefunc') or hooksecurefunc

Smartbot.interface = Smartbot.interface or 110200

local requiredAPIs = {
    'CreateFrame',
    'InCombatLockdown',
    'GetItemInfoInstant',
    'EquipItemByName',
    'UnitAffectingCombat',
}

function Health:CheckAPIs()
    for _, sym in ipairs(requiredAPIs) do
        local obj = API:Resolve(sym)
        if not obj then
            if Smartbot.Logger then
                Smartbot.Logger:Log('ERROR', 'Missing API', sym)
            end
        else
            local map = Smartbot.APIMap and Smartbot.APIMap[sym]
            if map and Smartbot.rgar and Smartbot.rgar.choices then
                local choice = Smartbot.rgar.choices[sym]
                if choice and map[1] and choice ~= map[1].name then
                    if Smartbot.Logger then
                        Smartbot.Logger:Log('INFO', 'Fallback API', sym, choice)
                    end
                end
            end
        end
    end
end

function Health:CheckInterface()
    local game = tonumber(select(4, GetBuildInfo())) or 0
    if Smartbot.interface and game ~= Smartbot.interface then
        if Smartbot.Logger then
            Smartbot.Logger:Log('WARN', 'Interface mismatch', game, Smartbot.interface)
        end
    end
end

function Health:CheckLoadOrder()
    if not Smartbot.db and Smartbot.Logger then
        Smartbot.Logger:Log('ERROR', 'Core not loaded before health check')
    end
end

function Health:CheckDBVersion()
    if Smartbot.db and Smartbot.SCHEMA_VERSION and Smartbot.db.version ~= Smartbot.SCHEMA_VERSION then
        if Smartbot.Logger then
            Smartbot.Logger:Log('ERROR', 'DB schema mismatch', Smartbot.db.version or "nil", Smartbot.SCHEMA_VERSION)
        end
    end
end

function Health:Verify()
    self:CheckLoadOrder()
    self:CheckAPIs()
    self:CheckInterface()
    self:CheckDBVersion()
end

if hooksecurefunc then
    hooksecurefunc('EquipItemByName', function()
        if InCombatLockdown() or UnitAffectingCombat('player') then
            if Smartbot.Logger then
                Smartbot.Logger:Log('ERROR', 'Equip attempted in combat')
            end
        end
    end)
end

local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
    Health:Verify()
end)

return Health
