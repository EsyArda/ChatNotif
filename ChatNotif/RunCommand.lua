import "Esy.ChatNotif.Set";

-- Message d'acceuil
Turbine.Shell.WriteLine("Welcome to Chat Notif! Run '/cn help' to list commands.");

-- Une CLI qui fonctionne
RunCommand = class(Turbine.ShellCommand);

function RunCommand:Execute(pluginCommand, argumentString)

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
    -- local arg = argumentList[2];

    -- Debug Mode
    if (SETTINGS.DEBUG) then
        local a = "";
        for _, arg in pairs(args) do
            a = a .. " " .. arg
        end
        Turbine.Shell.WriteLine("> /" .. pluginCommand .. a);
    end

    -- Display help
    if (command == "help") then
        self:GetHelp();
        return;
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

function RunCommand:GetHelp()
    Turbine.Shell.WriteLine("/cn help --> Display this help\
/cn add {channel_number} --> Watch the channel {channel_number}\
/cn rm {channel_number} --> Remove the channel {channel_number}\
/cn list --> List channels\
/cn debug {on|off} --> Enable or disable debug");
end

function RunCommand:ToggleDebug(newState)
    if (newState == "on") then
        SETTINGS.DEBUG = true;
    elseif (newState == "off") then
        SETTINGS.DEBUG = false;
    end
    Turbine.Shell.WriteLine("Debug is now " .. newState);
end

function RunCommand:AddChannel(channelNumber)
    local nb = tonumber(channelNumber)
    if nb ~= nil then
        AddToSet(SETTINGS.CHANNELS_ENABLED, nb)
        if SETTINGS.DEBUG then Turbine.Shell.WriteLine("Added " .. nb) end
    end
end

function RunCommand:RemoveChannel(channelNumber)
    local nb = tonumber(channelNumber)
    if nb ~= nil then
        RemoveFromSet(SETTINGS.CHANNELS_ENABLED, nb);
        if SETTINGS.DEBUG then Turbine.Shell.WriteLine("Removed " .. nb) end
    end
end

function RunCommand:ListChannels()
    local channels = "";
    for index, channel in pairs(SETTINGS.CHANNELS_ENABLED) do
        if channel then channels = channels .. " " .. index end
    end
    Turbine.Shell.WriteLine("> " .. channels)
end
