" todolist:
" [ ] cleanup
" [ ] wtf with my clipboard when i'm yanking?
" [ ] what is airblade/vim-gitgutter | http://vimawesome.com/plugin/vim-gitgutter
" [ ] that's may make my life better. Lokaltog/vim-easymotion
set nocompatible
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
    Plugin 'gmarik/Vundle.vim'

    Plugin 'Shougo/vimproc.vim'
    Plugin 'Shougo/unite.vim'

    Plugin 'junegunn/seoul256.vim'
    Plugin 'bling/vim-airline'

    Plugin 'scrooloose/nerdtree'
    Plugin 'scrooloose/nerdcommenter'
    Plugin 'majutsushi/tagbar'
    Plugin 'Yggdroot/indentLine'

    Plugin 'Valloric/YouCompleteMe'
    Plugin '2072/PHP-Indenting-for-VIm'
    Plugin 'fatih/vim-go'
    Plugin 'elzr/vim-json'

    " why this plugin do ^[0B in insert mode?
    " Plugin 'airblade/vim-gitgutter'

    Plugin 'l9'
    Plugin 'fuzzyfinder'

    Plugin 'Lokaltog/vim-easymotion'
    Plugin 'haya14busa/vim-easyoperator-line'

    Plugin 'sudo.vim'

call vundle#end()

filetype plugin indent on

syntax on
filetype plugin on
filetype indent on

set rtp-=~/.vim
set rtp^=~/.vim

set encoding=utf-8
set printencoding=cp1251

set timeoutlen=400
set wildmenu

set undofile
set undodir=$HOME/.vim/tmp/
set directory=$HOME/.vim/tmp/

set ttyfast
"set autowrite
"
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


"let g:airline_powerline_fonts = 1
"let g:airline_theme = 'lucius'
"let g:airline#extensions#whitespace#symbol = '☼'

colorscheme seoul256
set background=dark
let g:seoul256_background = 234
hi! link WildMenu PmenuSel
hi SPM1 ctermbg=1 ctermfg=7
hi SPM2 ctermbg=2 ctermfg=7
hi SPM3 ctermbg=3 ctermfg=7
hi SPM4 ctermbg=4 ctermfg=7
hi SPM5 ctermbg=5 ctermfg=7
hi SPM6 ctermbg=6 ctermfg=7

" disable weird standout mode
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

let g:go_fmt_fail_silently = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1

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

augroup syntax_hacks
    au!
    au FileType diff syn match DiffComment "^#.*"
    au FileType diff syn match DiffCommentIgnore "^###.*"
    au FileType diff call g:ApplySyntaxForDiffComments()
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

" au FileType php set omnifunc=phpcomplete#CompletePHP

nmap <F8> :TagbarToggle<CR>


nmap ,a :Unite ash<CR>
nmap ,r :UniteResume<CR>
nmap ,w :w<CR>
nmap ,s :bdelete<CR>

inoremap jk <esc>

map <C-n> :NERDTreeToggle<CR>

nnoremap \q :q<CR>
inoremap \q <Esc>:q<CR>a

inoremap \f <Esc>:FufFile<CR>a
inoremap \b <Esc>:FufBuffer<CR>a
nnoremap \c <Esc>:FufCoverageFile<CR>a

nnoremap `f :FufFile<CR>
nnoremap `<Tab> :FufBuffer<CR>
nnoremap `` :FufCoverageFile<CR>

