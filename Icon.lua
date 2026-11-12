-- Icon: the frame, where it is and the parts every style shares.
-- How it looks is decided by the active style, what it shows and when by
-- whoever uses it.
--
-- A style is an object with these methods:
--   style:Apply(parts, options)   configure the shared parts, show its own elements
--   style:Remove(parts)           hide its own elements, detach what it attached
--   style:ShowRunning(startedAt, duration)
--   style:ShowRecast()
--   style:ShowRemaining(seconds)
-- parts: { frame, texture, cooldown }. Before Apply, the shared parts are
-- reset to the baseline in ResetParts, so a style only sets what differs.

local _, ns = ...

if not ns.AddonIsActive() then return end

local DEFAULT_POSITION = { point = "CENTER", relativePoint = "CENTER", x = 0, y = 120 }
local SIZE = 44

-- styles: { [name] = style object }, defaultStyle: name used for unknown names.
-- Returns an icon object. Call once: WoW frames can't be destroyed.
function ns.CreateIcon(styles, defaultStyle)
    local icon = {}

    local frame = CreateFrame("Frame", nil, UIParent)
    frame:Hide()

    local texture = frame:CreateTexture(nil, "ARTWORK")
    texture:SetAllPoints()

    local cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")

    local parts = { frame = frame, texture = texture, cooldown = cooldown }

    local function ResetParts()
        frame:SetSize(SIZE, SIZE)
        cooldown:ClearAllPoints()
        cooldown:SetAllPoints()
        cooldown:SetReverse(false)
        cooldown:SetSwipeTexture("Interface\\Buttons\\WHITE8X8", 0, 0, 0, 0.64)
        cooldown:SetDrawEdge(false)
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

    function icon:Show()
        frame:Show()
    end

    function icon:Hide()
        frame:Hide()
    end

    function icon:SetSpell(spellId)
        texture:SetTexture(C_Spell.GetSpellTexture(spellId))
    end

    function icon:ShowRecast()
        running.startedAt, running.duration, running.remaining = nil, nil, nil
        cooldown:Clear()
        texture:SetDesaturated(true)
        activeStyle:ShowRecast()
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
    -- Style
    -----------------------------------------------------------------------

    -- name: a key of styles, or nil for the default. options are passed to
    -- the style as they are.
    function icon:SetStyle(name, options)
        if activeStyle then
            activeStyle:Remove(parts)
        end
        ResetParts()
        activeStyle = styles[name] or styles[defaultStyle]
        activeStyle:Apply(parts, options)

        -- Let the new style show the current state.
        if running.startedAt then
            activeStyle:ShowRunning(running.startedAt, running.duration)
            if running.remaining then
                activeStyle:ShowRemaining(running.remaining)
            end
        else
            activeStyle:ShowRecast()
        end
    end

    icon:SetStyle(defaultStyle)

    return icon
end
