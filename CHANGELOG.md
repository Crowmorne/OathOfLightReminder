# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/2.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [Unreleased]

### Added

- "Attach to Cooldown Manager" option in the settings: keeps the icon next to your Tracked Buffs or Tracked Bars, on the side you choose and with the same spacing as their own icons, and moves it along when you move them or change their padding in Edit Mode.
  Dragging the icon detaches it again.
- "Hide until" option in the settings: keeps the icon hidden until only that much time is left, or until it's time to recast.
  While the addon's settings page is open, the icon is always shown, so you can move it and see your changes.
- "Show" option in the settings: choose "In combat only" to hide the icon whenever you're out of combat.


## [0.2.0] - 2026-11-13

### Added

- Right-click the icon and choose "Reset timer" to show "Recast" right away.
- The right-click menu also has "Settings", which opens the addon's settings page.
- Display style option in the settings:
  - "**Default**": the countdown below the icon.
  - "**Action Bar button**": the countdown on the icon.
  - "**Tracked Buff**": looks like a tracked buff in the Cooldown Manager.
  - "**Tracked Bar**": looks like a tracked bar in the Cooldown Manager.
- Size option in the settings, and a bar width option for the "Tracked Bar" style.


## [0.1.0] - 2026-11-09

### Added

- Icon with a 5-minute countdown and cooldown swipe, starting when you cast Oath of Light.
- The icon turns grey and shows "Recast" when the countdown runs out.
- The countdown continues after `/reload` and relogging.
- Drag the icon to move it.
  Its position is saved per character.
- Settings page under Options → AddOns with a button to reset the icon's position.
- The addon only runs for Paladins who know Oath of Light.

[Unreleased]: https://github.com/Crowmorne/OathOfLightReminder/compare/0.2.0...HEAD
[0.2.0]: https://github.com/Crowmorne/OathOfLightReminder/releases/tag/0.2.0
[0.1.0]: https://github.com/Crowmorne/OathOfLightReminder/releases/tag/0.1.0
