#!/bin/bash

POINTS=(
    "bin"
    ".config/dunst"
    ".config/fontconfig"
    ".dircolors.dark"
    ".dircolors.light"
    ".fonts"
    ".icons"
    ".gitconfig"
    ".gitignore"
    ".gitignore_global"
    ".i3"
    ".mcabber"
    ".urxvt"
    ".vim/UltiSnips"
    ".vim/skeletons"
    ".vimperatorrc"
    ".vimrc-economic"
    ".vimrc"
    ".Xresources"
    ".Xresources.dark"
    ".Xresources.light"
    ".xinitrc"
    ".zpreztorc"
    ".zprezto/modules/prompt/functions"
    ".zshrc"
    ".keynavrc"
    ".mutt"
    ".muttrc"
    ".mailcap"
    ".terminfo"
    ".vimperator"
    ".tmux.conf"
    ".yaourtrc"
    ".toprc"
    ".sift.conf"
    ".ssh/config"
)

for POINT in "${POINTS[@]}"; do
    COMMAND="rm -rf ~/$POINT"
    echo "$COMMAND"
    eval $COMMAND

    COMMAND="ln -sf ~/dotfiles/$POINT ~/$POINT"
    echo "$COMMAND"
    eval $COMMAND
done
