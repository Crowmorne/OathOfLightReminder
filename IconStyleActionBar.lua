-- Icon style "Action Bar button": a square icon with a swipe and the
-- countdown numbers on it, like an action button.

local _, ns = ...

if not ns.AddonIsActive() then return end

function ns.CreateActionBarStyle()
    local style = CreateFromMixins(ns.IconStyle)

    function style:Apply(parts)
        -- Inset so the square swipe stays inside the icon's rounded corners.
        parts.cooldown:ClearAllPoints()
        parts.cooldown:SetPoint("TOPLEFT", 2, -2)
        parts.cooldown:SetPoint("BOTTOMRIGHT", -2, 2)
        parts.cooldown:SetDrawEdge(true)
        parts.cooldown:SetHideCountdownNumbers(false)
    end

    return style
end
