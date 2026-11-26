-- German texts. Keys not listed here stay English (see enUS.lua).

local _, ns = ...

if GetLocale() ~= "deDE" then return end

local L = ns.L

-- Icon
L.ICON_RECAST = "Erneuern"

-- Context menu
L.MENU_RESET_TIMER = "Timer zurücksetzen"

-- Settings: display style
L.SETTING_DISPLAY_STYLE = "Darstellung"
L.SETTING_DISPLAY_STYLE_TOOLTIP = "Wie das Symbol aussieht."
L.SETTING_DISPLAY_STYLE_ACTION_BAR = "Aktionsleistenbutton"
L.SETTING_DISPLAY_STYLE_TRACKED_BUFF = "Verfolgter Stärkungseffekt"
L.SETTING_DISPLAY_STYLE_TRACKED_BAR = "Verfolgte Leiste"

-- Settings: size
L.SETTING_BAR_WIDTH = "Leistenbreite"
L.SETTING_BAR_WIDTH_TOOLTIP = "Breite der Leiste in der Darstellung „Verfolgte Leiste“."

L.SETTING_SIZE = "Größe"
L.SETTING_SIZE_TOOLTIP = "Größe des Symbols oder der Leiste."

-- Settings: visibility
L.SETTING_HIDE_UNTIL = "Ausblenden bis"
-- %1$s: the full duration (60:00), %2$s: zero time (0:00)
L.SETTING_HIDE_UNTIL_TOOLTIP = "Blendet das Symbol aus, bis nur noch so viel Zeit übrig ist.\n"
    .. "%1$s: immer angezeigt.\n"
    .. "%2$s: erst angezeigt, wenn es Zeit zum Erneuern ist."

L.SETTING_SHOW = "Anzeigen"
L.SETTING_SHOW_TOOLTIP = "Nur im Kampf: Außerhalb des Kampfes ist das Symbol ausgeblendet, "
    .. "egal was der Timer anzeigt."
L.SETTING_SHOW_IN_COMBAT = "Nur im Kampf"

-- Settings: position
L.SETTING_ATTACH_TO = "An %s anheften"
L.SETTING_ATTACH_TO_TOOLTIP = "Hält das Symbol neben einem %1$s-Rahmen "
    .. "und bewegt es mit, wenn dieser Rahmen verschoben wird. "
    .. "Wird das Symbol gezogen, springt dies zurück auf „%2$s“."

L.SETTING_SIDE = "Seite"
L.SETTING_SIDE_TOOLTIP = "An welcher Seite des %s-Rahmens das Symbol angeheftet ist."
L.SETTING_SIDE_ABOVE = "Oben"
L.SETTING_SIDE_BELOW = "Unten"
L.SETTING_SIDE_LEFT = "Links"
L.SETTING_SIDE_RIGHT = "Rechts"

L.SETTING_LOCK_POSITION = "Position sperren"
L.SETTING_LOCK_POSITION_TOOLTIP = "Verhindert, dass das Symbol gezogen wird, "
    .. "damit es nicht versehentlich verschoben wird. Rechtsklick funktioniert weiterhin."

L.SETTING_ICON_POSITION = "Symbolposition"
L.SETTING_ICON_POSITION_BUTTON = "Position zurücksetzen"
L.SETTING_ICON_POSITION_TOOLTIP = "Setzt das Symbol auf seine Standardposition zurück."
