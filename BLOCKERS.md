# Blockers

- Missing Lua interpreter prevents running self-tests and health check.
  - Context: Unable to execute Lua scripts for tests and Smartbot:HealthCheck.
  - Error: `bash: command not found: lua` when running `/tmp/run_health_check.lua`.
  - Files: tests/*, Smartbot/Smartbot.lua
  - Next steps: Install a Lua interpreter (e.g., lua5.1) or provide environment with Lua to run tests and /sb learn health.
