#!/bin/bash

. /bin/systemd-cat-bash xinitrc

. ~/bin/environment-variables
. ~/bin/environment-setup

# @TODO: move to systemd
dunst &

screen-lock &

exec i3
