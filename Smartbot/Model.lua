-- Smartbot - Model.lua (RLS with ridge + forgetting)
local Model = {}
Model.__index = Model

local function deepcopy(t)
    if type(t) ~= "table" then return t end
    local r = {}
    for k,v in pairs(t) do r[k] = deepcopy(v) end
    return r
end

function Model:New(featureNames)
    local o = {
        featureNames = featureNames or {
            "STR","AGI","INT","STAM",
            "CRIT","HASTE","MASTERY","VERS",
            "LEECH","AVOIDANCE","SPEED",
            "WEAPON_DPS","WEAPON_SPEED",
            "ARMOR","ILVL",
            "AVG_TARGETS",
        },
        n = 0,
        accepted = 0,
        rejected = 0,
        lambda = 1.0,
        gamma = 0.995, -- forgetting factor
        -- RLS state
        A = nil, -- matrix (#f x #f)
        b = nil, -- vector (#f)
        w = nil, -- weights (#f)
        minSamples = 15,
    }
    setmetatable(o, Model)
    local F = #o.featureNames
    o.A = {}
    for i=1,F do
        o.A[i] = {}
        for j=1,F do o.A[i][j] = (i==j) and o.lambda or 0 end
    end
    o.b = {}
    for i=1,F do o.b[i] = 0 end
    o.w = {}
    for i=1,F do o.w[i] = 0 end
    return o
end

local function dot(a,b)
    local s = 0
    for i=1,#a do s = s + (a[i] or 0) * (b[i] or 0) end
    return s
end

local function cholesky_solve(A, b)
    local n = #A
    -- copy
    local L = {}
    for i=1,n do
        L[i] = {}
        for j=1,n do L[i][j] = A[i][j] end
    end
    -- Cholesky
    for i=1,n do
        for j=1,i do
            local sum = L[i][j]
            for k=1,j-1 do sum = sum - L[i][k]*L[j][k] end
            if i == j then
                if sum <= 1e-8 then sum = 1e-8 end
                L[i][j] = math.sqrt(sum)
            else
                L[i][j] = sum / L[j][j]
            end
        end
        for j=i+1,n do L[i][j] = 0 end
    end
    -- solve Ly=b
    local y = {}
    for i=1,n do
        local sum = b[i]
        for k=1,i-1 do sum = sum - L[i][k]*y[k] end
        y[i] = sum / L[i][i]
    end
    -- solve L^T w = y
    local w = {}
    for i=n,1,-1 do
        local sum = y[i]
        for k=i+1,n do sum = sum - L[k][i]*w[k] end
        w[i] = sum / L[i][i]
    end
    return w
end

function Model:Update(x, y)
    local F = #self.featureNames
    if #x ~= F then return false, "feature_len" end
    -- apply forgetting
    for i=1,F do
        for j=1,F do
            self.A[i][j] = self.gamma * self.A[i][j]
        end
        self.A[i][i] = self.A[i][i] + 1e-6 -- gentle ridge refresh
    end
    -- A += x x^T ; b += x y
    for i=1,F do
        local xi = x[i] or 0
        for j=1,F do
            self.A[i][j] = self.A[i][j] + xi * (x[j] or 0)
        end
        self.b[i] = (self.b[i] or 0) + xi * y
    end
    -- solve
    self.w = cholesky_solve(self.A, self.b)
    self.n = (self.n or 0) + 1
    return true
end

function Model:Predict(x)
    return dot(self.w, x)
end

function Model:Export()
    return {
        featureNames = deepcopy(self.featureNames),
        n = self.n, accepted = self.accepted, rejected = self.rejected,
        lambda = self.lambda, gamma = self.gamma,
        A = deepcopy(self.A),
        b = deepcopy(self.b),
        w = deepcopy(self.w),
        minSamples = self.minSamples,
    }
end

function Model.Import(t)
    local m = Model:New(t.featureNames)
    m.n = t.n or 0; m.accepted = t.accepted or 0; m.rejected = t.rejected or 0
    m.lambda = t.lambda or 1.0; m.gamma = t.gamma or 0.995
    m.A = t.A or m.A; m.b = t.b or m.b; m.w = t.w or m.w
    m.minSamples = t.minSamples or m.minSamples
    return m
end

SmartbotModel = Model
return Model
