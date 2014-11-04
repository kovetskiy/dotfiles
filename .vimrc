" [ ] wtf with my clipboard when i'm yanking?
set nocompatible

imap <UP> <NOP>
imap <DOWN> <NOP>
imap <LEFT> <NOP>
imap <RIGHT> <NOP>
imap <HOME> <NOP>
imap <END> <NOP>
imap <PageUp> <NOP>
imap <PageDown> <NOP>
imap <Del> <NOP>

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    Plugin 'gmarik/Vundle.vim'

    Plugin 'Shougo/vimproc.vim'
    Plugin 'Shougo/unite.vim'

    Plugin 'morhetz/gruvbox'
    Plugin 'bling/vim-airline'

    Plugin 'scrooloose/nerdcommenter'
    Plugin 'majutsushi/tagbar'
    Plugin 'Yggdroot/indentLine'
    Plugin 'Valloric/YouCompleteMe'
    Plugin '2072/PHP-Indenting-for-VIm'
    Plugin 'fatih/vim-go'
    "Plugin 'elzr/vim-json'
    Plugin 'mhinz/vim-startify'
    Plugin 'vim-php/tagbar-phpctags.vim'
    Plugin 'vim-scripts/smarty-syntax'

    " why this plugin do ^[0B in insert mode?
    " Plugin 'airblade/vim-gitgutter'

    Plugin 'l9'
    Plugin 'fuzzyfinder'
    Plugin 'lyokha/vim-xkbswitch'
    Plugin 'Lokaltog/vim-easymotion'
    Plugin 'haya14busa/vim-easyoperator-line'
    Plugin 'SirVer/ultisnips'
    Plugin 'kovetskiy/ash.vim'
    Plugin 'kovetskiy/xkb2en.vim'
    Plugin 'honza/vim-snippets'
    "Plugin 'tobyS/pdv'
    "Plugin 'tobyS/vmustache'
    Plugin 'm2mdas/phpcomplete-extended'
    Plugin 'vim-php/vim-php-refactoring'
    Plugin 'tpope/vim-fugitive'
    Plugin 'tpope/vim-surround'
    Plugin 'terryma/vim-multiple-cursors'
call vundle#end()

filetype plugin indent on

syntax on
filetype plugin on
filetype indent on

set rtp-=~/.vim
set rtp^=~/.vim

set encoding=utf-8
set printencoding=cp1251
set fileformat=unix

set timeoutlen=400
set wildmenu

set undofile
set undodir=$HOME/.vim/tmp/
set directory=$HOME/.vim/tmp/

set ttyfast

set number
set relativenumber

set history=500

set hlsearch
set incsearch
set smartcase

set expandtab
set autoindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set backspace=2

