# SmartWeaver

SmartWeaver learns how your character values stats based on real combat performance
and can automatically equip upgrades when you leave combat.

## Features
- Tracks your DPS or HPS from combat logs.
- Learns stat weights using recursive least squares.
- Scores items in your bags and suggests upgrades.
- Safe equip queue swaps gear only out of combat.
- Tooltip line showing estimated upgrade percentage.
- Retail settings panel with options, data export/import, queue viewer, and per-spec reset.

All learning happens locally and no data is sent anywhere.

## Usage
- Type `/sw` to open the settings panel.
- Enable Auto-equip to allow SmartWeaver to swap gear after combat.
- Export or import data from the Settings panel.
- Toggle tooltip, exploration, or verbose logging as desired.

## Development harness
Optional Lua tests live under `DevHarness/` and can be run with a standalone Lua interpreter for offline sanity checks.
