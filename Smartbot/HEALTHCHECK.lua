local addonName, Smartbot = ...
Smartbot.HealthCheck = Smartbot.HealthCheck or {}

Smartbot.interface = Smartbot.interface or 110200

local requiredAPIs = {
    'CreateFrame',
    'InCombatLockdown',
    'GetItemInfoInstant',
    'EquipItemByName',
    'UnitAffectingCombat',
}

function Smartbot.HealthCheck:CheckAPIs()
    for _, sym in ipairs(requiredAPIs) do
        local obj = _G[sym]
        if not obj and Smartbot.Logger then
            Smartbot.Logger:Log('ERROR', 'Missing API', sym)
        end
    end
end

function Smartbot.HealthCheck:CheckInterface()
    local build = select(4, _G.GetBuildInfo())
    local game = tonumber(build, 10) or 0
    if Smartbot.interface and game ~= Smartbot.interface then
        if Smartbot.Logger then
            Smartbot.Logger:Log('WARN', 'Interface mismatch', game, Smartbot.interface)
        end
    end
end

function Smartbot.HealthCheck:CheckLoadOrder()
    if not Smartbot.db and Smartbot.Logger then
        Smartbot.Logger:Log('ERROR', 'Core not loaded before health check')
    end
end

function Smartbot.HealthCheck:CheckDBVersion()
    if Smartbot.db and Smartbot.SCHEMA_VERSION and Smartbot.db.version ~= Smartbot.SCHEMA_VERSION then
        if Smartbot.Logger then
            Smartbot.Logger:Log('ERROR', 'DB schema mismatch', Smartbot.db.version or 'nil', Smartbot.SCHEMA_VERSION)
        end
    end
end

function Smartbot.HealthCheck:CheckAdapter()
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

function Smartbot.HealthCheck:CheckOptions()
    if not (_G.Settings and _G.Settings.GetCategory and Smartbot.Options and Smartbot.Options.categoryID) then
        if Smartbot.Logger then
            Smartbot.Logger:Log('WARN', 'Options not registered with Settings')
        end
    end
end

function Smartbot.HealthCheck:CheckTooltipSource()
    local f = io.open('Smartbot/Tooltip.lua', 'r')
    if f then
        local content = f:read('*a')
        f:close()
        if content and string.find(content, ':GetItem') and Smartbot.Logger then
            Smartbot.Logger:Log('WARN', 'Tooltip.lua uses :GetItem')
        end
    end
end

function Smartbot.HealthCheck:Verify()
    self:CheckLoadOrder()
    self:CheckAPIs()
    self:CheckInterface()
    self:CheckDBVersion()
    self:CheckAdapter()
    self:CheckOptions()
    self:CheckTooltipSource()
end

if _G.hooksecurefunc then
    _G.hooksecurefunc('EquipItemByName', function()
        if _G.InCombatLockdown() or _G.UnitAffectingCombat('player') then
            if Smartbot.Logger then
                Smartbot.Logger:Log('ERROR', 'Equip attempted in combat')
            end
        end
    end)
    _G.hooksecurefunc(Smartbot, 'QueueEquip', function(_, link, slot)
        if slot then
            local equipLoc = select(4, _G.GetItemInfoInstant(link))
            local ambig = { INVTYPE_FINGER = true, INVTYPE_TRINKET = true, INVTYPE_WEAPON = true }
            if equipLoc and not ambig[equipLoc] and Smartbot.Logger then
                Smartbot.Logger:Log('WARN', 'QueueEquip passed slot for non-ambiguous equipLoc', equipLoc)
            end
        end
    end)
end

local frame = _G.CreateFrame('Frame')
frame:RegisterEvent('ADDON_LOADED')
frame:SetScript('OnEvent', function(_, _, name)
    if name == addonName then
        Smartbot.HealthCheck:Verify()
    end
end)

return Smartbot.HealthCheck

