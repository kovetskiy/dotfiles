set nocompatible

let g:mapleader="\<Space>"
let mapleader=g:mapleader

let g:python3_host_prog = '/usr/bin/python3'

" set up indent/vim.vim
let g:vim_indent_cont = shiftwidth()

set shortmess+=sAIc
set encoding=utf-8
set printencoding=cp1251
set fileformat=unix
set textwidth=80
set timeoutlen=400
set wildmenu
set undofile
set undodir=$HOME/.vim/runtime/undo/
set directory=$HOME/.vim/runtime/tmp/
set backupdir=$HOME/.vim/runtime/backup/
set writebackup
set backup
set lazyredraw
set ttyfast
set number
set relativenumber
set history=500
set hlsearch
set incsearch
set ignorecase
set smartcase
set expandtab
set autoindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set backspace=2
set splitright
set laststatus=2
set gdefault
set completeopt-=preview
set nowrap
set updatetime=150
set timeoutlen=400
set showtabline=0
set cino=(s,m1,+0
set list
set lcs=trail:·,tab:→\ "
set pastetoggle=<F11>
set noequalalways
set winminheight=0
set clipboard=unnamedplus
set tags=./.tags;/
set cc=80,100
set termguicolors

set rtp-=~/.vim
set rtp^=~/.vim

syntax on
filetype plugin indent on

if !has('nvim')
    set signcolumn=number
else
    set signcolumn=yes
endif

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !mkdir -p ~/.vim/autoload
  silent !curl -fLo ~/.vim/autoload/plug.vim
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

let g:plug_url_format = 'git@github.com:%s'
let g:plug_shallow = 0

if has('nvim')
    set viminfo+=n~/.vim/runtime/neoviminfo
else
    set viminfo+=n~/.vim/runtime/viminfo
endif
