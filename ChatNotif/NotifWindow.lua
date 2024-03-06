-- NotifWindow

import "Esy.ChatNotif.Timer";
import "Esy.ChatNotif.Callback";
import "Esy.ChatNotif.Utils";

-- NotifWindow class displays a window with a given message
NotifWindow = class(Turbine.UI.Window); -- Inherit from Turbine.UI.Window

function NotifWindow:Constructor()
    -- Turbine Window fields
    Turbine.UI.Window.Constructor(self);
    local WINDOW_WIDTH = 500;
    local WINDOW_HEIGHT = 500;
    self:SetSize(WINDOW_WIDTH, WINDOW_HEIGHT);
    self:SetPosition(SETTINGS.POSITION.X, SETTINGS.POSITION.Y);
    if SETTINGS.DEBUG then self:SetBackColor(Turbine.UI.Color(0.5, 0.18, 0.31, 0.31)) end
    self:SetWantsKeyEvents(false);
    self:SetLock(SETTINGS.POSITION_LOCKED);
    self:SetVisible(true);



    -- Hide the window when the UI is hidden    
    self:SetWantsKeyEvents(true);
    self.KeyDown = function(sender, args)
        if (args.Action == Turbine.UI.Lotro.Action.Escape) then
            self:SetVisible(true);
        elseif (args.Action == 268435635) then
            self:SetVisible(not self:IsVisible());
        end
    end



    -- Ability to move the window when unlocked
    local mousePositionBefore = nil;
    local windowPositionBefore = nil;
    local dragging = false;
    -- On moouse click
    self.MouseDown = function(args)
        if SETTINGS.DEBUG then Turbine.Shell.WriteLine("[NotifWindow] MouseDown " .. tostring(args)) end
        mousePositionBefore = { Turbine.UI.Display.GetMousePosition(); }
        windowPositionBefore = { self:GetPosition(); }
        dragging = true;
    end
    -- On mouse release
    self.MouseUp = function(args)
        if SETTINGS.DEBUG then Turbine.Shell.WriteLine("[NotifWindow] MouseUp " .. tostring(args)) end
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
    self.Anounce:SetSize(WINDOW_WIDTH, WINDOW_HEIGHT);
    self.Anounce:SetPosition(0, 0);
    self.Anounce:SetTextAlignment(Turbine.UI.ContentAlignment.TopCenter);
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
    
    -- Highligh timer
    self.msgDuration = 0;
    self.msgColor = SETTINGS.DEFAULT_COLOR;
    self.msgText = "";
    HighlightTimer = Timer();
    local highlightCallback = function()
        self:DisplayMsg(self.msgText, math.max(0, self.msgDuration), self.msgColor);
    end
    AddCallback(HighlightTimer, "TimeReached", highlightCallback);

    
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
function NotifWindow:DisplayMsg(msg, duration, color)
    if (duration ~=nil and duration > 0) then DisplayTimer:SetTime(duration, false) end
    self.Anounce:SetText(msg);
    if (color ~= nil) then self.Anounce:SetForeColor(color) end
    self.Anounce:SetVisible(true);

    if SETTINGS.DEBUG and duration ~= nil and duration > 0 then Turbine.Shell.WriteLine("[NotifWindow] DisplayMsg(\"" .. tostring(msg) .."\", " .. tostring(duration) ..")") end
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
            if SETTINGS.DEBUG then msg = "[" .. args.ChatType .. "] " .. args.Message;
            else msg = args.Message end
            local duration = Clamp(SETTINGS.MSG_TIME * #msg, SETTINGS.MSG_TIME_MIN, SETTINGS.MSG_TIME_MAX); -- Capped between min and max duration
            
            -- Color
            local color;
            if SETTINGS.CHANNELS_COLORS ~= nil and SETTINGS.CHANNELS_COLORS[args.ChatType] ~= nil then
                color = SETTINGS.CHANNELS_COLORS[args.ChatType];
                color = Turbine.UI.Color(color.R, color.G, color.B)
            else
                color = SETTINGS.DEFAULT_COLOR;
            end

            -- Highlight
            if SETTINGS.MSG_TIME_HIGHLIGHT > 0 then
                self:DisplayMsg(msg, SETTINGS.MSG_TIME_HIGHLIGHT, Turbine.UI.Color.Orange);
                self.msgDuration = duration - SETTINGS.MSG_TIME_HIGHLIGHT;
                self.msgColor = color;
                self.msgText = msg;
                HighlightTimer:SetTime(SETTINGS.MSG_TIME_HIGHLIGHT, false);
            else
                self:DisplayMsg(msg, duration, color);
            end
        end
    end
end
