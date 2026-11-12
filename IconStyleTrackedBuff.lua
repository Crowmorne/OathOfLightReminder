-- Icon style "Tracked Buff": built like a tracked buff in the Cooldown Manager
-- (CooldownViewerBuffIconItemTemplate): rounded corners, an inner shadow and
-- a reverse swipe.

local _, ns = ...

if not ns.AddonIsActive() then return end

local SIZE = 40

function ns.CreateTrackedBuffStyle()
    local style = {}

    local mask, overlay -- created on first Apply

    function style:Apply(parts)
        if not mask then
            mask = parts.frame:CreateMaskTexture()
            mask:SetAtlas("UI-HUD-CoolDownManager-Mask")
            mask:SetAllPoints(parts.texture)

            overlay = parts.frame:CreateTexture(nil, "OVERLAY")
            overlay:SetAtlas("UI-HUD-CoolDownManager-IconOverlay")
            overlay:SetPoint("TOPLEFT", -8, 7)
            overlay:SetPoint("BOTTOMRIGHT", 8, -7)
        end
        parts.texture:AddMaskTexture(mask)
        overlay:Show()

        parts.frame:SetSize(SIZE, SIZE)
        parts.cooldown:SetReverse(true)
        parts.cooldown:SetSwipeTexture("Interface\\HUD\\UI-HUD-CoolDownManager-Icon-Swipe", 0, 0, 0, 0.7)
        parts.cooldown:SetHideCountdownNumbers(false)
    end

    function style:Remove(parts)
        parts.texture:RemoveMaskTexture(mask)
        overlay:Hide()
    end

    function style:ShowRunning()
    end

    function style:ShowRecast()
    end

    function style:ShowRemaining()
    end

    return style
end
