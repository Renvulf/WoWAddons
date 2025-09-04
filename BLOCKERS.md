# Blockers

- Stage 8 "Polish & guards" not implemented.
  - Need fail-safes for missing item data and additional non-NaN validations.
  - Requires in-game API behaviour for async item loads and equip safety which is hard to validate in this environment.
  - Next steps: implement retries for uncached items, ensure equip queue only runs out of combat, and add pure Lua self-tests for standardization and delta mapping.
