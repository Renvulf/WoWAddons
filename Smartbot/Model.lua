-- Model.lua - simple model with outlier handling for Smartbot

local Model = {}
Model.__index = Model

local Outlier = {}
Outlier.__index = Outlier

function Outlier:New(window)
    local o = {
        window = window or 50,
        residuals = {},
        median = 0,
        mad = 1e-9,
    }
    return setmetatable(o, Outlier)
end

local function median(values)
    local t = {}
    for i, v in ipairs(values) do t[i] = v end
    table.sort(t)
    local n = #t
    if n == 0 then return 0 end
    if n % 2 == 1 then
        return t[(n + 1) / 2]
    else
        return 0.5 * (t[n / 2] + t[n / 2 + 1])
    end
end

function Outlier:Recalc()
    self.median = median(self.residuals)
    local dev = {}
    for i, v in ipairs(self.residuals) do
        dev[i] = math.abs(v - self.median)
    end
    self.mad = median(dev)
    if self.mad < 1e-9 then
        self.mad = 1e-9
    end
end

function Outlier:Add(r)
    local res = self.residuals
    res[#res + 1] = r
    if #res > self.window then
        table.remove(res, 1)
    end
    self:Recalc()
end

function Outlier:IsOutlier(r)
    local dist = math.abs(r - self.median)
    return dist > 3.5 * self.mad
end

function Model:New()
    local o = {
        w = {},
        n = 0,
        outlier = Outlier:New(50),
    }
    return setmetatable(o, Model)
end

function Model:Predict(vec)
    local s = 0
    for i = 1, #vec do
        s = s + (self.w[i] or 0) * vec[i]
    end
    return s
end

function Model:Update(x, y, weight)
    local pred = self:Predict(x)
    local r = y - pred
    self.outlier:Add(r)
    if self.outlier:IsOutlier(r) then
        return false
    end
    self.n = self.n + (weight or 1)
    return true
end

function Model:Export()
    return {
        w = self.w,
        n = self.n,
        outlier = {
            residuals = self.outlier.residuals,
        },
    }
end

function Model.Import(t)
    local m = Model:New()
    if type(t) == "table" then
        m.w = t.w or {}
        m.n = t.n or 0
        if t.outlier and t.outlier.residuals then
            for _, v in ipairs(t.outlier.residuals) do
                m.outlier:Add(v)
            end
        end
    end
    return m
end

SmartbotModel = Model
return Model
