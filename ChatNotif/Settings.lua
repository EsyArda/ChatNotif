import "Esy.ChatNotif.VindarPatch";

-- Settings

-- Default settings
local DEFAULT_SETTINGS = {
    ["MSG_TIME"] = 0.10;
    ["MSG_TIME_MAX"] = 10;
    ["CHANNELS_ENABLED"] = {
        [6] = true,
        [11] = true,
        [12] = true,
        [13] = true,
        [23] = true,
        [28] = true,
        [29] = true,
        [30] = true,
        [31] = true,
        [32] = true,
        [39] = true,
        [40] = true,
        [41] = true,
        [42] = true
    };
    ["POSITION"] = {
        ["X"] = 735;
        ["Y"] = 320;
    };
    ["POSITION_LOCKED"] = true;
    ["DEBUG"] = false;
    ["ACCOUNT_WIDE_SETTINGS"] = false;
};

-- Actual settings for the character
local SETTINGS = {};

local settingsFileName = "Esy_ChatNotif_Settings";

-- Function to check if settings are valid and migrate them from anterior versions
function CheckSettings(loadedSettings)
    local settings;
    if (type(loadedSettings) == 'table') then
        settings = loadedSettings;

        -- Migrate settings from version 1.1.1 to 1.2.0
        if (settings.MSG_TIME ~= nil and settings.MSG_TIME > 2) then
            if settings.DEBUG then Turbine.Shell.WriteLine("> Settings: Transition of MSG_TIME from " .. settings.MSG_TIME .. " to " .. DEFAULT_SETTINGS.MSG_TIME) end
            settings.MSG_TIME = DEFAULT_SETTINGS.MSG_TIME;
        end
        
        if (settings.MSG_TIME_MAX == nil) then
            settings.MSG_TIME_MAX = DEFAULT_SETTINGS.MSG_TIME_MAX;
        end
    else
        settings = DEFAULT_SETTINGS;
    end

    if settings.DEBUG then Turbine.Shell.WriteLine("> Settings: checked") end

    return settings;
end


-- Load settings from the file
function LoadSettings()
    -- Always load account settings
    SETTINGS = CheckSettings(PatchDataLoad(Turbine.DataScope.Account, settingsFileName));
    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Settings: Loaded account settings") end
    
    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Settings: Loaded character settings") end
    
    
    -- If account wide settings are disabled, load character settings
    if not SETTINGS.ACCOUNT_WIDE_SETTINGS then
        SETTINGS = CheckSettings(PatchDataLoad(Turbine.DataScope.Character, settingsFileName));
    end

    return SETTINGS;
end

-- Save settings for the character in the file
function SaveSettings()

    -- Always save settings for the character and account
    PatchDataSave(Turbine.DataScope.Character, settingsFileName, SETTINGS);
    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Settings: Saved character settings") end
    
    -- Save account settings
    PatchDataSave(Turbine.DataScope.Account, settingsFileName, SETTINGS);
    Turbine.Shell.WriteLine("> Settings: Saved account settings");
end

-- Register the function to save settings when the plugin is unloaded
function RegisterForUnload()
    Turbine.Plugin.Unload = function(sender, args)
        SaveSettings();
    end
end
