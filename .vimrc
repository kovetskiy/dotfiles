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
    au operations FileType * let g:fzf#vim#default_layout  = {'bottom': '10%'}

Plug 'nixprime/cpsm', {'do': './install.sh' }
Plug 'ctrlpvim/ctrlp.vim'

    func! _ctrlp_buffer_add_augroup()
        augroup _ctrlp_buffer_bufenter
            au!
            au BufEnter * exe "wincmd" "_" |
                        \ call _ctrlp_buffer_remove_augroup()
        augroup end
    endfunc!

    func! _ctrlp_buffer_remove_augroup()
        augroup _ctrlp_buffer_bufenter
            au!
        augroup end
    endfunc!

    func! _ctrlp_buffer()
        CtrlPBuffer
        call _ctrlp_buffer_add_augroup()
    endfunc!

    func! _ctrlp()
        call _snippets_stop()
        CtrlP
    endfunc!

    nnoremap <C-B> :call _ctrlp_buffer()<CR>

    let g:ctrlp_working_path_mode='ra'
    let g:ctrlp_user_command = 'ctrlp-search %s'
    let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:50'
    let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}

    "let g:ctrlp_max_depth = 10

    let g:ctrlp_clear_cache_on_exit = 1
    let g:ctrlp_use_caching = 0
    let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp.vim'

    hi! def link CtrlPMatch Search

    let g:ctrlp_map = '<nop>'
    map <silent> <C-P> :call _ctrlp()<CR>

"Plug 'junegunn/seoul256.vim'
    "au User BgLightPre let g:seoul256_background = 255|let g:colorscheme='seoul256'

Plug 'marijnh/tern_for_vim', {'for': 'js'}
    au operations BufNewFile,BufRead *.js setlocal noet

Plug 'vim-airline/vim-airline-themes'

Plug 'vim-airline/vim-airline'
    let g:airline#extensions#wordcount#enabled = 0
    let g:airline#extensions#whitespace#symbol = '☼'
    let g:airline_powerline_fonts = 1
    let g:airline_skip_empty_sections = 1
    let g:airline#extensions#whitespace#checks = ['indent', 'trailing']

Plug 'reconquest/vim-colorscheme'
    let g:airline_theme = 'reconquest'

Plug 'scrooloose/nerdcommenter'
    vmap L <Plug>NERDCommenterAlignLeft

"Plug 'jeaye/color_coded', {'for': 'c'}

Plug 'Valloric/YouCompleteMe', { 'frozen': '1' }
	let g:ycm_show_diagnostics_ui = 0
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_key_list_previous_completion=['<UP>']
    let g:ycm_key_list_select_completion=['<DOWN>']

    let g:ycm_collect_identifiers_from_tags_files = 1
    "let g:ycm_collect_identifiers_from_comments_and_strings = 1

    let g:ycm_seed_identifiers_with_syntax = 1
    let g:ycm_use_ultisnips_completer = 0

Plug 'kovetskiy/synta', {'for': 'go'}

Plug 'fatih/vim-go', {'for': 'go'}
    let g:go_fmt_fail_silently = 0
    let g:go_fmt_command = "goimports"
    let g:go_fmt_autosave = 1
    let g:go_bin_path = $GOPATH . "/bin"
    let g:go_metalinter_command="gometalinter -D golint --cyclo-over 15"
    let g:go_list_type = "quickfix"

    "let g:go_auto_type_info = 1
    "let go_auto_sameids = 1

    let g:go_doc_keywordprg_enabled = 0
    let g:go_def_mapping_enabled = 0
    let g:go_def_mode = 'godef'


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

    au operations FileType go nmap <buffer> <Leader>f :GoFmt<CR>
    au operations FileType go let w:go_stack = 'fix that shit'
    au operations FileType go let w:go_stack_level = 'fix that shit'
    au operations FileType go nmap <silent><buffer> gd :GoDef<CR>
    au operations FileType go nmap <silent><buffer> gl :call go#def#Jump('vsplit')<CR>
    au operations FileType go nmap <silent><buffer> gk :call go#def#Jump('split')<CR>

    au operations FileType go nmap <silent><buffer> <Leader>, :w<CR>:call synta#go#build()<CR>
    au operations FileType go nmap <silent><buffer> <Leader>' :call synta#go#build()<CR>
    au operations FileType go imap <silent><buffer> <Leader>, <ESC>:w<CR>:call synta#go#build()<CR>


    au operations FileType go nmap <buffer> <Leader>;
        \ :let b:syntastic_mode = 'passive'<CR>:w<CR>:let b:syntastic_mode = 'active'<CR>:<ESC>


Plug 'elzr/vim-json', { 'for': 'json' }
    au operations BufNewFile,BufRead *.json set filetype=json

Plug 'l9'

Plug 'seletskiy/matchem'
    let g:UltiSnipsJumpForwardTrigger="<C-J>"
    let g:UltiSnipsJumpBackwardTrigger="<C-K>"

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

    au operations BufAdd,BufEnter * nnoremap / :OverExec /<CR>
    au operations BufAdd,BufEnter * vnoremap / :'<,'>OverExec /<CR>

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

Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
    au operations BufRead,BufNewFile *.md set filetype=markdown
    au operations BufRead,BufNewFile *.md set fo-=l

Plug 'AndrewRadev/sideways.vim'
    nnoremap <leader>h :SidewaysLeft<cr>
    nnoremap <leader>l :SidewaysRight<cr>


Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }

