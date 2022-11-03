function OptionsControl()
    -- Pixel values
    local boxHeight = 20;
    local boxWidth = 320;
    local xOffset = 20;
    local yMargin = 10;

    -- Fonts
    local headerFont = Turbine.UI.Lotro.Font.VerdanaBold16;
    local corpsFont = Turbine.UI.Lotro.Font.Verdana16;

    Options = Turbine.UI.Control();
    Turbine.Plugin.GetOptionsPanel = function(self) return Options; end

    if SETTINGS.DEBUG then Options:SetBackColor(Turbine.UI.Color.DarkSlateGray) end

    local yPos = 0;

    -- Lock position
    local lockPosition = Turbine.UI.Lotro.CheckBox();
    lockPosition:SetParent(Options);
    lockPosition:SetSize(boxWidth - xOffset, boxHeight);
    lockPosition:SetPosition(0, yPos);
    lockPosition:SetFont(headerFont);
    lockPosition:SetText("Lock window position");
    if SETTINGS.DEBUG then lockPosition:SetBackColor(Turbine.UI.Color.DarkOrange) end
    lockPosition:SetChecked(SETTINGS.POSITION_LOCKED);
    lockPosition.CheckedChanged = function(sender, args)
        MyNotifWindow:SetLock(lockPosition:IsChecked());
    end
    yPos = yPos + lockPosition:GetHeight() + yMargin;

    -- Channel choice
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
            channelsCheckbox[name] = Turbine.UI.Lotro.CheckBox();
            channelsCheckbox[name]:SetParent(Options);
            channelsCheckbox[name]:SetSize(boxWidth - xOffset, boxHeight);
            channelsCheckbox[name]:SetPosition(xOffset, yPos);
            channelsCheckbox[name]:SetFont(corpsFont);
            channelsCheckbox[name]:SetText(name);
            if SETTINGS.DEBUG then channelsCheckbox[name]:SetBackColor(Turbine.UI.Color.BlueViolet) end
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
            yPos = yPos + boxHeight;
        end
    end
    yPos = yPos+ yMargin;

    -- Font size
    local fontSizeLabel = Turbine.UI.Label();
    fontSizeLabel:SetParent(Options);
    fontSizeLabel:SetSize(boxWidth, boxHeight);
    if SETTINGS.DEBUG then fontSizeLabel:SetBackColor(Turbine.UI.Color.DarkGreen) end
    fontSizeLabel:SetPosition(0, yPos);
    fontSizeLabel:SetFont(headerFont);
    fontSizeLabel:SetText("[In a future update] Select font size");
    fontSizeLabel:SetVisible(false); -- TODO
    yPos = yPos + boxHeight;

    -- Notif timer
    local timerLabel = Turbine.UI.Label();
    timerLabel:SetParent(Options);
    timerLabel:SetSize(boxWidth, boxHeight);
    if SETTINGS.DEBUG then timerLabel:SetBackColor(Turbine.UI.Color.DarkGoldenrod) end
    timerLabel:SetPosition(0, yPos);
    timerLabel:SetFont(headerFont);
    timerLabel:SetText("[In a future update] Notification duration");
    timerLabel:SetVisible(false); -- TODO

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
    timerButton:SetVisible(false); -- TODO
    timerButton.Click = function(sender, args)
        -- timerMenu:ShowMenu();
    end
    yPos = yPos + boxHeight;

    Options:SetSize(2 * boxWidth, yPos);
end
