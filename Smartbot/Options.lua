local addonName, Smartbot = ...
Smartbot.Options = Smartbot.Options or {}
local Options = Smartbot.Options

local CreateFrame = CreateFrame
local Settings_RegisterCanvasLayoutCategory = Settings and Settings.RegisterCanvasLayoutCategory
local Settings_RegisterAddOnCategory = Settings and Settings.RegisterAddOnCategory
local Settings_OpenToCategory = Settings and Settings.OpenToCategory
local UnitClass = UnitClass
local GetSpecialization = GetSpecialization

local panel

local function getCurrentWeights()
    local class = select(2, UnitClass('player'))
    local spec = GetSpecialization() or 0
    return (Smartbot.db and Smartbot.db.weights and Smartbot.db.weights[class] and Smartbot.db.weights[class][spec]) or {}
end

local function updateWeightText()
    if not panel or not panel.weightText then return end
    local weights = getCurrentWeights()
    local parts = {}
    for stat, v in pairs(weights) do
        table.insert(parts, stat .. '=' .. string.format('%.2f', v))
    end
    panel.weightText:SetText(#parts > 0 and table.concat(parts, ', ') or 'No weights yet')
end

function Options:ResetWeights()
    if Smartbot.db then
        Smartbot.db.weights = {}
        Smartbot.db.modelMeta = {}
        updateWeightText()
        if Smartbot.Logger then
            Smartbot.Logger:Log('INFO', 'Weights reset')
        else
            print('Smartbot: weights reset')
        end
    end
end

function Options:Build()
    if not Smartbot.db then return end
    if panel then return panel end
    panel = CreateFrame('Frame')

    if Settings_RegisterCanvasLayoutCategory and Settings_RegisterAddOnCategory then
        local category = Settings_RegisterCanvasLayoutCategory(panel, addonName)
        Settings_RegisterAddOnCategory(category)
        panel.categoryID = category.ID
        Options.categoryID = category.ID
    else
        if Smartbot.Logger then
            Smartbot.Logger:Log('WARN', 'Settings API unavailable')
        end
    end

    local title = panel:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
    title:SetPoint('TOPLEFT', 16, -16)
    title:SetText('Smartbot')

    local auto = CreateFrame('CheckButton', nil, panel, 'InterfaceOptionsCheckButtonTemplate')
    auto:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -8)
    auto.Text:SetText('Enable Auto Equip')
    auto:SetChecked(Smartbot.db.profile.autoEquip)
    auto:SetScript('OnClick', function(self)
        Smartbot.db.profile.autoEquip = self:GetChecked()
    end)

    local minDelta = CreateFrame('Slider', addonName..'MinDelta', panel, 'OptionsSliderTemplate')
    minDelta:SetPoint('TOPLEFT', auto, 'BOTTOMLEFT', 0, -24)
    minDelta:SetMinMaxValues(0, 100)
    minDelta:SetValueStep(1)
    minDelta:SetObeyStepOnDrag(true)
    _G[minDelta:GetName() .. 'Low']:SetText('0')
    _G[minDelta:GetName() .. 'High']:SetText('100')
    _G[minDelta:GetName() .. 'Text']:SetText('Min Score Delta')
    minDelta:SetValue(Smartbot.db.profile.minDelta)
    minDelta:SetScript('OnValueChanged', function(self, value)
        Smartbot.db.profile.minDelta = math.floor(value + 0.5)
    end)

    local verb = CreateFrame('Slider', addonName..'Verbosity', panel, 'OptionsSliderTemplate')
    verb:SetPoint('TOPLEFT', minDelta, 'BOTTOMLEFT', 0, -24)
    verb:SetMinMaxValues(0, 3)
    verb:SetValueStep(1)
    verb:SetObeyStepOnDrag(true)
    _G[verb:GetName() .. 'Low']:SetText('0')
    _G[verb:GetName() .. 'High']:SetText('3')
    _G[verb:GetName() .. 'Text']:SetText('Verbosity')
    verb:SetValue(Smartbot.db.profile.verbosity)
    verb:SetScript('OnValueChanged', function(self, value)
        Smartbot.db.profile.verbosity = math.floor(value + 0.5)
    end)

    local wt = panel:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
    wt:SetPoint('TOPLEFT', verb, 'BOTTOMLEFT', 0, -24)
    wt:SetPoint('RIGHT', panel, -16, 0)
    wt:SetJustifyH('LEFT')
    wt:SetJustifyV('TOP')
    panel.weightText = wt
    updateWeightText()

    local reset = CreateFrame('Button', nil, panel, 'UIPanelButtonTemplate')
    reset:SetText('Reset Weights')
    reset:SetWidth(120)
    reset:SetHeight(22)
    reset:SetPoint('TOPLEFT', wt, 'BOTTOMLEFT', 0, -24)
    reset:SetScript('OnClick', function() Options:ResetWeights() end)

    return panel
end

function Options:Open()
    Options:Build()
    if Settings_OpenToCategory and Options.categoryID then
        Settings_OpenToCategory(Options.categoryID)
    elseif Settings and SettingsPanel then
        SettingsPanel:Show()
    end
end

local function trim(s)
    return s:match('^%s*(.-)%s*$')
end

function Options:HandleSlash(msg)
    msg = trim(msg or ''):lower()
    if msg == '' or msg == 'options' then
        Options:Open()
        return true
    elseif msg == 'auto' then
        if Smartbot.db and Smartbot.db.profile then
            Smartbot.db.profile.autoEquip = not Smartbot.db.profile.autoEquip
            local state = Smartbot.db.profile.autoEquip and 'ON' or 'OFF'
            if Smartbot.Logger then
                Smartbot.Logger:Log('INFO', 'AutoEquip', state)
            else
                print('Smartbot auto-equip', state)
            end
        end
        return true
    elseif msg == 'reset' then
        Options:ResetWeights()
        return true
    end
    Options:Open()
    return true
end

SLASH_SMARTBOT1 = '/smartbot'
SlashCmdList.SMARTBOT = function(msg)
    if not Options:HandleSlash(msg) then
        Options:Open()
    end
end

