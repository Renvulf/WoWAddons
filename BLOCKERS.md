# Blockers

- Missing Lua interpreter prevents running self-tests and health check.
  - Context: Unable to execute Lua scripts for tests and Smartbot:HealthCheck.
  - Error: `bash: command not found: lua` when running `/tmp/run_health_check.lua`.
  - Files: tests/*, Smartbot/Smartbot.lua
  - Next steps: Install a Lua interpreter (e.g., lua5.1) or provide environment with Lua to run tests and /sb learn health.
- Apt repositories return 403, preventing installation of Lua interpreter.
  - Context: Attempted `sudo apt-get update` before installing lua5.1.
  - Error: `E: The repository 'http://archive.ubuntu.com/ubuntu noble InRelease' is not signed.` and other 403 Forbidden errors.
  - Files: tests/*, Smartbot/Smartbot.lua
  - Next steps: Fix apt repository access or provide pre-installed Lua interpreter to run tests and /sb learn health.
- Another attempt to install Lua via apt-get update failed with 403 Forbidden, leaving tests unrun.
