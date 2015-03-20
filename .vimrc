set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !mkdir -p ~/.vim/autoload
  silent !curl -fLo ~/.vim/autoload/plug.vim
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/bundle')

Plug 'Shougo/vimproc.vim'
Plug 'Shougo/unite.vim'
Plug 'morhetz/gruvbox'
Plug 'junegunn/seoul256.vim'
Plug 'bling/vim-airline'
Plug 'scrooloose/nerdcommenter'
Plug 'Valloric/YouCompleteMe'
Plug '2072/PHP-Indenting-for-VIm'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'mhinz/vim-startify'
Plug 'l9'
Plug 'ctrlpvim/ctrlp.vim', { 'on': 'CtrlP' }
Plug 'lyokha/vim-xkbswitch'
Plug 'Lokaltog/vim-easymotion'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'm2mdas/phpcomplete-extended', { 'for': 'php' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'
Plug 'yuku-t/unite-git'
Plug 'joonty/vim-phpqa'
Plug 'pangloss/vim-javascript', { 'for': 'js' }
Plug 'jelera/vim-javascript-syntax', { 'for': 'js' }
Plug 'marijnh/tern_for_vim', { 'for': 'js' }
Plug 'rename', { 'on': 'Rename' }
Plug 't9md/vim-choosewin', { 'on': [ 'ChooseWin', 'ChooseWinSwap' ] }
Plug 'osyo-manga/vim-over', {'on': 'OverCommandLine'}
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'edsono/vim-matchit', { 'for': 'html'}
Plug 'AndrewRadev/sideways.vim'
Plug 'gorkunov/smartpairs.vim'
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }
Plug 'terryma/vim-multiple-cursors'
Plug 'raichoo/haskell-vim'
Plug 'eagletmt/neco-ghc'
Plug 'kana/vim-smartinput'
Plug 'majutsushi/tagbar'
Plug 'justinmk/vim-sneak'
Plug 'alvan/vim-php-manual'
Plug 'vim-scripts/smarty-syntax'
Plug 'SyntaxAttr.vim'

Plug 'kovetskiy/gocompletenote'
Plug 'kovetskiy/urxvt.vim'
Plug 'kovetskiy/ash.vim'
Plug 'seletskiy/vim-pythonx'

call plug#end()

syntax on
filetype plugin indent on

set rtp-=~/.vim
set rtp^=~/.vim

set encoding=utf-8
set printencoding=cp1251
set fileformat=unix

set textwidth=80
set timeoutlen=400
set wildmenu

set undofile
set undodir=$HOME/.vim/tmp/
set directory=$HOME/.vim/tmp/
set backupdir=$HOME/.vim/tmp

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

