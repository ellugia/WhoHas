# WhoHas [MOD]

Variant focused on Turtle WoW / WoW 1.12 item tooltips opened from chat.

## Dependency
- [Possessions](https://github.com/refaim/Possessions) is required to provide item ownership data.
- Without `Possessions`, the addon can still hook tooltips but it cannot display ownership lines.

## Behavior
- Reads item ownership data from `PossessionsData`.
- Shows counts for the current character and stored alts on the same realm.
- Shows only inventory/bags and bank counts.
- Prioritizes the item card opened by clicking an item link in chat (`ItemRefTooltip`).
- Inserts a blank separator line before the ownership section when matches are found.
- Keeps the basic hover behavior when the normal tooltip path still fires.
- Prints a one-time chat warning if `Possessions` is missing or has not produced usable data yet.

## Slash commands
- `/whohasmod`
- `/whm`

Supported options:
- `on`
- `off`
- `totals`
- `stacks`
