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
        if not obj and Smartbot.Logger then
            Smartbot.Logger:Log('ERROR', 'Missing API', sym)
        end
    end
end

function Health:CheckInterface()
    local build = select(4, GetBuildInfo())
    local game = tonumber(build)
    if not game then
        game = 0
        if Smartbot.Logger then
            Smartbot.Logger:Log('WARN', 'Invalid build info', tostring(build))
        end
    end
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

function Health:CheckAPIIntegrity()
    assert(type(Smartbot.API.GetItemStatsSafe) == 'function', 'Missing Smartbot.API.GetItemStatsSafe')
    if debug and debug.getupvalue then
        for name, mod in pairs(Smartbot) do
            if type(mod) == 'table' then
                for fname, fn in pairs(mod) do
                    if type(fn) == 'function' then
                        local i = 1
                        while true do
                            local up, _ = debug.getupvalue(fn, i)
                            if not up then break end
                            if up == 'GetItemStats' then
                                error('Forbidden upvalue GetItemStats in '..name..'.'..fname)
                            end
                            i = i + 1
                        end
                    end
                end
            end
        end
    end
end

function Health:Verify()
    self:CheckLoadOrder()
    self:CheckAPIs()
    self:CheckInterface()
    self:CheckDBVersion()
    self:CheckAPIIntegrity()
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
