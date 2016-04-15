#!/bin/sh

export DMENU_PATH="$HOME/bin/shortcuts"
export PATH="$(ruby -e 'print Gem.user_dir')/bin:$HOME/bin/:$HOME/private/bin/:$HOME/sources/dotfiles/deadfiles/bin:$HOME/go/bin/:$PATH"
export SHELL=/usr/bin/zsh
export TERMINAL=urxvt
export EDITOR=/usr/bin/vim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PROFILE="$(cat $HOME/profile)"
export BACKGROUND="$(cat $HOME/background)"

export GOROOT=""
export GOPATH="$HOME/go"

env-setup &

dunst &

lockscreen &

i3
