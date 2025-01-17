Windows3Styler = middleclass('Windows3Styler', Styler)

local INSET_SIZE = 3
local COLOR_SHIFT_AMOUNT = 40
local CORNER_DIP = 1

function Windows3Styler:initialize()
end

function Windows3Styler:DrawRaisedFrame(control, backColor, borderColor, borderSize, x, y, w, h)
    local lightenedBackColor = CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(-COLOR_SHIFT_AMOUNT,
    CurrentRenderer:HexadecimalColorToRGB(backColor)))
    local darkenedBackColor = CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(COLOR_SHIFT_AMOUNT,
    CurrentRenderer:HexadecimalColorToRGB(backColor)))

    if self:ControlShouldBeDeep(control) then
        y = y + borderSize * 2
    end

    self:DrawBorder(control, borderColor, borderSize, x, y, w, h)

    CurrentRenderer:FillRectangle(backColor, x, y, w, h)

    CurrentRenderer:FillRectangle(lightenedBackColor, x, y, w, INSET_SIZE)
    CurrentRenderer:FillRectangle(lightenedBackColor, x, y, INSET_SIZE, h)
    CurrentRenderer:FillRectangle(darkenedBackColor, x + w - INSET_SIZE, y + INSET_SIZE, INSET_SIZE, h - INSET_SIZE)
    CurrentRenderer:FillRectangle(darkenedBackColor, x + INSET_SIZE, y + h - INSET_SIZE, w - INSET_SIZE, INSET_SIZE)
end

function Windows3Styler:DrawBorder(control, borderColor, borderSize, x, y, w, h)
    local color = CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(COLOR_SHIFT_AMOUNT,
    CurrentRenderer:HexadecimalColorToRGB(borderColor)))

    local bX = x - borderSize
    local bY = y - borderSize
    local bW = w + borderSize
    local bH  = h + borderSize

    CurrentRenderer:FillRectangle(color, bX + CORNER_DIP, bY, bW - CORNER_DIP, borderSize)
    CurrentRenderer:FillRectangle(color, bX + CORNER_DIP, bY + bH, bW - CORNER_DIP, borderSize)
    CurrentRenderer:FillRectangle(color, bX, bY + CORNER_DIP, borderSize, bH - CORNER_DIP)
    CurrentRenderer:FillRectangle(color, bX + bW, bY + CORNER_DIP, borderSize, bH - CORNER_DIP)

    if not self:ControlShouldBeDeep(control) then
        CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(COLOR_SHIFT_AMOUNT*3,
        CurrentRenderer:HexadecimalColorToRGB(borderColor))), bX + CORNER_DIP, bY + bH + borderSize, bW - CORNER_DIP, 2)
    end
    
end

function Windows3Styler:DrawGenericAccentShape(control, backColor, x, y, w, h)
    CurrentRenderer:FillRectangle(backColor, x, y, w, h)

    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(-COLOR_SHIFT_AMOUNT,
    CurrentRenderer:HexadecimalColorToRGB(backColor))), x, y, w - INSET_SIZE * 2, h)
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(COLOR_SHIFT_AMOUNT,
    CurrentRenderer:HexadecimalColorToRGB(backColor))), x + w - INSET_SIZE, y, w - INSET_SIZE * 2, h)
end