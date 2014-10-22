#!/bin/bash

mkdir -p ~/.vim/{tmp,bundle}/

cd ~/.vim/bundle/

git clone https://github.com/gmarik/Vundle.vim.git 
git clone https://github.com/Shougo/unite.vim.git
git clone https://github.com/airblade/vim-gitgutter.git

hg clone https://bitbucket.org/ns9tks/vim-fuzzyfinder
hg clone https://bitbucket.org/ns9tks/vim-l9

git clone https://github.com/Shougo/vimproc.vim.git
cd ~/.vim/bundle/vimproc.vim
make

vim +PluginInstall +qall

cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer

vim
