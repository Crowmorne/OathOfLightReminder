-- Icon: the frame, the functions that change how it looks, and its position.
-- When to call them is decided by the Oath timer.

local _, ns = ...

if not ns.AddonIsActive() then return end

local DEFAULT_POSITION = { point = "CENTER", relativePoint = "CENTER", x = 0, y = 120 }

local icon = CreateFrame("Frame", nil, UIParent)
icon:SetSize(44, 44)
icon:Hide()

icon.texture = icon:CreateTexture(nil, "ARTWORK")
icon.texture:SetAllPoints()

icon.cooldown = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
-- Inset so the square swipe stays inside the icon's rounded corners.
icon.cooldown:SetPoint("TOPLEFT", 2, -2)
icon.cooldown:SetPoint("BOTTOMRIGHT", -2, 2)

icon.text = icon:CreateFontString(nil, "OVERLAY", "GameFontNormal")
icon.text:SetPoint("TOP", icon, "BOTTOM", 0, -2)

ns.icon = icon

---------------------------------------------------------------------------
-- Position: dragging, saved per character in OathOfLightReminderDB.position.
---------------------------------------------------------------------------

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

function ns.RestorePosition()
    local position = OathOfLightReminderDB.position or DEFAULT_POSITION
    icon:ClearAllPoints()
    icon:SetPoint(position.point, UIParent, position.relativePoint, position.x, position.y)
end

function ns.ResetPosition()
    OathOfLightReminderDB.position = nil
    ns.RestorePosition()
end

-- Calls onRightClick(icon) when the icon is right-clicked.
function ns.SetIconRightClick(onRightClick)
    icon:SetScript("OnMouseUp", function(self, button)
        if button == "RightButton" then
            onRightClick(self)
        end
    end)
end

---------------------------------------------------------------------------
-- Appearance
---------------------------------------------------------------------------

function ns.SetIconSpell(spellId)
    icon.texture:SetTexture(C_Spell.GetSpellTexture(spellId))
end

-- Shows the countdown either below the icon or on it, like an action button.
function ns.ApplyStyle()
    local onIcon = OathOfLightReminderDB.showCooldownNumbers
    icon.cooldown:SetHideCountdownNumbers(not onIcon)
    icon.text:SetShown(not onIcon)
end

function ns.ShowRecast()
    icon.cooldown:Clear()
    icon.texture:SetDesaturated(true)
    icon.text:SetText("Recast")
end

function ns.ShowRunning(startedAt, duration)
    icon.cooldown:SetCooldown(startedAt, duration)
    icon.texture:SetDesaturated(false)
end

function ns.ShowRemaining(seconds)
    icon.text:SetText(("%d:%02d"):format(math.floor(seconds / 60), seconds % 60))
end
