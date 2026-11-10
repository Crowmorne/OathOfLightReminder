local _, ns = ... -- private table shared by all files of this addon

local _, class = UnitClass("player")
if class ~= "PALADIN" then return end

local SPELL_ID = 1328548 -- Oath of Light
local DURATION = 300     -- 5 minutes

---------------------------------------------------------------------------
-- Icon: creates the frame and the functions that change how it looks.
-- When to call them is decided by the Oath timer below.
---------------------------------------------------------------------------

local DEFAULT_POSITION = { point = "CENTER", relativePoint = "CENTER", x = 0, y = 120 }

local icon = CreateFrame("Frame", nil, UIParent)
icon:SetSize(44, 44)
icon:Hide()

icon.texture = icon:CreateTexture(nil, "ARTWORK")
icon.texture:SetAllPoints()
icon.texture:SetTexture(C_Spell.GetSpellTexture(SPELL_ID))

icon.cooldown = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
-- Inset so the square swipe stays inside the icon's rounded corners.
icon.cooldown:SetPoint("TOPLEFT", 2, -2)
icon.cooldown:SetPoint("BOTTOMRIGHT", -2, 2)
icon.cooldown:SetHideCountdownNumbers(true)

icon.text = icon:CreateFontString(nil, "OVERLAY", "GameFontNormal")
icon.text:SetPoint("TOP", icon, "BOTTOM", 0, -2)

-- Dragging: the position is saved per character in OathOfLightReminderDB.position.
icon:SetMovable(true)
icon:SetClampedToScreen(true)
icon:EnableMouse(true)
icon:RegisterForDrag("LeftButton")

icon:SetScript("OnDragStart", icon.StartMoving)
icon:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, _, relativePoint, x, y = self:GetPoint()
    OathOfLightReminderDB.position = { point = point, relativePoint = relativePoint, x = x, y = y }
end)

local function RestorePosition()
    local position = OathOfLightReminderDB.position or DEFAULT_POSITION
    icon:ClearAllPoints()
    icon:SetPoint(position.point, UIParent, position.relativePoint, position.x, position.y)
end

local function ResetPosition()
    OathOfLightReminderDB.position = nil
    RestorePosition()
end
ns.ResetPosition = ResetPosition -- used by Settings.lua

local function ShowRecast()
    icon.cooldown:Clear()
    icon.texture:SetDesaturated(true)
    icon.text:SetText("Recast")
end

local function ShowRunning(startedAt)
    icon.cooldown:SetCooldown(startedAt, DURATION)
    icon.texture:SetDesaturated(false)
end

local function ShowRemaining(seconds)
    icon.text:SetText(("%d:%02d"):format(math.floor(seconds / 60), seconds % 60))
end

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
    ShowRunning(expiresAt - DURATION)
end

local function EndOath()
    expiresAt = nil
    OathOfLightReminderDB.expiresAt = nil
    ShowRecast()
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

icon:SetScript("OnUpdate", function()
    if not expiresAt then return end
    local remaining = math.ceil(expiresAt - GetTime())
    if remaining <= 0 then
        EndOath()
    else
        ShowRemaining(remaining)
    end
end)

---------------------------------------------------------------------------
-- Context menu: right-click the icon.
---------------------------------------------------------------------------

icon:SetScript("OnMouseUp", function(self, button)
    if button ~= "RightButton" then return end

    MenuUtil.CreateContextMenu(self, function(_, rootDescription)
        rootDescription:CreateButton("Reset timer", EndOath)
        rootDescription:CreateDivider()
        rootDescription:CreateButton("Settings", ns.OpenSettings)
    end)
end)

---------------------------------------------------------------------------
-- Enabling: only if you know Oath of Light.
---------------------------------------------------------------------------

local frame = CreateFrame("Frame")
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
function handlers.ADDON_LOADED(addonName)
    if addonName ~= "OathOfLightReminder" then return end
    OathOfLightReminderDB = OathOfLightReminderDB or {}
    RestorePosition()
    frame:UnregisterEvent("ADDON_LOADED")
end

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("SPELLS_CHANGED")
frame:SetScript("OnEvent", function(_, event, ...)
    handlers[event](...)
end)
