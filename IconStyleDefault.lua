-- Icon style "Default": a square icon with a swipe, and the countdown and
-- "Recast" as text below the icon.

local _, ns = ...

if not ns.AddonIsActive() then return end

function ns.CreateDefaultStyle()
    local style = CreateFromMixins(ns.IconStyle)

    local text -- countdown and "Recast" below the icon, created on first Apply

    function style:Apply(parts)
        if not text then
            text = parts.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            text:SetPoint("TOP", parts.frame, "BOTTOM", 0, -2)
        end
        text:Show()

        -- Inset so the square swipe stays inside the icon's rounded corners.
        parts.cooldown:ClearAllPoints()
        parts.cooldown:SetPoint("TOPLEFT", 2, -2)
        parts.cooldown:SetPoint("BOTTOMRIGHT", -2, 2)
        parts.cooldown:SetDrawEdge(true)
    end

    function style:Remove()
        text:Hide()
    end

    function style:ShowRecast()
        text:SetText("Recast")
    end

    function style:ShowRemaining(seconds)
        text:SetText(("%d:%02d"):format(math.floor(seconds / 60), seconds % 60))
    end

    return style
end
