set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !mkdir -p ~/.vim/autoload
  silent !curl -fLo ~/.vim/autoload/plug.vim
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/bundle')

Plug 'Shougo/vimproc.vim'
Plug 'Shougo/unite.vim', {'on': 'Unite'}
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
Plug 'vim-php/vim-php-refactoring', { 'for': 'php' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'
"Plug 'tsukkee/unite-tag'
Plug 'joonty/vim-phpqa', { 'for': 'php' }
Plug 'rhysd/clever-f.vim'
"Plug 'kovetskiy/filestyle'
Plug 'pangloss/vim-javascript', { 'for': 'js' }
Plug 'rename', { 'on': 'Rename' }
Plug 't9md/vim-choosewin', { 'on': [ 'ChooseWin', 'ChooseWinSwap' ] }
Plug 'osyo-manga/vim-over', {'on': 'OverCommandLine'}
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'edsono/vim-matchit', { 'for': 'html'}
Plug 'AndrewRadev/sideways.vim'
Plug 'gorkunov/smartpairs.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'StanAngeloff/php.vim'
Plug 'terryma/vim-multiple-cursors'

Plug 'kovetskiy/urxvt.vim'
Plug 'kovetskiy/ash.vim'

Plug 'yuku-t/unite-git'
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
set lcs=eol:¶,trail:·,tab:··

set pastetoggle=<F11>

set wildignore+=*/tmp/*,*.so,*.swp,*.zip

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

    au FileType go nmap <Leader>t :call urxvt#put('go test')<CR>
    au FileType go nmap <Leader>e :GoRename<CR>
    au FileType go nmap <Leader>i :GoImports<CR>
    au FileType go nmap <Leader>f :GoFmt<CR>
    au FileType go nmap <Leader>r :call urxvt#put('./' . expand('%:p:h:t'))<CR>
    au FileType go nmap <Leader>b :call urxvt#put('setup-android-env-go ./all.bash')<CR>
augroup END

augroup filetype_tpl
    au!
    au BufRead,BufNewFile *.tpl set filetype=html
augroup END

augroup filetype_php
    au!
    au FileType php setlocal omnifunc=phpcomplete_extended#CompletePHP
augroup END

augroup whitespace_hacks
    au!
    fu! Whitespaces()
        execute 'normal :%s/\s\+$//e'
    endfu!
    au FileType php,go,tpl,yml,json,js autocmd BufWritePre <buffer> :%s/\s\+$//e
augroup END

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
        let l:issue = system("git symbolic-ref HEAD 2>/dev/null | grep -oP '([A-Z]{1,}\-[0-9]{1,})'")

        if l:issue != ''
            execute 'normal I' . l:issue . ': '
        endif
    endif
endfu!

augroup skeletons
    au!
    au FileType gitcommit exec "call SkeletonGitCommit()"
    au BufNewFile *.php exec "normal I<?php\r\rcl"
augroup END

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

if !exists('g:unite_loaded')
    let g:unite_loaded = 0
endif

function! s:unite_my_settings()
    if g:unite_loaded == 0 
        let g:unite_loaded = 1

        call unite#custom#source(
            \ 'file,file/new,buffer,file_rec,file_rec/async,git_cached,git_untracked,directory',
            \ 'matchers', 'matcher_fuzzy')

        call unite#custom#default_action(
            \ 'directory', 'cd')

        call unite#force_redraw()
    endif

    imap <buffer> <C-R> <Plug>(unite_redraw)

    imap <silent><buffer><expr> <C-T> unite#do_action('split')
    imap <silent><buffer><expr> <C-V><C-T> unite#do_action('vsplit')
    call unite#custom#alias('ash_review', 'split', 'ls')
endfunction


function! PhpSyntaxOverride()
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END

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

" my magic function :))
function! MakeZaebis()
    let startLine = line(".")
    let content = getline(startLine)

    let content = substitute(content, "[,\(]", "&\r", "g")
    let content = substitute(content, "[\)]", "\r&", "g")
    let content = substitute(content, "\(\r\r\)", "()", "g")

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

let g:php_refactor_command='php ~/.vim/php/refactor.phar'
let g:tagbar_phpctags_bin = '~/.vim/php/phpctags/phpctags'
let g:tagbar_phpctags_memory_limit = '512M'

let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"

let g:unite_split_rule = "botright"
let g:unite_force_overwrite_statusline = 0
let g:unite_enable_start_insert = 1

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

let g:go_bin_path=$GOPATH . "/bin"

nnoremap <C-W><C-E> :ChooseWin<CR>
nnoremap <C-W><C-S> :ChooseWinSwap<CR>

nnoremap <Leader><Leader>i :PlugInstall<CR>
nnoremap <Leader><Leader>u :PlugUpdate<CR>
nnoremap <Leader><Leader>a 0v3f/sPlug '<ESC>A'<ESC>

nnoremap <F2>  :Phpcs<CR>
nnoremap <F7>  :!time tags_php<CR>
nnoremap <F8>  :TagbarToggle<CR>
nnoremap <F12> :noh<CR>

nnoremap <F10> :Gstatus<CR>

nnoremap <Leader>o o<ESC>
nnoremap <Leader>O O<ESC>

nnoremap X S<ESC>
vnoremap $ $h

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

nnoremap g< '<
nnoremap g> '>

nnoremap <F4> :let &scrolloff=999-&scrolloff<CR>
nnoremap <Leader><Leader>q :bdelete!<CR>
nnoremap <Leader><Leader>q <Esc>:bdelete!<CR>

nnoremap <Leader>ue :UltiSnipsEdit<CR>

nnoremap <Leader>vs :vsp<CR>

nnoremap <Leader>e :e! 
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q!<CR>

nnoremap <C-P> :Unite -hide-source-names buffer git_cached git_untracked<CR>
nnoremap <C-B> :Unite -hide-source-names buffer<CR>
nnoremap <C-Y> :Unite -hide-source-names history/yank<CR>
nnoremap `` :Unite -hide-source-names buffer file_rec/async<CR>
nnoremap <C-E><C-G> :Unite -hide-source-names grep:.<CR>

nnoremap <C-D> <C-F>
nnoremap <C-U> <C-B>
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

nnoremap <Leader>m :call MakeZaebis()<CR>

nnoremap <Leader>] :tnext<CR>

nnoremap <C-T><C-T> :retab<CR>

nnoremap <C-S><C-E> :UltiSnipsEdit<CR>

nnoremap H :OverCommandLine %s/<CR>
vnoremap H :OverCommandLine s/<CR>
map L *:OverCommandLine s//<CR>

noh

fu! Background(val)
    if a:val == "light"
        let g:colorscheme='seoul256'
    else
        let g:colorscheme='gruvbox'
    endif

    execute "colorscheme " . g:colorscheme
    execute "set background=" . a:val

    if &background == "light"
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
        hi CursorLineNr ctermfg=7 ctermbg=242
        hi LineNr ctermfg=241 ctermbg=7
        hi SignColumn ctermfg=none ctermbg=220
        hi ColorColumn ctermbg=251
        hi SpecialKey term=bold cterm=bold ctermfg=255 ctermbg=none
        hi NonText ctermfg=247 cterm=none term=none
        hi IncSearch cterm=none ctermfg=238 ctermbg=220
    endif

endfu!

call Background($BACKGROUND)
