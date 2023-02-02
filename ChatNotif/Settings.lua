-- Settings

-- Default settings
DEFAULT_SETTINGS = {
    ["MSG_TIME"] = 5;
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
    local loadedSettings = Turbine.PluginData.Load(SettingsDataScope, SettingsFileName);

    if (type(loadedSettings) == 'table') then
        SETTINGS = loadedSettings;
    else
        SETTINGS = DEFAULT_SETTINGS;
    end
    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Settings Loaded") end
end

-- Save settings for the character in the file
function SaveSettings()
    Turbine.PluginData.Save(SettingsDataScope, SettingsFileName, SETTINGS);
    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("> Settings Saved") end
end

-- Register the function to save settings when the plugin is unloaded
function RegisterForUnload()
    Turbine.Plugin.Unload = function(sender, args)
        SaveSettings();
    end
end
