-- Portable runner for local use (no external libs).
-- Runs every *_spec.lua tracked by git, in sorted order.
local function read_specs()
  local f = io.popen("git ls-files \"*_spec.lua\"")
  if not f then return {} end
  local t = {}
  for line in f:lines() do t[#t+1] = line end
  f:close()
  table.sort(t)
  return t
end

local failures = 0
for _, path in ipairs(read_specs()) do
  io.stdout:write("[RUN] "..path.."\n")
  local chunk, loadErr = loadfile(path)
  if not chunk then
    io.stderr:write("[FAIL] "..path..": "..tostring(loadErr).."\n")
    failures = failures + 1
  else
    local ok, runErr = pcall(chunk)
    if not ok then
      io.stderr:write("[FAIL] "..path..": "..tostring(runErr).."\n")
      failures = failures + 1
    else
      io.stdout:write("[ OK] "..path.."\n")
    end
  end
end
if failures > 0 then os.exit(1) end
