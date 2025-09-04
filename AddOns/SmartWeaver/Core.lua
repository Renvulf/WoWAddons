local ADDON_NAME, SW = ...
local C = SW.Const
local U = SW.Util
SW.Core = {}
local Core = SW.Core

local state = {}
SW.state = state

local defaults = {
    enable=true,
    autoEquip=false,
    showTooltip=true,
    explore=false,
    verbose=false,
    allowTank=false,
}

local function initDB()
    _G[C.SAVED_VAR] = _G[C.SAVED_VAR] or { config={}, models={}, history={} }
    local db = _G[C.SAVED_VAR]
    for k,v in pairs(defaults) do if db.config[k]==nil then db.config[k]=v end end
    db.history = db.history or {}
    db.models = db.models or {}
    SW.db = db
end

function Core:SpecRole()
    local spec = GetSpecialization()
    if not spec then
        U.log("Spec not ready, retrying")
        C_Timer.After(2, function() Core:SpecRole() end)
        return
    end
    local specID = GetSpecializationInfo(spec)
    local role = GetSpecializationRole(spec)
    local name, realm = UnitName("player"), GetRealmName()
    state.specID = specID
    state.role = role
    state.charKey = name.."-"..realm..":"..specID
    U.log("SpecRole detected %s %s", tostring(specID), tostring(role))
end

function Core:SlashCmd(msg)
    if msg=="export" then
        U.warn(Core:Export())
        return
    elseif msg=="import" then
        U.warn("Use settings panel for import")
        return
    end
    print("SmartWeaver status: spec="..(state.specID or "?").." role="..(state.role or "?"))
    if SW.UI and SW.UI.Open then SW.UI:Open() end
end

function Core:OnLoad()
    initDB()
    Core:SpecRole()
    if SW.Events and SW.Events.Init then SW.Events:Init() end
    if SW.UI and SW.UI.Init then SW.UI:Init() end
    SLASH_SMARTWEAVER1 = "/sw"
    SlashCmdList["SMARTWEAVER"] = Core.SlashCmd
    U.log("Loaded %s v%s", C.ADDON_NAME, C.VERSION)
end

function Core:Export()
    return U.jsonEncode({models=SW.db.models, history=SW.db.history, config=SW.db.config})
end

function Core:Import(str)
    local t = U.jsonDecode(str)
    if type(t)~='table' then
        U.warn("Import failed")
        return
    end
    if t.models then SW.db.models=t.models end
    if t.history then SW.db.history=t.history end
    if t.config then for k,v in pairs(t.config) do SW.db.config[k]=v end end
    U.warn("Import complete")
end

function Core:ResetSpec()
    if state.charKey then
        SW.db.models[state.charKey]=nil
        U.warn("Model reset for %s", state.charKey)
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
    if addon==ADDON_NAME then Core:OnLoad() end
end)

return Core
