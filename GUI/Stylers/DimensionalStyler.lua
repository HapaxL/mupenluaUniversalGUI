DimensionalStyler = middleclass('DimensionalStyler', Styler)

local DEPTH = 3
local DEPTH_DIVISOR = 1
local COLOR_SHIFT_AMOUNT = 20

function DimensionalStyler:initialize()
end

function DimensionalStyler:DrawRaisedFrame(control, backColor, borderColor, borderSize, x, y, w, h)
    local darkened = CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(100,
        CurrentRenderer:HexadecimalColorToRGB(backColor)))
    if not control.IsChecked then
        CurrentRenderer:FillRectangle(borderColor, x - DEPTH / DEPTH_DIVISOR, y - DEPTH / DEPTH_DIVISOR, w, h)
        CurrentRenderer:FillRectangle(backColor, x, y, w, h)

    else
        CurrentRenderer:FillRectangle(borderColor, x, y, w, h)

        CurrentRenderer:FillRectangle(backColor, x - DEPTH / DEPTH_DIVISOR, y - DEPTH / DEPTH_DIVISOR, w, h)


    end

    if not control.IsChecked then
        self:DrawBorder(control, darkened, borderSize, x, y, w, h)
    end
end

function DimensionalStyler:DrawBorder(control, borderColor, borderSize, x, y, w, h)

    CurrentRenderer:DrawLine(borderColor, borderSize, x, y, x - DEPTH, y - DEPTH)
    CurrentRenderer:DrawLine(borderColor, borderSize, x - DEPTH, y - DEPTH, x + w - DEPTH / 2, y - DEPTH)

    CurrentRenderer:DrawLine(borderColor, borderSize, x, y + h, x - DEPTH, y + h - DEPTH)
    CurrentRenderer:DrawLine(borderColor, borderSize, x - DEPTH, y - DEPTH, x - DEPTH, y + h - DEPTH)

    CurrentRenderer:DrawLine(borderColor, borderSize, x + w, y, x + w - DEPTH, y - DEPTH)
    CurrentRenderer:DrawLine(borderColor, borderSize, x, y + h, x + w, y + h)

    CurrentRenderer:DrawLine(borderColor, borderSize, x + w, y + h, x + w, y)

    CurrentRenderer:DrawLine(borderColor, borderSize, x, y, x + w, y)
    CurrentRenderer:DrawLine(borderColor, borderSize, x, y, x, y + h)

end


function DimensionalStyler:DrawGenericAccentShape(control, backColor, x, y, w, h)
    self:DrawDimensionalRectangle(backColor, x, y, w, h)
end

function DimensionalStyler:DrawDimensionalRectangle(backColor, x, y, w, h)

    local borderColor = CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(COLOR_SHIFT_AMOUNT,
    CurrentRenderer:HexadecimalColorToRGB(backColor)))
    CurrentRenderer:FillRectangle(borderColor, x - DEPTH / DEPTH_DIVISOR, y - DEPTH / DEPTH_DIVISOR, w, h)
    CurrentRenderer:FillRectangle(backColor, x, y, w, h)

    local borderSize = Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE
    CurrentRenderer:DrawLine(borderColor, borderSize, x, y, x - DEPTH, y - DEPTH)
    CurrentRenderer:DrawLine(borderColor, borderSize, x - DEPTH, y - DEPTH, x + w - DEPTH / 2, y - DEPTH)

    CurrentRenderer:DrawLine(borderColor, borderSize, x, y + h, x - DEPTH, y + h - DEPTH)
    CurrentRenderer:DrawLine(borderColor, borderSize, x - DEPTH, y - DEPTH, x - DEPTH, y + h - DEPTH)

    CurrentRenderer:DrawLine(borderColor, borderSize, x + w, y, x + w - DEPTH, y - DEPTH)
    CurrentRenderer:DrawLine(borderColor, borderSize, x, y + h, x + w, y + h)

    CurrentRenderer:DrawLine(borderColor, borderSize, x + w, y + h, x + w, y)

    CurrentRenderer:DrawLine(borderColor, borderSize, x, y, x + w, y)
    CurrentRenderer:DrawLine(borderColor, borderSize, x, y, x, y + h)
end