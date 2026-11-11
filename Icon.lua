-- Icon: the frame, how it looks and where it is.
-- What it shows and when is decided by whoever uses it.

local _, ns = ...

if not ns.AddonIsActive() then return end

local DEFAULT_POSITION = { point = "CENTER", relativePoint = "CENTER", x = 0, y = 120 }

-- Returns an icon object. Call once: WoW frames can't be destroyed.
function ns.CreateIcon()
    local icon = {}

    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetSize(44, 44)
    frame:Hide()

    local texture = frame:CreateTexture(nil, "ARTWORK")
    texture:SetAllPoints()

    local cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
    -- Inset so the square swipe stays inside the icon's rounded corners.
    cooldown:SetPoint("TOPLEFT", 2, -2)
    cooldown:SetPoint("BOTTOMRIGHT", -2, 2)

    local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("TOP", frame, "BOTTOM", 0, -2)

    -----------------------------------------------------------------------
    -- Position: dragging with the left mouse button.
    -----------------------------------------------------------------------

    local onMoved -- called with the new position after a drag

    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")

    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", function()
        frame:StopMovingOrSizing()
        if onMoved then
            local point, _, relativePoint, x, y = frame:GetPoint()
            onMoved({ point = point, relativePoint = relativePoint, x = x, y = y })
        end
    end)

    -- position: { point, relativePoint, x, y }, or nil for the default position.
    function icon:SetPosition(position)
        position = position or DEFAULT_POSITION
        frame:ClearAllPoints()
        frame:SetPoint(position.point, UIParent, position.relativePoint, position.x, position.y)
    end

    -- Calls fn(position) after the icon was dragged, with the same fields as SetPosition.
    function icon:SetOnMoved(fn)
        onMoved = fn
    end

    -----------------------------------------------------------------------
    -- Input
    -----------------------------------------------------------------------

    -- Calls onRightClick(frame) when the icon is right-clicked.
    function icon:SetRightClick(onRightClick)
        frame:SetScript("OnMouseUp", function(_, button)
            if button == "RightButton" then
                onRightClick(frame)
            end
        end)
    end

    -----------------------------------------------------------------------
    -- Appearance
    -----------------------------------------------------------------------

    function icon:Show()
        frame:Show()
    end

    function icon:Hide()
        frame:Hide()
    end

    function icon:SetSpell(spellId)
        texture:SetTexture(C_Spell.GetSpellTexture(spellId))
    end

    -- Shows the countdown on the icon like an action button if onIcon is true,
    -- otherwise below it.
    function icon:SetCountdownOnIcon(onIcon)
        cooldown:SetHideCountdownNumbers(not onIcon)
        text:SetShown(not onIcon)
    end

    function icon:ShowRecast()
        cooldown:Clear()
        texture:SetDesaturated(true)
        text:SetText("Recast")
    end

    function icon:ShowRunning(startedAt, duration)
        cooldown:SetCooldown(startedAt, duration)
        texture:SetDesaturated(false)
    end

    function icon:ShowRemaining(seconds)
        text:SetText(("%d:%02d"):format(math.floor(seconds / 60), seconds % 60))
    end

    return icon
end
