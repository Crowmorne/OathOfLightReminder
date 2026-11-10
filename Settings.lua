-- Settings: a category under Options -> AddOns.

local _, ns = ...

-- Core.lua stops early for non-Paladins, so there's nothing to configure.
if not ns.ResetPosition then return end

local category, layout = Settings.RegisterVerticalLayoutCategory("Oath of Light Reminder")

layout:AddInitializer(CreateSettingsButtonInitializer(
    "Icon position",
    "Reset position",
    ns.ResetPosition,
    "Moves the icon back to its default position.",
    true
))

Settings.RegisterAddOnCategory(category)

function ns.OpenSettings()
    Settings.OpenToCategory(category:GetID())
end
