# Changelog

Attribution lineage for this release:
- `WhoHas` is based on https://github.com/Road-block/WhoHas
- `Possessions` is used from https://github.com/refaim/Possessions
- `refaim/Possessions` comes from the earlier fork at https://github.com/Road-block/Possessions

## 2026-03-26 - WhoHas 0.2

### Added
- A one-time chat message when `Possessions` is detected and item ownership data is ready.
- Version reporting in `/whohasmod` status output, sourced from addon metadata with a safe fallback.

### Changed
- Bumped the public addon version from `0.1` to `0.2`.
- Updated the chat prefix from `WhoHas [MOD]` to `WhoHas`.
- Clarified credits and source lineage in project documentation and addon metadata.

### Documentation
- Documented the successful backend-ready startup message in `README.md`.
- Simplified the `Codex` development-assistant note in `README.md`.

## 2026-03-26 - WhoHas 0.1

### Added
- Support for reading item ownership only from `PossessionsData`.
- Support for showing counts for the current character and stored alts on the same realm.
- A blank separator line before ownership lines when matches are found.
- Minimal slash commands: `/whohasmod` and `/whm`.
- `.gitignore` entry for `AGENTS.md` so local agent instructions are not pushed to GitHub.

### Changed
- Reworked the addon to focus on chat-linked item tooltips via `ItemRefTooltip`.
- Limited displayed ownership locations to `inventory` and `bank`.
- Updated addon metadata and README to match the initial public release.

### Removed
- Legacy integration paths and assumptions for old backends and extra tooltip/config UI behavior not used by this variant.
