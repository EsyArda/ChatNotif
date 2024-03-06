-- Options window

import "Esy.ChatNotif.ColorPicker";
import "Esy.ChatNotif.Language";

function OptionsControl(stringsTranslated)
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
    lockPosition:SetText(stringsTranslated.options_lock_position_label);
    if SETTINGS.DEBUG then lockPosition:SetBackColor(Turbine.UI.Color.DarkOrange) end
    lockPosition:SetChecked(SETTINGS.POSITION_LOCKED);
    lockPosition.CheckedChanged = function(sender, args)
        MyNotifWindow:SetLock(lockPosition:IsChecked());
    end
    yPosition = yPosition + lockPosition:GetHeight() + yOffset;


    -- #### Enable highlight #####
    local enableHighlight = Turbine.UI.Lotro.CheckBox();
    enableHighlight:SetParent(Options);
    enableHighlight:SetSize(boxWidth, boxHeight);
    enableHighlight:SetPosition(0, yPosition);
    enableHighlight:SetFont(headerFont);
    enableHighlight:SetText(stringsTranslated.options_enable_highlight);
    if SETTINGS.DEBUG then enableHighlight:SetBackColor(Turbine.UI.Color.DarkGreen) end
    enableHighlight:SetChecked(SETTINGS.MSG_TIME_HIGHLIGHT>0);
    enableHighlight.CheckedChanged = function(sender, args)
    local defaultSettings = GetDefaultSettings()
       if (enableHighlight:IsChecked()) then
            SETTINGS.MSG_TIME_HIGHLIGHT = defaultSettings.MSG_TIME_HIGHLIGHT;
       else
            SETTINGS.MSG_TIME_HIGHLIGHT = 0;
       end
    end
    yPosition = yPosition + enableHighlight:GetHeight() + yOffset;

    
    -- ##### Notif timer #####
    -- Timer label
    local timerLabel = Turbine.UI.Label();
    timerLabel:SetParent(Options);
    timerLabel:SetSize(boxWidth, boxHeight);
    if SETTINGS.DEBUG then timerLabel:SetBackColor(Turbine.UI.Color.DarkGoldenrod) end
    timerLabel:SetPosition(0, yPosition);
    timerLabel:SetFont(headerFont);
    timerLabel:SetText(stringsTranslated.options_timer_label_1 .. SETTINGS.MSG_TIME .. stringsTranslated.options_timer_label_2);
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
        timerLabel:SetText(stringsTranslated.options_timer_label_1 .. SETTINGS.MSG_TIME .. stringsTranslated.options_timer_label_2);
    end
    yPosition = yPosition + scrollBarHeight + yOffset;

    
    -- ##### Channel choice #####
    local channelsLabel = Turbine.UI.Label();
    channelsLabel:SetParent(Options);
    channelsLabel:SetSize(boxWidth, boxHeight);
    if SETTINGS.DEBUG then channelsLabel:SetBackColor(Turbine.UI.Color.DarkRed) end
    channelsLabel:SetFont(headerFont);
    channelsLabel:SetPosition(0, yPosition);
    channelsLabel:SetText(stringsTranslated.options_channels_label);

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
            local color = SETTINGS.DEFAULT_COLOR;
            if SETTINGS.CHANNELS_COLORS ~= nil and SETTINGS.CHANNELS_COLORS[Turbine.ChatType[name]] ~= nil then
                color = SETTINGS.CHANNELS_COLORS[Turbine.ChatType[name]];
                color = Turbine.UI.Color(color.R, color.G, color.B);
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
    customizeColorsButton:SetText(stringsTranslated.options_customize_colors_button);

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
    resetColorsButton:SetText(stringsTranslated.options_reset_colors_button);

    local count = 0;
    resetColorsButton.Click = function(sender, args)
        count = (count + 1) % 2;
        
        if count == 1 then
            resetColorsButton:SetText(stringsTranslated.options_reset_colors_button_confirm);
        else
            local default_settings = GetDefaultSettings();
            SETTINGS.CHANNELS_COLORS = default_settings.CHANNELS_COLORS; -- Reset real color settings
            
            -- Update the option label colors
            local color;
            for name, channelCheckbox in pairs(channelsCheckbox) do
                if default_settings.CHANNELS_COLORS ~= nil and default_settings.CHANNELS_COLORS[Turbine.ChatType[name]] ~= nil then
                    color = default_settings.CHANNELS_COLORS[Turbine.ChatType[name]];
                    color = Turbine.UI.Color(color.R, color.G, color.B)
                else
                    color = SETTINGS.DEFAULT_COLOR;
                end
                channelCheckbox:SetForeColor(color);
            end
            resetColorsButton:SetText(stringsTranslated.options_reset_colors_button);
        end
    end

    if SETTINGS.DEBUG then resetColorsButton:SetBackColor(Turbine.UI.Color(0.22,0.17,0.47)) end
    yPosition = yPosition + resetColorsButton:GetHeight() + yOffset;



    -- ##### Account wide settings #####
    local accountWideCheckBox = Turbine.UI.Lotro.CheckBox();
    accountWideCheckBox:SetParent(Options);
    accountWideCheckBox:SetSize(boxWidth, 2*boxHeight);
    accountWideCheckBox:SetPosition(0, yPosition);
    accountWideCheckBox:SetFont(headerFont);
    accountWideCheckBox:SetText(stringsTranslated.options_account_wide_checkBox);
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
    commandsLabel:SetText(stringsTranslated.options_commands_label);
    yPosition = yPosition + commandsLabel:GetHeight() + yOffset;


    -- ##### Font size #####
    local fontSizeLabel = Turbine.UI.Label();
    fontSizeLabel:SetParent(Options);
    fontSizeLabel:SetSize(boxWidth, boxHeight);
    if SETTINGS.DEBUG then fontSizeLabel:SetBackColor(Turbine.UI.Color.DarkGreen) end
    fontSizeLabel:SetPosition(0, yPosition);
    fontSizeLabel:SetFont(headerFont);
    fontSizeLabel:SetText(stringsTranslated.options_font_size_label);
    fontSizeLabel:SetVisible(false); -- TODO
    yPosition = yPosition + boxHeight;

    Options:SetSize(2 * boxWidth, yPosition);
end
