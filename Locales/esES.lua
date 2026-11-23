-- Spanish texts. Keys not listed here stay English (see enUS.lua).

local _, ns = ...

if GetLocale() ~= "esES" then return end

local L = ns.L

-- Icon
L.ICON_RECAST = "Relanzar"

-- Context menu
L.MENU_RESET_TIMER = "Restablecer temporizador"

-- Settings: display style
L.SETTING_DISPLAY_STYLE = "Estilo de visualización"
L.SETTING_DISPLAY_STYLE_TOOLTIP = "El aspecto del icono."
L.SETTING_DISPLAY_STYLE_ACTION_BAR = "Botón de barra de acción"
L.SETTING_DISPLAY_STYLE_TRACKED_BUFF = "Beneficio rastreado"
L.SETTING_DISPLAY_STYLE_TRACKED_BAR = "Barra rastreada"

-- Settings: size
L.SETTING_BAR_WIDTH = "Anchura de la barra"
L.SETTING_BAR_WIDTH_TOOLTIP = "Anchura de la barra en el estilo «Barra rastreada»."

L.SETTING_SIZE = "Tamaño"
L.SETTING_SIZE_TOOLTIP = "Tamaño del icono o de la barra."

-- Settings: visibility
L.SETTING_HIDE_UNTIL = "Ocultar hasta"
-- %1$s: the full duration (5:00), %2$s: zero time (0:00)
L.SETTING_HIDE_UNTIL_TOOLTIP = "Oculta el icono hasta que solo quede este tiempo.\n"
    .. "%1$s: siempre visible.\n"
    .. "%2$s: solo visible cuando toca volver a lanzarlo."

L.SETTING_SHOW = "Mostrar"
L.SETTING_SHOW_TOOLTIP = "Solo en combate: el icono se oculta fuera de combate, "
    .. "muestre lo que muestre el temporizador."
L.SETTING_SHOW_IN_COMBAT = "Solo en combate"

-- Settings: position
L.SETTING_ATTACH_TO = "Anclar al %s"
L.SETTING_ATTACH_TO_TOOLTIP = "Mantiene el icono junto a un marco del %1$s "
    .. "y lo mueve con él cuando ese marco se desplaza. "
    .. "Arrastrar el icono vuelve a poner esta opción en «%2$s»."

L.SETTING_SIDE = "Lado"
L.SETTING_SIDE_TOOLTIP = "En qué lado del marco del %s se ancla el icono."
L.SETTING_SIDE_ABOVE = "Encima"
L.SETTING_SIDE_BELOW = "Debajo"
L.SETTING_SIDE_LEFT = "Izquierda"
L.SETTING_SIDE_RIGHT = "Derecha"

L.SETTING_LOCK_POSITION = "Bloquear posición"
L.SETTING_LOCK_POSITION_TOOLTIP = "Impide arrastrar el icono para que no se mueva por accidente. "
    .. "El clic derecho sigue funcionando."

L.SETTING_ICON_POSITION = "Posición del icono"
L.SETTING_ICON_POSITION_BUTTON = "Restablecer posición"
L.SETTING_ICON_POSITION_TOOLTIP = "Devuelve el icono a su posición predeterminada."
