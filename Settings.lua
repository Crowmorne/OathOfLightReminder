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
-- savedData: the table the settings store their values in
--   (style, barWidth, size, hideUntil, attachTo, attachSide).
-- oathDuration: how long Oath of Light lasts, in seconds.
-- actions: { resetPosition = function, appearanceChanged = function, positionChanged = function }
function ns.CreateSettings(savedData, oathDuration, actions)
    local settings = {}

    local category, layout = Settings.RegisterVerticalLayoutCategory("Oath of Light Reminder")

    -- onChanged: called after the value changed; nil if the value is read when needed.
    local function RegisterSetting(key, varType, label, default, onChanged)
        local setting = Settings.RegisterAddOnSetting(
            category, "OathOfLightReminder_" .. key, key, savedData, varType, label, default
        )
        if onChanged then
            setting:SetValueChangedCallback(function() onChanged() end)
        end
        return setting
    end

    local function AppearanceChanged() actions.appearanceChanged() end
    local function PositionChanged() actions.positionChanged() end

    local styleInitializer = Settings.CreateDropdown(
        category,
        RegisterSetting("style", Settings.VarType.String, "Display style", "default", AppearanceChanged),
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
        RegisterSetting("barWidth", Settings.VarType.Number, "Bar width", 100, AppearanceChanged),
        PercentSliderOptions(1), -- like the Cooldown Manager's bar width
        "Width of the bar in the Tracked Bar style."
    )
    barWidthInitializer:SetParentInitializer(styleInitializer, function()
        return savedData.style == "trackedBar"
    end)

    Settings.CreateSlider(
        category,
        RegisterSetting("size", Settings.VarType.Number, "Size", 100, AppearanceChanged),
        PercentSliderOptions(10), -- like the Cooldown Manager's icon size
        "Size of the icon or bar."
    )

    -- Seconds, shown as "m:ss". The default shows the icon for the whole Oath.
    local function FormatTime(seconds)
        return ("%d:%02d"):format(math.floor(seconds / 60), seconds % 60)
    end
    local hideUntilOptions = Settings.CreateSliderOptions(0, oathDuration, 5)
    hideUntilOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, FormatTime)
    Settings.CreateSlider(
        category,
        RegisterSetting("hideUntil", Settings.VarType.Number, "Hide until", oathDuration),
        hideUntilOptions,
        "Hides the icon until this much time is left.\n"
            .. FormatTime(oathDuration) .. ": always shown.\n"
            .. "0:00: only shown once it's time to recast."
    )

    local sideSetting = RegisterSetting("attachSide", Settings.VarType.String, "Side", "below", PositionChanged)

    -- Tracked Bars always stack vertically, so only above and below continue them.
    local function SideFitsAttachTo()
        local side = savedData.attachSide
        return savedData.attachTo ~= "trackedBars" or side == "above" or side == "below"
    end

    local attachSetting = RegisterSetting("attachTo", Settings.VarType.String, "Attach to Cooldown Manager", "none",
        function()
            if not SideFitsAttachTo() then
                sideSetting:SetValue("below")
            end
            PositionChanged()
        end
    )

    local attachInitializer = Settings.CreateDropdown(
        category,
        attachSetting,
        function()
            local container = Settings.CreateControlTextContainer()
            container:Add("none", "No")
            container:Add("trackedBuffs", "Tracked Buffs")
            container:Add("trackedBars", "Tracked Bars")
            return container:GetData()
        end,
        "Keeps the icon next to a Cooldown Manager frame, and moves it along when that frame moves. "
            .. "Dragging the icon sets this back to No."
    )

    -- Built each time the dropdown opens, so it only lists sides that fit.
    local sideInitializer = Settings.CreateDropdown(
        category,
        sideSetting,
        function()
            local container = Settings.CreateControlTextContainer()
            container:Add("above", "Above")
            container:Add("below", "Below")
            if savedData.attachTo ~= "trackedBars" then
                container:Add("left", "Left")
                container:Add("right", "Right")
            end
            return container:GetData()
        end,
        "Which side of the Cooldown Manager frame the icon is attached to."
    )
    sideInitializer:SetParentInitializer(attachInitializer, function()
        return savedData.attachTo ~= "none"
    end)

    layout:AddInitializer(CreateSettingsButtonInitializer(
        "Icon position",
        "Reset position",
        function()
            attachSetting:SetValue("none")
            actions.resetPosition()
        end,
        "Moves the icon back to its default position.",
        true
    ))

    Settings.RegisterAddOnCategory(category)

    function settings:Open()
        Settings.OpenToCategory(category:GetID())
    end

    -- Sets "Attach to Cooldown Manager" to No.
    function settings:Detach()
        attachSetting:SetValue("none")
    end

    return settings
end
