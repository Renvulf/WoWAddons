-- Model.lua - placeholder learning model for Smartbot

local Model = {}
Model.__index = Model

function Model:New()
    local o = {
        w = {},
        n = 0,
    }
    return setmetatable(o, Model)
end

function Model:Predict(vec)
    local s = 0
    for i=1,#vec do
        s = s + (self.w[i] or 0) * vec[i]
    end
    return s
end

function Model:Update(x, y)
    self.n = self.n + 1
    return true
end

function Model:Export()
    return {w = self.w, n = self.n}
end

function Model.Import(t)
    local m = Model:New()
    if type(t) == "table" then
        m.w = t.w or {}
        m.n = t.n or 0
    end
    return m
end

SmartbotModel = Model
return Model
