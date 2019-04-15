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

augroup operations
    au!
augroup end

nnoremap <Leader><Leader>i :PlugInstall<CR>
nnoremap <Leader><Leader>u :PlugUpdate<CR>

augroup plugvim
    au!
call plug#begin('~/.vim/bundle')

" set up indent/vim.vim
let g:vim_indent_cont = shiftwidth()

let g:py_modules = []

Plug 'kovetskiy/vim-hacks'

Plug 'junegunn/fzf', {'do': './install --all'}
Plug 'kovetskiy/fzf.vim'
    let g:fzf_prefer_tmux = 1
    au operations FileType * let g:fzf#vim#default_layout  = {
        \ 'bottom': '10%',
        \ 'options': '--no-sort',
        \ 'extra_options': '--no-sort'}
    let $FZF_DEFAULT_COMMAND = 'prols'
    func! _ctrlp()
        call _snippets_stop()
        exec 'FZF'
    endfunc!

    func! _ctrlp_buffers()
        call _snippets_stop()
        exec 'Buffers'
    endfunc!

    nnoremap <C-G> :call _ctrlp_buffers()<CR>
    map <silent> <c-t> :call _ctrlp()<CR>

"Plug 'marijnh/tern_for_vim', {'for': 'javascript'}
    au operations BufNewFile,BufRead *.js setlocal noet

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
"if has('nvim')
  "Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  "set guicursor=
"else
  "Plug 'Shougo/deoplete.nvim'
"endif

"Plug 'fishbullet/deoplete-ruby'
"Plug 'roxma/nvim-yarp'
"Plug 'roxma/vim-hug-neovim-rpc'

"Plug 'zchee/deoplete-go', { 'do': 'make'}
"    let g:deoplete#enable_at_startup = 1
"
"    func! _setup_deoplete()
"        call deoplete#custom#source(
"            \ '_', 'min_pattern_length', 1)
"
"		call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
"		call deoplete#custom#source('_', 'sorters', [])
"
"        " unlimited candidate length
"		call deoplete#custom#source('_', 'max_kind_width', 0)
"		call deoplete#custom#source('_', 'max_menu_width', 0)
"		call deoplete#custom#source('_', 'max_abbr_width', 0)
"    endfunc!
"
"    augroup _setup_deoplete
"        au!
"        au VimEnter * call _setup_deoplete()
"    augroup end

Plug 'Valloric/YouCompleteMe'
"Plug 'kovetskiy/ycm-sh'
    let g:ycm_server_python_interpreter = '/usr/bin/python3'
    let g:ycm_show_diagnostics_ui = 0
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_key_list_previous_completion=['<UP>']
    let g:ycm_key_list_select_completion=['<DOWN>']

    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_collect_identifiers_from_comments_and_strings = 1

    let g:ycm_seed_identifiers_with_syntax = 1
    let g:ycm_use_ultisnips_completer = 0

"Plug 'maralla/completor.vim'
"    let g:completor_gocode_binary = $HOME . '/go/bin/gocode'
"    let g:completor_python_binary = '/usr/bin/python3'

Plug 'kovetskiy/synta'
    let g:synta_go_highlight_calls = 0
    let g:synta_go_highlight_calls_funcs = 1
    let g:synta_use_sbuffer = 0
    let g:synta_use_go_fast_build = 0
    let g:synta_go_build_recursive = 1

"if has('nvim')
    "Plug 'zchee/nvim-go', { 'do': 'make'}
"else

Plug 'fatih/vim-go', {'for': ['go', 'yaml']}
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

    au operations BufEnter *.yaml call _extend_yaml()

    let g:go_template_autocreate = 0

    let g:go_fmt_fail_silently = 0
    let g:go_fmt_command = "goimports"
    let g:go_fmt_autosave = 0
    let g:go_bin_path = $GOPATH . "/bin"
    let g:go_metalinter_command="golangci-lint run"
    let g:go_list_type = "quickfix"
    let g:go_auto_type_info = 0
    let g:go_gocode_autobuild = 1

    "let g:go_auto_type_info = 1
    "let go_auto_sameids = 1

    let g:go_doc_keywordprg_enabled = 0
    let g:go_def_mapping_enabled = 0
    let g:go_def_mode = 'guru'

    "let g:go_highlight_functions = 0

    "func! _remove_go_dummy_syn()
        "syn clear goImaginary
        "syn clear goImaginaryFloat
        "syn clear goFloat
        "syn clear goDecimalInt
        "syn clear goHexadecimalInt
        "syn clear goOctalInt
        "syn clear goOctalError

        "syn clear goSingleDecl
    "endfunc!

    "au operations BufEnter *.go call _remove_go_dummy_syn()

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

    au operations FileType go nmap <buffer><silent> <C-Q> :call _goto_prev_func()<CR>

    au operations FileType go let w:go_stack = 'fix that shit'
    au operations FileType go let w:go_stack_level = 'fix that shit'
    au operations FileType go nmap <silent><buffer> gd :GoDef<CR>
    au operations FileType go nmap <silent><buffer> gl :call go#def#Jump('vsplit')<CR>
    au operations FileType go nmap <silent><buffer> gk :call go#def#Jump('split')<CR>

    au operations FileType go nmap <silent><buffer> <c-p> :call synta#go#build()<CR>
    au operations FileType go imap <silent><buffer> <c-p> <ESC>:w<CR>:call synta#go#build()<CR>

    au operations FileType go nnoremap <Leader>r :GoRename<Space>
