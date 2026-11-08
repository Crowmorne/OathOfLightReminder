# Oath of Light Reminder

A small WoW Forever addon for Holy Paladins.


## Install

WoW only loads addons from its `Interface\AddOns` folder.
The repository likely lives elsewhere and is linked there.

On Windows, with a junction:

```powershell
New-Item -ItemType Junction -Path "C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\OathOfLightReminder" -Target "$HOME\development\OathOfLightReminder"
```

On macOS, with a symbolic link:

```sh
ln -s ~/development/MyUI "/Applications/World of Warcraft/_forever_/Interface/AddOns/MyUI"
```
