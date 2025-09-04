local Model = {}
Model.__index = Model

local FEATURE_NAMES = {
    "PrimaryStat","CritRating","HasteRating","MasteryRating","VersatilityRating",
    "MH_DPS","OH_DPS","ItemLevel","Level","avgTargets"
}

local function clamp01(x)
    if x < 0 then return 0 elseif x > 1 then return 1 else return x end
end

function Model:New()
    local o = {
        featureNames = FEATURE_NAMES,
        w = {},
        b = 0,
        mean = {},
        var = {},
        g2sum = {},
        g2sum0 = 0,
        n = 0,
        maeEWMA = 0,
        deltaHuber = 300,
        ridge = 1e-4,
        accepted = 0,
        rejected = 0,
    }
    return setmetatable(o, self)
end

local function standardize(model, x)
    local xhat = {}
    for i = 1, #x do
        local mu = model.mean[i] or 0
        local var = (model.var[i] or 0)
        local n = model.n
        local sd = 0
        if n > 0 then
            sd = math.sqrt(var / n)
        end
        if sd < 1e-6 then sd = 1e-6 end
        xhat[i] = (x[i] - mu) / sd
    end
    return xhat
end

function Model:Update(x, y, seg, params)
    params = params or {}
    local lr = params.lr or 0.02
    local deltaHuber = params.deltaHuber or self.deltaHuber or 300
    local ridge = params.ridge or self.ridge or 1e-4

    self.n = self.n + 1
    -- Welford mean/var update
    for i = 1, #x do
        local xi = x[i]
        local mean = self.mean[i] or 0
        local delta = xi - mean
        mean = mean + delta / self.n
        self.mean[i] = mean
        local M2 = self.var[i] or 0
        self.var[i] = M2 + delta * (xi - mean)
    end

    local xhat = standardize(self, x)
    -- Prediction
    local yhat = self.b
    for i = 1, #xhat do
        yhat = yhat + (self.w[i] or 0) * xhat[i]
    end
    local e = y - yhat
    local absE = math.abs(e)
    local huber = math.max(deltaHuber, 2 * self.maeEWMA)
    if absE > huber then
        e = huber * (e >= 0 and 1 or -1)
    end

    -- EWMA of MAE
    if self.n == 1 then
        self.maeEWMA = absE
    else
        self.maeEWMA = 0.9 * self.maeEWMA + 0.1 * absE
    end

    local q = 1
    if seg then
        local dmgNorm = seg.totalDamage / ((seg.avgTargets or 0) > 1 and 150000 or 75000)
        q = clamp01(math.min(1, (seg.activeTime or 0) / 60) * math.min(1, dmgNorm))
    end

    -- Gradient updates
    for i = 1, #xhat do
        local w = self.w[i] or 0
        local g = -2 * e * xhat[i] + 2 * ridge * w
        self.g2sum[i] = (self.g2sum[i] or 0) + g * g
        self.w[i] = w - (lr * q / math.sqrt(self.g2sum[i] + 1e-6)) * g
    end
    local g0 = -2 * e
    self.g2sum0 = self.g2sum0 + g0 * g0
    self.b = self.b - (lr * q / math.sqrt(self.g2sum0 + 1e-6)) * g0

    return yhat, e
end

SmartbotModel = Model
return Model