Plug 'terryma/vim-multiple-cursors'

Plug 'kshenoy/vim-signature'
    let g:SignatureMarkOrder = "\m"

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
        \ 'diff', 'markdown'
    \ ]

    func! _whitespaces_fix()
        if ShouldMatchWhitespace()
            FixWhitespace
        endif
    endfunc!

    au operations BufWritePre * call _whitespaces_fix()

"Plug 'seletskiy/vim-nunu'

Plug 'sjl/gundo.vim', { 'on': 'GundoShow' }

Plug 'kovetskiy/kb-train', { 'on': 'Train' }

Plug 'NLKNguyen/papercolor-theme'
    au operations BufNewFile,BufRead *.c,*.cpp,*.h,*.hpp setlocal noet

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

Plug 'chrisbra/Recover.vim'

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
    nnoremap <silent> @l :call search('[\(\{\[]', 'cs')<CR>l:ArgWrap<CR>
    nnoremap <silent> @; :ArgWrap<CR>

Plug 'kovetskiy/sxhkd-vim'

Plug 'PotatoesMaster/i3-vim-syntax', {'for': 'i3'}

Plug 'vimperator/vimperator.vim', {'for': 'vimperator'}

Plug 'vitalk/vim-simple-todo', {'for': 'markdown'}
    let g:simple_todo_map_keys = 1
    let g:simple_todo_map_insert_mode_keys = 0
    let g:simple_todo_map_visual_mode_keys = 0
    let g:simple_todo_map_normal_mode_keys = 1

Plug 'brooth/far.vim'
    nmap <Leader>f :Farp<CR>
    au operations FileType far_vim nmap <buffer> <Leader>d :Fardo<CR>

Plug 'kovetskiy/vim-autoresize'

"Plug 'terryma/vim-smooth-scroll'
    "noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 1, 2)<CR>
    "noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 1, 2)<CR>

Plug 'ddrscott/vim-side-search'
    nnoremap <Leader>s :SideSearch<space>

Plug 'bagrat/vim-workspace'
    noremap <Tab> :WSNext<CR>
    noremap <S-Tab> :WSPrev<CR>
    noremap <Leader><Tab> :WSClose<CR>
    noremap <Leader><S-Tab> :WSClose!<CR>
    noremap <C-t> :WSTabNew<CR>

    let g:workspace_subseparator = ""
    let g:workspace_tab_icon = ''

    func! _hl_workspace()
        hi! WorkspaceBufferCurrent cterm=NONE ctermbg=232 ctermfg=7
        hi! WorkspaceBufferActive cterm=NONE ctermbg=237 ctermfg=254
        hi! WorkspaceBufferHidden cterm=NONE ctermbg=237 ctermfg=254
        hi! WorkspaceBufferTrunc cterm=bold ctermbg=10 ctermfg=8
        hi! WorkspaceTabCurrent cterm=NONE ctermbg=4 ctermfg=8
        hi! WorkspaceTabHidden cterm=NONE ctermbg=4 ctermfg=8
        hi! WorkspaceFill cterm=NONE ctermbg=237 ctermfg=10
        hi! WorkspaceIcon cterm=NONE ctermbg=5 ctermfg=10
    endfunc!

    augroup _autocall_hl_workspace
        au ColorScheme * call _hl_workspace()
    augroup END

Plug 'lambdalisue/gina.vim'

augroup end
call plug#end()

"au VimEnter * doautocmd User plugins_loaded
au VimEnter * au! plugvim

set rtp-=~/.vim
set rtp^=~/.vim

let &background=$BACKGROUND

if &background == "light"
    colorscheme PaperColor
    let g:airline_theme = 'sol'
    set cursorline
    call _hl_workspace()
else
    colorscheme reconquest
    au ColorScheme * hi! CursorLine ctermbg=236
    set cursorline
    call _hl_workspace()
endif

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
set lcs=trail:·,tab:☰\ "

set pastetoggle=<F11>

au operations VimEnter,WinEnter,BufRead,BufNewFile * set nofoldenable
au operations VimEnter,WinEnter,BufRead,BufNewFile * au! matchparen

set noequalalways
set winminheight=0
set clipboard=unnamed

set tags=./.tags;/

au FileType help setlocal number

au BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif


func! _snapshot()
   silent execute "!vim-bundle-save >/dev/null 2>&1 &"
endfunc!
command! -bar Snapshot call _snapshot()

au operations BufWritePost ~/.vimrc
    \ source % | AirlineRefresh | Snapshot

au operations BufWritePost */.config/sxhkd/sxhkdrc silent !pkill -USR1 sxhkd
au operations BufWritePost */.i3/config silent !i3-msg restart

au operations VimResized,VimEnter * set cc=79

au operations BufRead /tmp/vimperator-confluence* set ft=html.confluence | call HtmlBeautify()

" trim empty <p><br/></p> from document
au operations BufRead /tmp/vimperator-confluence* map <buffer> <Leader>t :%s/\v[\ \t\n]+\<p\>([\ \t\n]+\<br\>)?[\ \t\n]+\<\/p\>/<CR>

" ugly hack to trim all inter-tags whitespaces
au operations BufWritePre /tmp/vimperator-confluence* %s/\v\>[\ \t\n]+\</></
au operations BufWritePost /tmp/vimperator-confluence* silent! undo

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

noh
