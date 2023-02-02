-- NotifWindow

import "Esy.ChatNotif.Timer";
import "Esy.ChatNotif.Callback";

-- NotifWindow class displays a window with a given message
NotifWindow = class(Turbine.UI.Window); -- Inherit from Turbine.UI.Window

function NotifWindow:Constructor()
    -- Turbin Window fields
    Turbine.UI.Window.Constructor(self);
    self:SetSize(500, 100);
    self:SetPosition(SETTINGS.POSITION.X, SETTINGS.POSITION.Y);
    if SETTINGS.DEBUG then self:SetBackColor(Turbine.UI.Color(0.5, 0.18, 0.31, 0.31)) end
    self:SetWantsKeyEvents(false);
    self:SetLock(SETTINGS.POSITION_LOCKED);
    self:SetVisible(true);

    -- Ability to move the window when unlocked
    local mousePositionBefore = nil;
    local windowPositionBefore = nil;
    local dragging = false;
    -- On moouse click
    self.MouseDown = function(args)
        if SETTINGS.DEBUG then Turbine.Shell.WriteLine("MouseDown " .. tostring(args)) end
        mousePositionBefore = { Turbine.UI.Display.GetMousePosition(); }
        windowPositionBefore = { self:GetPosition(); }
        dragging = true;
    end
    -- On mouse release
    self.MouseUp = function(args)
        if SETTINGS.DEBUG then Turbine.Shell.WriteLine("MouseUp " .. tostring(args)) end
        dragging = false;
        SETTINGS.POSITION.X, SETTINGS.POSITION.Y = self:GetPosition();
    end
    -- On mouse move
    self.MouseMove = function(args)
        if (dragging) then
            local mouseBeforeX, mouseBeforeY = unpack(mousePositionBefore);
            local mouseCurrentX, mouseCurrentY = Turbine.UI.Display.GetMousePosition();
            local deltaX = mouseCurrentX - mouseBeforeX;
            local deltaY = mouseCurrentY - mouseBeforeY;
            local x, y = unpack(windowPositionBefore);
            x = x + deltaX;
            y = y + deltaY;
            x = math.min(Turbine.UI.Display:GetWidth() - self:GetWidth(), math.max(0, x));
            y = math.min(Turbine.UI.Display:GetHeight() - self:GetHeight(), math.max(0, y));
            self:SetPosition(x, y);
        end
    end

    -- Text label
    self.Anounce = Turbine.UI.Label();
    self.Anounce:SetParent(self);
    self.Anounce:SetSize(450, 100);
    self.Anounce:SetPosition(0, 0);
    self.Anounce:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    self.Anounce:SetFont(Turbine.UI.Lotro.Font.TrajanProBold25);
    self.Anounce:SetForeColor(Turbine.UI.Color.Azure);
    self.Anounce:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.Anounce:SetVisible(false);
    self.Anounce:SetMarkupEnabled(true);
    self.Anounce:SetMouseVisible(false);

    -- Timer
    -- Instantiate the timer
    DisplayTimer = Timer();
    -- Default blank message
    local clearMsg = function()
        self:DisplayMsg("");
    end
    -- Set the TimeReached event handler to clear the message when the timer ends
    AddCallback(DisplayTimer, "TimeReached", clearMsg);
    -- On message received
    self.ChatReceived(self);
end

-- Lock or unlock the window position
function NotifWindow:SetLock(lockState)
    if (not lockState) then
        self:SetBackColor(Turbine.UI.Color(0.5, 0.18, 0.31, 0.31));
    else
        if (not SETTINGS.DEBUG) then
            self:SetBackColor(Turbine.UI.Color.Transparent);
        end
    end
    self:SetMouseVisible(not lockState);
    SETTINGS.POSITION_LOCKED = lockState
end

-- Displays a message for a given duration
function NotifWindow:DisplayMsg(msg, duration)
    if (duration ~= 0) then DisplayTimer:SetTime(duration, false) end
    self.Anounce:SetText(msg);
    self.Anounce:SetVisible(true);
end

-- Check if the message should be displayed given the current settings
function NotifWindow:ShouldDisplay(message)
    -- TODO Check if UI is hidden
    return SETTINGS.CHANNELS_ENABLED[message.ChatType];
end

-- On message received
function NotifWindow:ChatReceived()
    Turbine.Chat.Received = function(sender, args)
        if (self:ShouldDisplay(args)) then
            local msg;
            if SETTINGS.DEBUG then
                msg = "[" .. args.ChatType .. "] " .. args.Message;
            else
                msg = args.Message;
            end
            self:DisplayMsg(msg, SETTINGS.MSG_TIME);
        end
    end
end
