-- Decides whether the addon runs for this character: only for Paladins.
-- Other files call ns.AddonIsActive() and stop early if it returns false.

local _, ns = ...

function ns.AddonIsActive()
    local _, class = UnitClass("player")
    return class == "PALADIN"
end
