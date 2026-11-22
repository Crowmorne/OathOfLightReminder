-- Settings: a category under Options -> AddOns.

local _, ns = ...

if not ns.AddonIsActive() then return end

local L = ns.L

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
--   (style, barWidth, size, hideUntil, showWhen, attachTo, attachSide, locked).
-- oathDuration: how long Oath of Light lasts, in seconds.
-- actions: { resetPosition = function, appearanceChanged = function,
--   positionChanged = function, lockChanged = function }
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
        RegisterSetting("style", Settings.VarType.String, L.SETTING_DISPLAY_STYLE, "default", AppearanceChanged),
        function()
            local container = Settings.CreateControlTextContainer()
            container:Add("default", L.SETTING_DISPLAY_STYLE_DEFAULT)
            container:Add("actionBar", L.SETTING_DISPLAY_STYLE_ACTION_BAR)
            container:Add("trackedBuff", L.SETTING_DISPLAY_STYLE_TRACKED_BUFF)
            container:Add("trackedBar", L.SETTING_DISPLAY_STYLE_TRACKED_BAR)
            return container:GetData()
        end,
        L.SETTING_DISPLAY_STYLE_TOOLTIP
    )

    -- Only used by the Tracked Bar style; greyed out for the others.
    local barWidthInitializer = Settings.CreateSlider(
        category,
        RegisterSetting("barWidth", Settings.VarType.Number, L.SETTING_BAR_WIDTH, 100, AppearanceChanged),
        PercentSliderOptions(1), -- like the Cooldown Manager's bar width
        L.SETTING_BAR_WIDTH_TOOLTIP
    )
    barWidthInitializer:SetParentInitializer(styleInitializer, function()
        return savedData.style == "trackedBar"
    end)

    Settings.CreateSlider(
        category,
        RegisterSetting("size", Settings.VarType.Number, L.SETTING_SIZE, 100, AppearanceChanged),
        PercentSliderOptions(10), -- like the Cooldown Manager's icon size
        L.SETTING_SIZE_TOOLTIP
    )

    -- Seconds, shown as "m:ss". The default shows the icon for the whole Oath.
    local function FormatTime(seconds)
        return ("%d:%02d"):format(math.floor(seconds / 60), seconds % 60)
    end
    local hideUntilOptions = Settings.CreateSliderOptions(0, oathDuration, 5)
    hideUntilOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, FormatTime)
    Settings.CreateSlider(
        category,
        RegisterSetting("hideUntil", Settings.VarType.Number, L.SETTING_HIDE_UNTIL, oathDuration),
        hideUntilOptions,
        L.SETTING_HIDE_UNTIL_TOOLTIP:format(FormatTime(oathDuration), FormatTime(0))
    )

    Settings.CreateDropdown(
        category,
        RegisterSetting("showWhen", Settings.VarType.String, L.SETTING_SHOW, "always"),
        function()
            local container = Settings.CreateControlTextContainer()
            container:Add("always", L.SETTING_SHOW_ALWAYS)
            container:Add("inCombat", L.SETTING_SHOW_IN_COMBAT)
            return container:GetData()
        end,
        L.SETTING_SHOW_TOOLTIP
    )

    local sideSetting = RegisterSetting("attachSide", Settings.VarType.String, L.SETTING_SIDE, "below", PositionChanged)

    -- Tracked Bars always stack vertically, so only above and below continue them.
    local function SideFitsAttachTo()
        local side = savedData.attachSide
        return savedData.attachTo ~= "trackedBars" or side == "above" or side == "below"
    end

    local attachSetting = RegisterSetting("attachTo", Settings.VarType.String,
        L.SETTING_ATTACH_TO:format(L.COOLDOWN_MANAGER), "none",
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
            container:Add("none", L.SETTING_ATTACH_TO_NONE)
            container:Add("trackedBuffs", L.SETTING_ATTACH_TO_TRACKED_BUFFS)
            container:Add("trackedBars", L.SETTING_ATTACH_TO_TRACKED_BARS)
            return container:GetData()
        end,
        L.SETTING_ATTACH_TO_TOOLTIP:format(L.COOLDOWN_MANAGER, L.SETTING_ATTACH_TO_NONE)
    )

    -- Built each time the dropdown opens, so it only lists sides that fit.
    local sideInitializer = Settings.CreateDropdown(
        category,
        sideSetting,
        function()
            local container = Settings.CreateControlTextContainer()
            container:Add("above", L.SETTING_SIDE_ABOVE)
            container:Add("below", L.SETTING_SIDE_BELOW)
            if savedData.attachTo ~= "trackedBars" then
                container:Add("left", L.SETTING_SIDE_LEFT)
                container:Add("right", L.SETTING_SIDE_RIGHT)
            end
            return container:GetData()
        end,
        L.SETTING_SIDE_TOOLTIP:format(L.COOLDOWN_MANAGER)
    )
    sideInitializer:SetParentInitializer(attachInitializer, function()
        return savedData.attachTo ~= "none"
    end)

    Settings.CreateCheckbox(
        category,
        RegisterSetting("locked", Settings.VarType.Boolean, L.SETTING_LOCK_POSITION, false, function()
            actions.lockChanged()
        end),
        L.SETTING_LOCK_POSITION_TOOLTIP
    )

    layout:AddInitializer(CreateSettingsButtonInitializer(
        L.SETTING_ICON_POSITION,
        L.SETTING_ICON_POSITION_BUTTON,
        function()
            attachSetting:SetValue("none")
            actions.resetPosition()
        end,
        L.SETTING_ICON_POSITION_TOOLTIP,
        true
    ))

    Settings.RegisterAddOnCategory(category)

    function settings:Open()
        Settings.OpenToCategory(category:GetID())
    end

    -- True while the settings panel shows this page.
    function settings:IsOpen()
        return SettingsPanel:IsShown() and SettingsPanel:GetCurrentCategory() == category
    end

    -- Sets "Attach to Cooldown Manager" to No.
    function settings:Detach()
        attachSetting:SetValue("none")
    end

    return settings
end
