Mouse = {
    X = 0,
    Y = 0,
    PreviousScrollDelta = 0,
    ScrollDelta = 0,
    IsPrimaryButtonDown = false,
    IsSecondaryButtonDown = false,
    _mouseTable = {},
    _previousMouseTable = {}
}

function Mouse.Update()
    Mouse.ScrollingDirection = 0
    Mouse._previousMouseTable = Mouse._mouseTable
    Mouse._mouseTable = input.get()
    Mouse.X = Mouse._mouseTable["xmouse"]
    Mouse.Y = Mouse._mouseTable["ymouse"]
    if WindowsMessageManager.CurrentWindowsMessage.Id == WindowsMessages.WM_MOUSEWHEEL then
        Mouse.PreviousScrollDelta = Mouse.ScrollDelta
        Mouse.ScrollDelta = (WindowsMessageManager.CurrentWindowsMessage.wParam & 0xFFFF0000) >> 16
    end
end


function Mouse.IsInside(x, y, w, h)
    return Mouse.X > x and Mouse.X < x + w and Mouse.Y > y and Mouse.Y < y + h
end

function Mouse.IsPrimaryDown()
    -- TODO: left-handed mode support
    return Mouse._mouseTable["leftclick"] and true or false
end

function Mouse.IsSecondaryDown()
    -- TODO: left-handed mode support
    return Mouse._mouseTable["rightclick"] and true or false
end

function Mouse.IsPrimaryClicked()
    -- TODO: left-handed mode support
    return (Mouse._mouseTable["leftclick"] and not Mouse._previousMouseTable["leftclick"]) and true or false
end

function Mouse.IsSecondaryClicked()
    -- TODO: left-handed mode support
    return (Mouse._mouseTable["rightclick"] and not Mouse._previousMouseTable["rightclick"]) and true or false
end

function Mouse.IsPrimaryClickedInside(x, y, w, h)
    return Mouse.IsPrimaryClicked() and Mouse.IsInside(x, y, w, h)
end

function Mouse.IsSecondaryClickedInside(x, y, w, h)
    return Mouse.IsSecondaryClicked() and Mouse.IsInside(x, y, w, h)
end

function Mouse.IsScrolledDown()
    return Mouse.ScrollDelta == 65416
end

function Mouse.IsScrolledUp()
    return Mouse.ScrollDelta == 120
end
