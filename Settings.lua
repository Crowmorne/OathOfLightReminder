-- Settings: a category under Options -> AddOns.

local _, ns = ...

if not ns.AddonIsActive() then return end

local category

-- Called by Core.lua once OathOfLightReminderDB exists, because the
-- checkbox stores its value there. icon is the object from ns.CreateIcon().
function ns.RegisterSettings(icon)
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
    setting:SetValueChangedCallback(function() icon:ApplyStyle() end)
    Settings.CreateCheckbox(
        category,
        setting,
        "Shows the countdown on the icon like an action button, instead of below it."
    )

    layout:AddInitializer(CreateSettingsButtonInitializer(
        "Icon position",
        "Reset position",
        function() icon:ResetPosition() end,
        "Moves the icon back to its default position.",
        true
    ))

    Settings.RegisterAddOnCategory(category)
end

function ns.OpenSettings()
    Settings.OpenToCategory(category:GetID())
end