set laststatus=2
set gdefault
set completeopt-=preview
set nowrap
set updatetime=150
set showtabline=0
set cino=(s,m1,+0

set list
set lcs=eol:¶,trail:·,tab:··

set background=dark
colorscheme gruvbox

let mapleader=" "
let g:airline#extensions#whitespace#symbol = '☼'

hi! link WildMenu PmenuSel
hi SPM1 ctermbg=1 ctermfg=7
hi SPM2 ctermbg=2 ctermfg=7
hi SPM3 ctermbg=3 ctermfg=7
hi SPM4 ctermbg=4 ctermfg=7
hi SPM5 ctermbg=5 ctermfg=7
hi SPM6 ctermbg=6 ctermfg=7

hi ErrorMsg term=none
hi Todo term=none
hi SignColumn term=none
hi FoldColumn term=none
hi Folded term=none
hi WildMenu term=none
hi WarningMsg term=none
hi Question term=none
hi ErrorMsg term=none
hi underlined cterm=underline
hi CursorLineNr ctermfg=242 ctermbg=none
hi LineNr ctermfg=248 ctermbg=none
hi SignColumn ctermfg=none ctermbg=none
hi ColorColumn ctermbg=233
hi SpecialKey term=bold cterm=bold ctermfg=1 ctermbg=none
hi NonText ctermfg=235 cterm=none term=none
hi IncSearch cterm=none ctermfg=238 ctermbg=220

augroup filetype_go
    au!

    au BufRead,BufNewFile *.go set filetype=go
    au FileType go nmap <Leader>s <Plug>(go-implements)
    au FileType go nmap <Leader>i <Plug>(go-info)
    au FileType go nmap <Leader>gd <Plug>(go-doc)
    au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
    au FileType go nmap <Leader>gb <Plug>(go-doc-browser)

    au FileType go nmap <leader>r <Plug>(go-run)
    au FileType go nmap <leader>b <Plug>(go-build)
    au FileType go nmap <leader>t <Plug>(go-test)
    au FileType go nmap <leader>c <Plug>(go-coverage)

    au FileType go nmap gd <Plug>(go-def)

    au FileType go nmap <Leader>ds <Plug>(go-def-split)
    au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
    au FileType go nmap <Leader>dt <Plug>(go-def-tab)

    au FileType go nmap <Leader>e <Plug>(go-rename)
augroup END

augroup filetype_tpl
    au!

    au BufRead,BufNewFile *.tpl set filetype=smarty
augroup END

augroup filetype_php
    au!

    au FileType php setlocal omnifunc=phpcomplete_extended#CompletePHP
augroup END

augroup whitespace_hacks
    au!

    au FileType php,go,tpl,yml autocmd BufWritePre <buffer> :%s/\s\+$//e
augroup END

augroup syntax_hacks
    au!

    au FileType diff syn match DiffComment "^#.*"
    au FileType diff syn match DiffCommentIgnore "^###.*"
    au FileType diff call g:ApplySyntaxForDiffComments()
    au FileType diff nnoremap o o# 
augroup end


fun! g:ApplySyntaxForDiffComments()
    if &background == 'light'
        hi DiffCommentIgnore ctermfg=249 ctermbg=none
        hi DiffComment ctermfg=16 ctermbg=254
    else
        hi DiffCommentIgnore ctermfg=249 ctermbg=none
        hi DiffComment ctermfg=15 ctermbg=237
    endif
endfun

function! AddEmptyLineBelow()
  call append(line("."), "")
endfunction

function! AddEmptyLineAbove()
  let l:scrolloffsave = &scrolloff
  set scrolloff=0

  call append(line(".") - 1, "")
  if winline() != winheight(0)
    silent normal! <C-e>
  end
  let &scrolloff = l:scrolloffsave
endfunction

function! DelEmptyLineBelow()
  if line(".") == line("$")
    return
  end
  let l:line = getline(line(".") + 1)
  if l:line =~ '^\s*$'
    let l:colsave = col(".")
    .+1d
    ''
    call cursor(line("."), l:colsave)
  end
endfunction

function! DelEmptyLineAbove()
  if line(".") == 1
    return
  end
  let l:line = getline(line(".") - 1)
  if l:line =~ '^\s*$'
    let l:colsave = col(".")
    .-1d
    silent normal! <C-y>
    call cursor(line("."), l:colsave)
  end
endfunction

let g:go_fmt_fail_silently = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1

let g:php_refactor_command='php ~/.vim/php/refactor.phar'
let g:tagbar_phpctags_bin = '~/.vim/php/phpctags/phpctags'
let g:tagbar_phpctags_memory_limit = '512M'

let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"

nmap <F8> :TagbarToggle<CR>

nmap <F12> :set nohlsearch<CR>

nnoremap <F1> <ESC>:call xkb2en#change_layout()<CR>
inoremap <F1> <ESC>:call xkb2en#change_layout()<CR><ESC>

nmap ,i :Unite ash_inbox<CR>
nmap ,l :Unite ash_lsreviews:ngs/auto<CR>
nmap ,r :UniteResume<CR>

nmap <Leader>` :tabedit ~/.vimrc<CR>
nmap <Leader>% :so ~/.vimrc<CR>

nnoremap <Leader><Leader>q :bdelete!<CR>
nnoremap <Leader><Leader>q <Esc>:bdelete!<CR>

nnoremap <Leader>e :e! 
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q!<CR>

nnoremap `` <Esc>:FufCoverageFile<CR>a
nnoremap `o :FufFile<CR>
nnoremap <Tab><Tab> :FufBuffer<CR>
nnoremap `` :FufCoverageFile<CR>
nnoremap <Leader>`` :FufFileWithCurrentBufferDir<CR>

nnoremap <Space> viw

nnoremap <Leader>d V"_d<Esc>
vnoremap <Leader>d "_d

vnoremap <C-c> "+yy
inoremap <C-d> <C-[>diwi

nnoremap <Leader><Leader>j :call DelEmptyLineBelow()<CR>
nnoremap <Leader><Leader>k :call DelEmptyLineAbove()<CR>
nnoremap <Leader>j :call AddEmptyLineBelow()<CR>
nnoremap <Leader>k :call AddEmptyLineAbove()<CR>

