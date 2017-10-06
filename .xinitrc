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
 ( while :; do keynav; done ) &
sxhkd &

exec i3
