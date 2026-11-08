local _, class = UnitClass("player")
if class ~= "PALADIN" then return end

local SPELL_ID = 1328548 -- Oath of Light
local DURATION = 300     -- 5 minutes

---------------------------------------------------------------------------
-- Icon: creates the frame and the functions that change how it looks.
-- When to call them is decided by the Oath tracking below.
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
-- The active Oath: who it was cast on and when it runs out. nil if none.
---------------------------------------------------------------------------

local oath -- { target = "First Last", expiresAt = <GetTime() value> }

local function StartOath(target)
    local now = GetTime()
    oath = { target = target, expiresAt = now + DURATION }
    ShowRunning(now)
end

local function EndOath()
    oath = nil
    ShowRecast()
end

icon:SetScript("OnUpdate", function()
    if not oath then return end
    local remaining = math.ceil(oath.expiresAt - GetTime())
    if remaining <= 0 then
        EndOath()
    else
        ShowRemaining(remaining)
    end
end)

---------------------------------------------------------------------------
-- Name -> unit ID. Buff functions only accept unit IDs ("player", "party2",
-- "raid7"), not names, so the remembered name has to be looked up.
---------------------------------------------------------------------------

-- UnitName returns first and last name; the cast event gives "First Last".
local function IsUnitNamed(unit, name)
    local firstName, lastName = UnitName(unit)
    if not firstName then return false end
    if lastName and lastName ~= "" then
        return firstName .. " " .. lastName == name
    end
    return firstName == name
end

-- Searches you and your party or raid. nil if the player isn't in the group.
local function FindUnitByName(name)
    if IsUnitNamed("player", name) then return "player" end

    if IsInRaid() then
        for i = 1, GetNumGroupMembers() do
            if IsUnitNamed("raid" .. i, name) then return "raid" .. i end
        end
    else
        for i = 1, GetNumSubgroupMembers() do
            if IsUnitNamed("party" .. i, name) then return "party" .. i end
        end
    end
end

---------------------------------------------------------------------------
-- Checking whether the Oath is still there.
-- Buff data is hidden in combat, so this only runs out of combat.
-- If the target can't be found, the timer stays as it is.
---------------------------------------------------------------------------

-- "PLAYER" filter: only buffs you cast, so another Paladin's Oath doesn't count.
local function HasOwnOath(unit)
    for i = 1, 40 do
        local aura = C_UnitAuras.GetAuraDataByIndex(unit, i, "HELPFUL|PLAYER")
        if not aura then return false end
        if aura.spellId == SPELL_ID then return true end
    end
    return false
end

local function VerifyOath()
    if not oath or not oath.target or InCombatLockdown() then return end
    local unit = FindUnitByName(oath.target)
    if unit and not HasOwnOath(unit) then
        EndOath()
    end
end

---------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------

local frame = CreateFrame("Frame")
local enabled = false
local castTarget -- name from UNIT_SPELLCAST_SENT, used once the cast succeeds

local OATH_EVENTS = { "UNIT_SPELLCAST_SENT", "UNIT_SPELLCAST_SUCCEEDED", "PLAYER_REGEN_ENABLED", "UNIT_AURA" }

local function Enable()
    enabled = true
    for _, event in ipairs(OATH_EVENTS) do frame:RegisterEvent(event) end
    EndOath()
    icon:Show()
end

local function Disable()
    enabled = false
    for _, event in ipairs(OATH_EVENTS) do frame:UnregisterEvent(event) end
    oath = nil
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

local handlers = {}

handlers.PLAYER_LOGIN = UpdateEnabled
handlers.SPELLS_CHANGED = UpdateEnabled

function handlers.UNIT_SPELLCAST_SENT(unit, target, _, spellId)
    if unit ~= "player" or spellId ~= SPELL_ID then return end
    castTarget = (target ~= "" and not issecretvalue(target)) and target or nil
end

function handlers.UNIT_SPELLCAST_SUCCEEDED(unit, _, spellId)
    if unit ~= "player" or spellId ~= SPELL_ID then return end
    StartOath(castTarget)
    castTarget = nil
end

handlers.PLAYER_REGEN_ENABLED = VerifyOath

function handlers.UNIT_AURA(unit)
    if InCombatLockdown() then return end
    if oath and oath.target and IsUnitNamed(unit, oath.target) then
        VerifyOath()
    end
end

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("SPELLS_CHANGED")
frame:SetScript("OnEvent", function(_, event, ...)
    handlers[event](...)
end)
