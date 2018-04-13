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
    "let g:fzf_prefer_tmux = 1
    au operations FileType * let g:fzf#vim#default_layout  = {'bottom': '10%'}
    let $FZF_DEFAULT_COMMAND = 'ctrlp-search'
    func! _ctrlp()
        call _snippets_stop()
        exec 'FZF'
    endfunc!
    map <silent> <c-e><c-p> :call _ctrlp()<CR>

Plug 'marijnh/tern_for_vim', {'for': 'js'}
    au operations BufNewFile,BufRead *.js setlocal noet

"Plug 'itchyny/lightline.vim'
    "let g:lightline = {}

    "let g:lightline.enable = {
        "\ 'statusline': 1,
        "\ 'tabline': 0
        "\ }

    "if &background == "light"
        "let g:lightline.colorscheme = 'Tomorrow'
    "else
        "let g:lightline.colorscheme = 'wombat'
    "endif


if $BACKGROUND == "dark"
    Plug 'reconquest/vim-colorscheme'
    func! _setup_colorscheme()
        colorscheme reconquest
    endfunc!
endif

Plug 'scrooloose/nerdcommenter'
    vmap L <Plug>NERDCommenterAlignLeft

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  set guicursor=
else
endif

Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

Plug 'zchee/deoplete-go', { 'do': 'make'}
    let g:deoplete#enable_at_startup = 1

    func! _setup_deoplete()
        call deoplete#custom#source(
            \ '_', 'min_pattern_length', 1)

		call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
		call deoplete#custom#source('_', 'sorters', [])

        " unlimited candidate length
		call deoplete#custom#source('_', 'max_kind_width', 0)
		call deoplete#custom#source('_', 'max_menu_width', 0)
		call deoplete#custom#source('_', 'max_abbr_width', 0)
    endfunc!

    augroup _setup_deoplete
        au!
        au VimEnter * call _setup_deoplete()
    augroup end

Plug 'kovetskiy/synta'
    let g:synta_go_highlight_calls = 0
    let g:synta_go_highlight_calls_funcs = 1

"if has('nvim')
    "Plug 'zchee/nvim-go', { 'do': 'make'}
"else
Plug 'fatih/vim-go', {'for': 'go'}
    let g:go_fmt_fail_silently = 0
    let g:go_fmt_command = "goimports"
    let g:go_fmt_autosave = 0
    let g:go_bin_path = $GOPATH . "/bin"
    let g:go_metalinter_command="gometalinter -D golint --cyclo-over 15"
    let g:go_list_type = "quickfix"

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
    au operations FileType go nmap <buffer><silent> <C-A> :call _goto_next_func()<CR>

    au operations FileType go let w:go_stack = 'fix that shit'
    au operations FileType go let w:go_stack_level = 'fix that shit'
    au operations FileType go nmap <silent><buffer> gd :GoDef<CR>
    au operations FileType go nmap <silent><buffer> gl :call go#def#Jump('vsplit')<CR>
    au operations FileType go nmap <silent><buffer> gk :call go#def#Jump('split')<CR>

    au operations FileType go nmap <silent><buffer> <c-p> :call synta#go#build()<CR>
    au operations FileType go imap <silent><buffer> <c-p> <ESC>:w<CR>:call synta#go#build()<CR>
"endif


Plug 'elzr/vim-json', { 'for': 'json' }
    au operations BufNewFile,BufRead *.json set filetype=json

Plug 'vim-scripts/l9'

"Plug 'kovetskiy/vim-cucu'
"Plug 'seletskiy/vim-nunu'
Plug 'seletskiy/matchem'
    let g:UltiSnipsJumpForwardTrigger="<C-J>"
    let g:UltiSnipsJumpBackwardTrigger="<C-K>"

    au User _overwrite_matchem
        \ au VimEnter,BufEnter,FileType *
        \ inoremap <expr> <DOWN>  pumvisible() ? "\<C-N>" : "\<DOWN>"

    au User _overwrite_matchem
        \ au VimEnter,BufEnter,FileType *
        \ inoremap <expr> <UP>    pumvisible() ? "\<C-P>" : "\<UP>"

    doau User _overwrite_matchem

