#!/bin/bash

source ~/bin/environment-variables
source ~/bin/environment-setup

( while :; do keynav; sleep 1; done ) &

export I3SOCK=${I3SOCK:-/tmp/i3-ipc.sock}

#xsetroot -bg black
xsetroot -solid '#282A36'
wallpaper
#conky

systemctl --user import-environment PATH
systemctl --user import-environment GOPATH
#
#dbus-update-activation-environment --systemd DISPLAY
#eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
#export SSH_AUTH_SOCK

exec i3
