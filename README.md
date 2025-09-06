# Smartbot

Smartbot is a World of Warcraft Retail addon that learns per-spec stat weights from play and can automatically equip upgrades out of combat. It integrates with Details! Damage Meter when available, falling back to a lightweight internal meter otherwise.

## Usage
1. Install Smartbot in `Interface/AddOns`.
2. In game, type `/smartbot` to open the settings panel.
3. Enable auto-equip if desired and adjust the minimum upgrade delta.
4. Hover items to see Smartbot score deltas; upgrades may be equipped automatically when out of combat.

## Development
This repository also contains reference addons used for API discovery. Smartbot remains independent and stores its own saved variables.

## License
Smartbot is released under the MIT License. See `LICENSE` for details.