Plug 'sirver/ultisnips', { 'frozen': 1 }
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

Plug 'tpope/vim-surround'

Plug 'pangloss/vim-javascript', { 'for': 'js' }

Plug 'danro/rename.vim'
    nnoremap <Leader><Leader>r :noautocmd Rename<Space>

Plug 'kovetskiy/SearchParty'


if has('nvim')
    set inccommand=nosplit
    nnoremap H :%s/\v
    nnoremap L V:%s/\v
    vnoremap H :s/

    nnoremap M :%s/\C\V<C-R><C-W>/
else
    Plug 'seletskiy/vim-over'
        let g:over#command_line#search#enable_move_cursor = 1
        let g:over#command_line#search#very_magic = 1

        nmap L VH

        nnoremap M :exec 'OverExec' '%s/\C\V' . expand('<cword>') . '/'<CR>
        nnoremap H :OverExec %s/<CR>
        vnoremap H :OverExec s/<CR>

        nmap <Leader><Leader> :call _search_clear_highlighting()<CR>
        noremap n :call _search_cursorhold_register()<CR>n
        noremap N :call _search_cursorhold_register()<CR>N

        au operations User OverCmdLineExecute call _over_autocmd()

        augroup _search_cursorhold_events
            au!
        augroup end

        func! _search_clear_highlighting()
            call searchparty#mash#unmash()
            call feedkeys(":nohlsearch\<CR>")
            "nohlsearch
        endfunc!

        func! _search_cursorhold_do()
            if &updatetime != g:updatetime
                exec "set updatetime =" . g:updatetime
            endif

            augroup _search_cursorhold_events
                au!
            augroup end

            call _search_clear_highlighting()
        endfunc!

        func! _search_cursorhold_register()
            set updatetime=3000

            augroup _search_cursorhold_events
                au!
                au CursorHold * call _search_cursorhold_do()
            augroup end

            call searchparty#mash#mash()
        endfunc!

        let g:over_exec_autocmd_skip = 0
        func! _over_autocmd()
            if g:over_exec_autocmd_skip
                let g:over_exec_autocmd_skip = 0
                return
            endif

            call searchparty#mash#mash()
        endfunc!


        func! _over_exec(line1, line2, args)
            call _search_cursorhold_register()

            let g:over#command_line#search#enable_move_cursor = 1

            try
                call over#command_line(
                \   g:over_command_line_prompt,
                \   a:line1 != a:line2 ? printf("'<,'>%s", a:args) : a:args
                \)
            catch
                call _over_exec(a:line1, a:line2, a:args)
            endtry

        endfunc!

        command! -range -nargs=* OverExec call _over_exec(<line1>, <line2>, <q-args>)

        nmap <Plug>(OverExec) :OverExec<CR>

        func! s:_over_exec_do(args)
            let g:over_exec_autocmd_skip = 1
            let g:over#command_line#search#enable_move_cursor = 0
            call feedkeys("\<CR>" . a:args . "\<Plug>(OverExec)\<Up>")
        endfunc!

        func! _over_next()
            call s:_over_exec_do("n")
            return ""
        endfunc!

        let g:over_command_line_key_mappings = {
            \ "\<C-F>": ".",
            \ "\<C-E>": '\w+',
            \ "\<C-O>": ".*",
            \ "\<C-L>": "\\zs",
            \
            \ "\<C-K>": "\<Left>\\\<Right>",
            \ "\<C-D>": "\<Left>\<BackSpace>\<Right>",
            \
            \ "\<C-N>" : {
            \ 	"key" : "_over_next()",
            \   "expr": 1,
            \ 	"noremap" : 1,
            \ 	"lock" : 1,
            \ },
        \ }
endif

Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
    au operations BufRead,BufNewFile *.md set filetype=markdown
    au operations BufRead,BufNewFile *.md set fo-=l

