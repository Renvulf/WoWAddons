-- Model.lua - learning models for Smartbot

-- Outlier tracker using rolling median/MAD
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

-- Recursive Least Squares model
local ModelRLS = {}
ModelRLS.__index = ModelRLS

function ModelRLS:New(lambda, gamma)
    local o = {
        lambda = lambda or 1,
        gamma = gamma or 0.99,
        A = nil,
        b = nil,
        w = nil,
        dim = 0,
        n = 0,
        outlier = Outlier:New(50),
    }
    return setmetatable(o, ModelRLS)
end

function ModelRLS:Ensure(dim)
    if self.A then return end
    self.dim = dim
    self.A = {}
    self.b = {}
    self.w = {}
    for i = 1, dim do
        self.A[i] = {}
        for j = 1, dim do
            self.A[i][j] = 0
        end
        self.b[i] = 0
        self.w[i] = 0
    end
end

function ModelRLS:Predict(x)
    local s = 0
    for i = 1, #x do
        s = s + (self.w[i] or 0) * x[i]
    end
    return s
end

local function cholesky(A)
    local n = #A
    local L = {}
    for i = 1, n do
        L[i] = {}
        for j = 1, i do
            local sum = 0
            for k = 1, j - 1 do
                sum = sum + L[i][k] * L[j][k]
            end
            if i == j then
                local v = A[i][i] - sum
                if v <= 0 then
                    return nil
                end
                L[i][j] = math.sqrt(v)
            else
                L[i][j] = (A[i][j] - sum) / L[j][j]
            end
        end
    end
    return L
end

local function cholSolve(A, b)
    local L = cholesky(A)
    if not L then return nil end
    local n = #A
    local y = {}
    for i = 1, n do
        local sum = 0
        for k = 1, i - 1 do
            sum = sum + L[i][k] * y[k]
        end
        y[i] = (b[i] - sum) / L[i][i]
    end
    local x = {}
    for i = n, 1, -1 do
        local sum = 0
        for k = i + 1, n do
            sum = sum + L[k][i] * x[k]
        end
        x[i] = (y[i] - sum) / L[i][i]
    end
    return x
end

function ModelRLS:Update(x, y, weight)
    weight = weight or 1
    self:Ensure(#x)
    local pred = self:Predict(x)
    local r = y - pred
    self.outlier:Add(r)
    if self.outlier:IsOutlier(r) then
        return false
    end
    self.n = self.n + weight
    local n = self.dim
    local gamma = self.gamma
    for i = 1, n do
        self.b[i] = gamma * self.b[i] + weight * x[i] * y
        for j = 1, n do
            self.A[i][j] = gamma * self.A[i][j] + weight * x[i] * x[j]
        end
        self.A[i][i] = self.A[i][i] + self.lambda
    end
    local w = cholSolve(self.A, self.b)
    if w then
        for i = 1, #w do
            local v = w[i]
            if v ~= v or v == math.huge or v == -math.huge then
                w[i] = 0
            elseif v > 100 then
                w[i] = 100
            elseif v < -100 then
                w[i] = -100
            end
        end
        self.w = w
    end
    return true
end

function ModelRLS:Export()
    local tA = {}
    if self.A then
        for i = 1, #self.A do
            tA[i] = {}
            for j = 1, #self.A[i] do
                tA[i][j] = self.A[i][j]
            end
        end
    end
    local tb = {}
    if self.b then
        for i = 1, #self.b do tb[i] = self.b[i] end
    end
    local tw = {}
    if self.w then
        for i = 1, #self.w do tw[i] = self.w[i] end
    end
    return {
        lambda = self.lambda,
        gamma = self.gamma,
        A = tA,
        b = tb,
        w = tw,
        n = self.n,
        outlier = {residuals = self.outlier.residuals},
    }
end

function ModelRLS.Import(t)
    local m = ModelRLS:New(t and t.lambda or nil, t and t.gamma or nil)
    if type(t) == "table" then
        m.A = t.A
        m.b = t.b
        m.w = t.w
        m.n = t.n or 0
        if m.A then
            m.dim = #m.A
        end
        if t.outlier and t.outlier.residuals then
            for _, v in ipairs(t.outlier.residuals) do
                m.outlier:Add(v)
            end
        end
    end
    return m
end

-- Pairwise delta model using robust regression
local ModelDelta = {}
ModelDelta.__index = ModelDelta

function ModelDelta:New(lambda)
    local o = {
        lambda = lambda or 1,
        A = nil,
        b = nil,
        w = nil,
        dim = 0,
        n = 0,
        outlier = Outlier:New(50),
    }
    return setmetatable(o, ModelDelta)
end

function ModelDelta:Ensure(dim)
    if self.A then return end
    self.dim = dim
    self.A = {}
    self.b = {}
    self.w = {}
    for i = 1, dim do
        self.A[i] = {}
        for j = 1, dim do
            self.A[i][j] = 0
        end
        self.b[i] = 0
        self.w[i] = 0
    end
end

function ModelDelta:Predict(x)
    local s = 0
    for i = 1, #x do
        s = s + (self.w[i] or 0) * x[i]
    end
    return s
end

function ModelDelta:Update(x, y)
    self:Ensure(#x)
    local pred = self:Predict(x)
    local r = y - pred
    self.outlier:Add(r)
    local scale = self.outlier.mad
    local c = 1.5 * scale
    local weight = 1
    if scale > 0 and math.abs(r) > c then
        weight = c / math.abs(r)
    end
    self.n = self.n + weight
    local n = self.dim
    for i = 1, n do
        self.b[i] = self.b[i] + weight * x[i] * y
        for j = 1, n do
            self.A[i][j] = self.A[i][j] + weight * x[i] * x[j]
        end
        self.A[i][i] = self.A[i][i] + self.lambda
    end
    local w = cholSolve(self.A, self.b)
    if w then
        for i = 1, #w do
            local v = w[i]
            if v ~= v or v == math.huge or v == -math.huge then
                w[i] = 0
            elseif v > 100 then
                w[i] = 100
            elseif v < -100 then
                w[i] = -100
            end
        end
        self.w = w
    end
    return true
end

function ModelDelta:Export()
    local tA = {}
    if self.A then
        for i = 1, #self.A do
            tA[i] = {}
            for j = 1, #self.A[i] do
                tA[i][j] = self.A[i][j]
            end
        end
    end
    local tb = {}
    if self.b then
        for i = 1, #self.b do tb[i] = self.b[i] end
    end
    local tw = {}
    if self.w then
        for i = 1, #self.w do tw[i] = self.w[i] end
    end
    return {
        lambda = self.lambda,
        A = tA,
        b = tb,
        w = tw,
        n = self.n,
        outlier = {residuals = self.outlier.residuals},
    }
end

function ModelDelta.Import(t)
    local m = ModelDelta:New(t and t.lambda or nil)
    if type(t) == "table" then
        m.A = t.A
        m.b = t.b
        m.w = t.w
        m.n = t.n or 0
        if m.A then
            m.dim = #m.A
        end
        if t.outlier and t.outlier.residuals then
            for _, v in ipairs(t.outlier.residuals) do
                m.outlier:Add(v)
            end
        end
    end
    return m
end

-- Expose models
SmartbotModelRLS = ModelRLS
SmartbotModelDelta = ModelDelta
SmartbotModel = ModelRLS

return ModelRLS
