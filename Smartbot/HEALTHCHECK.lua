local addonName, Smartbot = ...
Smartbot.HealthCheck = Smartbot.HealthCheck or {}
local Health = Smartbot.HealthCheck

local CreateFrame = CreateFrame
local GetBuildInfo = GetBuildInfo
local InCombatLockdown = InCombatLockdown
local UnitAffectingCombat = UnitAffectingCombat
local hooksecurefunc = hooksecurefunc

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
        local obj = _G[sym]
        if not obj and Smartbot.Logger then
            Smartbot.Logger:Log('ERROR', 'Missing API', sym)
        end
    end
end

function Health:CheckInterface()
    local build = select(4, GetBuildInfo())
    local game = tonumber(build, 10) or 0
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

function Health:CheckAdapter()
    assert(type(Smartbot.API) == 'table' and type(Smartbot.API.GetItemStatsSafe) == 'function', 'Missing Smartbot.API.GetItemStatsSafe')
    if debug and debug.getupvalue then
        for name, mod in pairs(Smartbot) do
            if type(mod) == 'table' then
                for fname, fn in pairs(mod) do
                    if type(fn) == 'function' then
                        local i = 1
                        while true do
                            local up = debug.getupvalue(fn, i)
                            if not up then break end
                            local upname = up
                            if upname == 'GetItemStats' then
                                if Smartbot.Logger then
                                    Smartbot.Logger:Log('WARN', 'Replace GetItemStats upvalue in '..name..'.'..fname)
                                end
                                break
                            end
                            i = i + 1
                        end
                    end
                end
            end
        end
    end
end

function Health:CheckOptions()
    if not (Settings and Settings.GetCategory and Smartbot.Options and Smartbot.Options.categoryID) then
        if Smartbot.Logger then
            Smartbot.Logger:Log('WARN', 'Options not registered with Settings')
        end
    end
end

function Health:Verify()
    self:CheckLoadOrder()
    self:CheckAPIs()
    self:CheckInterface()
    self:CheckDBVersion()
    self:CheckAdapter()
    self:CheckOptions()
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
frame:RegisterEvent('ADDON_LOADED')
frame:SetScript('OnEvent', function(_, _, name)
    if name == addonName then
        Health:Verify()
    end
end)

return Health
