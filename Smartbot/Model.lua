local Model = {}
Model.__index = Model

local FEATURE_NAMES = {
    "PrimaryStat","CritRating","HasteRating","MasteryRating","VersatilityRating",
    "MH_DPS","OH_DPS","ItemLevel","avgTargets"
}

-- Lightweight Base64 implementation -------------------------------------------------
-- These helpers operate on plain Lua strings and avoid external dependencies.  They
-- are intentionally tiny as the exported model data is already small.
local B64_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function b64encode(data)
    return ((data:gsub('.', function(x)
        local r = B64_CHARS:find(x) - 1
        return string.format('%06b', r)
    end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(bits)
        if #bits < 6 then return '' end
        local c = tonumber(bits, 2) + 1
        return B64_CHARS:sub(c, c)
    end) .. ({ '', '==', '=' })[#data % 3 + 1])
end

local function b64decode(data)
    data = data:gsub('[^' .. B64_CHARS .. '=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r = B64_CHARS:find(x) - 1
        return string.format('%06b', r)
    end):gsub('%d%d%d?%d?%d?%d?', function(bits)
        if #bits < 8 then return '' end
        local c = tonumber(bits, 2)
        return string.char(c)
    end))
end

-- Minimal JSON (sufficient for numbers, booleans, strings and arrays) --------------
local function json_encode(v)
    local t = type(v)
    if t == 'number' or t == 'boolean' then
        return tostring(v)
    elseif t == 'string' then
        return string.format('%q', v)
    elseif t == 'table' then
        local isArray = (#v > 0)
        local parts = {}
        if isArray then
            for i = 1, #v do parts[i] = json_encode(v[i]) end
            return '[' .. table.concat(parts, ',') .. ']'
        else
            for k, val in pairs(v) do
                parts[#parts + 1] = string.format('%q:%s', k, json_encode(val))
            end
            return '{' .. table.concat(parts, ',') .. '}'
        end
    else
        return 'null'
    end
end

local function json_decode(str)
    local lua = str:gsub('"([%w_]+)":', '["%1"]=')
    lua = lua:gsub('null', 'nil')
    local f, err = load('return ' .. lua)
    if not f then return nil, err end
    return f()
end

local function checksum(str)
    local sum = 0
    for i = 1, #str do
        sum = (sum + str:byte(i)) % 4294967296
    end
    return string.format('%x', sum)
end

function Model:New()
    local o = {
        featureNames = FEATURE_NAMES,
        A = {},
        bVec = {},
        w = {},
        mean = {},
        var = {},
        n = 0,
        maeEWMA = 0,
        ridge = 1e-3,
        gamma = 0.99,
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
    local gamma = params.gamma or self.gamma or 0.99
    local ridge = params.ridge or self.ridge or 1e-3
    self.gamma = gamma
    self.ridge = ridge

    self.n = self.n + 1
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
    local d = #xhat

    for i = 1, d + 1 do
        self.bVec[i] = (self.bVec[i] or 0) * gamma
        self.A[i] = self.A[i] or {}
        for j = 1, d + 1 do
            self.A[i][j] = (self.A[i][j] or 0) * gamma
            if i == j then self.A[i][j] = self.A[i][j] + ridge end
        end
    end

    local xaug = {}
    for i = 1, d do xaug[i] = xhat[i] end
    xaug[d + 1] = 1
    for i = 1, d + 1 do
        self.bVec[i] = self.bVec[i] + xaug[i] * y
        for j = 1, d + 1 do
            self.A[i][j] = self.A[i][j] + xaug[i] * xaug[j]
        end
    end

    self.w = solve(self.A, self.bVec)

    local yhat = 0
    for i = 1, d do
        yhat = yhat + (self.w[i] or 0) * xhat[i]
    end
    yhat = yhat + (self.w[d + 1] or 0)

    local e = y - yhat
    local absE = math.abs(e)
    if self.n == 1 then
        self.maeEWMA = absE
    else
        self.maeEWMA = 0.9 * self.maeEWMA + 0.1 * absE
    end

    for i = 1, d do
        local w = self.w[i] or 0
        if w > 1000 then w = 1000 elseif w < -1000 then w = -1000 end
        if i == 1 and not params.allowNegativeWeights and w < 0 then
            w = 0
        end
        self.w[i] = w
    end

    return yhat, e
end

-- Returns standardized feature vector; exposed for unit tests.
function Model:Standardize(x)
    return standardize(self, x)
end

-- Estimates change in prediction for a delta feature vector.
function Model:PredictDelta(delta)
    local ydelta = 0
    for i = 1, #delta do
        local var = self.var[i] or 0
        local n = self.n
        local sd = 0
        if n > 0 then
            sd = math.sqrt(var / n)
        end
        if sd < 1e-6 then sd = 1e-6 end
        ydelta = ydelta + (self.w[i] or 0) * (delta[i] / sd)
    end
    return ydelta
end

-- Serialises the model into a base64 encoded JSON string with a simple checksum.
function Model:Export()
    local fchk = checksum(table.concat(self.featureNames, ','))
    local data = {
        featureNames = self.featureNames,
        featureChecksum = fchk,
        A = self.A,
        bVec = self.bVec,
        w = self.w,
        mean = self.mean,
        var = self.var,
        n = self.n,
        maeEWMA = self.maeEWMA,
        ridge = self.ridge,
        gamma = self.gamma,
        accepted = self.accepted,
        rejected = self.rejected,
    }
    local json = json_encode(data)
    local chk = checksum(json)
    return b64encode(chk .. ':' .. json)
end

-- Recreates a model instance from an exported string.  Returns model or nil + err.
function Model.Import(str)
    if type(str) ~= 'string' then return nil, 'invalid' end
    local decoded = b64decode(str or '')
    local chk, json = decoded:match('^([^:]+):(.*)$')
    if not chk or not json then return nil, 'format' end
    if chk ~= checksum(json) then return nil, 'checksum' end
    local tbl, err = json_decode(json)
    if not tbl then return nil, err or 'json' end
    local fchk = checksum(table.concat(tbl.featureNames or {}, ','))
    if tbl.featureChecksum and fchk ~= tbl.featureChecksum then return nil, 'features' end
    local m = Model:New()
    for k, v in pairs(tbl) do m[k] = v end
    return m
end

SmartbotModel = Model
return Model
