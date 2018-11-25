#!/bin/bash

source ~/bin/environment-variables
source ~/bin/environment-setup

xsetroot -bg 0

 ( while :; do keynav; sleep 1; done ) &

SHELL=/bin/zsh sudo -E nice -n -19 sudo -E -u $USER sxhkd &

systemctl --user import-environment DISPLAY

redshift &

export I3SOCK=${I3SOCK:-/tmp/i3-ipc.sock}

wallpaper
conky

exec i3
