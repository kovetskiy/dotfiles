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
Plugin 'kovetskiy/ash.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/unite.vim'
Plugin 'morhetz/gruvbox'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/nerdcommenter'
Plugin 'majutsushi/tagbar'
Plugin 'Valloric/YouCompleteMe'
Plugin '2072/PHP-Indenting-for-VIm'
Plugin 'fatih/vim-go'
Plugin 'elzr/vim-json'
Plugin 'mhinz/vim-startify'
Plugin 'vim-scripts/smarty-syntax'
Plugin 'l9'
Plugin 'fuzzyfinder'
Plugin 'lyokha/vim-xkbswitch'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'haya14busa/vim-easyoperator-line'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'm2mdas/phpcomplete-extended'
Plugin 'vim-php/vim-php-refactoring'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tsukkee/unite-tag'
Plugin 'joonty/vim-phpqa'

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

colorscheme gruvbox
set background=dark

let mapleader=" "
let g:mapleader=mapleader

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
    au FileType php,go,tpl,yml,json autocmd BufWritePre <buffer> :%s/\s\+$//e
augroup END

augroup syntax_hacks
    au!
    au FileType diff syn match DiffComment "^#.*"
    au FileType diff syn match DiffCommentIgnore "^###.*"
    au FileType diff call g:ApplySyntaxForDiffComments()
    au FileType diff nnoremap o o# 
augroup end

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

fu! SkeletonGitCommit()
    let l:line = getline(".")
    if l:line == "" 
        let l:issue = system("git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3 | grep -oP '([A-Z]{1,}\-[0-9]{1,})'")

        if l:issue != '' 
            execute 'normal I' . l:issue . ': '
        endif
    endif
endfu!

augroup skeletons
    au!
    au BufRead,BufNewFile *COMMIT_EDITMSG exec "call SkeletonGitCommit()"
augroup END

augroup unite_setting  
    au!

    au FileType unite call s:unite_my_settings()
augroup end

function! s:unite_my_settings()   
    imap <buffer> <C-R> <Plug>(unite_redraw) 

    imap <silent><buffer><expr> <C-T> unite#do_action('split')
    call unite#custom#alias('ash_review', 'split', 'ls')
endfunction

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

set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

let g:unite_split_rule = "botright"
let g:unite_force_overwrite_statusline = 0
let g:unite_enable_start_insert = 1

let g:phpqa_php_cmd='php'
let g:phpqa_codesniffer_cmd='phpcs'
let g:phpqa_codesniffer_args="--standard='" . expand('~') . "/php_standarts.cs/Standards/NGS/ruleset.xml'"

let g:phpqa_codesniffer_autorun=0
let g:phpqa_messdetector_autorun=0

set pastetoggle=<F11>

nmap <F8> :TagbarToggle<CR>

nmap <Leader><Leader> :noh<CR>
nmap <F2> :Phpcs<CR>

nnoremap / /\v
vnoremap / \v

nnoremap > >>
nnoremap < <<

nnoremap <F7> <ESC>:!time phptags-scripts<CR>

let g:XkbSwitchLib = '/usr/local/lib/libxkbswitch.so'
let g:XkbSwitchEnabled = 1

nmap ,i :Unite ash_inbox<CR>
nmap ,l :Unite ash_lsreviews:ngs/auto<CR>
nmap ,r :UniteResume<CR>

nmap <C-P> :Unite -buffer-name=files -start-insert buffer file_rec/async:!<CR>
nmap ,f :Unite file<CR>
nmap ,g :Unite grep<CR>

nmap <Leader>` :tabedit ~/.vimrc<CR>
nmap <Leader>% :so ~/.vimrc<CR>

vmap <silent> > >gv
vmap <silent> < <gv

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

nnoremap <Leader>m :call MakeZaebis()<CR>

nnoremap <Leader>] :tnext<CR>

noh
set background=dark

