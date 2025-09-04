DONE_STAGE:1 - Initial repository detection. DB schema, slash commands, and learning toggle already present. (Smartbot/Smartbot.lua)
DONE_STAGE:2 - Added combat segment logger skeleton with damage tracking and unit test. (Smartbot/Segment.lua Smartbot/Smartbot.lua tests/segment_spec.lua)

DONE_STAGE:3 - Implemented feature sampler with 10-element vector averaged per combat segment. (Smartbot/Features.lua Smartbot/Smartbot.lua Smartbot/Smartbot.toc tests/features_spec.lua)

DONE_STAGE:4 - Added online regression model with per-spec storage and synthetic self-test. (Smartbot/Model.lua Smartbot/Smartbot.lua tests/model_spec.lua)

DONE_STAGE:5 - Integrated learned item scoring into bag scanning and tooltips. (Smartbot/Smartbot.lua)

DONE_STAGE:6 - Added model stats panel and enabled reset button. (Smartbot/Smartbot.lua)
DONE_STAGE:7 - Added developer commands for stats, scoring, and model export/import with checksum. (Smartbot/Model.lua Smartbot/Smartbot.lua tests/export_spec.lua)

DONE_STAGE:8 - Added safeguards for missing data, non-combat equipping, and non-NaN checks. (Smartbot/Model.lua Smartbot/Smartbot.lua tests/guards_spec.lua)
DONE_REFINE:R1 - Hardened DB schema with model validation and versioning. (Smartbot/Smartbot.lua)
DONE_REFINE:R2 - Added instance and PvP learning filters. (Smartbot/Smartbot.lua)
DONE_REFINE:R3 - Added AoE learning weight controls. (Smartbot/Model.lua Smartbot/Smartbot.lua)
DONE_REFINE:R4 - Added weight clamping and negative-weight guard. (Smartbot/Model.lua Smartbot/Smartbot.lua)
DONE_REFINE:R5 - Existing ring and trinket slot logic verified.
DONE_REFINE:R6 - Enhanced tooltip with learned ΔDPS and warm-up notice. (Smartbot/Smartbot.lua)
DONE_REFINE:R7 - Verified timers and CLEU handlers reuse resources.
DONE_REFINE:R8 - Added vehicle GUID handling for combat log filtering. (Smartbot/Smartbot.lua)
DONE_REFINE:R9 - Added feature-order checksum to export/import. (Smartbot/Model.lua)
DONE_REFINE:R10 - Added developer health check command. (Smartbot/Smartbot.lua)
GATED_PRINTS - Added learnVerbose flag and logout timer cleanup. (Smartbot/Smartbot.lua)
BLOCKER: Missing Lua interpreter; cannot execute self-tests or /sb learn health to finalize.
BLOCKER: Apt repository 403 prevents installing Lua interpreter; tests and health check remain unrun.
CI_INSTALLED: .github/workflows/lua-tests.yml - Added CI workflow and local spec runner (scripts/run_specs.lua, README.md).
