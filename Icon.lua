-- Icon: the frame, where it is and the parts every style shares.
-- How it looks is decided by the active style (see IconStyle.lua), what it
-- shows and when by whoever uses it.

local _, ns = ...

if not ns.AddonIsActive() then return end

local DEFAULT_POSITION = { point = "CENTER", relativePoint = "CENTER", x = 0, y = 120 }
local SIZE = 44

-- For AttachTo: which point of the icon touches which point of the other
-- frame, and in which direction the gap pushes the icon away from it.
local SIDES = {
    above = { point = "BOTTOM", relativePoint = "TOP", x = 0, y = 1 },
    below = { point = "TOP", relativePoint = "BOTTOM", x = 0, y = -1 },
    left = { point = "RIGHT", relativePoint = "LEFT", x = -1, y = 0 },
    right = { point = "LEFT", relativePoint = "RIGHT", x = 1, y = 0 },
}

-- styles: { [name] = style object }, defaultStyle: name used for unknown names.
-- Returns an icon object. Call once: WoW frames can't be destroyed.
function ns.CreateIcon(styles, defaultStyle)
    local icon = {}

    -- frame holds the position and takes the mouse. The styles draw into
    -- content, which is scaled for the size setting. Scaling frame itself
    -- would also scale its offset from UIParent and move it on screen.
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:Hide()

    local content = CreateFrame("Frame", nil, frame)
    content:SetPoint("CENTER")

    -- frame always covers content, so dragging and clicking match what's drawn.
    content:SetScript("OnSizeChanged", function()
        local scale = content:GetScale()
        frame:SetSize(content:GetWidth() * scale, content:GetHeight() * scale)
    end)

    local texture = content:CreateTexture(nil, "ARTWORK")
    texture:SetAllPoints()

    local cooldown = CreateFrame("Cooldown", nil, content, "CooldownFrameTemplate")

    local parts = { frame = content, texture = texture, cooldown = cooldown }

    local function ResetParts()
        content:SetSize(SIZE, SIZE)
        texture:ClearAllPoints()
        texture:SetAllPoints()
        cooldown:ClearAllPoints()
        cooldown:SetAllPoints()
        cooldown:SetReverse(false)
        cooldown:SetDrawSwipe(true)
        cooldown:SetSwipeTexture("Interface\\Buttons\\WHITE8X8", 0, 0, 0, 0.64)
        cooldown:SetDrawEdge(false)
        cooldown:SetDrawBling(true)
        cooldown:SetHideCountdownNumbers(true)
    end

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

    -- Places the icon centred against one side of anchor: "above", "below",
    -- "left" or "right", gap pixels away (negative values overlap). The game
    -- keeps it there when anchor moves or changes size. Dragging the icon
    -- replaces this with a normal position.
    function icon:AttachTo(anchor, side, gap)
        local s = SIDES[side]
        frame:ClearAllPoints()
        frame:SetPoint(s.point, anchor, s.relativePoint, s.x * gap, s.y * gap)
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
    -- State: what the icon shows, passed on to the active style.
    -----------------------------------------------------------------------

    local activeStyle
    local running = { startedAt = nil, duration = nil, remaining = nil } -- startedAt is nil when not running

    function icon:SetShown(shown)
        frame:SetShown(shown)
    end

    function icon:SetSpell(spellId)
        texture:SetTexture(C_Spell.GetSpellTexture(spellId))
    end

    function icon:ShowExpired()
        running.startedAt, running.duration, running.remaining = nil, nil, nil
        cooldown:Clear()
        texture:SetDesaturated(true)
        activeStyle:ShowExpired()
    end

    function icon:ShowRunning(startedAt, duration)
        running.startedAt, running.duration, running.remaining = startedAt, duration, nil
        cooldown:SetCooldown(startedAt, duration)
        texture:SetDesaturated(false)
        activeStyle:ShowRunning(startedAt, duration)
    end

    function icon:ShowRemaining(seconds)
        running.remaining = seconds
        activeStyle:ShowRemaining(seconds)
    end

    -----------------------------------------------------------------------
    -- Style and size
    -----------------------------------------------------------------------

    -- scale: 1 for the style's own size.
    function icon:SetScale(scale)
        content:SetScale(scale)
        frame:SetSize(content:GetWidth() * scale, content:GetHeight() * scale)
    end

    -- name: a key of styles, or nil for the default.
    function icon:SetStyle(name)
        if activeStyle then
            activeStyle:Remove(parts)
        end
        ResetParts()
        activeStyle = styles[name] or styles[defaultStyle]
        activeStyle:Apply(parts)

        -- Let the new style show the current state.
        if running.startedAt then
            activeStyle:ShowRunning(running.startedAt, running.duration)
            if running.remaining then
                activeStyle:ShowRemaining(running.remaining)
            end
        else
            activeStyle:ShowExpired()
        end
    end

    icon:SetStyle(defaultStyle)

    return icon
end
