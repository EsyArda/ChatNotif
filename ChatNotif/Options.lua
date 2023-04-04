function OptionsControl()
    -- Pixel values
    local boxHeight = 20;
    local boxWidth = 320;
    local leftMargin = 20;
    local yOffset = 10;
    local scrollBarWidth = boxWidth/2;
    local scrollBarHeight = 10;

    -- Fonts
    local headerFont = Turbine.UI.Lotro.Font.VerdanaBold16;
    local corpsFont = Turbine.UI.Lotro.Font.Verdana16;

    Options = Turbine.UI.Control();
    Turbine.Plugin.GetOptionsPanel = function(self) return Options; end

    if SETTINGS.DEBUG then Options:SetBackColor(Turbine.UI.Color.DarkSlateGray) end

    local yPos = 0;

    -- ##### Lock position #####
    local lockPosition = Turbine.UI.Lotro.CheckBox();
    lockPosition:SetParent(Options);
    lockPosition:SetSize(boxWidth - leftMargin, boxHeight);
    lockPosition:SetPosition(0, yPos);
    lockPosition:SetFont(headerFont);
    lockPosition:SetText("Lock window position");
    if SETTINGS.DEBUG then lockPosition:SetBackColor(Turbine.UI.Color.DarkOrange) end
    lockPosition:SetChecked(SETTINGS.POSITION_LOCKED);
    lockPosition.CheckedChanged = function(sender, args)
        MyNotifWindow:SetLock(lockPosition:IsChecked());
    end
    yPos = yPos + lockPosition:GetHeight() + yOffset;

    -- ##### Channel choice #####
    local channelsLabel = Turbine.UI.Label();
    channelsLabel:SetParent(Options);
    channelsLabel:SetSize(boxWidth, boxHeight);
    if SETTINGS.DEBUG then channelsLabel:SetBackColor(Turbine.UI.Color.DarkRed) end
    channelsLabel:SetFont(headerFont);
    channelsLabel:SetPosition(0, yPos);
    channelsLabel:SetText("Select channels");

    -- Chat types
    yPos = channelsLabel:GetTop() + channelsLabel:GetHeight();
    local channelsCheckbox = {};
    for name, code in pairs(Turbine.ChatType) do
        if type(code) == "number" then
            -- Channel checkbox
            channelsCheckbox[code] = Turbine.UI.Lotro.CheckBox();
            channelsCheckbox[code]:SetParent(Options);
            channelsCheckbox[code]:SetSize(boxWidth - leftMargin, boxHeight);
            channelsCheckbox[code]:SetPosition(leftMargin, yPos);
            channelsCheckbox[code]:SetFont(corpsFont);
            local label;
            if SETTINGS.DEBUG then label = code .. " - " .. name else label = name end;
            channelsCheckbox[code]:SetText(label);
            if SETTINGS.DEBUG then channelsCheckbox[code]:SetBackColor(Turbine.UI.Color.BlueViolet) end
            channelsCheckbox[code]:SetChecked(ExistsInSet(SETTINGS.CHANNELS_ENABLED, code));
            channelsCheckbox[code].CheckedChanged = function(sender, args)
                if channelsCheckbox[code]:IsChecked() then
                    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Added " .. name) end
                    AddToSet(SETTINGS.CHANNELS_ENABLED, code);
                else
                    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Removed " .. name) end
                    RemoveFromSet(SETTINGS.CHANNELS_ENABLED, code);
                end
            end
            -- Update Y position
            yPos = yPos + boxHeight;
        end
    end
    yPos = yPos+ yOffset;


    -- ##### Notif timer #####
    local timerLabel = Turbine.UI.Label();
    timerLabel:SetParent(Options);
    timerLabel:SetSize(boxWidth, boxHeight);
    if SETTINGS.DEBUG then timerLabel:SetBackColor(Turbine.UI.Color.DarkGoldenrod) end
    timerLabel:SetPosition(0, yPos);
    timerLabel:SetFont(headerFont);
    timerLabel:SetText("Notification duration : " .. SETTINGS.MSG_TIME .. "s");
    timerLabel:SetVisible(true);
    yPos = yPos + boxHeight;

    -- Timer scroll bar
    local timerScrollBar = Turbine.UI.Lotro.ScrollBar();
    timerScrollBar:SetParent(Options);
    timerScrollBar:SetPosition(leftMargin, yPos);
    timerScrollBar:SetOrientation(Turbine.UI.Orientation.Horizontal);
    timerScrollBar:SetSize(scrollBarWidth, scrollBarHeight);
    timerScrollBar:SetValue(SETTINGS.MSG_TIME);
    timerScrollBar.ValueChanged = function(sender, args)
        local value = timerScrollBar:GetValue();
        if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Timer value: " .. value) end
        SETTINGS.MSG_TIME = value;
        timerLabel:SetText("Notification duration : " .. SETTINGS.MSG_TIME .. "s");
    end
    yPos = yPos + scrollBarHeight;

    -- Timer context menu

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
    timerButton:SetPosition(boxWidth, yPos);
    timerButton:SetWidth(100);
    timerButton:SetText("Set time");
    timerButton:SetVisible(true);
    timerButton.Click = function(sender, args)
       -- timerMenu:ShowMenu();
    end
    yPos = yPos + boxHeight;

    
    -- ##### Font size #####
    local fontSizeLabel = Turbine.UI.Label();
    fontSizeLabel:SetParent(Options);
    fontSizeLabel:SetSize(boxWidth, boxHeight);
    if SETTINGS.DEBUG then fontSizeLabel:SetBackColor(Turbine.UI.Color.DarkGreen) end
    fontSizeLabel:SetPosition(0, yPos);
    fontSizeLabel:SetFont(headerFont);
    fontSizeLabel:SetText("[In a future update] Select font size");
    fontSizeLabel:SetVisible(false); -- TODO
    yPos = yPos + boxHeight;

    Options:SetSize(2 * boxWidth, yPos);
end
