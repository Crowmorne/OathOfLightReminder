<img align="right" src="./spell_holy_greaterblessingoflight.jpg" alt="Oath of Light Symbol" />


# Oath of Light Reminder

A simple on-screen timer that reminds Holy Paladins to keep Oath of Light up.

Oath of Light lasts 5 minutes, and it's easy to forget to recast it in the middle of a dungeon.
This addon shows a small icon with a countdown, so you always know when it's time to put your Oath back on someone.


## Features

- **Countdown icon:** When you cast Oath of Light, the icon shows the time left, with a cooldown swipe like on your action bars.
- **Recast reminder:** When the time is up, the icon turns grey and shows "Recast".
- **Survives reloads and relogs:** The timer picks up where it left off after `/reload` or logging back in.
- **Movable:** Drag the icon wherever you like.
  Its position is saved per character.
- **Settings page:** Under Options → AddOns → Oath of Light Reminder, you can reset the icon to its default position.
- **Only runs when needed:** The addon does nothing on other classes, or on Paladins who haven't learned Oath of Light.


## How it works

The addon tracks your cast of Oath of Light, not the buff itself.
Buff data on other players isn't available to addons in dungeons, so the timer simply counts down 5 minutes from your cast.

This means the icon can't tell if the Oath ends early, for example when your target dies, leaves the group or removes the buff.
For a "time to recast" reminder this works well in practice.


## Development

WoW only loads addons from its `Interface\AddOns` folder.
The repository likely lives elsewhere and is linked there.

On Windows, with a junction:

```powershell
New-Item -ItemType Junction -Path "C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\OathOfLightReminder" -Target "$HOME\development\OathOfLightReminder"
```

On macOS, with a symbolic link:

```sh
ln -s ~/development/OathOfLightReminder "/Applications/World of Warcraft/_forever_/Interface/AddOns/OathOfLightReminder"
```


### Linting

The code is checked with [luacheck](https://github.com/lunarmodules/luacheck), using the settings in `.luacheckrc`.
CI runs it on every push, so install it locally to catch warnings before pushing:

```sh
scoop install luacheck      # Windows
brew install luacheck       # macOS
luarocks install luacheck   # anywhere with LuaRocks
```

Then run it from the repository root:

```sh
luacheck .
```
