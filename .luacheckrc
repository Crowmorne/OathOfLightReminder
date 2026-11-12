std = "lua51"
quiet = 1
self = false -- methods don't have to use self

exclude_files = {
	"**/Libs",
}

globals = {
    -- WoW API
    "C_Spell",
    "C_SpellBook",
    "CreateFrame",
    "CreateFromMixins",
    "CreateSettingsButtonInitializer",
    "GetServerTime",
    "GetTime",
    "MenuUtil",
    "Settings",
    "UIParent",
    "UnitClass",

    -- Oath of Light Reminder
    "OathOfLightReminderDB",
}
