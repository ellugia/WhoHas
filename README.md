# WhoHas

Initial Turtle WoW / WoW 1.12 release focused on item tooltips opened from chat.

## Credits
- `ellugia` for this release and current maintenance.
- `road-block` for prior WhoHas maintenance work that informed this variant.
- `refaim` for `Possessions`, which provides the ownership data backend used by this addon.

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

## Development note
This version was developed with Codex as a development assistant. Codex is not part of the addon author metadata.
