# Chat Notif

A simple LOTRO plugin to display chat messages larger on your screen.

## Installation guide

1. Download the latest release from [Github](https://github.com/EsyArda/ChatNotif/releases/latest) of [lotroInterface](https://www.lotrointerface.com/downloads/info1208).
2. Unzip the content of the zip file to your `The Lord of the Rings Online\Plugins\` folder (for example `C:\Users\USER\Documents\The Lord of the Rings Online\Plugins\`).
3. Launch the game, open the plugin manager and load `ChatNotif`.

## Features

Displays simple notification for chat messages.

![Screenshot from LOTRO with the message "Hello world!" in the centre.](./ChatNotif/res/notif.jpg)

In the Options panel, you can unlock the window to move it around and select which channels to display.
You can customize the color for each channel.

![Screenshot of the option panel. There are checkboxes and color pickers for each chat channel.](./ChatNotif/res/options1.jpg)


You can change the speed in the Options window.
The duration is based on the length of the text.
Settings can be saved for your character or for the entire account.

Some additional features are available from the command line.
Type `/cn help` to see all available commands.


![Screenshot of the option panel. Buttons allow to customize or reset colors, there is a slider to change text speed and a checkbox to save settings account wide.](./ChatNotif/res/options2.jpg)

## Planned features

- Options
  - [x] ~~Select channels~~
  - [x] ~~Lock / unlock option~~
    - [x] ~~Change the opacity of the window~~
    - [x] ~~Enable mouse drag to move the window~~
  - [x] ~~Set notification duration~~
  - [x] ~~Sort channels in the channel list~~
  - [x] ~~Save settings by character or account~~
  - [x] ~~Customize and reset font colour~~
  - [ ] Set font size
  - [ ] Option to hide messages sent by the player
- Notification window
  - [x] ~~Message duration based on the length of the text.~~
  - [x] ~~Don't display notifications if UI is hidden~~
  - [x] ~~Font color based on chat types~~
  - [ ] Messages fade in and out
- Commands
  - [x] ~~Better debug messages~~
- [x] ~~New logo~~
- [ ] Translate the plugin into French and German
