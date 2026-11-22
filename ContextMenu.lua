-- Context menu: what the menu shows and which action each entry calls.

local _, ns = ...

if not ns.AddonIsActive() then return end

local L = ns.L

-- actions: { resetTimer = function, openSettings = function }
-- Returns a menu object; menu:Open(owner) shows it next to owner.
function ns.CreateContextMenu(actions)
    local menu = {}

    function menu:Open(owner)
        MenuUtil.CreateContextMenu(owner, function(_, rootDescription)
            rootDescription:CreateButton(L.MENU_RESET_TIMER, function() actions.resetTimer() end)
            rootDescription:CreateDivider()
            rootDescription:CreateButton(L.MENU_SETTINGS, function() actions.openSettings() end)
        end)
    end

    return menu
end
