#!/bin/bash

POINTS=(
    "bin"
    ".config/dunst"
    ".config/redshift.conf"
    ".config/fontconfig"
    ".dircolors.dark"
    ".dircolors.light"
    ".fonts"
    ".gitconfig"
    ".gitignore"
    ".gitignore_global"
    ".i3"
    ".i3status.conf"
    ".mcabber"
    ".muttator"
    ".muttatorrc"
    ".urxvt"
    ".vim/UltiSnips"
    ".vim/pythonx"
    ".vimperatorrc"
    ".vimrc"
    ".Xdefaults"
    ".Xdefaults.dark"
    ".Xdefaults.light"
    ".xsessionrc"
    ".zpreztorc"
    ".zprezto/modules/prompt/functions"
    ".zshrc"
)

for POINT in "${POINTS[@]}"; do
    COMMAND="rm -rf ~/$POINT"
    echo "$COMMAND"
    eval $COMMAND

    COMMAND="ln -sf ~/repos/dotfiles/$POINT ~/$POINT"
    echo "$COMMAND"
    eval $COMMAND
done
