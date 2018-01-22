#!/bin/bash

source ~/bin/environment-variables
source ~/bin/environment-setup

marvex-spawn-reserve &

xsetroot -bg 0

(
    if [[ -f ~/wallpaper.jpg ]]; then
        feh --bg-scale ~/wallpaper.jpg
    fi
) &

dunst &
 ( while :; do keynav; sleep 1; done ) &

SHELL=/bin/zsh sudo -E nice -n -19 sudo -E -u $USER sxhkd &

systemctl --user import-environment DISPLAY

redshift &

I3SOCK=/tmp/i3-ipc.sock exec i3
