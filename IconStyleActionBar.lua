-- Icon style "Action Bar button": a square icon with a swipe like an action
-- button, and the countdown either below the icon or on it.

local _, ns = ...

if not ns.AddonIsActive() then return end

-- options: { countdownOnIcon = boolean }
function ns.CreateActionBarStyle()
    local style = {}

    local text -- countdown and "Recast" below the icon, created on first Apply

    function style:Apply(parts, options)
        local countdownOnIcon = options and options.countdownOnIcon

        if not text then
            text = parts.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            text:SetPoint("TOP", parts.frame, "BOTTOM", 0, -2)
        end
        text:SetShown(not countdownOnIcon)

        -- Inset so the square swipe stays inside the icon's rounded corners.
        parts.cooldown:ClearAllPoints()
        parts.cooldown:SetPoint("TOPLEFT", 2, -2)
        parts.cooldown:SetPoint("BOTTOMRIGHT", -2, 2)
        parts.cooldown:SetDrawEdge(true)
        parts.cooldown:SetHideCountdownNumbers(not countdownOnIcon)
    end

    function style:Remove()
        text:Hide()
    end

    function style:ShowRunning()
    end

    function style:ShowRecast()
        text:SetText("Recast")
    end

    function style:ShowRemaining(seconds)
        text:SetText(("%d:%02d"):format(math.floor(seconds / 60), seconds % 60))
    end

    return style
end