Plug 'AndrewRadev/sideways.vim'
    nnoremap <leader>h :SidewaysLeft<cr>
    nnoremap <leader>l :SidewaysRight<cr>


Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }

Plug 'terryma/vim-multiple-cursors'
    function! Multiple_cursors_before()
        let b:deoplete_disable_auto_complete = 1
    endfunction

    function! Multiple_cursors_after()
        let b:deoplete_disable_auto_complete = 0
    endfunction

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
    Plug 'nightsense/seagrey'
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim'}

    func! _setup_colorscheme()
        set background="light"
        colorscheme PaperColor
    endfunc!
endif

Plug 'justinmk/vim-syntax-extra', { 'for': 'c' }

Plug 'seletskiy/ashium'

Plug 'klen/python-mode', {'for': 'python'}
    let g:pymode_lint = 0
    let g:pymode_lint_on_write = 0
    let g:pymode_run = 0
    let g:pymode_rope_lookup_project = 0
    let g:pymode_rope_project_root = $HOME . '/ropeproject/'
    let g:pymode_folding = 0

Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }

Plug 'yssl/QFEnter'

Plug 'kovetskiy/next-indentation'
    nnoremap <C-z> :IndentationSameUp<CR>
    nnoremap <C-x> :IndentationSameDown<CR>

Plug 'rust-lang/rust.vim', {'for': 'rust' }

Plug 'rhysd/vim-go-impl'

Plug 'wellle/targets.vim'

Plug 'kovetskiy/ycm-sh', {'for': 'sh'}

"Plug 'lokikl/vim-ctrlp-ag'
    let g:grep_last_query = ""

    func! _grep(query)
        let g:grep_last_query = a:query

        let @/ = a:query
        call fzf#vim#ag(a:query, fzf#vim#layout(0))
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
    nnoremap <C-G> :call _grep_recover()<CR>

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

Plug 'vitalk/vim-simple-todo', {'for': 'markdown'}
    let g:simple_todo_map_keys = 1
    let g:simple_todo_map_insert_mode_keys = 0
    let g:simple_todo_map_visual_mode_keys = 0
    let g:simple_todo_map_normal_mode_keys = 1

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

Plug 'w0rp/ale'
    func! _ale_gotags()

    endfunc!
    let g:ale_enabled = 0

    let g:ale_fixers = {
    \   'go': [function("synta#ale#goimports#Fix")],
    \}
    let g:ale_linters = {
    \   'go': ['gobuild'],
    \}
    let g:ale_fix_on_save = 1
    " au operations BufRead,BufNewFile *.go


Plug 'romainl/vim-cool'

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
set undodir=$HOME/.vim/undo/
set directory=$HOME/.vim/tmp/
set backupdir=$HOME/.vim/backup/
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
set lcs=trail:·,tab:⇢\ "

set pastetoggle=<F11>

au operations VimEnter,WinEnter,BufRead,BufNewFile * set nofoldenable
au operations VimEnter,WinEnter,BufRead,BufNewFile * au! matchparen

set noequalalways
set winminheight=0
set clipboard=unnamed

set tags=./.tags;/

if has('nvim')
    set viminfo+=n~/.vim/info/neoviminfo
else
    set viminfo+=n~/.vim/info/viminfo
endif

au FileType help setlocal number

au BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif


func! _snapshot()
   silent execute "!vim-bundle-save >/dev/null 2>&1 &"
endfunc!
command! -bar Snapshot call _snapshot()

au operations BufWritePost ~/.vimrc
    \ source % | Snapshot

au operations BufWritePost */.config/sxhkd/sxhkdrc silent !pkill -USR1 sxhkd
au operations BufWritePost */.i3/config silent !i3-msg restart

au operations VimResized,VimEnter * set cc=79

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

augroup setup_colorscheme
    au!
    au VimEnter * call _setup_colorscheme()
augroup end

nnoremap <silent> <Leader>/ :noh<CR>

func! _get_github_link()
    silent call system("github-link " . expand('%:p') . " " . line('.'))
endfunc!

nnoremap <Leader>g :call _get_github_link()<CR>

noh
