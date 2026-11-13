-- Settings: a category under Options -> AddOns.

local _, ns = ...

if not ns.AddonIsActive() then return end

-- Slider from 50% to 200% in steps of step percent, labelled like "120%".
local function PercentSliderOptions(step)
    local options = Settings.CreateSliderOptions(50, 200, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
        return ("%d%%"):format(value)
    end)
    return options
end

-- Returns a settings object; settings:Open() shows the page. Call once.
-- savedData: the table the settings store their values in (style, barWidth, size).
-- actions: { resetPosition = function, appearanceChanged = function }
function ns.CreateSettings(savedData, actions)
    local settings = {}

    local category, layout = Settings.RegisterVerticalLayoutCategory("Oath of Light Reminder")

    local function RegisterSetting(key, varType, label, default)
        local setting = Settings.RegisterAddOnSetting(
            category, "OathOfLightReminder_" .. key, key, savedData, varType, label, default
        )
        setting:SetValueChangedCallback(function() actions.appearanceChanged() end)
        return setting
    end

    local styleInitializer = Settings.CreateDropdown(
        category,
        RegisterSetting("style", Settings.VarType.String, "Display style", "default"),
        function()
            local container = Settings.CreateControlTextContainer()
            container:Add("default", "Default")
            container:Add("actionBar", "Action Bar button")
            container:Add("trackedBuff", "Tracked Buff")
            container:Add("trackedBar", "Tracked Bar")
            return container:GetData()
        end,
        "How the icon looks."
    )

    -- Only used by the Tracked Bar style; greyed out for the others.
    local barWidthInitializer = Settings.CreateSlider(
        category,
        RegisterSetting("barWidth", Settings.VarType.Number, "Bar width", 100),
        PercentSliderOptions(1), -- like the Cooldown Manager's bar width
        "Width of the bar in the Tracked Bar style."
    )
    barWidthInitializer:SetParentInitializer(styleInitializer, function()
        return savedData.style == "trackedBar"
    end)

    Settings.CreateSlider(
        category,
        RegisterSetting("size", Settings.VarType.Number, "Size", 100),
        PercentSliderOptions(10), -- like the Cooldown Manager's icon size
        "Size of the icon or bar."
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