"endif


Plug 'elzr/vim-json', { 'for': 'json' }
    au operations BufNewFile,BufRead *.json set filetype=json
    au operations BufNewFile,BufRead *.yaml,*.yml setlocal ts=2 sts=2 sw=2 expandtab

Plug 'vim-scripts/l9'

"Plug 'kovetskiy/vim-cucu'
"Plug 'seletskiy/vim-nunu'
"Plug 'seletskiy/matchem'
"    au User _overwrite_matchem
"        \ au VimEnter,BufEnter,FileType *
"        \ inoremap <expr> <DOWN>  pumvisible() ? "\<C-N>" : "\<DOWN>"

"    au User _overwrite_matchem
"        \ au VimEnter,BufEnter,FileType *
"        \ inoremap <expr> <UP>    pumvisible() ? "\<C-P>" : "\<UP>"

"    doau User _overwrite_matchem

Plug 'cohama/lexima.vim'

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

    au operations FileType snippets set textwidth=0
    au operations FileType dockerfile set textwidth=0

Plug 'tpope/vim-surround'

Plug 'pangloss/vim-javascript', { 'for': 'js' }

Plug 'danro/rename.vim'
    nnoremap <Leader><Leader>r :noautocmd Rename<Space>


Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
    au operations BufRead,BufNewFile *.md set filetype=markdown
    au operations BufRead,BufNewFile *.md set fo-=l
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

"Plug 'kovetskiy/urxvt.vim'
    "au operations FileType go nmap <buffer>
        "\ <Leader>h :call urxvt#put('go build')<CR>


Plug 'reconquest/vim-pythonx'
    let g:pythonx_highlight_completion = 0

    vnoremap <C-x>v :python px.langs.go.transform.to_variable()<CR>



Plug 'reconquest/snippets'
    "au operations FileType go nmap <buffer>
         "\ <Leader>gc :py px.go.goto_const()<CR>

    "au operations FileType go nmap <buffer>
         "\ <Leader>gt :py px.go.goto_type()<CR>

    "au operations FileType go nmap <buffer>
         "\ <Leader>gv :py px.go.goto_var()<CR>

    "au operations FileType go nmap <buffer>
         "\ <Leader>gl :py px.go.goto_prev_var()<CR>

	au operations VimEnter * py
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

Plug 'kovetskiy/vim-empty-lines'
    nnoremap <silent> <Leader><Leader>j :call DelEmptyLineBelow()<CR>
    nnoremap <silent> <Leader><Leader>k :call DelEmptyLineAbove()<CR>
    nnoremap <silent> <Leader>j :call AddEmptyLineBelow()<CR>
    nnoremap <silent> <Leader>k :call AddEmptyLineAbove()<CR>

Plug 'kovetskiy/vim-plugvim-utils', {'on': 'NewPlugFromClipboard'}
    nnoremap <Leader><Leader>c :call NewPlugFromClipboard()<CR>

