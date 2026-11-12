-- Icon style "Action Bar button": a square icon with a swipe and the
-- countdown numbers on it, like an action button.

local _, ns = ...

if not ns.AddonIsActive() then return end

function ns.CreateActionBarStyle()
    local style = {}

    function style:Apply(parts)
        -- Inset so the square swipe stays inside the icon's rounded corners.
        parts.cooldown:ClearAllPoints()
        parts.cooldown:SetPoint("TOPLEFT", 2, -2)
        parts.cooldown:SetPoint("BOTTOMRIGHT", -2, 2)
        parts.cooldown:SetDrawEdge(true)
        parts.cooldown:SetHideCountdownNumbers(false)
    end

    function style:Remove()
    end

    function style:ShowRunning()
    end

    function style:ShowRecast()
    end

    function style:ShowRemaining()
    end

    return style
end
