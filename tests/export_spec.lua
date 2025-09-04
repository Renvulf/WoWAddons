local Model = dofile("Smartbot/Model.lua")

local m1 = Model:New()
m1.w = {1,2,3,4,5,6,7,8,9,10}
m1.mean = {10,9,8,7,6,5,4,3,2}
m1.var = {1,1,1,1,1,1,1,1,1}
m1.n = 5
local data = m1:Export()
assert(type(data) == "string" and #data > 0, "export string")
local m2, err = Model.Import(data)
assert(m2, err)
for i=1,10 do assert(m2.w[i] == m1.w[i], "w mismatch") end
assert(m2.n == m1.n, "n mismatch")
-- corrupt data should fail checksum
local bad = data:sub(1, #data-1) .. 'A'
local m3 = Model.Import(bad)
assert(not m3, "checksum should fail")
print("export_spec passed")
