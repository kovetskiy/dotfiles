#!/bin/bash

source ~/bin/environment-variables
source ~/bin/environment-setup

if ! tmux list-sessions &>/dev/null; then
    tmux new-session -d -s marvex-reserve-alpha &
    tmux new-session -d -s marvex-reserve-beta &
fi

xsetroot -bg 0

(
    if [[ -f ~/wallpaper.jpg ]]; then
        feh --bg-scale ~/wallpaper.jpg
    fi
) &

dunst &
 ( while :; do keynav; sleep 1; done ) &

SHELL=/bin/sh sxhkd &

systemctl --user import-environment DISPLAY

I3SOCK=/tmp/i3-ipc.sock exec i3
