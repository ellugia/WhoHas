# WhoHas [MOD]

Variant focused on Turtle WoW / WoW 1.12 item tooltips opened from chat.

## Behavior
- Reads item ownership data from `PossessionsData`.
- Shows counts for the current character and stored alts on the same realm.
- Shows only inventory/bags and bank counts.
- Prioritizes the item card opened by clicking an item link in chat (`ItemRefTooltip`).
- Inserts a blank separator line before the ownership section when matches are found.
- Keeps the basic hover behavior when the normal tooltip path still fires.

## Slash commands
- `/whohasmod`
- `/whm`

Supported options:
- `on`
- `off`
- `totals`
- `stacks`
