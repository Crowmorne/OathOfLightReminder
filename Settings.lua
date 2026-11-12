-- Settings: a category under Options -> AddOns.

local _, ns = ...

if not ns.AddonIsActive() then return end

-- Returns a settings object; settings:Open() shows the page. Call once.
-- savedData: the table the settings store their values in (style, showCooldownNumbers).
-- actions: { resetPosition = function, styleChanged = function }
function ns.CreateSettings(savedData, actions)
    local settings = {}

    local category, layout = Settings.RegisterVerticalLayoutCategory("Oath of Light Reminder")

    local styleSetting = Settings.RegisterAddOnSetting(
        category,
        "OathOfLightReminder_Style",
        "style",
        savedData,
        Settings.VarType.String,
        "Display style",
        "actionBar"
    )
    styleSetting:SetValueChangedCallback(function() actions.styleChanged() end)
    Settings.CreateDropdown(
        category,
        styleSetting,
        function()
            local container = Settings.CreateControlTextContainer()
            container:Add("actionBar", "Action Bar button")
            container:Add("trackedBuff", "Tracked Buff")
            return container:GetData()
        end,
        "How the icon looks."
    )

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
