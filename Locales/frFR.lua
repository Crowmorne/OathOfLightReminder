-- French texts. Keys not listed here stay English (see enUS.lua).

local _, ns = ...

if GetLocale() ~= "frFR" then return end

local L = ns.L

-- Icon
L.ICON_RECAST = "Relancer"

-- Context menu
L.MENU_RESET_TIMER = "Réinitialiser le minuteur"

-- Settings: display style
L.SETTING_DISPLAY_STYLE = "Style d’affichage"
L.SETTING_DISPLAY_STYLE_TOOLTIP = "L’apparence de l’icône."
L.SETTING_DISPLAY_STYLE_ACTION_BAR = "Bouton de barre d’actions"
L.SETTING_DISPLAY_STYLE_TRACKED_BUFF = "Bonus suivi"
L.SETTING_DISPLAY_STYLE_TRACKED_BAR = "Barre suivie"

-- Settings: size
L.SETTING_BAR_WIDTH = "Largeur de la barre"
L.SETTING_BAR_WIDTH_TOOLTIP = "Largeur de la barre dans le style « Barre suivie »."

L.SETTING_SIZE = "Taille"
L.SETTING_SIZE_TOOLTIP = "Taille de l’icône ou de la barre."

-- Settings: visibility
L.SETTING_HIDE_UNTIL = "Masquer jusqu’à"
-- %1$s: the full duration (5:00), %2$s: zero time (0:00)
L.SETTING_HIDE_UNTIL_TOOLTIP = "Masque l’icône jusqu’à ce qu’il ne reste plus que ce temps.\n"
    .. "%1$s : toujours affichée.\n"
    .. "%2$s : affichée seulement quand il est temps de relancer."

L.SETTING_SHOW = "Afficher"
L.SETTING_SHOW_TOOLTIP = "En combat uniquement : l’icône est masquée hors combat, "
    .. "quoi qu’affiche le minuteur."
L.SETTING_SHOW_IN_COMBAT = "En combat uniquement"

-- Settings: position
L.SETTING_ATTACH_TO = "Attacher au %s"
L.SETTING_ATTACH_TO_TOOLTIP = "Garde l’icône à côté d’un cadre du %1$s "
    .. "et la déplace avec lui quand ce cadre bouge. "
    .. "Faire glisser l’icône remet ce réglage sur « %2$s »."

L.SETTING_SIDE = "Côté"
L.SETTING_SIDE_TOOLTIP = "Le côté du cadre du %s auquel l’icône est attachée."
L.SETTING_SIDE_ABOVE = "Au-dessus"
L.SETTING_SIDE_BELOW = "En dessous"
L.SETTING_SIDE_LEFT = "À gauche"
L.SETTING_SIDE_RIGHT = "À droite"

L.SETTING_LOCK_POSITION = "Verrouiller la position"
L.SETTING_LOCK_POSITION_TOOLTIP = "Empêche de faire glisser l’icône, "
    .. "pour qu’elle ne soit pas déplacée par accident. Le clic droit fonctionne toujours."

L.SETTING_ICON_POSITION = "Position de l’icône"
L.SETTING_ICON_POSITION_BUTTON = "Réinitialiser la position"
L.SETTING_ICON_POSITION_TOOLTIP = "Replace l’icône à sa position par défaut."
