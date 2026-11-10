-- Settings: a category under Options -> AddOns.

local _, ns = ...

-- Core.lua stops early for non-Paladins, so there's nothing to configure.
if not ns.ResetPosition then return end

local category

-- Called by Core.lua once OathOfLightReminderDB exists, because the
-- checkbox stores its value there.
function ns.RegisterSettings()
    local layout
    category, layout = Settings.RegisterVerticalLayoutCategory("Oath of Light Reminder")

    local setting = Settings.RegisterAddOnSetting(
        category,
        "OathOfLightReminder_ShowCooldownNumbers",
        "showCooldownNumbers",
        OathOfLightReminderDB,
        Settings.VarType.Boolean,
        "Action Bar Cooldown style",
        false
    )
    setting:SetValueChangedCallback(ns.ApplyStyle)
    Settings.CreateCheckbox(
        category,
        setting,
        "Shows the countdown on the icon like an action button, instead of below it."
    )

    layout:AddInitializer(CreateSettingsButtonInitializer(
        "Icon position",
        "Reset position",
        ns.ResetPosition,
        "Moves the icon back to its default position.",
        true
    ))

    Settings.RegisterAddOnCategory(category)
end

function ns.OpenSettings()
    Settings.OpenToCategory(category:GetID())
end
