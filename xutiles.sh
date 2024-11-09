#! /bin/bash

# Prerequisites:
# install wmctrl (from repositories, 1.07-7ubuntu3)

# PANEL_HEIGHT - find out in your Xfce panel height in the panel settings; in other distros, use your top panel height. If no panel there, use 0. To account for bottom panel, lower the vertical screen resolution accordingly.
# WINDOW_DECORATION_HEIGHT - top-bar window decoration; find out empirically. 25px is for Graybird-dark on Xubuntu.
# WINDOW_DECORATION_WIDTH - vertical borders of windows; find out empirically. 1px is for Graybird-dark on Xubuntu.

# Special windows workarounds
# - Firefox: On tab bar, right click > Customize and select "Title Bar" at the bottom of the screen. This forces FF to use native window decorations and avoid screwing up positioning. Another option may be to add FF to the specific windows workaround. See $WINNAME for that. You're on your own, tho.
# - Vivaldi: Similar to Firefox, in Settings > Appearance, select "Use Native Window" and restart Vivaldi.
# - Brave: A workaround is in place for the option "Use system title bar and borders" not selected. If you want to use the option, comment out the if branch for 'Brave-browser'

# wmctrl explanation:
# -r selects a window. It can by title, but for this case, :ACTIVE: pseudoclass is useful.
# -b add|remove|toggle attributes of the selected window. We need to remove maximization on both axis to enable window resize
# -e resizes window: geometry,position_left,position_top,window_width,window_height -- geometry is 0 for top-left starting point of window content; 1 is also top-left but works somewhat consistently across various windows and decorations.


SCREEN_RESOLUTION_X=3840
SCREEN_RESOLUTION_Y=1600
PANEL_HEIGHT=24
WINDOW_DECORATION_HEIGHT=23
WINDOW_DECORATION_WIDTH=1

REAL_RES_X=$SCREEN_RESOLUTION_X
REAL_RES_Y=$((SCREEN_RESOLUTION_Y - PANEL_HEIGHT - WINDOW_DECORATION_HEIGHT))

resize_and_place_window () {
	if [[ $TOP == 0 ]]; then
		WINDECOR_CORRECTION=0
	else
		WINDECOR_CORRECTION=$WINDOW_DECORATION_HEIGHT   
	fi

	ACTIVE_WINDOW_ID=$(xprop -root _NET_ACTIVE_WINDOW | cut -d' ' -f5 | sed s/,//)
	WINNAME=$(xwininfo -id $ACTIVE_WINDOW_ID |grep 'xwininfo: Window id:' | sed -r 's/xwininfo: Window id:.*"(.*)".*/\1/')
	WIN_CLASS_NAME=$(xprop -id $ACTIVE_WINDOW_ID | grep WM_CLASS | sed -r 's/.*?"(.*?)".*/\1/')

	local TMP=$((SCREEN_RESOLUTION_Y - PANEL_HEIGHT - WINDOW_DECORATION_HEIGHT))
	local FLOATTMP=$(echo "scale=2; $TMP * $TOP + $PANEL_HEIGHT + $WINDECOR_CORRECTION" | bc)
	local REAL_TOP=${FLOATTMP%.*}
	local FLOATTMP=$(echo "scale=2; $REAL_RES_X * $LEFT" | bc)
	local REAL_LEFT=${FLOATTMP%.*}

	local FLOATTMP=$(echo "scale=2; $REAL_RES_X * $WIDTH - $WINDOW_DECORATION_WIDTH * 2" | bc)
	local REAL_WIDTH=${FLOATTMP%.*}
	local REAL_HEIGHT=$(echo "scale=2; $REAL_RES_Y * $HEIGHT - $WINDECOR_CORRECTION" | bc)
	local REAL_HEIGHT=${REAL_HEIGHT%.*}

	if    [[ $WINNAME == "Resources" ]] \
	   || [[ $WINNAME == "Mission Center" ]]; then
		local REAL_TOP=$((REAL_TOP-55))
		local REAL_LEFT=$((REAL_LEFT-59))

		local REAL_HEIGHT=$((REAL_HEIGHT+145))
		local REAL_WIDTH=$((REAL_WIDTH+120))
	elif [[ $WIN_CLASS_NAME == "Brave-browser" ]]; then
		local REAL_LEFT=$((REAL_LEFT-2))
		local REAL_HEIGHT=$((REAL_HEIGHT+28))
		local REAL_WIDTH=$((REAL_WIDTH+4))
	fi

	wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz
	wmctrl -r :ACTIVE: -e 1,$REAL_LEFT,$REAL_TOP,$REAL_WIDTH,$REAL_HEIGHT
}

if [ $1 == 0 ]; then
	LEFT=0
	TOP=0
	WIDTH=0.6
	HEIGHT=1

	resize_and_place_window
fi

if [ $1 == 1 ]; then
	LEFT=0.6
	TOP=0
	WIDTH=0.4
	HEIGHT=0.55

	resize_and_place_window
fi

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