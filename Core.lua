local _, class = UnitClass("player")
if class ~= "PALADIN" then return end

local SPELL_ID = 1328548 -- Oath of Light
local DURATION = 300     -- 5 minutes

local enabled = false
local expiresAt

local frame = CreateFrame("Frame")

local icon = CreateFrame("Frame", nil, UIParent)
icon:SetSize(44, 44)
icon:SetPoint("CENTER", 0, 120)
icon:Hide()

icon.texture = icon:CreateTexture(nil, "ARTWORK")
icon.texture:SetAllPoints()
icon.texture:SetTexture(C_Spell.GetSpellTexture(SPELL_ID))

icon.cooldown = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
icon.cooldown:SetAllPoints()
icon.cooldown:SetHideCountdownNumbers(true)

icon.text = icon:CreateFontString(nil, "OVERLAY", "GameFontNormal")
icon.text:SetPoint("TOP", icon, "BOTTOM", 0, -2)

local function ShowExpired()
    expiresAt = nil
    icon.cooldown:Clear()
    icon.texture:SetDesaturated(true)
    icon.text:SetText("Recast")
end

local function OnOathCast()
    local now = GetTime()
    expiresAt = now + DURATION
    icon.cooldown:SetCooldown(now, DURATION)
    icon.texture:SetDesaturated(false)
end

icon:SetScript("OnUpdate", function()
    if not expiresAt then return end
    local remaining = math.ceil(expiresAt - GetTime())
    if remaining <= 0 then
        ShowExpired()
    else
        icon.text:SetText(("%d:%02d"):format(math.floor(remaining / 60), remaining % 60))
    end
end)

local function Enable()
    enabled = true
    frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
    ShowExpired()
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

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("SPELLS_CHANGED")
frame:SetScript("OnEvent", function(_, event, ...)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        local _, _, spellId = ...
        if spellId == SPELL_ID then
            OnOathCast()
        end
    else
        UpdateEnabled()
    end
end)
