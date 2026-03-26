# Changelog

This project is based on the `WhoHas` fork maintained at [Road-block/WhoHas](https://github.com/Road-block/WhoHas), derived from the original addon by Gruma and the later Vanilla/Turtle-compatible maintenance work published in that fork.

## 2026-03-26 - WhoHas [MOD]

### Added
- Support for reading item ownership only from `PossessionsData`.
- Support for showing counts for the current character and stored alts on the same realm.
- A blank separator line before ownership lines when matches are found.
- Minimal slash commands: `/whohasmod` and `/whm`.
- `.gitignore` entry for `AGENTS.md` so local agent instructions are not pushed to GitHub.

### Changed
- Reworked the addon to focus on chat-linked item tooltips via `ItemRefTooltip`.
- Limited displayed ownership locations to `inventory` and `bank`.
- Updated addon metadata and README to match the simplified behavior.

### Removed
- Legacy integration paths and assumptions for old backends and extra tooltip/config UI behavior not used by this variant.
