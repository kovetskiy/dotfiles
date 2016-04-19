set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !mkdir -p ~/.vim/autoload
  silent !curl -fLo ~/.vim/autoload/plug.vim
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

let g:mapleader="\<Space>"
let mapleader=g:mapleader

augroup filetype_go
    au!
augroup end

nnoremap <Leader><Leader>i :PlugInstall<CR>
nnoremap <Leader><Leader>u :PlugUpdate<CR>

call plug#begin('~/.vim/bundle')

let g:py_modules = []

Plug 'ctrlpvim/ctrlp.vim'
    nnoremap <C-B> :CtrlPBuffer<CR>
    nnoremap <C-P> :CtrlPMixed<CR>

    let g:ctrlp_working_path_mode='raw'
    let g:ctrlp_use_caching = 0

    let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:200'

Plug 'kovetskiy/SearchParty'
    nmap <silent> <Leader><Leader> :let @/=''<CR>
                \ <Plug>SearchPartyHighlightClear

"Plug 'junegunn/seoul256.vim'
    "au User BgLightPre let g:seoul256_background = 255|let g:colorscheme='seoul256'

Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'
    let g:airline_theme = 'term'
    let g:airline#extensions#whitespace#symbol = '☼'
    let g:airline_powerline_fonts = 1

Plug 'scrooloose/nerdcommenter'

Plug 'Valloric/YouCompleteMe'
    let g:ycm_key_list_previous_completion=['<UP>']
    let g:ycm_key_list_select_completion=['<DOWN>']

    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_collect_identifiers_from_comments_and_strings = 1

    let g:ycm_seed_identifiers_with_syntax = 1

Plug 'fatih/vim-go', { 'for': 'go' }
    let g:go_fmt_fail_silently = 0
    let g:go_fmt_command = "goimports"
    let g:go_fmt_autosave = 1
    let g:go_bin_path = $GOPATH . "/bin"
    let g:go_metalinter_command="gometalinter -D golint --cyclo-over 15"
    let g:go_list_type = "quickfix"

    nnoremap <C-]> :cN<CR>
    nnoremap <C-[> :cn<CR>
    nnoremap <C-Q> :cclose<CR>

    let g:go_doc_keywordprg_enabled = 0

    au filetype_go FileType go nmap <buffer> <Leader>f :GoFmt<CR>
    au filetype_go FileType go nmap <buffer> <Leader>h :GoDoc<CR>

Plug 'elzr/vim-json', { 'for': 'json' }
    augroup filetype_json
        au!
        au BufNewFile,BufRead *.json set filetype=json
    augroup end

Plug 'l9'

Plug 'seletskiy/matchem'
    let g:UltiSnipsJumpForwardTrigger="<C-J>"
    let g:UltiSnipsJumpBackwardTrigger="<C-K>"

Plug 'sirver/ultisnips'
    let g:UltiSnipsSnippetsDir = $HOME . '/.vim/bundle/snippets/'
    let g:UltiSnipsSnippetDirectories = [
    \     $HOME . '/.vim/bundle/snippets/',
    \     $HOME . '/.vim/UltiSnips/',
    \]
    let g:UltiSnipsEnableSnipMate = 0
    let g:UltiSnipsExpandTrigger="<TAB>"
    let g:UltiSnipsEditSplit="horizontal"

    nnoremap <C-S><C-E> :UltiSnipsEdit<CR>

    smap <C-E> <C-V><ESC>a
    smap <C-B> <C-V>o<ESC>i
    augroup textwidth_for_snippets
        au!
        au FileType snippets set textwidth=999
    augroup end

Plug 'reconquest/snippets', { 'for': ['go', 'ruby', 'python']}

Plug 'tpope/vim-surround'

Plug 'pangloss/vim-javascript', { 'for': 'js' }

Plug 'danro/rename.vim', { 'on': 'Rename' }
    nnoremap <Leader><Leader>r :noautocmd Rename<Space>

Plug 't9md/vim-choosewin', { 'on': [ 'ChooseWin', 'ChooseWinSwap' ] }
    let g:choosewin_overlay_enable = 1
    let g:choosewin_overlay_clear_multibyte = 1
    let g:choosewin_label = 'QWEASDIOPJKL'

    nnoremap <C-W><C-E> :ChooseWin<CR>
    nnoremap <C-W><C-S> :ChooseWinSwap<CR>

Plug 'seletskiy/vim-over'
    nmap L VH

    nnoremap H :OverCommandLine %s/<CR>
    vnoremap H :OverCommandLine s/<CR>

    let g:over#command_line#search#enable_move_cursor = 1
    let g:over#command_line#search#very_magic = 1

    au BufAdd,BufEnter * nnoremap / :OverCommandLine /<CR>
    au BufAdd,BufEnter * vnoremap / :'<,'>OverCommandLine /<CR>

    au User OverCmdLineExecute call searchparty#mash#mash()

    "let g:over_command_line_key_mappings={
        "\ "\<Space>": "."
    "\ }

Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
    augroup filetype_markdown
        au!
        au BufRead,BufNewFile *.md set filetype=markdown
    augroup end

Plug 'AndrewRadev/sideways.vim', { 'on': ['SidewayLeft', 'SidewayRight',
            \ 'SidewayJumpLight', 'SidewayRightJump']}

Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }

