#!/bin/bash

source ~/bin/environment-variables
source ~/bin/environment-setup

# @TODO: move to systemd
dunst &

if ! tmux list-sessions &>/dev/null; then
    tmux new-session -d -s marvex-reserve-alpha &
    tmux new-session -d -s marvex-reserve-beta &
fi

sxhkd &
xcompmgr &

i3
