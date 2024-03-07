import "Esy.ChatNotif.VindarPatch";

-- Settings

-- Default settings
local default_settings = {
    ["VERSION"] = "1.7.0";
    ["MSG_TIME"] = 0.18; -- seconds per character
    ["MSG_TIME_MAX"] = 10; -- seconds
    ["MSG_TIME_MIN"] = 0.8; -- seconds
    ["MSG_TIME_HIGHLIGHT"] = 0.4; -- seconds
    ["CHANNELS_ENABLED"] = {
        [6] = true, -- Tell
        [11] = true, -- Fellowship
        [12] = true, -- Kinship
        [13] = true, -- Officer
        [23] = true, -- Raid
        [28] = true, -- UserChat1
        [29] = true, -- UserChat2
        [30] = true, -- UserChat3
        [31] = true, -- UserChat4
        [32] = true, -- Tribe
        [39] = true, -- UserChat5
        [40] = true, -- UserChat6
        [41] = true, -- UserChat7
        [42] = true -- UserChat8
    };
    ["POSITION"] = {
        ["X"] = 735;
        ["Y"] = 320;
    };
    ["POSITION_LOCKED"] = true;
    ["DEBUG"] = false;
    ["ACCOUNT_WIDE_SETTINGS"] = false;
    ["CHANNELS_COLORS"] = {
        [1] = -- Error
		{
			["A"] = 1,
			["R"] = 0.83,
			["G"] = 0.27,
			["B"] = 0.27
		},
        [4] = -- Standard
		{
			["A"] = 1,
			["R"] = 0.75,
			["G"] = 0.71,
			["B"] = 0.4
		},
        [6] = -- Tell
		{
			["A"] = 1,
			["R"] = 0.9,
			["G"] = 0.77,
			["B"] = 0.3
		},
        [7] = -- Emote
		{
			["A"] = 1,
			["R"] = 0.48,
			["G"] = 0.48,
			["B"] = 0.48
		},
        [11] = -- Fellowship
		{
			["A"] = 1,
			["R"] = 0.26,
			["G"] = 0.66,
			["B"] = 0.17
		},
        [12] = -- Kinship
		{
			["A"] = 1,
			["R"] = 0.32,
			["G"] = 0.67,
			["B"] = 1
		},
        [13] = -- Officer
		{
			["A"] = 1,
			["R"] = 0.32,
			["G"] = 0.67,
			["B"] = 1
		},
        [14] = -- Advancement
		{
			["A"] = 1,
			["R"] = 0.02,
			["G"] = 0.69,
			["B"] = 0.82
		},
        [20] = -- Death
		{
			["A"] = 1,
			["R"] = 1,
			["G"] = 0,
			["B"] = 0
		},
        [32] = -- Tribe
		{
			["A"] = 1,
			["R"] = 0.32,
			["G"] = 0.67,
			["B"] = 1
		},
        [34] = -- PlayerCombat 
		{
			["A"] = 1,
			["R"] = 0.97,
			["G"] = 0.82,
			["B"] = 0
		},
        [35] = -- EnemyCombat
		{
			["A"] = 1,
			["R"] = 1,
			["G"] = 0,
			["B"] = 0
		},
        [36] = -- SelfLoot
		{
			["A"] = 1,
			["R"] = 0.92,
			["G"] = 0.62,
			["B"] = 0.62
		},
        [37] = -- FellowLoot
		{
			["A"] = 1,
			["R"] = 0,
			["G"] = 0.71,
			["B"] = 0.27
		}
    };
    ["DEFAULT_COLOR"] = Turbine.UI.Color(1, 0.82, 0.82, 0.82)
};

-- Actual settings for the character
local SETTINGS = {};

local settingsFileName = "Esy_ChatNotif_Settings";

-- Function to check if settings are valid and migrate them from anterior versions
function CheckSettings(loadedSettings)
    local settings;
    local major, minor, patch; -- version number
    
    if (type(loadedSettings) == 'table') then
        settings = loadedSettings;
        
        if (settings.VERSION ~= nil and settings.VERSION ~= "") then
            major, minor, patch = string.match(settings.VERSION, "(%d+)%.(%d+)%.(%d+)");
        else
            major = "1";
            minor = "6";
            patch = "0";
        end
        if settings.DEBUG then Turbine.Shell.WriteLine("[Settings] Version "..major.."."..minor.."."..patch) end


        -- Migrate settings from version 1.1.1 to 1.2.0
        if (settings.MSG_TIME ~= nil and settings.MSG_TIME > 2) then
            if settings.DEBUG then Turbine.Shell.WriteLine("[Settings] Transition of MSG_TIME from " .. settings.MSG_TIME .. " to " .. default_settings.MSG_TIME) end
            settings.MSG_TIME = default_settings.MSG_TIME;
        end
        if (settings.MSG_TIME_MAX == nil) then
            settings.MSG_TIME_MAX = default_settings.MSG_TIME_MAX;
        end

        -- Migrate settings from version 1.5.0 to 1.6.0
        -- Creating a new table for channels colors
        if (settings.CHANNELS_COLORS == nil) then
            settings.CHANNELS_COLORS = {};
        end
        -- Create new default color table
        if (settings.DEFAULT_COLOR == nil) then
            settings.DEFAULT_COLOR = default_settings.DEFAULT_COLOR;
        end

        -- Migrate setttings from 1.6.0 to 1.7.0
        if (tonumber(major)<2 and tonumber(minor)<7) then
            settings.MSG_TIME_MIN = default_settings.MSG_TIME_MIN;
            settings.MSG_TIME_HIGHLIGHT = default_settings.MSG_TIME_HIGHLIGHT;
            if settings.DEBUG then Turbine.Shell.WriteLine("[Settings] Migrated settings from 1.6.0 to 1.7.0") end
        end
        
        -- End of migrations
        settings.VERSION = default_settings.VERSION

        settings.DEFAULT_COLOR = Turbine.UI.Color(settings.DEFAULT_COLOR.A, settings.DEFAULT_COLOR.R, settings.DEFAULT_COLOR.G, settings.DEFAULT_COLOR.B);
    else
        settings = default_settings;
    end

    if settings.DEBUG then Turbine.Shell.WriteLine("[Settings] checked") end

    return settings;
end


-- Load settings from the file
function LoadSettings()
    -- Always load account settings
    SETTINGS = CheckSettings(PatchDataLoad(Turbine.DataScope.Account, settingsFileName));
    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("[Settings] Loaded account settings") end
    
    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("[Settings] Loaded character settings") end
    
    
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
    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("[Settings] Saved character settings") end
    
    -- Save account settings
    PatchDataSave(Turbine.DataScope.Account, settingsFileName, SETTINGS);
    if SETTINGS.DEBUG then Turbine.Shell.WriteLine("[Settings] Saved account settings") end
end

-- Register the function to save settings when the plugin is unloaded
function RegisterForUnload()
    Turbine.Plugin.Unload = function(sender, args)
        SaveSettings();
    end
end

function GetDefaultSettings()
    return default_settings
end
