#!/bin/bash

. /bin/systemd-cat-bash xinitrc

set -x

source ~/bin/environment-variables
source ~/bin/environment-setup

# @TODO: move to systemd
dunst &

screen-lock &

echo $PATH
i3
