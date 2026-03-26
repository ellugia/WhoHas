# WhoHas

Initial Turtle WoW / WoW 1.12 release focused on item tooltips opened from chat.

## Credits
- `ellugia` for this release and current maintenance.
- `road-block` for the `WhoHas` repository this addon is based on: https://github.com/Road-block/WhoHas
- `refaim` for the `Possessions` repository used as the ownership-data backend: https://github.com/refaim/Possessions
- `road-block` for the earlier `Possessions` fork that `refaim/Possessions` builds on: https://github.com/Road-block/Possessions

## Dependency
- [Possessions](https://github.com/refaim/Possessions) is required to provide item ownership data.
- The backend in use is `refaim/Possessions`, which itself comes from the earlier `Road-block/Possessions` fork.
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
This version was developed with Codex as a development assistant.
