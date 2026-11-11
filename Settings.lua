-- Settings: a category under Options -> AddOns.

local _, ns = ...

if not ns.AddonIsActive() then return end

-- Returns a settings object; settings:Open() shows the page. Call once.
-- savedData: the table the checkbox stores its value in (showCooldownNumbers).
-- actions: { resetPosition = function, styleChanged = function }
function ns.CreateSettings(savedData, actions)
    local settings = {}

    local category, layout = Settings.RegisterVerticalLayoutCategory("Oath of Light Reminder")

    local setting = Settings.RegisterAddOnSetting(
        category,
        "OathOfLightReminder_ShowCooldownNumbers",
        "showCooldownNumbers",
        savedData,
        Settings.VarType.Boolean,
        "Action Bar Cooldown style",
        false
    )
    setting:SetValueChangedCallback(function() actions.styleChanged() end)
    Settings.CreateCheckbox(
        category,
        setting,
        "Shows the countdown on the icon like an action button, instead of below it."
    )

    layout:AddInitializer(CreateSettingsButtonInitializer(
        "Icon position",
        "Reset position",
        function() actions.resetPosition() end,
        "Moves the icon back to its default position.",
        true
    ))

    Settings.RegisterAddOnCategory(category)

    function settings:Open()
        Settings.OpenToCategory(category:GetID())
    end

    return settings
end
