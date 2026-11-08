local _, class = UnitClass("player")
if class ~= "PALADIN" then return end

local SPELL_ID = 1328548 -- Oath of Light
local DURATION = 300     -- 5 minutes

---------------------------------------------------------------------------
-- Icon: creates the frame and the functions that change how it looks.
-- When to call them is decided by the Oath timer below.
---------------------------------------------------------------------------

local icon = CreateFrame("Frame", nil, UIParent)
icon:SetSize(44, 44)
icon:SetPoint("CENTER", 0, 120)
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
---------------------------------------------------------------------------

local expiresAt -- GetTime() value when the Oath runs out, nil if none

local function StartOath()
    local now = GetTime()
    expiresAt = now + DURATION
    ShowRunning(now)
end

local function EndOath()
    expiresAt = nil
    ShowRecast()
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
-- Enabling: only if you know Oath of Light.
---------------------------------------------------------------------------

local frame = CreateFrame("Frame")
local enabled = false

local function Enable()
    enabled = true
    frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
    EndOath()
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
        StartOath()
    end
end

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("SPELLS_CHANGED")
frame:SetScript("OnEvent", function(_, event, ...)
    handlers[event](...)
end)
