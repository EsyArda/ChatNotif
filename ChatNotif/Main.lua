import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";

import "Esy.ChatNotif.RunCommand";
import "Esy.ChatNotif.NotifWindow";
import "Esy.ChatNotif.Settings";
import "Esy.ChatNotif.Options";


function Main()
    LoadSettings();
    RegisterForUnload();
    Commands = RunCommand();
    Turbine.Shell.AddCommand("cn", Commands);
    MyNotifWindow = NotifWindow();
    OptionsControl();
end

Main();