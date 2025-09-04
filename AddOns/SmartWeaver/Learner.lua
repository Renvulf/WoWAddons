local ADDON_NAME, SW = ...
local C = SW.Const
local U = SW.Util
SW.Learner = {}
local L = SW.Learner

local function zero(n)
    local r={}; for i=1,n do r[i]=0 end; return r
end

local function initModel()
    local key = SW.state.charKey
    local m = SW.db.models[key]
    if not m then
        local n=10
        m={A=U.identity(n),b=zero(n),w=zero(n),samples=0}
        SW.db.models[key]=m
    end
    return m
end

local function equippedFeatures()
    local sum
    for slot=1,17 do
        if slot~=4 then -- skip shirt
            local link = GetInventoryItemLink("player", slot)
            if link then
                local f = SW.ItemStats:Features(link)
                if f then
                    sum = sum or zero(#f)
                    for i=1,#f do sum[i]=sum[i]+f[i] end
                end
            end
        end
    end
    return sum
end

function L:RecordEncounter(dps,hps)
    local m = initModel()
    local x = equippedFeatures()
    if not x then return end
    local y = (SW.state.role==C.ROLES.HEALER) and hps or dps
    if not y or y<=0 then return end
    m.A = U.matAdd(U.scalarMulMat(C.FORGET, m.A), U.outer(x))
    m.b = U.vecAdd(U.scalarMulVec(C.FORGET, m.b), U.scalarMulVec(y, x))
    m.w = U.matVecMul(U.invert(m.A), m.b)
    m.samples = m.samples + 1
    local hist = SW.db.history
    hist[#hist+1] = {dps=dps,hps=hps,ts=time()}
    if #hist>C.HISTORY_MAX then table.remove(hist,1) end
end

local priors = {1,0.1,0.5,0.5,0.5,0.5,0.05,0.01,0.01,0.1}

function L:GetWeights()
    local m = initModel()
    if m.samples < C.COLD_START_SAMPLES then
        return priors, true
    end
    return m.w
end

return L
