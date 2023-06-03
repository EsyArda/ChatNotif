-- Options window

import "Esy.ChatNotif.ColorPicker";

function OptionsControl()
    -- Pixel values
    local boxHeight = 20;
    local boxWidth = 320;
    local leftMargin = 20;
    local yOffset = 10;
    local scrollBarWidth = boxWidth/2;
    local scrollBarHeight = 10;
    local colorPickerWidth = 100;

    -- Fonts
    local headerFont = Turbine.UI.Lotro.Font.VerdanaBold16;
    local corpsFont = Turbine.UI.Lotro.Font.Verdana16;

    Options = Turbine.UI.Control();
    Turbine.Plugin.GetOptionsPanel = function(self) return Options; end

    if SETTINGS.DEBUG then Options:SetBackColor(Turbine.UI.Color.DarkSlateGray) end

    local yPosition = 0;

    -- ##### Lock position #####
    local lockPosition = Turbine.UI.Lotro.CheckBox();
    lockPosition:SetParent(Options);
    lockPosition:SetSize(boxWidth, boxHeight);
    lockPosition:SetPosition(0, yPosition);
    lockPosition:SetFont(headerFont);
    lockPosition:SetText("Lock window position");
    if SETTINGS.DEBUG then lockPosition:SetBackColor(Turbine.UI.Color.DarkOrange) end
    lockPosition:SetChecked(SETTINGS.POSITION_LOCKED);
    lockPosition.CheckedChanged = function(sender, args)
        MyNotifWindow:SetLock(lockPosition:IsChecked());
    end
    yPosition = yPosition + lockPosition:GetHeight() + yOffset;


    
    -- ##### Customize colors #####
    local lockPosition = Turbine.UI.Lotro.CheckBox();
    lockPosition:SetParent(Options);
    lockPosition:SetSize(boxWidth, 2*boxHeight);
    lockPosition:SetPosition(0, yPosition);
    lockPosition:SetFont(headerFont);
    lockPosition:SetText("Customize colors (uncheck after setting colors for better performance)");
    if SETTINGS.DEBUG then lockPosition:SetBackColor(Turbine.UI.Color(0.22,0.17,0.47)) end
    lockPosition:SetChecked(SETTINGS.CUSTOMIZE_COLORS);
    lockPosition.CheckedChanged = function(sender, args)
        SETTINGS.CUSTOMIZE_COLORS = not SETTINGS.CUSTOMIZE_COLORS;
    end
    yPosition = yPosition + lockPosition:GetHeight() + yOffset;
    
    


    -- ##### Channel choice #####
    local channelsLabel = Turbine.UI.Label();
    channelsLabel:SetParent(Options);
    channelsLabel:SetSize(boxWidth, boxHeight);
    if SETTINGS.DEBUG then channelsLabel:SetBackColor(Turbine.UI.Color.DarkRed) end
    channelsLabel:SetFont(headerFont);
    channelsLabel:SetPosition(0, yPosition);
    channelsLabel:SetText("Select channels");

    -- Chat types
    yPosition = channelsLabel:GetTop() + channelsLabel:GetHeight();
    local channelsCheckbox = {};
    
    -- Table with key (the chat name) sorted [1,2,3,... -> Admin,Advancement,Death,...]
    local sortedKeys = {}
    for key in pairs(Turbine.ChatType) do
        if (type(key) == "string") then
            table.insert(sortedKeys, key)
        end
    end
    -- Sort by chat name
    table.sort(sortedKeys)

    -- name is the name of the chat type and chatTypeNames[name] is it's number
    for _, name in ipairs(sortedKeys) do
        if(type(Turbine.ChatType[name]) == "number") then
            -- Channel checkbox
            channelsCheckbox[name] = Turbine.UI.Lotro.CheckBox();
            channelsCheckbox[name]:SetParent(Options);
            channelsCheckbox[name]:SetSize(boxWidth - leftMargin - colorPickerWidth, boxHeight);
            channelsCheckbox[name]:SetPosition(leftMargin, yPosition);
            channelsCheckbox[name]:SetFont(corpsFont);
            local label;
            if SETTINGS.DEBUG then label = Turbine.ChatType[name] .. " - " .. name else label = name end;
            channelsCheckbox[name]:SetText(label);
            if SETTINGS.DEBUG then channelsCheckbox[name]:SetBackColor(Turbine.UI.Color.BlueViolet) end
            channelsCheckbox[name]:SetChecked(ExistsInSet(SETTINGS.CHANNELS_ENABLED, Turbine.ChatType[name]));
            channelsCheckbox[name].CheckedChanged = function(sender, args)
                if channelsCheckbox[name]:IsChecked() then
                    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Added " .. name) end
                    AddToSet(SETTINGS.CHANNELS_ENABLED, Turbine.ChatType[name]);
                else
                    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Removed " .. name) end
                    RemoveFromSet(SETTINGS.CHANNELS_ENABLED, Turbine.ChatType[name]);
                end
            end

            -- -- ##### Color Picker #####
            if SETTINGS.CUSTOMIZE_COLORS then
                local colorPicker = ColorPicker();
                colorPicker:SetParent(Options);
                colorPicker:SetPosition(boxWidth - colorPickerWidth, yPosition);
                -- colorPicker.doActive=function()
                --     Turbine.Shell.WriteLine("Color picker active");
                -- end
                colorPicker.ColorChanged=function(sender,args)
                    channelsCheckbox[name]:SetForeColor(args.Color);
                    SETTINGS.CHANNELS_COLORS[Turbine.ChatType[name]] = args.Color;
                end
            end


            -- Update Y position
            yPosition = yPosition + boxHeight + yOffset;
        end
    end
    yPosition = yPosition+ yOffset;


    -- ##### Notif timer #####
    -- Timer label
    local timerLabel = Turbine.UI.Label();
    timerLabel:SetParent(Options);
    timerLabel:SetSize(boxWidth, boxHeight);
    if SETTINGS.DEBUG then timerLabel:SetBackColor(Turbine.UI.Color.DarkGoldenrod) end
    timerLabel:SetPosition(0, yPosition);
    timerLabel:SetFont(headerFont);
    timerLabel:SetText("Notification duration : " .. SETTINGS.MSG_TIME .. "s per character");
    timerLabel:SetVisible(true);
    yPosition = yPosition + boxHeight;

    -- Timer scroll bar
    local timerScrollBar = Turbine.UI.Lotro.ScrollBar();
    timerScrollBar:SetParent(Options);
    timerScrollBar:SetPosition(leftMargin, yPosition);
    timerScrollBar:SetOrientation(Turbine.UI.Orientation.Horizontal);
    timerScrollBar:SetSize(scrollBarWidth, scrollBarHeight);
    -- Larger bar
    timerScrollBar:SetMinimum(1);
    timerScrollBar:SetMaximum(50);
    -- Value
    timerScrollBar:SetValue(SETTINGS.MSG_TIME * 100);
    timerScrollBar.ValueChanged = function(sender, args)
        local value = timerScrollBar:GetValue();
        if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Timer value: " .. value) end
        SETTINGS.MSG_TIME = value / 100;
        timerLabel:SetText("Notification duration : " .. SETTINGS.MSG_TIME .. "s per character");
    end
    yPosition = yPosition + scrollBarHeight + yOffset;





    -- ##### Account wide settings #####
    local accountWideCheckBox = Turbine.UI.Lotro.CheckBox();
    accountWideCheckBox:SetParent(Options);
    accountWideCheckBox:SetSize(boxWidth, 2*boxHeight);
    accountWideCheckBox:SetPosition(0, yPosition);
    accountWideCheckBox:SetFont(headerFont);
    accountWideCheckBox:SetText("Save settings account wide (update on logout)");
    if SETTINGS.DEBUG then accountWideCheckBox:SetBackColor(Turbine.UI.Color.RoyalBlue) end
    accountWideCheckBox:SetChecked(SETTINGS.ACCOUNT_WIDE_SETTINGS);
    accountWideCheckBox.CheckedChanged = function(sender, args)
        SETTINGS.ACCOUNT_WIDE_SETTINGS = accountWideCheckBox:IsChecked();
         if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Options: Account wide settings set to " .. tostring(SETTINGS.ACCOUNT_WIDE_SETTINGS)) end

    end
    yPosition = yPosition + accountWideCheckBox:GetHeight() + yOffset;


    -- ##### Command help label #####
    local commandsLabel = Turbine.UI.Label();
    commandsLabel:SetParent(Options);
    commandsLabel:SetSize(boxWidth, 2*boxHeight);
    if SETTINGS.DEBUG then commandsLabel:SetBackColor(Turbine.UI.Color.YellowGreen) end
    commandsLabel:SetFont(corpsFont);
    commandsLabel:SetPosition(0, yPosition);
    commandsLabel:SetText("Type '/cn help' in the chat window to see all commands");
    yPosition = yPosition + commandsLabel:GetHeight() + yOffset;


    -- ##### Font size #####
    local fontSizeLabel = Turbine.UI.Label();
    fontSizeLabel:SetParent(Options);
    fontSizeLabel:SetSize(boxWidth, boxHeight);
    if SETTINGS.DEBUG then fontSizeLabel:SetBackColor(Turbine.UI.Color.DarkGreen) end
    fontSizeLabel:SetPosition(0, yPosition);
    fontSizeLabel:SetFont(headerFont);
    fontSizeLabel:SetText("[In a future update] Select font size");
    fontSizeLabel:SetVisible(false); -- TODO
    yPosition = yPosition + boxHeight;

    Options:SetSize(2 * boxWidth, yPosition);
end
