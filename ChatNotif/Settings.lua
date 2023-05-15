import "Esy.ChatNotif.VindarPatch";

-- Settings

-- Default settings
DEFAULT_SETTINGS = {
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
};

-- Actual settings for the character
SETTINGS = {};

SettingsFileName = "Esy_ChatNotif_Settings";
SettingsDataScope = Turbine.DataScope.Character;

-- Load settings from the file
function LoadSettings()
    -- local loadedSettings = Turbine.PluginData.Load(SettingsDataScope, SettingsFileName);
    local loadedSettings = PatchDataLoad(SettingsDataScope, SettingsFileName);

    if (type(loadedSettings) == 'table') then
        SETTINGS = loadedSettings;

        -- Migrate settings from version 1.1.1 to 1.2.0
        if (SETTINGS.MSG_TIME ~= nil and SETTINGS.MSG_TIME > 2) then
            if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Settings: Transition of MSG_TIME from " .. SETTINGS.MSG_TIME .. " to " .. DEFAULT_SETTINGS.MSG_TIME) end
            SETTINGS.MSG_TIME = DEFAULT_SETTINGS.MSG_TIME;
        end
        
        if (SETTINGS.MSG_TIME_MAX == nil) then
            SETTINGS.MSG_TIME_MAX = DEFAULT_SETTINGS.MSG_TIME_MAX;
        end
    else
        SETTINGS = DEFAULT_SETTINGS;
    end
    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Settings Loaded") end
end

-- Save settings for the character in the file
function SaveSettings()
    -- Turbine.PluginData.Save(SettingsDataScope, SettingsFileName, SETTINGS);
    PatchDataSave(SettingsDataScope, SettingsFileName, SETTINGS);
    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Settings Saved") end
end

-- Register the function to save settings when the plugin is unloaded
function RegisterForUnload()
    Turbine.Plugin.Unload = function(sender, args)
        SaveSettings();
    end
end
