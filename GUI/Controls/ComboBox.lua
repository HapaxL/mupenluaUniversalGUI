ComboBox = middleclass('ComboBox', Control)

function ComboBox:initialize(containingScene, index, x, y, w, h, items, onSelectedItemChangedCallback)
    Control.initialize(self, containingScene, index, x, y, w, h, nil, nil)

    self.Items = items -- Must be of type "string" :)

    self.CurrentItemBackColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR
    self.CurrentItemSelectedBackColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR

    self.SelectedItemIndex = 1
    self.ItemHeight = 20
    self.IsOpened = false

    self.CurrentBackColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR
    self.CurrentForeColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR
    self.CurrentBorderColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR

    -- self.RightChevronX = self.X + self.Width - Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH
    self.CurrentRightChevronY = self.Y
    self.TargetRightChevronY = self.CurrentRightChevronY

    self.RightChevronWidth = Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH
    self.RightChevronHeight = self.Height
    self.RightChevronText = self.IsOpened and "^" or "v"

    self.TargetDropDownHeight = 0
    self.CurrentDropDownHeight = self.TargetDropDownHeight

    self.OnSelectedItemChangedCallback = onSelectedItemChangedCallback
end

function ComboBox:PersistentUpdate()
    self.CurrentBackColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentBackColor),
        CurrentRenderer:HexadecimalColorToRGB(Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and
                                                  Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BACK_COLOR or
                                                  Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
    self.CurrentForeColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentForeColor),
        CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
    self.CurrentBorderColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentBorderColor),
        CurrentRenderer:HexadecimalColorToRGB(Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and
                                                  Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR or
                                                  Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
    self.CurrentItemBackColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentItemBackColor),
        CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR))
    self.CurrentItemSelectedBackColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentItemSelectedBackColor),
        CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR))
    self.CurrentRightChevronY = Numeric.TemporalInterpolateNumberWithSpeed(0.5, self.CurrentRightChevronY,
        self.TargetRightChevronY)

end

function ComboBox:IsAnotherComboBoxOpenInScene()
    -- TODO: refactor to O(1) using dict cache
    for key, control in pairs(self.ContainingScene.Controls) do
        if control:isInstanceOf(ComboBox) and control.IsOpened and control == self == false then
            return true
        end
    end
    return false
end

function ComboBox:SetOpen(isOpen)
    if self:IsAnotherComboBoxOpenInScene() then
        return
    end
    self.IsOpened = isOpen
    self.TargetDropDownHeight = self.IsOpened and (self.ItemHeight * #self.Items) or -self.ItemHeight
    self.RightChevronText = self.IsOpened and "^" or "v"
end

function ComboBox:Update()
    self.CurrentDropDownHeight =
        Numeric.TemporalInterpolateNumber(self.CurrentDropDownHeight, self.TargetDropDownHeight)

    if Mouse.IsPrimaryClickedInside(self.X, self.Y, self.Width, self.Height) then
        self.SetOpen(self, not self.IsOpened)
    end

    if self.CurrentDropDownHeight > self.TargetDropDownHeight / 4 and self.IsOpened then

        local itemWasClicked = false

        local baseY = self.Y - self.ItemHeight * #self.Items + self.ItemHeight / 2 + self.CurrentDropDownHeight
        for i = 1, #self.Items, 1 do
            local thisY = baseY + (i * self.ItemHeight)
            if Mouse.IsPrimaryClickedInside(self.X - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, thisY,
                self.Width + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE + 1, self.ItemHeight) then
                self.SetSelectedIndex(self, i)
                itemWasClicked = true
            end
        end

        if Mouse.IsPrimaryClicked() and
            Mouse.IsInside(self.X, self.Y, self.Width, self.Height + self.CurrentDropDownHeight) == false and
            itemWasClicked == false then
            self.SetOpen(self, false)
        end
        self.PerformKeyboardNavigation(self)
    else
        if Mouse.IsInside(self.X, self.Y, self.Width, self.Height) then
            self.PerformKeyboardNavigation(self)
        end

    end

    if Mouse.IsInside(self.X, self.Y, self.Width, self.Height) then
        self.TargetRightChevronY = self.Y + (self.IsOpened and -5 or 5)
    else
        self.TargetRightChevronY = (self.Y)
    end
end

function ComboBox:PerformKeyboardNavigation()
    if self:IsAnotherComboBoxOpenInScene() then
        return
    end
    if Keyboard.KeyPressed("down") then
        self.SetSelectedIndex(self, self.SelectedItemIndex + 1)
    end
    if Keyboard.KeyPressed("up") then
        self.SetSelectedIndex(self, self.SelectedItemIndex - 1)
    end
end

function ComboBox:SetSelectedIndex(index)
    self.SelectedItemIndex = Numeric.WrappingClamp(index, 1, #self.Items)
    self.ContainingScene:AddQueuedCallback( self.OnSelectedItemChangedCallback, self)
end

function ComboBox:ModalDraw()
    if self.CurrentDropDownHeight > 0 then

        CurrentStyler:DrawBorder(self, Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR,
            Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.X, self.Y, self.Width,
            self.CurrentDropDownHeight + self.ItemHeight / 2 + self.ItemHeight)

        local baseY = self.Y - self.ItemHeight * #self.Items + self.ItemHeight / 2 + self.CurrentDropDownHeight

        for i = 1, #self.Items, 1 do

            local thisY = baseY + (i * self.ItemHeight)

            if thisY > self.Y + self.Height - self.ItemHeight then

                CurrentRenderer:FillRectangle((self.SelectedItemIndex == i or Mouse.IsInside(self.X, thisY, self.Width, self.ItemHeight)) and self.CurrentItemSelectedBackColor or
                                                  self.CurrentItemBackColor, self.X, thisY, self.Width, self.ItemHeight)

                CurrentRenderer:DrawText(self.CurrentForeColor, self.Items[i], self.X + 3, thisY + 2)

            end
        end
        if math.floor(self.CurrentDropDownHeight) == math.floor(self.TargetDropDownHeight) == false then
            self:Draw()
        end
    end
end

function ComboBox:Draw()

    CurrentStyler:DrawRaisedFrame(self, self.CurrentBackColor, self.CurrentBorderColor,
        Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.X, self.Y, self.Width, self.Height)

    CurrentRenderer:DrawText(self.CurrentForeColor, self.RightChevronText, self.X + self.Width -
        Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH / 2 - 4, self.CurrentRightChevronY)

    CurrentRenderer:DrawText(self.CurrentForeColor, self.Items[self.SelectedItemIndex], self.X + 3, self.Y + 2)

end
