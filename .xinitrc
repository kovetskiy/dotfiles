#!/bin/sh

export PATH="$HOME/bin/:$HOME/go/bin/:$PATH"
export SHELL=/bin/zsh
export TERMINAL=urxvt
export EDITOR="/usr/bin/vim"
export LANG="en_US.UTF-8"

export BACKGROUND=$(cat $HOME/background)

xrandr --output VGA1 --mode 1920x1080 --pos 0x0 --output HDMI1 --mode 1920x1080 --pos 1920x0 &

reconfig-kbd &
sudo charge &
sudo shift-shift &
keynav &
background $BACKGROUND &
feh --bg-scale ~/wallpaper.jpg &

xrdb -load ~/.Xresources
xrdb -merge ~/.Xresources.theme

i3