Plug 'kovetskiy/vim-ski'
    let g:skeletons_dir=$HOME . '/.vim/skeletons/'

    au operations BufRead,BufNewFile */bin/* set ft=sh

Plug 'bronson/vim-trailing-whitespace'
    let g:extra_whitespace_ignored_filetypes = [
        \ 'diff', 'markdown', 'go'
    \ ]

    func! _whitespaces_fix()
        if ShouldMatchWhitespace()
            FixWhitespace
        endif
    endfunc!

    au operations BufWritePre * call _whitespaces_fix()

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

    func! _tags_sh()
        if &ft != "sh"
            return
        endif

        let tagfiles = tagfiles()
        if len(tagfiles) > 0
            let tagfile = tagfiles[0]
            silent execute "!tags-sh " . tagfile . " >/dev/null 2>&1 &"
        endif
    endfunc!

    au operations BufWritePost * call _tags_sh()

"Plug 'seletskiy/vim-autosurround'
    "func! _ultisnips_enter()
        "let v:char="	"
        "call UltiSnips#TrackChange()
        "let v:char=""
        "call UltiSnips#TrackChange()
        "return """
    "endfunc!

    "nnoremap o o<C-R>=_ultisnips_enter()<CR>
    "nnoremap O O<C-R>=_ultisnips_enter()<CR>

    "au User _overwrite_matchem
        "\ au VimEnter,BufEnter,FileType *
        "\ inoremap <CR> <C-R>=g:MatchemExpandCr(1)<CR><C-R>=_ultisnips_enter()<CR>

    "au User _overwrite_matchem
        "\ au VimEnter,BufEnter,FileType *
        "\ inoremap <buffer> ( (<C-R>=AutoSurround(")") ? "" : g:MatchemMatchStart()<CR>

    "au User _overwrite_matchem
        "\ autocmd VimEnter,BufEnter,FileType * call AutoSurroundInitMappings()


    "au User plugins_loaded doau User _overwrite_matchem
    "doau User _overwrite_matchem


Plug 'FooSoft/vim-argwrap', {'on': 'ArgWrap'}
    au operations BufRead,BufNewFile *.go let b:argwrap_tail_comma = 1

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
    au operations FileType far_vim nmap <buffer> <Leader>d :Fardo<CR>

"Plug 'kovetskiy/vim-autoresize'

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
    \}
    let g:ale_linters = {
    \   'go': ['gobuild'],
    \}
    let g:ale_fix_on_save = 1
    " au operations BufRead,BufNewFile *.go


"Plug 'romainl/vim-cool'
Plug 'rhysd/vim-crystal'

Plug 'vim-ruby/vim-ruby'
func! _setup_ruby()
	setlocal shiftwidth=2
    setlocal cc=120
endfunc!

au operations BufRead,BufNewFile *.rb call _setup_ruby()

Plug 'ruby-formatter/rufo-vim'

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

    au operations FileType java call _setup_java()
    au operations FileType java nmap <silent><buffer> <c-p> :Make<CR>
    au operations FileType java nmap <silent><buffer> ; :cn<CR>
    au operations FileType java nmap <silent><buffer> <Leader>; :cN<CR>

Plug 'fvictorio/vim-extract-variable'

Plug 'lambdalisue/gina.vim'

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

au operations VimEnter,WinEnter,BufRead,BufNewFile * set nofoldenable
au operations VimEnter,WinEnter,BufRead,BufNewFile * au! matchparen

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
command! -bar Snapshot call _snapshot()

au operations BufWritePost ~/.vimrc
    \ source % | Snapshot

"au operations BufWritePost */.config/sxhkd/sxhkdrc silent !pkill -USR1 sxhkd
"au operations BufWritePost */.i3/config silent !i3-msg restart

set cc=80,100

au operations BufRead *.noml set ft=noml.dracula

au operations FileType html setlocal sw=2

au operations BufRead */.vimperator/*.vim,.vimperatorrc set ft=vimperator

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
inoremap <silent> <C-S> <Esc>:w<CR>

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

nmap <C-_> <C-W>_
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l

imap <C-E> <C-R>=strpart(search("[)}\"'`\\]]", "c"), -1, 0)<CR><Right>

inoremap <C-H> <C-O>o

imap <C-U> <ESC>ua

nnoremap Q qq
nnoremap @@ @q

au operations BufRead,BufNewFile ~/.zshrc set ft=zsh.sh
au operations BufRead,BufNewFile *.zsh    set ft=zsh.sh

au operations BufRead,BufNewFile *.service set noet ft=systemd
au operations BufRead,BufNewFile PKGBUILD set et ft=pkgbuild.sh
au operations BufRead incident.md set et ft=incident.markdown
au operations BufNewFile incident.md set et ft=incident|Skeleton|set ft=incident.markdown

au operations BufRead,BufNewFile *mcabberrc* set noet ft=mcabberrc.sh

au operations BufRead,BufNewFile *.snippets set noet ft=snippets.python
au operations BufRead,BufNewFile *.skeleton set noet ft=snippets.python

au operations BufRead,BufNewFile *.chart set noet ft=mermaid
au operations BufRead,BufNewFile task set noet ft=task

au operations WinEnter * wincmd =

nmap K :s///g<CR><C-O>i

func! _open_random()
    let filename = system("git ls-files *.go | sort -R | head -n 1")
    let current = expand("%:p:t")
    if current == filename
        call _open_random()
        return
    endif

    execute ":e " filename
endfunc!

nmap <silent> <Leader>m :call _open_random()<CR>

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

func! _macros_mode_toggle()
    if !get(g:, "macro_toggle_recording")
        let g:macro_toggle_recording = 0
    endif

    if g:macro_toggle_recording == 0
        normal qx
    else
        normal q
    endif

    let g:macro_toggle_recording = !g:macro_toggle_recording
endfunc!

func! DiffApplyTop()
    let start = line('.')
    call search(">>>>>>", "cs")
    let end = line('.')
    execute start.",".end "delete"
    call search("<<<<<", "bcs")
    execute "delete"
    nohlsearch
endfunc!

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

func! VerboseToggle()
     if !&verbose
        set verbosefile=~/.log/vim/verbose.log
        set verbose=15
    else
        set verbose=0
        set verbosefile=
    endif
endfunc!

command!
    \ Verbose
    \ call VerboseToggle()


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

func! _fzf_github()
    silent call system("fzf-github")
endfunc!

nnoremap <Leader>i :call _fzf_github()<CR>

func! _prompt_new_file_where_current_file()
    execute "normal :e"
endfunc!

nnoremap <Leader>x :vsp <C-R>=expand('%:h')<CR>/
nnoremap <Leader>t :vsp<Space>

func! _sys_read(cmdline)
    let l:result = system(a:cmdline)
    execute "normal" "a" . l:result
endfunc!

command! -nargs=1 SysRead call _sys_read("<args>")

noh
