# Xutiles

_A window tiling helper for X_

Xutiles /ksutɪlɛs/ is a window tiling helper for X-server based Linux systems like Xubuntu that aims to provide a functionality similar to Windows Fancy Zones, Gnome gTile, or Kubuntu KZones.

The **main use case of Xutiles** is wide display setup, i.e., screens with 12:5 aspect ratio and such. There's usually not much use for windows tiling on classic 16:9 screens. You can, however, use Xutiles on whatever aspect ratio and resolution you wish.

Xutiles is a BASH script that takes one parameter representing the target zone and moves the currently active window to the zone. Xutiles is written with the idea that you bind it to keyboard shortcuts. No mouse support you may know from Fancy Zones or Kzones is implemented.

This is how your screen may be organized with Xutiles:

![Windows organization with Xutiles](./img/screen-tiles-example.webp)

## Installation

1. Clone this repo or simply download `xutiles.sh` to your computer.
1. Make `xutiles.sh` executable: `chmod 744 xutiles.sh`.
1. Open the script in your favorite text editor and make configuration adjustments. See _Configuration_ for more details.
1. Test its functionality. See _Usage_ for more details.

## Screen and panel configuration

Xutiles doesn't automatically detect your screen resolution, system task bar height, and window decoration width. You need to know these and configure them. 

Because Xutiles has to compensate for the window decoration sizes, the tiling precision is not always pixel-perfect. Especially for windows that are not native to the XFWM4 window manager, such as [Resources](https://flathub.org/apps/net.nokyan.Resources) or most web browsers. This is something we have to live with.

### Resolution

The resolution of the screen you're using. 

Set the variables:

- `SCREEN_RESOLUTION_X` to the width of your screen, and 
- `SCREEN_RESOLUTION_Y` to the height of your screen.

Out of the box, Xutiles is set to resolution 3840×1600 px.

If you don't know your screen resolution, open system configuration > display settings, you'll likely find it there. Under Xubuntu:

1. Open Settings manager.
1. Click **Display**.
1. See **Resolution**.

_Note: I have not tested Xutiles on multi-monitor setup._

### Panel height

Xubuntu displays, by default, system panel at the top of the screen. This height in pixels needs to be accounted for when tiling windows. Find out your panel height and set the `PANEL_HEIGHT` variable accordingly.

Under Xubuntu:

1. Right click the panel > Panel > Panel preferences.
1. See the value in Row size (pixels). Use this value for the variable.

#### Panel auto-hide

If you use auto-hide on the panel, set the height to `0`.

#### Panel at the bottom of the screen

If you have the panel placed at the bottom of the screen:

- Set `PANEL_HEIGHT` to `0`.
- Decrease `SCREEN_RESOLUTION_Y` by the panel height.

#### Vertical panel at the left or right side of the screen

Vertical panel is currently not directly supported. You may account for it when you set the zone dimensions. This may, however, prove to be difficult, because the dimensions are set as percentage of the screen resolution, so getting pixel-perfect results would entail setting the percentages very precisely.

## Zones configuration

Zones and their number are configured in the `if` block that tests for the input parameter. It's one if block (i.e., one parameter) per zone. The following code examples split screen into four zones according to this schema:

![Zones defined out of the box by Xutiles](./img/zone-schema.svg)

The first and biggest zone:

```
if [ $1 == 0 ]; then
	LEFT=0
	TOP=0
	WIDTH=0.6
	HEIGHT=1
```

... defines a zone that has top-left corner at the top-left corner of the screen (0,0) and spans 60% of the screen horizontally and 100% of the screen vertically.

This zone is invoked by `./xutiles.sh 0`.

The next zone

```
if [ $1 == 1 ]; then
	LEFT=0.6
	TOP=0
	WIDTH=0.4
	HEIGHT=0.55
```

... has top corner at the top of the screen (0) but the left corner is at the right end of the previous zone, i.e., at 60th percent of the screen. It's width is the remaining of the screen, that is 40 %, and it's height is 55 % of screen vertically.

This zone is invoked by `./xutiles.sh 1`.

Beneath this zone, there are two zones that split the remaining space into two rectangles. On the left is starts a zone on the 60th percent of the screen horizontally, uses 17% of the screen and uses remaining height vertically, i.e., 45 %. The zone next to it is vertically the same and uses the remainder of the screen horizontally, that is 23 % (because 100-60-17=23).

```
if [ $1 == 2 ]; then
	LEFT=0.6
	TOP=0.55
	WIDTH=0.17
	HEIGHT=0.45
	resize_and_place_window
fi

if [ $1 == 3 ]; then
	LEFT=0.77
	TOP=0.55
	WIDTH=0.23
	HEIGHT=0.45
	resize_and_place_window
fi
```

These zones are invoked by `./xutiles.sh 2` and `./xutiles.sh 3` respectively.

You can customize the parameters as you wish. However, for the ease of use, integers are recommended.

## Usage

To test your setup, invoke the script from your terminal as follows:

`./xutiles.sh 1`

This should resize and move your terminal to the zone you have defined in the `if` block for parameter `1`.

To test with other windows, prepend the command with `sleep 3;` to wait 3 seconds until Xutiles invokes:

`sleep 3; xutiles.sh 1`

### Bind to keyboard shortcuts

To actually use Xutiles, it's best to bind it to keyboard shortcuts. The choice of shortcuts largely depends on your taste, as well as what keyboard you use. If you have numeric block, I find it very convenient to use the numbers placed in the same relative position as the zone they invoke. To illustrate, the left large zone would be invoked by `4`, the top-right zone by `9`, the bottom-right zones would then be on `2` and `3` according to their relative position. 

The modifier key choice is also important - I find the `super` key ("Windows" key) useful but it conflicts with certain default Xfce4 shortcuts. The choice is yours.

To bind the script to keyboard shortcuts in Xubuntu:

1. In Settings Manager, select **Keyboard**.
1. Cllick **+ Add**.
1. In **Command**, type the command for the zone you want to set the shortcut for. For example, `/home/you/apps/xutiles.sh 2`.
1. Click **OK**.
1. Press the desired keyboard shortcut.

Repeat these steps for all the zones you defined.