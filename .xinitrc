#!/bin/sh

export PATH="$(ruby -e 'print Gem.user_dir')/bin:$HOME/bin/:$HOME/private/bin/:$HOME/go/bin/:$PATH"
export SHELL=/usr/bin/zsh
export TERMINAL=urxvt
export EDITOR=/usr/bin/vim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PROFILE="$(cat $HOME/profile)"
export BACKGROUND="$(cat $HOME/background)"

env-setup &

dunst &

( sleep 0.1; xtrlock -b ) &
i3
