# Smartbot Health

## Status
- Core, logger, runtime API adapter, class/spec rules and item scoring ready
- Equip pipeline with OOC queue, min-delta damping, and slot coupling active
- Tooltip score deltas integrated via TooltipDataProcessor item data
- Settings UI registered through Retail Settings API and /smartbot opens it
- DetailsBridge with fallback internal meter operational
- Online learner with per-spec weights and persistence active
- Health checks validate API availability, interface version, load order, combat safety, DB schema version, adapter usage and Settings registration; warn on stray GetItemStats locals, tooltip:GetItem and improper equip slots

## Next Steps
- None

