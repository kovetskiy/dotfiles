#!/bin/bash

. /bin/systemd-cat-bash xinitrc

set -x

source ~/bin/environment-variables
source ~/bin/environment-setup

# @TODO: move to systemd
dunst &

if ! tmux list-sessions &>/dev/null; then
    slock &
fi

i3