set laststatus=2
set gdefault
set completeopt-=preview
set nowrap
set updatetime=150
set showtabline=0
set cino=(s,m1,+0

set list
set lcs=eol:¶,trail:·,tab:\ \ "t

set pastetoggle=<F11>

set wildignore+=*/tmp/*,*.so,*.swp,*.zip

set tags=tags;/

let g:airline_theme = 'base16'
let g:airline#extensions#whitespace#symbol = '☼'
let g:airline_powerline_fonts = 1

hi! link WildMenu PmenuSel
hi SPM1 ctermbg=1 ctermfg=7
hi SPM2 ctermbg=2 ctermfg=7
hi SPM3 ctermbg=3 ctermfg=7
hi SPM4 ctermbg=4 ctermfg=7
hi SPM5 ctermbg=5 ctermfg=7
hi SPM6 ctermbg=6 ctermfg=7

augroup filetype_markdown
    au!

    au BufRead,BufNewFile *.md set filetype=markdown
augroup end

augroup filetype_go
    au!

    au BufRead,BufNewFile *.go set filetype=go

    "au FileType go py import go

    au FileType go nmap <buffer> <Leader>t :call urxvt#put('go test')<CR>
    au FileType go nmap <buffer> <Leader>e :GoRename<CR>
    au FileType go nmap <buffer> <Leader>f :GoFmt<CR>:w<CR>
    au FileType go nmap <buffer> <Leader>h :GoDoc<CR>
    au FileType go nmap <buffer> <Leader>r :call urxvt#put('./' . expand('%:p:h:t'))<CR>
    au FileType go nmap <buffer> <Leader>b :GoFmt<CR>:w<CR>:call urxvt#put('go build')<CR>
    au FileType go inoremap <buffer> <C-L> <C-\><C-O>:py go.cycle_by_var_name()<CR>
    au FileType go smap <buffer> <C-L> <BS><C-L>
    au FileType go smap <buffer> <C-K> <BS><C-I>
augroup end

augroup filetype_tpl
    au!

    au BufRead,BufNewFile *.tpl set filetype=smarty
augroup end

augroup filetype_php
    au!

    au BufRead,BufNewFile *.php set filetype=php

    au FileType php nmap <Leader>e :call PhpRefactorRenameLocalVariable()<CR>
    au FileType php setlocal omnifunc=phpcomplete_extended#CompletePHP
    au FileType php nnoremap <F2>  :Phpcs<CR>
    au FileType php nnoremap <F7>  :!time tags_php<CR>
    au FileType php hi! def link phpDocTags  phpDefine
    au FileType php hi! def link phpDocParam phpType
    au FileType php inoremap <C-L> <C-\><C-O>:py php.cycle_by_var_name()<CR>
    au FileType php smap <C-L> <BS><C-L>
    au FileType php imap <C-S><C-P> ps<TAB>
    au FileType php imap <C-G><C-P> pg<TAB>
    au FileType php imap <C-S><C-V> vs<TAB>
    au FileType php imap <C-G><C-V> vg<TAB>
    au FileType php imap <C-S><C-U> us<TAB>
    au FileType php imap <C-G><C-U> ug<TAB>
augroup end

augroup whitespace_hacks
    au!

    fu! Whitespaces()
        let l=line('.')
        let c=virtcol('.')
        %s/\s\+$//e
        execute "normal " . l . "gg"
        execute "normal" . c . "|"
    endfu!

    au FileType php,go,tpl,yml,json,js autocmd BufWritePre <buffer> :call Whitespaces()
augroup end

"augroup my_syntax_hacks
    "au!
    "au FileType diff call g:MyApplySyntaxForDiffComments()
"augroup end

augroup dir_autocreate
    au!
    au BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif
augroup end

augroup filetype_json
    au!
    au BufNewFile,BufRead *.json set filetype=json
augroup end

let s:prev_line = 0
augroup rnu_nu
    au!
    au CursorMoved * if &rnu && line('.') != s:prev_line | set nornu nu | endif
    au CursorHold  * if &nu | set rnu | let s:prev_line = line('.') | endif
augroup end

augroup vimrc
    au!
    au BufWritePost ~/.vimrc source % | AirlineRefresh
augroup end

augroup mcabber
    au!
    au BufWritePost ~/.mcabber/mcabberrc !echo "/source ~/.mcabber/mcabberrc" > ~/.mcabber/mcabber.fifo
augroup end

fu! SkeletonGitCommit()
    let l:line = getline(".")
    if l:line == ""
        let l:issue = system("git symbolic-ref HEAD 2>/dev/null | grep -oP '([A-Za-z]{1,}\-[0-9]{1,})'")

        if l:issue != ''
            execute 'normal I' . toupper(l:issue)
            execute 'normal gg$a: '
        endif
    endif
endfu!

augroup skeletons
    au!
    au FileType gitcommit exec "call SkeletonGitCommit()"
    au BufNewFile *.php exec "normal I<?php\r\rcl"
augroup end

augroup unite_setting
    au!

    au FileType unite call s:unite_my_settings()
augroup end

augroup urxvt
    au!
    au BufRead,BufNewFile * UrxvtChangeDir
augroup end

augroup hilight_over
    au!
    au VimResized,VimEnter * set cc=80,120
augroup end

if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
        \ '--nocolor --nogroup --hidden --ignore-dir vendor/cache ' .
        \ '--ignore-dir .git --ignore *.log --ignore *.bundle.* ' .
        \ '--ignore-dir .jhw-cache'
    let g:unite_source_grep_recursive_opt = ''
elseif executable('ack-grep')
    let g:unite_source_grep_command = 'ack-grep'
    let g:unite_source_grep_default_opts =
        \ '--no-heading --no-color -a -H'
    let g:unite_source_grep_recursive_opt = ''
endif


call unite#custom#source(
    \ 'file,file/new,buffer,file_rec,file_rec/async,git_cached,git_untracked,directory',
    \ 'matchers', 'matcher_fuzzy')

call unite#custom#default_action(
    \ 'directory', 'cd')

call unite#filters#sorter_default#use(['sorter_selecta'])

call unite#custom#source('file,file_rec,file_rec/async,git_cached,git_untracked', 'ignore_globs',
    \ split('*.png,*.zip,*.tar,*.gz,*.jpg,*.jpeg,*.chunks,*.gif', ','))

function! s:unite_my_settings()
    imap <buffer> <C-R> <Plug>(unite_redraw)

    imap <silent><buffer><expr> <C-T> unite#do_action('split')
    imap <silent><buffer><expr> <C-V> unite#do_action('vsplit')
    call unite#custom#alias('ash_review', 'split', 'ls')
endfunction

"fun! g:MyApplySyntaxForDiffComments()
    "if &background == 'light'
        "hi DiffCommentIgnore ctermfg=249 ctermbg=none
        "hi DiffComment ctermfg=16 ctermbg=254
    "else
        "hi DiffCommentIgnore ctermfg=249 ctermbg=none
        "hi DiffComment ctermfg=15 ctermbg=237
    "endif
"endfun

function! AddEmptyLineBelow()
  let l:scrolloffsave = &scrolloff
  set scrolloff=0

  let l:linesave = line(".")
  let l:colsave = col(".")

  silent normal o

  call cursor(l:linesave, l:colsave)

  let &scrolloff = l:scrolloffsave
endfunction

function! AddEmptyLineAbove()
  let l:scrolloffsave = &scrolloff
  set scrolloff=0

  let l:linesave = line(".")
  let l:colsave = col(".")

  silent normal O

  call cursor(l:linesave+1, l:colsave)

  let &scrolloff = l:scrolloffsave
endfunction

function! DelEmptyLineBelow()
  let l:scrolloffsave = &scrolloff
  set scrolloff=0

  let l:linesave = line(".")
  let l:colsave = col(".")

  " <Leader>d
  silent normal j d

  call cursor(l:linesave, l:colsave)

  let &scrolloff = l:scrolloffsave
endfunction

function! DelEmptyLineAbove()
  let l:scrolloffsave = &scrolloff
  set scrolloff=0

  let l:linesave = line(".")
  let l:colsave = col(".")

  " <Leader>d
  silent normal k d

  call cursor(l:linesave-1, l:colsave)

  let &scrolloff = l:scrolloffsave
endfunction

function! TryToReduce()
    let startLine = line(".")
    let content = getline(startLine)

    let content = substitute(content, "[,\(]", "&\r", "g")
    let content = substitute(content, "[\)]", "\r&", "g")
    let content = substitute(content, "\(\r\r\)", "()", "g")
    let content = substitute(content, "\rarray\r", "array", "g")

    execute 'normal S'
    execute 'normal i' . content

    let currentLine = line(".")
    let cow = currentLine - startLine + 2

    execute 'normal ' . (startLine - 1) . 'gg'
    execute 'normal ' . cow . '=='
    execute 'normal ' . startLine . 'gg^'
endfunction

let mapleader=" "
let g:mapleader=mapleader

let g:go_fmt_fail_silently = 0
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 0
let g:go_bin_path = $GOPATH . "/bin"

let g:php_refactor_command='php ~/.vim/php/refactor.phar'
let g:tagbar_phpctags_bin = '~/.vim/php/phpctags/phpctags'
let g:tagbar_phpctags_memory_limit = '512M'

let g:UltiSnipsExpandTrigger="<TAB>"
let g:UltiSnipsJumpForwardTrigger="<C-J>"
let g:UltiSnipsJumpBackwardTrigger="<C-K>"
let g:UltiSnipsEditSplit="vertical"

let g:unite_split_rule = "botright"
let g:unite_force_overwrite_statusline = 0
let g:unite_enable_start_insert = 1

let g:unite_source_history_yank_enable = 1
let g:unite_source_history_yank_limit = 10000
let g:unite_source_history_yank_file=expand('~'). "/.vim/tmp/yank"

let g:phpqa_php_cmd='php'
let g:phpqa_run_on_write=0
let g:phpqa_codesniffer_cmd='phpcs'
let g:phpqa_codesniffer_args="--encoding=utf8 --standard='" . expand('~') . "/repos/standards/CodeSniffer/Standards/NGS/ruleset.xml'"

let g:phpqa_codesniffer_autorun=0
let g:phpqa_messdetector_autorun=0

let g:XkbSwitchLib = '/usr/local/lib/libxkbswitch.so'
let g:XkbSwitchEnabled = 1

let g:startify_session_dir = '~/.vim/sessions'
let g:startify_enable_special = 1
let g:startify_list_order = ['sessions', 'dir', 'files']
let g:startify_files_number = 20
let g:startify_session_persistence = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_dir = 0

let g:choosewin_overlay_enable = 1
let g:choosewin_overlay_clear_multibyte = 1
let g:choosewin_label = 'QWEASDIOPJKL'

let g:EasyMotion_keys = "hjkluiopqweasd"


let g:ycm_key_list_previous_completion=['<UP>']
let g:ycm_key_list_select_completion=['<DOWN>']

hi link EasyMotionTarget ErrorMsg
"hi link EasyMotionShade  Comment

hi link EasyMotionTarget2First ErrorMsg
hi link EasyMotionTarget2Second ErrorMsg

let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1

nnoremap <C-W><C-E> :ChooseWin<CR>
nnoremap <C-W><C-S> :ChooseWinSwap<CR>

nnoremap <Leader><Leader>i :PlugInstall<CR>
nnoremap <Leader><Leader>u :PlugUpdate<CR>
nnoremap <Leader><Leader>a 0v3f/sPlug '<ESC>A'<ESC>

nnoremap <F8>  :TagbarToggle<CR>
nnoremap <F12> :noh<CR>

nnoremap <F10> :Gstatus<CR>

nnoremap <Leader>o o<ESC>
nnoremap <Leader>O O<ESC>

nnoremap X S<ESC>
vnoremap $ g_

nnoremap / /\v
vnoremap / \v

nnoremap > >>
nnoremap < <<

nnoremap ,i :Unite ash_inbox<CR>
nnoremap ,l :Unite ash_lsreviews:ngs/auto<CR>
nnoremap ,r :UniteResume<CR>

nnoremap ,f :Unite file<CR>
nnoremap ,g :Unite grep<CR>

nnoremap <Leader>` :tabedit ~/.vimrc<CR>
nnoremap <Leader>% :so ~/.vimrc<CR>

vnoremap <silent> > >gv
vnoremap <silent> < <gv

inoremap jk <ESC>

nnoremap g< '<
nnoremap g> '>

nnoremap g. '>
nnoremap g, '<

nnoremap <F4> :let &scrolloff=999-&scrolloff<CR>
nnoremap <Leader><Leader>q :bdelete!<CR>
nnoremap <Leader><Leader>q <Esc>:bdelete!<CR>

nnoremap <Leader>vs :vsp<CR>

nnoremap <Leader>e :e! 
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q!<CR>

nnoremap <C-P> :Unite -hide-source-names buffer git_cached git_untracked<CR>
nnoremap <C-Y> :Unite -hide-source-names history/yank<CR>
nnoremap <C-E><C-G> :Unite -hide-source-names grep:.<CR>

nnoremap <Space> viw

nnoremap <Leader>d V"_d<Esc>
vnoremap <Leader>d "_d

vnoremap <Leader>s y<ESC>:%s/<C-r>"/

vnoremap <Leader><C-y> "kyy
vnoremap <Leader><C-d> "kdgvd
vnoremap <Leader><C-x> "kygvx
vnoremap <Leader><C-p> "kp
vnoremap <Leader><C-P> "kP
vnoremap <Leader><C-s> "ks

nnoremap <Leader><C-x> v"kx
nnoremap <Leader><C-p> "kp
nnoremap <Leader><C-P> "kP

vnoremap / y/<C-r>"
nnoremap <Leader><Leader>j :call DelEmptyLineBelow()<CR>
nnoremap <Leader><Leader>k :call DelEmptyLineAbove()<CR>
nnoremap <Leader>j :call AddEmptyLineBelow()<CR>
nnoremap <Leader>k :call AddEmptyLineAbove()<CR>

nnoremap <Leader>m :call TryToReduce()<CR>

nnoremap <Leader>] :tnext<CR>

nnoremap <C-T><C-T> :retab<CR>

nnoremap <C-S><C-E> :UltiSnipsEdit<CR>

nnoremap L :OverCommandLine %s/<CR>
vnoremap L :OverCommandLine s/<CR>

" bullshit
nmap <NOP> <Plug>Sneak_s
vmap <NOP> <Plug>Sneak_s
nmap <NOP><NOP> <Plug>Sneak_S
vmap <NOP><NOP> <Plug>Sneak_S

nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F
"replace 't' with 1-char Sneak
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T

inoremap <C-A> <C-O>A

map <C-_> <C-W>_
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

imap <C-T> <C-R>=strpart(search("[)}\"'`\\]]", "c"), -1, 0)<CR><Right>

inoremap <C-K> <C-O>A;<C-O>o

noh

fu! Background(val)
    let bg = a:val
    if bg == ""
        let bg = "light"
    endif

    if bg == "light"
        let g:seoul256_background = 255
        let g:colorscheme='seoul256'
    else
        let g:colorscheme='gruvbox'
    endif

    execute "colorscheme " . g:colorscheme
    execute "set background=" . bg

    hi! link WildMenu PmenuSel
    hi SPM1 ctermbg=1 ctermfg=7
    hi SPM2 ctermbg=2 ctermfg=7
    hi SPM3 ctermbg=3 ctermfg=7
    hi SPM4 ctermbg=4 ctermfg=7
    hi SPM5 ctermbg=5 ctermfg=7
    hi SPM6 ctermbg=6 ctermfg=7
    hi VertSplit cterm=none ctermbg=none ctermfg=16
    hi ErrorMsg term=none
    hi Todo term=none
    hi SignColumn term=none
    hi FoldColumn term=none
    hi Folded term=none
    hi WildMenu term=none
    hi WarningMsg term=none
    hi Question term=none

    if &background == "light"
        set background=light
        hi! underlined cterm=underline
        hi! CursorLineNr ctermfg=241 ctermbg=none
        hi! LineNr ctermfg=249 ctermbg=none
        hi! SignColumn ctermfg=none ctermbg=none
        hi! SpecialKey term=bold cterm=bold ctermfg=1 ctermbg=none
        hi! NonText ctermfg=254 cterm=none term=none
        hi! IncSearch cterm=none ctermfg=238 ctermbg=220
        hi! Cursor ctermbg=0 ctermfg=15
        hi! PmenuSel ctermbg=136 ctermfg=15 cterm=bold
    endif

    " for smarty
    hi htmlLink gui=none
endfu!

augroup ash_my_settings
    au!

    au FileType diff syn match DiffAddedContent "^+.*" containedin=ALL
    au FileType diff hi! DiffAddedContent ctermbg=65 guibg=#719872 ctermfg=232
    au FileType diff syn match DiffRemovedContent "^-.*" containedin=ALL
    au FileType diff hi! DiffRemovedContent ctermbg=131 guibg=#be7572 ctermfg=232
augroup end

call Background($BACKGROUND)


if !exists('g:php_handle_enter')
    let g:php_handle_enter = 0
endif

augroup filetype_help
    au!
    au FileType help setlocal number
augroup end

inoremap <C-E> <C-O>:call GoHelpSaveThat()<CR><C-O>a