Plug 'terryma/vim-multiple-cursors'

Plug 'kshenoy/vim-signature'
    let g:SignatureMarkOrder = "\m"

Plug 'justinmk/vim-sneak'
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

Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
    vnoremap <C-T> :Tabularize /

Plug 'kovetskiy/urxvt.vim'
    au filetype_go FileType go nmap <buffer>
        \ <Leader>h :call urxvt#put('go build')<CR>

    function! KillFuckingQuickfixesAndDoFuckingBuild()
        let current_winnr = winnr()

        exe 'windo
            \ if &buftype == "quickfix" || &buftype == "locationlist"
            \     | lclose |
            \ endif
            \'

        exe current_winnr 'wincmd w'

        exe 'GoFmt'
        normal w
        exe 'GoBuild'
    endfunction!

    au filetype_go FileType go nmap <buffer> <silent>
        \ <Leader>b :call KillFuckingQuickfixesAndDoFuckingBuild()<CR>


Plug 'reconquest/vim-pythonx'
    au filetype_go FileType go nmap <buffer>
         \ <Leader>gc :py px.go.goto_const()<CR>

    au filetype_go FileType go nmap <buffer>
         \ <Leader>gt :py px.go.goto_type()<CR>

    au filetype_go FileType go nmap <buffer>
         \ <Leader>gv :py px.go.goto_var()<CR>

    au filetype_go FileType go nmap <buffer>
         \ <Leader>gl :py px.go.goto_prev_var()<CR>

    call add(g:py_modules, 'px.all')
    call add(g:py_modules, 'px.go')
    call add(g:py_modules, 'px.util')
    call add(g:py_modules, 'px.py')

Plug 'kovetskiy/vim-empty-lines'
    nnoremap <Leader><Leader>j :call DelEmptyLineBelow()<CR>
    nnoremap <Leader><Leader>k :call DelEmptyLineAbove()<CR>
    nnoremap <Leader>j :call AddEmptyLineBelow()<CR>
    nnoremap <Leader>k :call AddEmptyLineAbove()<CR>

Plug 'kovetskiy/vim-plugvim-utils', {'on': 'NewPlugFromClipboard'}
    nnoremap <Leader><Leader>c :call NewPlugFromClipboard()<CR>

