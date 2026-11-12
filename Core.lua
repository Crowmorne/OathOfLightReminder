local _, ns = ... -- private table shared by all files of this addon

if not ns.AddonIsActive() then return end

local SPELL_ID = 1328548 -- Oath of Light
local DURATION = 300     -- 5 minutes

local icon = ns.CreateIcon({
    default = ns.CreateDefaultStyle(),
    actionBar = ns.CreateActionBarStyle(),
    trackedBuff = ns.CreateTrackedBuffStyle(),
    trackedBar = ns.CreateTrackedBarStyle(SPELL_ID),
}, "default")
icon:SetSpell(SPELL_ID)

local frame = CreateFrame("Frame")

---------------------------------------------------------------------------
-- Oath timer: starts when you cast Oath of Light, runs for DURATION.
-- Names and buff data are secret inside instances, so the timer is all
-- the addon can rely on.
--
-- The end time is also saved per character in OathOfLightReminderDB as
-- server time, so the timer survives /reload and relogging. GetTime() is
-- used for the countdown itself because it has sub-second precision.
---------------------------------------------------------------------------

local expiresAt -- GetTime() value when the Oath runs out, nil if none

local function StartOath(remaining)
    expiresAt = GetTime() + remaining
    icon:ShowRunning(expiresAt - DURATION, DURATION)
end

local function EndOath()
    expiresAt = nil
    OathOfLightReminderDB.expiresAt = nil
    icon:ShowExpired()
end

local function OnOathCast()
    OathOfLightReminderDB.expiresAt = GetServerTime() + DURATION
    StartOath(DURATION)
end

-- Resumes a saved timer after /reload or login, or shows "Recast" if it has run out.
local function RestoreOath()
    local saved = OathOfLightReminderDB.expiresAt
    local remaining = saved and saved - GetServerTime()
    if remaining and remaining > 0 then
        StartOath(remaining)
    else
        EndOath()
    end
end

frame:SetScript("OnUpdate", function()
    if not expiresAt then return end
    local remaining = math.ceil(expiresAt - GetTime())
    if remaining <= 0 then
        EndOath()
    else
        icon:ShowRemaining(remaining)
    end
end)

---------------------------------------------------------------------------
-- Enabling: only if you know Oath of Light.
---------------------------------------------------------------------------

local enabled = false

local function Enable()
    enabled = true
    frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
    RestoreOath()
    icon:Show()
end

local function Disable()
    enabled = false
    frame:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    expiresAt = nil
    icon:Hide()
end

local function UpdateEnabled()
    local knows = C_SpellBook.IsSpellKnown(SPELL_ID)
    if knows and not enabled then
        Enable()
    elseif not knows and enabled then
        Disable()
    end
end

---------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------

local handlers = {}

handlers.PLAYER_LOGIN = UpdateEnabled   -- login and reload
handlers.SPELLS_CHANGED = UpdateEnabled -- learning or unlearning the talent

function handlers.UNIT_SPELLCAST_SUCCEEDED(_, _, spellId)
    if spellId == SPELL_ID then
        OnOathCast()
    end
end

-- Saved variables are loaded before this event; create the table on first use.
-- Everything that reads them is set up here.
function handlers.ADDON_LOADED(addonName)
    if addonName ~= "OathOfLightReminder" then return end
    OathOfLightReminderDB = OathOfLightReminderDB or {}

    -- Icon position, saved per character.
    icon:SetPosition(OathOfLightReminderDB.position)
    icon:SetOnMoved(function(position)
        OathOfLightReminderDB.position = position
    end)

    -- Display style, saved per character by the settings.
    local function ApplyStyle()
        icon:SetStyle(OathOfLightReminderDB.style)
    end
    ApplyStyle()

    local settings = ns.CreateSettings(OathOfLightReminderDB, {
        resetPosition = function()
            OathOfLightReminderDB.position = nil
            icon:SetPosition(nil)
        end,
        styleChanged = ApplyStyle,
    })

    -- Right-click the icon for the context menu.
    local contextMenu = ns.CreateContextMenu({
        resetTimer = EndOath,
        openSettings = function() settings:Open() end,
    })
    icon:SetRightClick(function(owner) contextMenu:Open(owner) end)

    frame:UnregisterEvent("ADDON_LOADED")
end

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("SPELLS_CHANGED")
frame:SetScript("OnEvent", function(_, event, ...)
    handlers[event](...)
end)
