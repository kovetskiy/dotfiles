set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !mkdir -p ~/.vim/autoload
  silent !curl -fLo ~/.vim/autoload/plug.vim
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

let g:plug_url_format = 'git@github.com:%s'
let g:plug_shallow = 0

let g:mapleader="\<Space>"
let mapleader=g:mapleader

augroup plugvim
    au!
call plug#begin('~/.vim/bundle')

" set up indent/vim.vim
let g:vim_indent_cont = shiftwidth()

let g:py_modules = []

Plug 'kovetskiy/vim-hacks'

Plug 'junegunn/fzf', {'do': './install --all'}
Plug 'junegunn/fzf.vim'
    let g:fzf_prefer_tmux = 1
    let g:fzf_layout = { 'right': '~40%' }

    func! _select_file()
        call _snippets_stop()
        call fzf#run(fzf#wrap({'source': 'prols', 'options': '--no-sort --no-exact'}))
    endfunc!

    func! _select_buffer()
        call _snippets_stop()
        call fzf#vim#buffers({'options': '--no-sort --no-exact'})
    endfunc!

    nnoremap <C-G> :call _select_buffer()<CR>
    map <silent> <c-t> :call _select_file()<CR>

"Plug 'marijnh/tern_for_vim', {'for': 'javascript'}
    augroup _js_settings
        au!
        au BufNewFile,BufRead *.js setlocal noet
    augroup end

Plug 'itchyny/lightline.vim'
    let g:lightline = {
      \ 'component_function': {
      \   'filename': '_relative_filename'
      \ }
      \ }

    function! _relative_filename()
      return expand('%')
    endfunction

    let g:lightline.enable = {
        \ 'statusline': 1,
        \ 'tabline': 0
        \ }

    if &background == "light"
        let g:lightline.colorscheme = 'PaperColor'
    else
    endif

        let g:lightline.colorscheme = 'wombat'


if $BACKGROUND == "dark"
    Plug 'reconquest/vim-colorscheme'
    func! _setup_colorscheme()
        colorscheme reconquest
    endfunc!
endif

Plug 'scrooloose/nerdcommenter'

func! LoadCompletion()
    if &ft == "java"
        return
    endif

    call plug#load('YouCompleteMe')
endfunc!

augroup Completion
    au!
    autocmd InsertEnter * call LoadCompletion() | autocmd! Completion
augroup end

Plug 'Valloric/YouCompleteMe', {'for': []}
    let g:ycm_server_python_interpreter = '/usr/bin/python3'
    let g:ycm_show_diagnostics_ui = 0
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_key_list_previous_completion=['<UP>']
    let g:ycm_key_list_select_completion=['<DOWN>']

    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_collect_identifiers_from_comments_and_strings = 1

    let g:ycm_seed_identifiers_with_syntax = 1
    let g:ycm_use_ultisnips_completer = 0

    let g:EclimCompletionMethod = 'omnifunc'

Plug 'kovetskiy/synta'
    let g:synta_go_highlight_calls = 0
    let g:synta_go_highlight_calls_funcs = 1
    let g:synta_use_sbuffer = 0
    let g:synta_use_go_fast_build = 0
    let g:synta_go_build_recursive = 1

