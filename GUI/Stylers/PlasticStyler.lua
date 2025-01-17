PlasticStyler = middleclass('PlasticStyler', Styler)

local COLOR_SHIFT_AMOUNT = 20

function PlasticStyler:initialize()
end


function PlasticStyler:DrawRaisedFrame(control, backColor, borderColor, borderSize, x, y, w, h)

    local lightenedBorderColor = CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(-COLOR_SHIFT_AMOUNT,
    CurrentRenderer:HexadecimalColorToRGB(borderColor)))
    local darkenedBorderColor = CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(COLOR_SHIFT_AMOUNT,
    CurrentRenderer:HexadecimalColorToRGB(borderColor)))

    if not self:ControlShouldBeDeep(control) then
        self:DrawBorder(control, borderColor, borderSize, x, y, w - borderSize, h - borderSize)
    end
    
    self:DrawBorder(control, borderColor, borderSize, x + borderSize, y + borderSize, w, h)

    if self:ControlShouldBeDeep(control) then
        x = x + borderSize
        y = y + borderSize
    end

    self:DrawPlasticRectangle(backColor, x, y, w, h)
end

function PlasticStyler:DrawPlasticRectangle(backColor, x, y, w, h)
    CurrentRenderer:FillRectangle(backColor, x, y, w, h)
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(-COLOR_SHIFT_AMOUNT,
    CurrentRenderer:HexadecimalColorToRGB(backColor))), x, y, w, h / 4)
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(COLOR_SHIFT_AMOUNT,
    CurrentRenderer:HexadecimalColorToRGB(backColor))), x, y + h / 2, w, h / 2)
end

function PlasticStyler:DrawBorder(control, borderColor, borderSize, x, y, w, h)
    CurrentRenderer:FillRectangle(borderColor, x - borderSize, y - borderSize, w + borderSize * 2, h + borderSize * 2)
end

function PlasticStyler:DrawGenericAccentShape(control, backColor, x, y, w, h)
    self:DrawPlasticRectangle(backColor, x, y, w, h)
end