# Oath of Light Reminder

A WoW addon for the **WoW Forever** client.
It reminds Paladins to recast the talent _Oath of Light_ (lasts 5 minutes) on an ally.


## Decisions

- **Track the cast, never the buff.**
  Don't scan party or raid members, match names or read auras; names and aura data are secret in dungeons (see below).
  The icon can't tell if the Oath ends early, and that's fine.
- **The 5-minute duration is hard-coded.**
  There is no API for a spell's duration.
- **All saved data is per character.**
  Don't add account-wide saved variables.
- **Prefer the settings page over slash commands.**


## Changelog

- `CHANGELOG.md` follows Keep a Changelog.
- **Every user-facing change gets an entry under `## [Unreleased]`**, in the same change as the code.
  Use the categories `Added`, `Changed`, `Fixed` and `Removed`.
- **Entries are written for players**, one line each, describing what they notice in game.
  No function names, events or other implementation details.
- **Internal changes don't get entries**, for example refactoring, comments or tooling.
- **The changelog lists only what changed between releases.**
  Changes made and undone before a release don't appear in it.
- **Releases are handled by the user.**
  Don't move entries out of `[Unreleased]` or add version headings unless asked.


## Verified game API facts (tested in game on Forever)

- **Oath of Light:** spell ID `1328548`.
  The buff has the same ID and name.
  Its icon file ID is `135909`.
- **Names:** `UnitName(unit)` returns **first name and last name**, not name and realm.
  `UNIT_SPELLCAST_SENT` gives the target as `"First Last"`.
- **Names are not unit IDs:** buff functions don't accept player names, only unit IDs (`"player"`, `"party2"`, …).
- **Secret values are active on Forever:**
  - **Open world, out of combat:** auras are readable, even on players outside the group.
  - **Open world, in combat:** auras on other units come back empty.
  - **Dungeons, even out of combat:** `UnitName` returns secret strings, and reading auras throws "Auras cannot be accessed when secret".
    Comparing a secret value throws an error.
  - **`UNIT_SPELLCAST_SUCCEEDED` for `"player"`:** comparing its spell ID works in dungeons.


## Working with the user

- **Testing:** the user tests everything in game.
  Give short numbered test steps with the expected result.
  Don't write "I haven't tested this in game".
- **When unclear, ask first.**
  Don't read extra requirements into a sentence.
- **Build only what was asked**, in small steps.
  No speculative features, settings or slash commands.
- **Forever only:** no compatibility code for other clients, and no "this might differ on Forever" caveats for standard WoW addon behaviour.
- **Answers:** answer the question directly first.
  If something doesn't exist (yet), say so plainly before explaining anything hypothetical.
- **Comments** describe what the code does.
  Don't list other files or future modules in them.
- **Never record history.**
  Comments, READMEs, CLAUDE.md and code describe the current state only.
  Never mention what was tried, built, removed, rejected or discussed in a session.