Plug 'fatih/vim-go', {'for': ['go', 'yaml']}
    nnoremap <Leader><Leader>i :!go-install-deps<CR>

    func! _extend_yaml()
        if exists("b:yaml_extended")
            return
        endif


        runtime! syntax/yaml.vim
        if exists("b:current_syntax")
            unlet b:current_syntax
        endif
        runtime! syntax/gotexttmpl.vim

        let b:current_syntax = 'yaml'

        let b:yaml_extended = 1
    endfunc!

    augroup _yaml_settings
        au!
        au BufEnter *.yaml call _extend_yaml()
    augroup end

    let g:go_template_autocreate = 0

    let g:go_fmt_fail_silently = 0
    let g:go_fmt_command = "goimports"
    let g:go_fmt_autosave = 0
    let g:go_bin_path = $GOPATH . "/bin"
    let g:go_metalinter_command="golangci-lint run"
    let g:go_list_type = "quickfix"
    let g:go_auto_type_info = 0
    let g:go_gocode_autobuild = 1

    let g:go_doc_keywordprg_enabled = 0
    let g:go_def_mapping_enabled = 0
    let g:go_def_mode = 'guru'
    let g:go_info_mode = 'godef'


    func! _goto_prev_func()
        call search('^func ', 'b')
        nohlsearch
        normal zt
    endfunc!

    func! _goto_next_func()
        call search('^func ', '')
        nohlsearch
        normal zt
    endfunc!

    augroup _go_settings
        au!
        au FileType go nmap <buffer><silent> <C-Q> :call _goto_prev_func()<CR>

        au FileType go let w:go_stack = 'fix that shit'
        au FileType go let w:go_stack_level = 'fix that shit'
        au FileType go nmap <silent><buffer> gt :call go#def#Jump('', 1)<CR>
        au FileType go nmap <silent><buffer> gd :call go#def#Jump('', 0)<CR>
        au FileType go nmap <silent><buffer> gl :call go#def#Jump('vsplit', 0)<CR>
        au FileType go nmap <silent><buffer> gk :call go#def#Jump('split', 0)<CR>

        au FileType go nmap <silent><buffer> <c-p> :call synta#go#build()<CR>
        au FileType go imap <silent><buffer> <c-p> <ESC>:w<CR>:call synta#go#build()<CR>

        au FileType go nnoremap <Leader>r :GoRename<Space>
    augroup end


"Plug 'elzr/vim-json', { 'for': 'json' }
    augroup _json_settings
        au!
        au BufNewFile,BufRead *.json set filetype=json
        au BufNewFile,BufRead *.yaml,*.yml setlocal ts=2 sts=2 sw=2 expandtab
    augroup end

Plug 'vim-scripts/l9'

"Plug 'kovetskiy/vim-cucu'
"Plug 'seletskiy/vim-nunu'

" disabled because causes snippet args[] work incorrectly
"Plug 'seletskiy/matchem'
    au User _overwrite_matchem
        \ au VimEnter,BufEnter,FileType *
        \ inoremap <expr> <DOWN>  pumvisible() ? "\<C-N>" : "\<DOWN>"

    au User _overwrite_matchem
        \ au VimEnter,BufEnter,FileType *
        \ inoremap <expr> <UP>    pumvisible() ? "\<C-P>" : "\<UP>"

    doau User _overwrite_matchem

" need to press enter
"Plug 'rstacruz/vim-closer'
" lexima doesn't detect closing pair
"Plug 'cohama/lexima.vim'
" disabled due to weird behavior with {} the end bracket disappears
"Plug 'tmsvg/pear-tree'
    "let g:pear_tree_smart_openers = 0
    "let g:pear_tree_smart_closers = 0
    "let g:pear_tree_smart_backspace = 0
    "let g:pear_tree_pairs = {
    "  \ '(': {'closer': ')'},
    "  \ '[': {'closer': ']'},
    "  \ '{': {'closer': '}'},
    "  \ "'": {'closer': "'"},
    "  \ '"': {'closer': '"'}
    "  \ }

" breaks snippets
"Plug 'jiangmiao/auto-pairs'

" doesn't even add a new line in case of for{|} ENTER
"Plug 'Raimondi/delimitMate'

Plug 'sirver/ultisnips', { 'frozen': 1 }
    let g:UltiSnipsJumpForwardTrigger="<C-J>"
    let g:UltiSnipsJumpBackwardTrigger="<C-K>"

    let g:UltiSnipsUsePythonVersion = 2

    let g:snippets_dotfiles = $HOME . '/.vim/snippets/'
    let g:snippets_reconquest = $HOME . '/.vim/bundle/snippets/'

    let g:UltiSnipsSnippetDirectories = [
    \      g:snippets_reconquest,
	\      g:snippets_dotfiles,
    \]

    let g:UltiSnipsEnableSnipMate = 0
    let g:UltiSnipsExpandTrigger="<TAB>"
    let g:UltiSnipsEditSplit="horizontal"

    func! _snippets_stop()
        python "UltiSnips_Manager._leave_buffer()"
    endfunc!

    func! _snippets_get_filetype()
        let l:dot = strridx(&filetype, ".")
        if l:dot != -1
            return strpart(&filetype, 0, dot)
        endif

        return &filetype
    endfunc!

    func! _snippets_open_dotfiles()
        split
        execute "edit" g:snippets_dotfiles .
            \ _snippets_get_filetype() . ".snippets"
    endfunc!

    func! _snippets_open_reconquest()
        split
        execute "edit" g:snippets_reconquest .
            \ _snippets_get_filetype() .  ".snippets"
    endfunc!

    nnoremap <C-E><C-D> :call _snippets_open_dotfiles()<CR>
    nnoremap <C-E><C-S> :call _snippets_open_reconquest()<CR>

    smap <C-E> <C-V><ESC>a
    smap <C-B> <C-V>o<ESC>i

    augroup _disable_textwidth
        au!
        au FileType snippets set textwidth=0
        au FileType dockerfile set textwidth=0
    augroup end