Plug 'kovetskiy/vim-ski'
    let g:skeletons_dir=$HOME.'/.vim/skeletons/'

    augroup skeleton_git
        au BufRead *.git/COMMIT_EDITMSG call Skeleton()
        au BufRead,BufNewFile */bin/* set ft=sh
    augroup end

Plug 'bronson/vim-trailing-whitespace'
    let g:extra_whitespace_ignored_filetypes = [
        \ 'diff'
    \ ]

    function! MyWhitespaceFix()
        if ShouldMatchWhitespace()
            FixWhitespace
        endif
    endfunction!

    augroup whitespaces_remover
        au!
        au BufWritePre * call MyWhitespaceFix()
    augroup end

Plug 'seletskiy/vim-nunu'

Plug 'sjl/gundo.vim', { 'on': 'GundoShow' }

Plug 'blerins/flattown'

Plug 'kovetskiy/kb-train', { 'on': 'Train' }

Plug 'NLKNguyen/papercolor-theme'

Plug 'justinmk/vim-syntax-extra', { 'for': 'c' }

Plug 'seletskiy/ashium'

"Plug 'klen/python-mode'
    "let g:pymode_lint = 0
    "let g:pymode_lint_on_write = 0
    "let g:pymode_run = 0

Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }

Plug 'yssl/QFEnter'

Plug 'kovetskiy/next-indentation'
    nnoremap <Up> :IndentationGoUp<CR>
    nnoremap <Down> :IndentationGoDown<CR>

Plug 'rust-lang/rust.vim', {'for': 'rust' }

Plug 'rhysd/vim-go-impl'

Plug 'wellle/targets.vim'

Plug 'takac/vim-hardtime'
    let g:list_of_insert_keys = []
    let g:list_of_visual_keys = []
    let g:list_of_normal_keys = ["<Leader>r"]

    let g:hardtime_showerr = 1
    let g:hardtime_timeout = 5000
    let g:hardtime_default_on = 1

Plug 'kovetskiy/ycm-sh'

Plug 'lokikl/vim-ctrlp-ag'
    let g:grep_last_query = ""

    function! Grep(query)
        let g:grep_last_query = a:query

        let @/ = a:query
        call ctrlp#ag#exec(a:query)
    endfunction!

    function! GrepSlash()
        let l:slash = strpart(@/, 2)
        call Grep(l:slash)
    endfunction!

    function! GrepRestore()
        call Grep(g:grep_last_query)
    endfunction!

    command! -nargs=1 Grep call Grep(<q-args>)
    command! GrepSlash call GrepRestore()
    command! GrepRestore call GrepRestore()

    nnoremap <C-F> :Grep<Space>
    nnoremap <C-E><C-F> :GrepSlash<CR>
    nnoremap <C-E><C-G> :GrepRestore<CR>

call plug#end()

syntax on
filetype plugin indent on

set rtp-=~/.vim
set rtp^=~/.vim

set encoding=utf-8
set printencoding=cp1251
set fileformat=unix

set textwidth=79
set timeoutlen=400
set wildmenu

set undofile
set undodir=$HOME/.vim/undo/
set directory=$HOME/.vim/tmp/
set backupdir=$HOME/.vim/backup/
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
set showtabline=0
set cino=(s,m1,+0

set list
set lcs=eol:¶,trail:·,tab:\ \ "t

set pastetoggle=<F11>

augroup nofolding
    au!
    au VimEnter,WinEnter * set nofoldenable
augroup end

set noequalalways
set winminheight=0
set clipboard=unnamed

set tags=tags;/

augroup filetype_help
    au!
    au FileType help setlocal number
augroup end

augroup dir_autocreate
    au!
    au BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif
augroup end

augroup vimrc
    au!
    func! ReloadPythonModules()
        python <<CODE
import sys
modules = vim.eval('g:py_modules')
for module_name in modules:
    try:
        reload(sys.modules[module_name])
    except:
        pass
CODE
    endfunc!
    command! ReloadPythonModules call ReloadPythonModules()
    au BufWritePost ~/.vimrc source % | AirlineRefresh | ReloadPythonModules
augroup end

augroup mcabberrc
    au!
    au BufWritePost ~/.mcabber/mcabberrc !echo "/source ~/.mcabber/mcabberrc" > ~/.mcabber/mcabber.fifo
augroup end

augroup i3config
    au!
    au BufWritePost */.i3/config !i3-msg restart
augroup end

augroup hilight_over
    au!
    au VimResized,VimEnter * set cc=79
augroup end


augroup confluence
    au!
    au BufRead /tmp/vimperator-confluence* set ft=html.confluence | call HtmlBeautify()

    " trim empty <p><br/></p> from document
    au BufRead /tmp/vimperator-confluence* map <buffer> <Leader>t :%s/\v[\ \t\n]+\<p\>([\ \t\n]+\<br\>)?[\ \t\n]+\<\/p\>/<CR>

    " ugly hack to trim all inter-tags whitespaces
    au BufWritePre /tmp/vimperator-confluence* %s/\v\>[\ \t\n]+\</></
    au BufWritePost /tmp/vimperator-confluence* silent! undo
