std = "lua51"
quiet = 1
self = false -- methods don't have to use self

exclude_files = {
	"**/Libs",
}

globals = {
    -- WoW API
    "BuffBarCooldownViewer",
    "BuffIconCooldownViewer",
    "COOLDOWN_DURATION_SEC",
    "C_Spell",
    "C_SpellBook",
    "CreateFrame",
    "CreateFromMixins",
    "CreateSettingsButtonInitializer",
    "GetServerTime",
    "GetTime",
    "hooksecurefunc",
    "MenuUtil",
    "MinimalSliderWithSteppersMixin",
    "Settings",
    "UIParent",
    "UnitClass",

    -- Oath of Light Reminder
    "OathOfLightReminderDB",
}