Plug 'tpope/vim-surround'

Plug 'pangloss/vim-javascript', { 'for': 'js' }

Plug 'danro/rename.vim'
    nnoremap <Leader><Leader>r :noautocmd Rename<Space>


Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
    augroup _md_settings
        au!
        au BufRead,BufNewFile *.md set filetype=markdown
        au BufRead,BufNewFile *.md set fo-=l
    augroup end
    let g:vim_markdown_folding_disabled=0

Plug 'AndrewRadev/sideways.vim'
    nnoremap <leader>h :SidewaysLeft<cr>
    "nnoremap <leader>l :SidewaysRight<cr>


Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }

"Plug 'terryma/vim-multiple-cursors'
    "function! Multiple_cursors_before()
        "let b:deoplete_disable_auto_complete = 1
    "endfunction

    "function! Multiple_cursors_after()
        "let b:deoplete_disable_auto_complete = 0
    "endfunction

Plug 'justinmk/vim-sneak'
    " bullshit
    nmap <nop><C-E><C-S>S <Plug>Sneak_s
    vmap <nop><C-E><C-S>s <Plug>Sneak_s
    nmap <C-E><C-S><C-S> <Plug>Sneak_S
    vmap <C-E><C-S><C-S> <Plug>Sneak_S

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


Plug 'reconquest/vim-pythonx'
    let g:pythonx_highlight_completion = 0

    vnoremap <C-x>v :python px.langs.go.transform.to_variable()<CR>



Plug 'reconquest/snippets'
    augroup _snippets_reload
        au!
        au VimEnter * py
            \   import vim;
            \   import px;
            \   import snippets;
            \   [
            \       vim.command("call add(g:py_modules, '%s')" % library)
            \       for library in px.libs()
            \   ]
            \   and
            \   [
            \       vim.command("call add(g:py_modules, '%s')" % library)
            \       for library in px.libs('snippets')
            \   ]
    augroup end

Plug 'kovetskiy/vim-empty-lines'
    nnoremap <silent> <Leader><Leader>j :call DelEmptyLineBelow()<CR>
    nnoremap <silent> <Leader><Leader>k :call DelEmptyLineAbove()<CR>
    nnoremap <silent> <Leader>j :call AddEmptyLineBelow()<CR>
    nnoremap <silent> <Leader>k :call AddEmptyLineAbove()<CR>

Plug 'kovetskiy/vim-plugvim-utils', {'on': 'NewPlugFromClipboard'}
    nnoremap <Leader><Leader>c :call NewPlugFromClipboard()<CR>

