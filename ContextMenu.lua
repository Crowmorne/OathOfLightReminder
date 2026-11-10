-- Context menu: right-click the icon.

local _, ns = ...

if not ns.AddonIsActive() then return end

ns.icon:SetScript("OnMouseUp", function(self, button)
    if button ~= "RightButton" then return end

    MenuUtil.CreateContextMenu(self, function(_, rootDescription)
        rootDescription:CreateButton("Reset timer", ns.EndOath)
        rootDescription:CreateDivider()
        rootDescription:CreateButton("Settings", ns.OpenSettings)
    end)
end)
