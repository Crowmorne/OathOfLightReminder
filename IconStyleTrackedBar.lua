-- Icon style "Tracked Bar": built like a tracked bar in the Cooldown Manager
-- (CooldownViewerBuffBarItemTemplate): a small icon on the left and a bar
-- with the spell name and the remaining time that empties as time runs out.

local _, ns = ...

if not ns.AddonIsActive() then return end

local WIDTH, HEIGHT = 220, 30
local ICON_SIZE = 30
local BAR_HEIGHT = 19

-- spellId: the spell whose name the bar shows.
function ns.CreateTrackedBarStyle(spellId)
    local style = CreateFromMixins(ns.IconStyle)

    local mask, overlay, bar, pip, name, remaining -- created on first Apply
    local startedAt, duration -- of the running Oath, nil when expired

    local function UpdateBar()
        local left = startedAt and startedAt + duration - GetTime()
        if left and left > 0 then
            bar:SetMinMaxValues(0, duration)
            bar:SetValue(left)
            remaining:SetText(COOLDOWN_DURATION_SEC:format(left))
            pip:Show()
        else
            bar:SetMinMaxValues(0, 0)
            bar:SetValue(0)
            remaining:SetText("")
            pip:Hide()
        end
    end

    local function Create(parts)
        mask = parts.frame:CreateMaskTexture()
        mask:SetAtlas("UI-HUD-CoolDownManager-Mask")
        mask:SetAllPoints(parts.texture)

        overlay = parts.frame:CreateTexture(nil, "OVERLAY")
        overlay:SetAtlas("UI-HUD-CoolDownManager-IconOverlay")
        overlay:SetPoint("TOPLEFT", parts.texture, -6, 5)
        overlay:SetPoint("BOTTOMRIGHT", parts.texture, 6, -5)

        bar = CreateFrame("StatusBar", nil, parts.frame)
        bar:SetHeight(BAR_HEIGHT)
        bar:SetPoint("LEFT", parts.texture, "RIGHT", 2, 0)
        bar:SetPoint("RIGHT")
        bar:SetStatusBarTexture("UI-HUD-CoolDownManager-Bar")
        bar:SetStatusBarColor(1, 0.5, 0.25)

        local background = bar:CreateTexture(nil, "BACKGROUND")
        background:SetAtlas("UI-HUD-CoolDownManager-Bar-BG")
        background:SetPoint("TOPLEFT", -2, 2)
        background:SetPoint("BOTTOMRIGHT", 4, -7)

        pip = bar:CreateTexture(nil, "OVERLAY")
        pip:SetAtlas("UI-HUD-CoolDownManager-Bar-Pip", true)
        pip:SetPoint("CENTER", bar:GetStatusBarTexture(), "RIGHT", 0, -1)

        name = bar:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
        name:SetJustifyH("LEFT")
        name:SetJustifyV("MIDDLE")
        name:SetPoint("TOPLEFT", 5, 0)
        name:SetPoint("BOTTOMRIGHT", -25, 0)
        name:SetText(C_Spell.GetSpellName(spellId))

        remaining = bar:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
        remaining:SetJustifyH("LEFT")
        remaining:SetPoint("RIGHT", -8, 0)

        bar:SetScript("OnUpdate", UpdateBar)
    end

    function style:Apply(parts)
        if not bar then
            Create(parts)
        end
        parts.texture:AddMaskTexture(mask)
        overlay:Show()
        bar:Show()

        parts.frame:SetSize(WIDTH, HEIGHT)
        parts.texture:ClearAllPoints()
        parts.texture:SetSize(ICON_SIZE, ICON_SIZE)
        parts.texture:SetPoint("LEFT")

        -- The bar shows the time, so the cooldown draws nothing.
        parts.cooldown:SetDrawSwipe(false)
        parts.cooldown:SetDrawBling(false)
    end

    function style:Remove(parts)
        parts.texture:RemoveMaskTexture(mask)
        overlay:Hide()
        bar:Hide()
    end

    function style:ShowRunning(newStartedAt, newDuration)
        startedAt, duration = newStartedAt, newDuration
        UpdateBar()
    end

    function style:ShowExpired()
        startedAt, duration = nil, nil
        UpdateBar()
    end

    return style
end
