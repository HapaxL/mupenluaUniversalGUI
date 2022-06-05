Appearance = {
    Themes = {
        Classic = {
            WINDOW_BACK_COLOR = "#F0F0F0",
            BUTTON_BORDER_COLOR = "#B0B0B0",
            BUTTON_BACK_COLOR = "#E1E1E1",
            BUTTON_FORE_COLOR = "#000000",
            BUTTON_HOVERED_BORDER_COLOR = "#0078D7",
            BUTTON_PUSHED_BACK_COLOR = "#C5E1F7",
            TEXTBOX_BACK_COLOR = "#FFFFFF",
            TEXTBOX_READONLY_BACK_COLOR = "#F0F0F0",
            TEXTBOX_BORDER_COLOR = "#7A7A7A",
            TEXTBOX_HOVERED_BORDER_COLOR = "#171717",
            TEXTBOX_ACTIVE_BORDER_COLOR = "#0078D7",
            SLIDER_TRACK_COLOR = "#E7EAEA",
            SLIDER_HEAD_COLOR = "#0078D7",
            SLIDER_PRESSED_HEAD_COLOR = "#CCCCCC",
            SLIDER_HOVERED_HEAD_COLOR = "#171717",
            SLIDER_HEAD_WIDTH = 8,
            SLIDER_HEAD_HEIGHT = 16,
            SLIDER_TRACK_HEIGHT = 2
        },
        Dark = {}
    }
}

function Appearance.Initialize()
    Appearance.Themes.Dark = Table.Copy(Appearance.Themes.Classic)

    for k, v in pairs(Appearance.Themes.Dark) do
        if (type(v) == "string") then
            local rgb = WGUI.HexadecimalColorToRGB(Appearance.Themes.Dark[k]);
            Appearance.Themes.Dark[k] = WGUI.RGBToHexadecimalColor(255 - rgb[1], 255 - rgb[2], 255 - rgb[3])
        end
    end
end

function LightenDarkenColor(col, amt)
    col = tonumber(col, 16)
    return string.format("%#x",
        ((col & 0x0000FF) + amt) | ((((col >> 8) & 0x00FF) + amt) << 8) | (((col >> 16) + amt) << 16))
end

VERTICAL_SAFE_ZONE = 30
FONT_SIZE = 10
BORDER_SIZE = 1