augroup end

map Q <nop>
map K <nop>

imap <C-F> tx<TAB>
vmap <C-F> ctx<TAB>

nnoremap <C-E><C-D> :cd %:p:h<CR>:pwd<CR>
nnoremap <C-E><C-F> :lcd %:p:h<CR>:pwd<CR>

nnoremap O O<Left><Right>
nnoremap o o<Left><Right>

nnoremap <Leader>o o<ESC>
nnoremap <Leader>O O<ESC>

nnoremap X S<ESC>
vnoremap $ g_

nnoremap > >>
nnoremap < <<

nnoremap <Leader>` :tabedit ~/.vimrc<CR>
nnoremap <Leader>% :so ~/.vimrc<CR>

vnoremap <silent> > >gv
vnoremap <silent> < <gv

inoremap jk <ESC>

nnoremap g< '<
nnoremap g> '>

nnoremap g. '>
nnoremap g, '<

nnoremap <Leader>vs :vsp<CR>

nnoremap <Leader>e :e!<CR>

nnoremap <Leader>r :w<CR>

nnoremap <Leader>n <ESC>:bdelete!<CR>
nnoremap <Leader>, <ESC>:qa!<CR>

nnoremap <Leader> :noh<CR>

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

nnoremap <Leader>] :tnext<CR>

nnoremap <C-T><C-T> :retab<CR>

nnoremap <C-E><C-E><C-R> :silent !rm -rf ~/.vim/view/*<CR>:redraw!<CR>

imap <C-A> <C-O>A

nmap <C-_> <C-W>_
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l

nmap <Leader>s :sp<Space>

imap <C-T> <C-R>=strpart(search("[)}\"'`\\]]", "c"), -1, 0)<CR><Right>

nmap <Leader>m O_ = "breakpoint"<ESC>

inoremap <C-H> <C-O>o

imap <C-U> <ESC>ua

fu! SetBg(bg)
    let bg = a:bg
    if bg == ""
        let bg = "light"
    endif

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

    if bg == "light"
        set background=light
        colorscheme PaperColor

        let g:airline_theme = 'sol'

        hi! underlined cterm=underline
        hi! CursorLineNr ctermfg=241 ctermbg=none
        hi! LineNr ctermfg=249 ctermbg=none
        hi! SignColumn ctermfg=none ctermbg=none
        hi! SpecialKey term=bold cterm=bold ctermfg=1 ctermbg=none
        hi! NonText ctermfg=254 cterm=none term=none
        hi! IncSearch cterm=none ctermfg=238 ctermbg=220
        hi! Cursor ctermbg=0 ctermfg=15
        hi! PmenuSel ctermbg=136 ctermfg=15 cterm=bold
    else
        set background=dark
        colorscheme flattown

        hi! underlined cterm=underline
        hi! CursorLineNr ctermfg=241 ctermbg=none
        hi! LineNr ctermfg=249 ctermbg=none
        hi! SignColumn ctermfg=none ctermbg=none
        hi! SpecialKey term=bold cterm=bold ctermfg=1 ctermbg=none
        hi! NonText ctermfg=238 cterm=none term=none
        hi! IncSearch cterm=none ctermfg=238 ctermbg=1
        hi! Cursor ctermbg=0 ctermfg=1
        hi! PmenuSel ctermbg=136 ctermfg=255 cterm=bold
    endif
endfu!

call SetBg($BACKGROUND)

noh

"nnoremap <ESC>w <ESC>:w<CR>

nnoremap <Leader>e :e!<Space>
nnoremap <Leader>ft :set filetype=

nmap <Tab> /
nmap K :s///g<CR><C-O>i

let @l="f(ak$%i,%"
let @k="^f=i:"
let @j="^t=x"
let @t=':%s/\t/    /g@t'

imap <C-Y> <Down>
cmap <C-F> <NOP>

vmap <Leader> S<Space><Space>
