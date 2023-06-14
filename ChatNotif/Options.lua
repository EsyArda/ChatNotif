-- Options window

import "Esy.ChatNotif.ColorPicker";
import "Esy.ChatNotif.Strings";

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
    lockPosition:SetText(STRINGS.options_lock_position_label);
    if SETTINGS.DEBUG then lockPosition:SetBackColor(Turbine.UI.Color.DarkOrange) end
    lockPosition:SetChecked(SETTINGS.POSITION_LOCKED);
    lockPosition.CheckedChanged = function(sender, args)
        MyNotifWindow:SetLock(lockPosition:IsChecked());
    end
    yPosition = yPosition + lockPosition:GetHeight() + yOffset;


    
    -- ##### Channel choice #####
    local channelsLabel = Turbine.UI.Label();
    channelsLabel:SetParent(Options);
    channelsLabel:SetSize(boxWidth, boxHeight);
    if SETTINGS.DEBUG then channelsLabel:SetBackColor(Turbine.UI.Color.DarkRed) end
    channelsLabel:SetFont(headerFont);
    channelsLabel:SetPosition(0, yPosition);
    channelsLabel:SetText(STRINGS.options_channels_label);

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
    for _, name in pairs(sortedKeys) do
        if(type(Turbine.ChatType[name]) == "number") then
            -- Channel checkbox
            channelsCheckbox[name] = Turbine.UI.Lotro.CheckBox();
            channelsCheckbox[name]:SetParent(Options);
            channelsCheckbox[name]:SetSize(boxWidth - leftMargin, boxHeight);
            channelsCheckbox[name]:SetPosition(leftMargin, yPosition);
            channelsCheckbox[name]:SetFont(corpsFont);
            local color;
            if SETTINGS.CHANNELS_COLORS ~= nil and SETTINGS.CHANNELS_COLORS[Turbine.ChatType[name]] ~= nil then
                color = SETTINGS.CHANNELS_COLORS[Turbine.ChatType[name]];
                color = Turbine.UI.Color(color.R, color.G, color.B);
            else
                color = Turbine.UI.Color.Azure;
            end
            channelsCheckbox[name]:SetForeColor(color);
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

            -- Update Y position
            yPosition = yPosition + boxHeight + yOffset;
        end
    end
    yPosition = yPosition+ yOffset;



    -- ##### Customize colors #####
    local customizeColorsButton = Turbine.UI.Lotro.Button();
    customizeColorsButton:SetParent(Options);
    customizeColorsButton:SetSize(boxWidth, 4*boxHeight);
    customizeColorsButton:SetPosition(0, yPosition);
    customizeColorsButton:SetFont(headerFont);
    customizeColorsButton:SetText(STRINGS.options_customize_colors_button);

    customizeColorsButton.Click = function(sender, args)
        -- For each channelCheckbox, add a color picker
        for name, channelCheckbox in pairs(channelsCheckbox) do
            channelCheckbox.colorPicker = ColorPicker();
            channelCheckbox.colorPicker:SetParent(channelCheckbox);
            channelCheckbox.colorPicker:SetPosition(boxWidth - colorPickerWidth, 0);
            -- colorPicker.doActive=function()
            --     Turbine.Shell.WriteLine("Color picker active");
            -- end
            channelCheckbox.colorPicker.ColorChanged=function(sender,args)
                channelCheckbox:SetForeColor(args.Color);
                SETTINGS.CHANNELS_COLORS[Turbine.ChatType[name]] = args.Color;
            end
        end
    end

    if SETTINGS.DEBUG then customizeColorsButton:SetBackColor(Turbine.UI.Color(0.22,0.17,0.47)) end
    yPosition = yPosition + customizeColorsButton:GetHeight() + yOffset;
    

    -- ##### Reset colors #####
    local resetColorsButton = Turbine.UI.Lotro.Button();
    resetColorsButton:SetParent(Options);
    resetColorsButton:SetSize(boxWidth, 4*boxHeight);
    resetColorsButton:SetPosition(0, yPosition);
    resetColorsButton:SetFont(headerFont);
    resetColorsButton:SetText(STRINGS.options_reset_colors_button);

    local count = 0;
    resetColorsButton.Click = function(sender, args)
        count = (count + 1) % 2;
        
        if count == 1 then
            resetColorsButton:SetText(STRINGS.options_reset_colors_button_confirm);
        else
            SETTINGS.CHANNELS_COLORS = {};
            for name, channelCheckbox in pairs(channelsCheckbox) do
                channelCheckbox:SetForeColor(SETTINGS.DEFAULT_COLOR);
            end
            resetColorsButton:SetText(STRINGS.options_reset_colors_button);
        end
    end

    if SETTINGS.DEBUG then resetColorsButton:SetBackColor(Turbine.UI.Color(0.22,0.17,0.47)) end
    yPosition = yPosition + resetColorsButton:GetHeight() + yOffset;


    -- ##### Notif timer #####
    -- Timer label
    local timerLabel = Turbine.UI.Label();
    timerLabel:SetParent(Options);
    timerLabel:SetSize(boxWidth, boxHeight);
    if SETTINGS.DEBUG then timerLabel:SetBackColor(Turbine.UI.Color.DarkGoldenrod) end
    timerLabel:SetPosition(0, yPosition);
    timerLabel:SetFont(headerFont);
    timerLabel:SetText(STRINGS.options_timer_label_1 .. SETTINGS.MSG_TIME .. STRINGS.options_timer_label_2);
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
        timerLabel:SetText(STRINGS.options_timer_label_1 .. SETTINGS.MSG_TIME .. STRINGS.options_timer_label_2);
    end
    yPosition = yPosition + scrollBarHeight + yOffset;





    -- ##### Account wide settings #####
    local accountWideCheckBox = Turbine.UI.Lotro.CheckBox();
    accountWideCheckBox:SetParent(Options);
    accountWideCheckBox:SetSize(boxWidth, 2*boxHeight);
    accountWideCheckBox:SetPosition(0, yPosition);
    accountWideCheckBox:SetFont(headerFont);
    accountWideCheckBox:SetText(STRINGS.options_account_wide_checkBox);
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
    commandsLabel:SetText(STRINGS.options_commands_label);
    yPosition = yPosition + commandsLabel:GetHeight() + yOffset;


    -- ##### Font size #####
    local fontSizeLabel = Turbine.UI.Label();
    fontSizeLabel:SetParent(Options);
    fontSizeLabel:SetSize(boxWidth, boxHeight);
    if SETTINGS.DEBUG then fontSizeLabel:SetBackColor(Turbine.UI.Color.DarkGreen) end
    fontSizeLabel:SetPosition(0, yPosition);
    fontSizeLabel:SetFont(headerFont);
    fontSizeLabel:SetText(STRINGS.options_font_size_label);
    fontSizeLabel:SetVisible(false); -- TODO
    yPosition = yPosition + boxHeight;

    Options:SetSize(2 * boxWidth, yPosition);
end
