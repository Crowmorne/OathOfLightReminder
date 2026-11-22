-- English texts: every text the addon shows.
-- Other languages replace the ones they translate,
-- so anything not translated stays English.

local _, ns = ...

local L = {}
ns.L = L

-- Icon
L.ICON_RECAST = "Recast"

-- Context menu
L.MENU_RESET_TIMER = "Reset timer"
L.MENU_SETTINGS = "Settings"

-- Settings: display style
L.SETTING_DISPLAY_STYLE = "Display style"
L.SETTING_DISPLAY_STYLE_TOOLTIP = "How the icon looks."
L.SETTING_DISPLAY_STYLE_DEFAULT = "Default"
L.SETTING_DISPLAY_STYLE_ACTION_BAR = "Action Bar button"
L.SETTING_DISPLAY_STYLE_TRACKED_BUFF = "Tracked Buff"
L.SETTING_DISPLAY_STYLE_TRACKED_BAR = "Tracked Bar"

-- Settings: size
L.SETTING_BAR_WIDTH = "Bar width"
L.SETTING_BAR_WIDTH_TOOLTIP = "Width of the bar in the Tracked Bar style."

L.SETTING_SIZE = "Size"
L.SETTING_SIZE_TOOLTIP = "Size of the icon or bar."

-- Settings: visibility
L.SETTING_HIDE_UNTIL = "Hide until"
-- %1$s: the full duration (5:00), %2$s: zero time (0:00)
L.SETTING_HIDE_UNTIL_TOOLTIP = "Hides the icon until this much time is left.\n"
    .. "%1$s: always shown.\n"
    .. "%2$s: only shown once it's time to recast."

L.SETTING_SHOW = "Show"
L.SETTING_SHOW_TOOLTIP = "In combat only: the icon is hidden while you're out of combat, whatever the timer shows."
L.SETTING_SHOW_ALWAYS = "Always"
L.SETTING_SHOW_IN_COMBAT = "In combat only"

-- Settings: position
L.SETTING_ATTACH_TO = "Attach to Cooldown Manager"
L.SETTING_ATTACH_TO_TOOLTIP = "Keeps the icon next to a Cooldown Manager frame, "
    .. "and moves it along when that frame moves. "
    .. "Dragging the icon sets this back to No."
L.SETTING_ATTACH_TO_NONE = "No"
L.SETTING_ATTACH_TO_TRACKED_BUFFS = "Tracked Buffs"
L.SETTING_ATTACH_TO_TRACKED_BARS = "Tracked Bars"

L.SETTING_SIDE = "Side"
L.SETTING_SIDE_TOOLTIP = "Which side of the Cooldown Manager frame the icon is attached to."
L.SETTING_SIDE_ABOVE = "Above"
L.SETTING_SIDE_BELOW = "Below"
L.SETTING_SIDE_LEFT = "Left"
L.SETTING_SIDE_RIGHT = "Right"

L.SETTING_LOCK_POSITION = "Lock position"
L.SETTING_LOCK_POSITION_TOOLTIP = "Stops the icon from being dragged, so it can't be moved by accident. "
    .. "Right-clicking still works."

L.SETTING_ICON_POSITION = "Icon position"
L.SETTING_ICON_POSITION_BUTTON = "Reset position"
L.SETTING_ICON_POSITION_TOOLTIP = "Moves the icon back to its default position."
