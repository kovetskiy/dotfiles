#!/bin/bash

source ~/bin/environment-variables
~/bin/environment-setup &

 ( while :; do keynav; sleep 1; done ) &

SHELL=/bin/zsh sudo -E -u $USER sxhkd &

redshift &

export I3SOCK=${I3SOCK:-/tmp/i3-ipc.sock}

wallpaper
#conky

exec i3
