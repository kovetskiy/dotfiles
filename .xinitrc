#!/bin/bash

source ~/bin/environment-variables
~/bin/environment-setup &

 ( while :; do keynav; sleep 1; done ) &


redshift &

export I3SOCK=${I3SOCK:-/tmp/i3-ipc.sock}

wallpaper
#conky

systemctl --user import-environment PATH
systemctl --user import-environment GOPATH

urxvtd &
exec i3