Plug 'kovetskiy/vim-ski'
    let g:skeletons_dir=$HOME . '/.vim/skeletons/'

    augroup _sh_filetype
        au!
        au BufRead,BufNewFile */bin/* set ft=sh
    augroup end

Plug 'bronson/vim-trailing-whitespace'
    let g:extra_whitespace_ignored_filetypes = [
        \ 'diff', 'markdown', 'go'
    \ ]

    func! _whitespaces_fix()
        if ShouldMatchWhitespace()
            FixWhitespace
        endif
    endfunc!

    augroup _whitespace_auto
        au!
        au BufWritePre * call _whitespaces_fix()
    augroup end

Plug 'sjl/gundo.vim', { 'on': 'GundoShow' }

Plug 'kovetskiy/kb-train', { 'on': 'Train' }

if $BACKGROUND == "light"
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'sonph/onehalf', {'rtp': 'vim/'}

    func! _setup_colorscheme()
        set background="light"
        "colorscheme PaperColor
        colorscheme onehalflight

        hi! SpecialKey ctermfg=250
        hi! String ctermfg=33
        hi! PreProc ctermfg=19
    endfunc!
endif

Plug 'justinmk/vim-syntax-extra', { 'for': 'c' }

Plug 'seletskiy/ashium'

"Plug 'klen/python-mode', {'for': 'python'}
"    let g:pymode_rope_complete_on_dot = 0
"    let g:pymode_lint = 1
"    let g:pymode_lint_on_write = 1
"    let g:pymode_run = 0
"    let g:pymode_rope_lookup_project = 0
"    let g:pymode_rope_project_root = $HOME . '/ropeproject/'
"    let g:pymode_folding = 0

"Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }

Plug 'yssl/QFEnter'

Plug 'kovetskiy/next-indentation'
    nnoremap <C-z> :IndentationSameUp<CR>
    nnoremap <C-x> :IndentationSameDown<CR>

Plug 'rust-lang/rust.vim', {'for': 'rust' }

Plug 'rhysd/vim-go-impl'

Plug 'wellle/targets.vim'

"Plug 'kovetskiy/ycm-sh', {'for': 'sh'}

"Plug 'lokikl/vim-ctrlp-ag'
    let g:grep_last_query = ""

    func! _grep(query)
        let g:grep_last_query = a:query

        let @/ = a:query
        call fzf#vim#ag(a:query, {'options': '--delimiter : --nth 4..'})
    endfunc!

    func! _grep_word()
        let l:word = expand('<cword>')
        call _grep(l:word)
    endfunc!

    func! _grep_slash()
        let l:slash = strpart(@/, 2)
        call _grep(l:slash)
    endfunc!

    func! _grep_recover()
        call _grep(g:grep_last_query)
    endfunc!

    command! -nargs=* Grep call _grep(<q-args>)

    nnoremap <C-F> :Grep<CR>
    nnoremap <C-E><C-F> :call _grep_word()<CR>

Plug 'kovetskiy/vim-bash'
    nmap gd <C-]>

    "func! _tags_sh()
    "    if &ft != "sh"
    "        return
    "    endif

    "    let tagfiles = tagfiles()
    "    if len(tagfiles) > 0
    "        let tagfile = tagfiles[0]
    "        silent execute "!tags-sh " . tagfile . " >/dev/null 2>&1 &"
    "    endif
    "endfunc!

    "augroup _sh_tags
    "    au!
    "    au BufWritePost * call _tags_sh()
    "augroup end


Plug 'FooSoft/vim-argwrap', {'on': 'ArgWrap'}
    augroup _go_argwarap
        au!
        au BufRead,BufNewFile *.go let b:argwrap_tail_comma = 1
    augroup end

    func! _search_wrappable()
        let l:bracket = '\([^\)]'
        let l:squares = '\[[^\]]'
        let l:braces  = '\{[^\}]'
        let l:pattern = '\v[^ ](' . l:bracket . '|' . l:squares . '|' . l:braces . ')'

        call search(l:pattern, 'cs')
    endfunc!
    nnoremap <silent> @l :call _search_wrappable()<CR>ll:ArgWrap<CR>
    nnoremap <silent> @; :ArgWrap<CR>
    func! _chain_wrap()
        let match = search(').', 'cs', line('.'))
        if match == 0
            return
        endif
        call cursor(match, 0)
        exec "normal" "lli\r"
        call _chain_wrap()
    endfunc!

    nnoremap <silent> @h :call _chain_wrap()<CR>

Plug 'kovetskiy/sxhkd-vim'

Plug 'PotatoesMaster/i3-vim-syntax', {'for': 'i3'}

Plug 'brooth/far.vim'
    nmap <Leader>a :Farp<CR>
    augroup _far_settings
        au!
        au FileType far_vim nmap <buffer> <Leader>d :Fardo<CR>
    augroup end

Plug 'reconquest/vim-autosurround'
Plug 'kovetskiy/vim-autoresize'

Plug 'ddrscott/vim-side-search'
    nnoremap <Leader>s :SideSearch<space>

    func! _random_line()
        execute 'normal! '.(system('/bin/bash -c "echo -n $RANDOM"') % line('$')).'G'
        normal zz
    endfunc!

    noremap <silent> <Tab>   :bNext<CR>:call _random_line()<CR>
    noremap <silent> <S-Tab> :bprev<CR>:call _random_line()<CR>

Plug 'lambdalisue/gina.vim'

Plug 'kovetskiy/ale'
    func! _ale_gotags()

    endfunc!
    let g:ale_enabled = 0

    let g:ale_fixers = {
    \   'go': [function("synta#ale#goimports#Fix"), function("synta#ale#goinstall#Fix")],
    \   'ruby': [function('ale#fixers#rufo#Fix')],
    \   'java': [function('ale#fixers#google_java_format#Fix')],
    \}
    let g:ale_linters = {
    \   'go': ['gobuild'],
    \}

    let g:ale_fix_on_save = 1
    augroup _java_codestyle
        au!
        au BufRead,BufNewFile *.java
            \ call ale#Set('google_java_format_options',
            \ '--skip-removing-unused-imports --skip-sorting-imports')
    augroup end


Plug 'mg979/vim-visual-multi'
    let g:VM_no_meta_mappings = 1
    let g:VM_maps = {
    \ 'Select All': '<C-A>',
    \ }
    let g:VM_leader = "\\"

    fun! VM_before_auto()
        call MacroBefore()
    endfun

    fun! VM_after_auto()
        call MacroAfter()
    endfun

    function! MacroBefore(...)
        unmap f
        unmap F
        unmap t
        unmap T
        unmap ,
        unmap ;
    endfunction!

    function! MacroAfter(...)
        map f <Plug>Sneak_f
        map F <Plug>Sneak_F
        map t <Plug>Sneak_t
        map T <Plug>Sneak_T
        map , <Plug>Sneak_,
        map ; <Plug>Sneak_;
    endfunction!

Plug 'tmhedberg/matchit'

Plug 'pangloss/vim-javascript'

Plug 'markonm/traces.vim'
    nnoremap M :%s/\C\V<C-R>=expand('<cword>')<CR>/
    nnoremap H :%s/\v
    vnoremap H :s/\v
    nmap L VH

Plug 'lambdalisue/gina.vim'
    let g:gina#command#blame#formatter#format="%su%=%au on %ti %ma%in"

Plug 'tpope/vim-dispatch'

    func! _setup_java()
        setlocal errorformat=[ERROR]\ %f:[%l\\,%v]\ %m
    endfunc!

    augroup _java_bindings
        au!
        au FileType java call _setup_java()
        au FileType java let b:dispatch = 'make'
        "au FileType java nmap <silent><buffer> <c-p> :Dispatch<CR>
        au FileType java nmap <silent><buffer> <c-a> :ALEFix<CR>
        au FileType java nmap <silent><buffer> <c-p> :JavaImportOrganize<CR>
        au FileType java nmap <silent><buffer> gd :JavaDocSearch<CR>
        au FileType java nmap <silent><buffer> ; :cn<CR>
        au FileType java nmap <silent><buffer> <Leader>; :cN<CR>
    augroup end

Plug 'fvictorio/vim-extract-variable'

Plug 'lambdalisue/gina.vim'

Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}, 'for': ['java']}

Plug 'wakatime/vim-wakatime'

Plug 'ap/vim-buftabline'

augroup end

call plug#end()

au VimEnter * au! plugvim

set rtp-=~/.vim
set rtp^=~/.vim

syntax on
filetype plugin indent on

set shortmess+=sAIc

set encoding=utf-8
set printencoding=cp1251
set fileformat=unix

set textwidth=79
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
set norelativenumber

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
let g:updatetime=150
set updatetime=150

set timeoutlen=400
set showtabline=0
set cino=(s,m1,+0

set list
set lcs=trail:·,tab:→\ "

set pastetoggle=<F11>

augroup _foldings
    au!
    au VimEnter,WinEnter,BufRead,BufNewFile * set nofoldenable
    au VimEnter,WinEnter,BufRead,BufNewFile * au! matchparen
augroup end

set noequalalways
set winminheight=0
set clipboard=unnamed

set tags=./.tags;/

if has('nvim')
    set viminfo+=n~/.vim/runtime/neoviminfo
else
    set viminfo+=n~/.vim/runtime/viminfo
endif

au FileType help setlocal number

au BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif


func! _snapshot()
   silent execute "!vim-bundle-save >/dev/null 2>&1 &"
endfunc!

augroup _snapshot
    au!
    au BufWritePost ~/.vimrc call _snapshot()
augroup end

set cc=80,100

map Q <nop>
map K <nop>

imap <C-F> tx<TAB>
vmap <C-F> ctx<TAB>

imap <C-D> context.

"nnoremap <C-E><C-D> :cd %:p:h<CR>:pwd<CR>

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

nnoremap <Leader>q <ESC>:q<CR>
nnoremap <silent> <C-S> :w<CR>
"inoremap <silent> <C-S> <Esc>:w<CR>

nnoremap <Leader>n <ESC>:bdelete!<CR>
nnoremap <Leader>q <ESC>:qa!<CR>

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

"nnoremap <C-T><C-T> :retab<CR>

nnoremap <C-E><C-E><C-R> :silent !rm -rf ~/.vim/view/*<CR>:redraw!<CR>

imap <C-A> <C-O>A

nmap <C-_> <C-W>=
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l

imap <C-J> <nop>

imap <C-E> <C-R>=strpart(search("[)}\"'`\\]]", "c"), -1, 0)<CR><Right>

inoremap <C-H> <C-O>o

imap <C-U> <ESC>ua

nnoremap Q qq
nnoremap @@ @q

augroup _zsh_filetype
    au!
    au BufRead,BufNewFile ~/.zshrc set ft=zsh.sh
    au BufRead,BufNewFile *.zsh    set ft=zsh.sh
augroup end

augroup _filetypes
    au!
    au BufRead,BufNewFile *.service set noet ft=systemd
    au BufRead,BufNewFile PKGBUILD set et ft=pkgbuild.sh
    au BufRead,BufNewFile *.snippets set noet ft=snippets.python
    au BufRead,BufNewFile *.skeleton set noet ft=snippets.python
    au BufRead,BufNewFile *.chart set noet ft=mermaid
augroup end

"augroup _window_size
"    au!
"    au WinEnter * wincmd =
"augroup end

nmap K :s///g<CR><C-O>i

let @k="^f=i:"
let @j="^t=x"

func! _tab_space()
    keepjumps %s/\t/    /
    normal ''
endfunc!

nmap @t :call _tab_space()<CR>

imap <C-Y> <Down>
cmap <C-F> <NOP>

vmap <Leader> S<Space><Space>

func! DiffApplyBottom()
    let start = line('.')
    call search("<<<<<", "bcs")
    let end = line('.')
    execute start.",".end "delete"
    call search(">>>>>", "bcs")
    execute "delete"
    nohlsearch
endfunc!

func! DiffEnable()
    nmap <buffer> <C-F><C-D> :Grep '\=\=\=\=\=\=\='<CR><CR>
    nmap <buffer> rr :/=====<CR>zz:noh<CR>
    nmap <buffer> rk :call DiffApplyTop()<CR>rr
    nmap <buffer> rj :call DiffApplyBottom()<CR>rr
endfunc!

command!
    \ Diff
    \ call DiffEnable()

let g:profiling = 0
func! ProfileToggle()
    if g:profiling == 0
        let g:profiling = 1
        profile start /tmp/profile
        profile func *
        profile file *
    else
        let g:profiling = 0
        profile pause
    endif
endfunc!

command!
    \ Profile
    \ call ProfileToggle()

nmap Y yy

map <leader>y "0y
map <leader>p "0p

augroup setup_colorscheme
    au!
    au VimEnter * call _setup_colorscheme()
augroup end

nnoremap <silent> <Leader>/ :noh<CR>
nnoremap <leader>f /\v^func\s+.*\zs

func! _get_github_link()
    silent call system("github-link " . expand('%:p') . " " . line('.'))
endfunc!

nnoremap <Leader>g :call _get_github_link()<CR>

nnoremap <Leader>x :vsp <C-R>=expand('%:h')<CR>/
nnoremap <Leader>t :vsp<Space>

func! _sys_read(cmdline)
    let l:result = system(a:cmdline)
    execute "normal" "a" . l:result
endfunc!

command! -nargs=1 SysRead call _sys_read("<args>")

set makeprg="make"

noh
