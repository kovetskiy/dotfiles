#!/bin/bash

mkdir -p ~/.vim/{tmp,bundle}/

cd ~/.vim/bundle/

if [ ! -d "vim-l9i" ]; then
    hg clone https://bitbucket.org/ns9tks/vim-l9
fi

if [ ! -d "vimproc.vim" ]; then
    git clone https://github.com/Shougo/vimproc.vim.git
    cd ~/.vim/bundle/vimproc.vim
    make
fi

if [ ! -f "YouCompleteMe/third_party/ycmd/ycm_core.so" ]; then
    cd ~/.vim/bundle/YouCompleteMe
    ./install.sh --clang-completer
fi

mkdir ~/.vim/php
cd ~/.vim/php

# ohhh white magic!
if [ ! -f "refactor.phar" ]; then
    wget https://github.com/QafooLabs/php-refactoring-browser/releases/download/v0.0.4/refactor.phar
fi

#UltiSnips fix for autoloading.
ln -s ~/.vim/bundle/UltiSnips/after/plugin/* ~/.vim/after/plugin
ln -s ~/.vim/bundle/UltiSnips/ftdetect/* ~/.vim/ftdetect

echo "Vim installed!"
