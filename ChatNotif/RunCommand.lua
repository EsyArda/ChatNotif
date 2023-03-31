-- RunCommand
import "Esy.ChatNotif.Set";

-- Welcome message
Turbine.Shell.WriteLine("Welcome to Chat Notif! Run '/cn help' to list commands.");

-- Command line class
RunCommand = class(Turbine.ShellCommand);

function RunCommand:Constructor()
    Turbine.ShellCommand.Constructor(self);
end

function RunCommand:Execute(pluginCommand, argumentString)

    -- Return help if no argument is given
    if ((argumentString == nil) or (string.len(argumentString) == 0)) then
        self:GetHelp();
        return;
    end

    -- Parse the arguments into a list.
    local args = {};
    local i = 1;
    for arg in argumentString:gmatch("%w+") do
        args[i] = arg;
        i = i + 1;
    end

    -- Extract the command and argument.
    local command = string.lower(args[1]);

    -- Display the command in the chat if debug is enabled
    if (SETTINGS.DEBUG) then
        local argument = "";
        for _, arg in pairs(args) do
            argument = argument .. " " .. arg
        end
        Turbine.Shell.WriteLine("> /" .. pluginCommand .. argument);
    end

    -- Commands available
    if (command == "help") then
        self:GetHelp();
    elseif (command == "debug") then
        self:ToggleDebug(string.lower(args[2]));
    elseif (command == "add") then
        self:AddChannel(string.lower(args[2]));
    elseif (command == "rm") then
        self:RemoveChannel(string.lower(args[2]));
    elseif (command == "list") then
        self:ListChannels();
    end
end

-- Print the help
function RunCommand:GetHelp()
    Turbine.Shell.WriteLine("/cn help --> Display this help\
/cn add {channel_number} --> Watch the channel {channel_number}\
/cn rm {channel_number} --> Remove the channel {channel_number}\
/cn list --> List channels\
/cn debug {on|off} --> Enable or disable debug");
end

-- Toggle debug on or off
function RunCommand:ToggleDebug(newState)
    if (newState == "on") then
        SETTINGS.DEBUG = true;
    elseif (newState == "off") then
        SETTINGS.DEBUG = false;
    end
    Turbine.Shell.WriteLine("Debug is now " .. newState .. ". Please reload the UI.");
end

-- Add a channel from the list
function RunCommand:AddChannel(channelNumber)
    local nb = tonumber(channelNumber)
    if nb ~= nil then
        AddToSet(SETTINGS.CHANNELS_ENABLED, nb)
        if SETTINGS.DEBUG then Turbine.Shell.WriteLine("Added " .. nb .. " [" .. GetChatTypeName(nb) .."]") end
    end
end

-- Remove a channel from the list
function RunCommand:RemoveChannel(channelNumber)
    local nb = tonumber(channelNumber)
    if nb ~= nil then
        RemoveFromSet(SETTINGS.CHANNELS_ENABLED, nb);
        if SETTINGS.DEBUG then Turbine.Shell.WriteLine("Removed " .. nb .. " [" .. GetChatTypeName(nb) .."]") end
    end
end

-- List enabled channels
function RunCommand:ListChannels()
    local channels = "Channels enabled :";
    for index, channel in pairs(SETTINGS.CHANNELS_ENABLED) do
        if channel then channels = channels .. " " .. index .. "[" .. GetChatTypeName(index) .. "]," end
    end
    Turbine.Shell.WriteLine("> " .. channels)
end

-- Get the chat type name from the id
function GetChatTypeName(chatTypeId)
    local chatTypeName = "Unknown";
    chatTypeId = (chatTypeId)
    for key, value in pairs(Turbine.ChatType) do
        if (type(value) == "number" and value == chatTypeId) then
            chatTypeName = key;
            break;
        end
    end
    return chatTypeName;
end