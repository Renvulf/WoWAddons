local ADDON_NAME, SW = ...
SW.Util = {}
local U = SW.Util

function U.log(msg, ...)
    if SW.db and SW.db.config and SW.db.config.verbose then
        print("["..ADDON_NAME.."] "..string.format(msg, ...))
    end
end

function U.warn(msg, ...)
    print("["..ADDON_NAME.."] "..string.format(msg, ...))
end

function U.defer(func, delay)
    delay = delay or 0
    if InCombatLockdown() then
        C_Timer.After(1, function() U.defer(func, delay) end)
    else
        C_Timer.After(delay, func)
    end
end

function U.identity(n)
    local I = {}
    for i=1,n do
        I[i]={}
        for j=1,n do
            I[i][j] = (i==j) and 1 or 0
        end
    end
    return I
end

local function deepcopy(t)
    if type(t)~='table' then return t end
    local r = {}
    for k,v in pairs(t) do r[k] = deepcopy(v) end
    return r
end
U.deepcopy = deepcopy

local function matAdd(A,B)
    local R={}
    for i=1,#A do
        R[i]={}
        for j=1,#A[i] do
            R[i][j]=A[i][j]+B[i][j]
        end
    end
    return R
end
U.matAdd=matAdd

local function scalarMulMat(s,A)
    local R={}
    for i=1,#A do
        R[i]={}
        for j=1,#A[i] do
            R[i][j]=A[i][j]*s
        end
    end
    return R
end
U.scalarMulMat=scalarMulMat

local function outer(x)
    local n=#x
    local R={}
    for i=1,n do
        R[i]={}
        for j=1,n do
            R[i][j]=x[i]*x[j]
        end
    end
    return R
end
U.outer=outer

local function vecAdd(a,b)
    local r={}
    for i=1,#a do r[i]=a[i]+b[i] end
    return r
end
U.vecAdd=vecAdd

local function scalarMulVec(s,v)
    local r={}
    for i=1,#v do r[i]=v[i]*s end
    return r
end
U.scalarMulVec=scalarMulVec

local function matVecMul(A,x)
    local r={}
    for i=1,#A do
        local sum=0
        for j=1,#x do sum=sum+A[i][j]*x[j] end
        r[i]=sum
    end
    return r
end
U.matVecMul=matVecMul

local function invert(A)
    local n=#A
    local aug={}
    for i=1,n do
        aug[i]={}
        for j=1,n do aug[i][j]=A[i][j] end
        for j=n+1,2*n do aug[i][j]=(j-n==i) and 1 or 0 end
    end
    for i=1,n do
        local pivot=aug[i][i]
        if pivot==0 then return U.identity(n) end
        for j=i,2*n do aug[i][j]=aug[i][j]/pivot end
        for k=1,n do
            if k~=i then
                local factor=aug[k][i]
                for j=i,2*n do
                    aug[k][j]=aug[k][j]-factor*aug[i][j]
                end
            end
        end
    end
    local inv={}
    for i=1,n do
        inv[i]={}
        for j=1,n do inv[i][j]=aug[i][j+n] end
    end
    return inv
end
U.invert=invert

-- tiny JSON (numbers/strings/bools/tables)
function U.jsonEncode(val)
    local t=type(val)
    if t=="table" then
        local isArray=true
        local idx=1
        local parts={}
        for k,v in pairs(val) do
            if k~=idx then isArray=false break end
            idx=idx+1
        end
        if isArray then
            for i=1,#val do parts[#parts+1]=U.jsonEncode(val[i]) end
            return "["..table.concat(parts,",").."]"
        else
            for k,v in pairs(val) do
                parts[#parts+1]=string.format("\"%s\":%s",k,U.jsonEncode(v))
            end
            return "{"..table.concat(parts,",").."}"
        end
    elseif t=="string" then
        return string.format("\"%s\"",val:gsub("\n","\\n"))
    elseif t=="number" or t=="boolean" then
        return tostring(val)
    else
        return "null"
    end
end

local function parseValue(str)
    local f=load("return "..str)
    if f then return f() end
end

function U.jsonDecode(str)
    local ok, res = pcall(parseValue, str)
    if ok then return res end
end

return U
