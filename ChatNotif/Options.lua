function OptionsControl()
    local boxHeight = 25;
    local boxWidth = 200;
    local scrollBarHeight = 10;
    local scrollBarWidth = 100;
    local xOffset = 15;


    Options = Turbine.UI.Control();
    Turbine.Plugin.GetOptionsPanel = function(self) return Options; end

    Options:SetBackColor(Turbine.UI.Color.DarkSlateGray);

    local ypos = 0;
    -- Channel choice
    local channelsLabel = Turbine.UI.Label();
    channelsLabel:SetParent(Options);
    channelsLabel:SetSize(boxWidth, boxHeight);
    channelsLabel:SetBackColor(Turbine.UI.Color.DarkRed);
    channelsLabel:SetText("Channels");
    channelsLabel:SetPosition(0, ypos);

    -- Chat types
    ypos = channelsLabel:GetTop() + channelsLabel:GetHeight();
    local channelsCheckbox = {};
    for name, code in pairs(Turbine.ChatType) do
        if type(code) == "number" then
            -- Channel checkbox
            channelsCheckbox[name] = Turbine.UI.Lotro.CheckBox();
            channelsCheckbox[name]:SetParent(Options);
            channelsCheckbox[name]:SetSize(boxWidth - xOffset, boxHeight);
            channelsCheckbox[name]:SetPosition(xOffset, ypos);
            channelsCheckbox[name]:SetText(name);
            channelsCheckbox[name]:SetBackColor(Turbine.UI.Color.BlueViolet);
            channelsCheckbox[name]:SetChecked(ExistsInSet(SETTINGS.CHANNELS_ENABLED, code));
            channelsCheckbox[name].CheckedChanged = function(sender, args)
                if channelsCheckbox[name]:IsChecked() then
                    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Added " .. name) end
                    AddToSet(SETTINGS.CHANNELS_ENABLED, code);
                else
                    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Removed " .. name) end
                    RemoveFromSet(SETTINGS.CHANNELS_ENABLED, code);
                end
            end
            -- Update Y position
            ypos = ypos + boxHeight;
        end
    end

    -- Font size
    local fontSizeLabel = Turbine.UI.Label();
    fontSizeLabel:SetParent(Options);
    fontSizeLabel:SetSize(boxWidth, boxHeight);
    fontSizeLabel:SetBackColor(Turbine.UI.Color.DarkGreen);
    fontSizeLabel:SetPosition(0, ypos);
    fontSizeLabel:SetText("Font size");
    ypos = ypos + boxHeight;

    -- Notif timer
    local timerLabel = Turbine.UI.Label();
    timerLabel:SetParent(Options);
    timerLabel:SetSize(boxWidth, boxHeight);
    timerLabel:SetBackColor(Turbine.UI.Color.DarkGoldenrod);
    timerLabel:SetPosition(0, ypos);
    timerLabel:SetText("Notification timer");
    
    -- local timerMenu = Turbine.UI.ContextMenu();
    -- local timerMenuItems = timerMenu:GetItems();
    -- for i = 1, 10 do
    --     timerMenuItems:Add(Turbine.UI.MenuItem(tostring(i)));
    -- end
    -- for i = 1, timerMenuItems:GetCount() do
    --     local timerMenuItem = timerMenuItems:Get(i);
    --     local timerItemText = timerMenuItems:GetText();
    --     if ( timerItemText == self.selectedItem ) then
	-- 		timerMenuItems:SetChecked( true );
	-- 		timerMenuItems:SetEnabled( false );
	-- 	end
    -- end

    local timerButton = Turbine.UI.Lotro.Button();
    timerButton:SetParent(Options);
    timerButton:SetPosition(boxWidth, ypos);
    timerButton:SetWidth(boxWidth);
    timerButton:SetText("Set time");
    timerButton.Click = function(sender, args)
        -- timerMenu:ShowMenu();
    end

    ypos = ypos + boxHeight;

    -- Position
    local positionLabel = Turbine.UI.Label();
    positionLabel:SetParent(Options);
    positionLabel:SetSize(boxWidth, boxHeight);
    positionLabel:SetBackColor(Turbine.UI.Color.DarkBlue);
    positionLabel:SetPosition(0, ypos);
    positionLabel:SetText("Position");
   
    ypos = ypos + boxHeight;

    -- Lock position
    local lockPosition = Turbine.UI.Lotro.CheckBox();
    lockPosition:SetParent(Options);
    lockPosition:SetSize(boxWidth - xOffset, boxHeight);
    lockPosition:SetPosition(xOffset, ypos);
    lockPosition:SetText("Lock position");
    lockPosition:SetBackColor(Turbine.UI.Color.DarkOrange);
    lockPosition:SetChecked(SETTINGS.POSITION_LOCKED);
    lockPosition.CheckedChanged = function(sender, args)
        -- TODO
        Turbine.Shell.WriteLine("Lock position: " .. tostring(lockPosition:IsChecked()));
        MyNotifWindow:SetLock(lockPosition:IsChecked());
    end

    ypos = ypos + boxHeight;

    -- TODO Position initiale des scrollbars
    -- X ScrollBar
    local XPositionScrollBar = Turbine.UI.Lotro.ScrollBar();
    XPositionScrollBar:SetParent(Options);
    XPositionScrollBar:SetPosition(scrollBarHeight, ypos);
    XPositionScrollBar:SetSize(scrollBarWidth, scrollBarHeight);
    XPositionScrollBar:SetOrientation(Turbine.UI.Orientation.Horizontal);
    XPositionScrollBar.ValueChanged = function(sender, args)
        local x = XPositionScrollBar:GetValue() * (Turbine.UI.Display:GetWidth() - MyNotifWindow:GetWidth()) / 100;
        SETTINGS.POSITION.X = x;
        MyNotifWindow:SetPosition(x, MyNotifWindow:GetTop());
    end
    ypos = ypos + scrollBarHeight;

    -- Y ScrollBar
    local YPositionScrollBar = Turbine.UI.Lotro.ScrollBar();
    YPositionScrollBar:SetParent(Options);
    YPositionScrollBar:SetPosition(0, ypos);
    YPositionScrollBar:SetSize(scrollBarHeight, scrollBarWidth);
    YPositionScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    YPositionScrollBar.ValueChanged = function(sender, args)
        local y = YPositionScrollBar:GetValue() * (Turbine.UI.Display:GetHeight() - MyNotifWindow:GetHeight()) / 100;
        SETTINGS.POSITION.Y = y;
        MyNotifWindow:SetPosition(MyNotifWindow:GetLeft(), y);
    end
    ypos = ypos + scrollBarWidth;

    Options:SetSize(2 * boxWidth, ypos);
end
