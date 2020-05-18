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
"    let $FZF_DEFAULT_COMMAND='sk'
    let g:fzf_prefer_tmux = 1
    let g:fzf_layout = { 'down': '~40%' }

    func! _select_file()
        call _snippets_stop()

        call fzf#run(fzf#wrap({
            \ 'source': 'prols',
            \ 'options': '--sort --no-exact --tiebreak=index'
        \ }))
    endfunc!

    func! _select_buffer()
        call _snippets_stop()
        call fzf#vim#buffers({'options': '--sort --no-exact --tiebreak=index'})
    endfunc!

    map <silent> <c-t> :call _select_file()<CR>

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

    nnoremap <silent> <C-F><C-F> :Grep<CR>
    nnoremap <silent> <C-E><C-F> :call _grep_word()<CR>

    func! _lstags()
        call fzf#vim#ag("", {'source':  'lstags', 'options': '--delimiter : --nth 4..'})
    endfunc!

    nnoremap <silent> <c-g> :call _lstags()<CR>

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
        let g:lightline.colorscheme = 'one'
    else
        let g:lightline.colorscheme = 'wombat'
    endif


if $BACKGROUND == "dark"
    Plug 'reconquest/vim-colorscheme'
    func! _setup_colorscheme()
        colorscheme reconquest

        hi! CursorLineNr ctermbg=1
        hi! GitDeleted ctermfg=88
        hi! GitAdded ctermfg=22
        hi! GitModified ctermfg=238
        hi! MoreMsg ctermbg=none ctermfg=238
    endfunc!
endif

Plug 'scrooloose/nerdcommenter'

Plug 'kovetskiy/synta'
    let g:synta_go_highlight_calls = 0
    let g:synta_go_highlight_calls_funcs = 1
    let g:synta_use_sbuffer = 0
    let g:synta_use_go_fast_build = 0
    let g:synta_go_build_recursive = 1
    let g:synta_go_build_recursive_cwd = 1

Plug 'fatih/vim-go', {'for': ['go', 'yaml', 'template']}
    nnoremap <Leader><Leader>i :!go-install-deps<CR>
    let g:go_rename_command = 'gopls'

    hi! link goCall Function

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

    func! _extend_templatego()
        if exists("b:templatego_extended")
            return
        endif

        call plug#load('vim-go')
        if exists("b:current_syntax")
            unlet b:current_syntax
        endif
        runtime! syntax/gotexttmpl.vim

        let b:templatego_extended = 1
    endfunc!

    augroup _yaml_settings
        au!
        au BufEnter *.yaml call _extend_yaml()
    augroup end

    augroup _template_go
        au!
        au BufEnter *.template call _extend_templatego()
    augroup end

    let g:go_template_autocreate = 0

    let g:go_fmt_fail_silently = 0
    let g:go_fmt_command = "gofumports"
    let g:go_fmt_autosave = 0
    let g:go_bin_path = $GOPATH . "/bin"
    let g:go_metalinter_command="golangci-lint run"
    let g:go_list_type = "quickfix"
    let g:go_auto_type_info = 0
    let g:go_gocode_autobuild = 1

    let g:go_doc_keywordprg_enabled = 0
    let g:go_def_mapping_enabled = 0
    let g:go_def_mode = 'godef'
    let g:go_info_mode = 'gopls'


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

        au FileType go nmap <silent><buffer> <c-p> :w<CR>:call synta#go#build()<CR>
        au FileType go imap <silent><buffer> <c-p> <ESC>:w<CR>:call synta#go#build()<CR>

        au FileType go nnoremap <Leader>r :GoRename<Space>
    augroup end


    augroup _json_settings
        au!
        au BufNewFile,BufRead *.dump set filetype=dump
        au BufNewFile,BufRead *.json set filetype=json
        au BufNewFile,BufRead *.yaml,*.yml,*.ts,*.js setlocal ts=2 sts=2 sw=2 expandtab
        "au BufNewFile,BufRead *.js setlocal ts=4 sts=4 sw=4 expandtab
    augroup end

Plug 'vim-scripts/l9'

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
    let g:UltiSnipsExpandTrigger="<NOP>"
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

   func! _expand_snippet()
        let g:_expand_snippet = 1
        call UltiSnips#ExpandSnippet()
        let g:_expand_snippet = 0

        if g:ulti_expand_res == 0
            if pumvisible()
                "&& !empty(v:completed_item)
                return coc#_select_confirm()
            else
                call coc#refresh()
                let col = col('.') - 1
                if !col || getline('.')[col - 1]  =~# '\s'
                    return "\<tab>"
                end
            end
        else
            call coc#refresh()
            return ""
        end

        return "\<c-n>"
    endfunc

    inoremap <silent> <Tab> <c-r>=_expand_snippet()<cr>
    xnoremap <silent> <Tab> <Esc>:call UltiSnips#SaveLastVisualSelection()<cr>gvs

    inoremap <expr> <DOWN> pumvisible() ? "\<C-N>" : "\<DOWN>"
    inoremap <expr> <UP>   pumvisible() ? "\<C-P>" : "\<UP>"

Plug 'tpope/vim-surround'

Plug 'pangloss/vim-javascript', { 'for': 'js' }

Plug 'danro/rename.vim'
    nnoremap <Leader><Leader>r :noautocmd Rename<Space>

    func! _delete_file()
        call system("rm " . expand("%"))
        call _close_it()
    endfunc!

    nnoremap <Leader><Leader>x :call _delete_file()<CR>

Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
    augroup _md_settings
        au!
        au BufRead,BufNewFile *.md set filetype=markdown
        au BufRead,BufNewFile *.md set fo-=l
    augroup end
    let g:vim_markdown_folding_disabled=0

Plug 'AndrewRadev/sideways.vim'
    nnoremap <leader>sh :SidewaysLeft<cr>
    nnoremap <leader>sl :SidewaysRight<cr>

    nnoremap <leader>h :SidewaysJumpLeft<cr>
    nnoremap <leader>l :SidewaysJumpRight<cr>


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

Plug 'reconquest/vim-pythonx'
    let g:pythonx_highlight_completion = 0
    let g:pythonx_go_info_mode = 'coc'

    vnoremap <C-x>v :python px.langs.go.transform.to_variable()<CR>
    nmap <C-x> $T{i<tab>


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
    let g:skeletons_dir=$HOME . '/.vim/bundle/snippets/skeletons/'

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
        colorscheme one

        hi! SpecialKey ctermfg=250
        hi! String ctermfg=33
        hi! PreProc ctermfg=19
        hi! CursorLineNr ctermbg=1
    endfunc!
endif

Plug 'justinmk/vim-syntax-extra', { 'for': 'c' }

Plug 'yssl/QFEnter'

Plug 'kovetskiy/next-indentation'
    nnoremap <C-z> :IndentationSameUp<CR>
    "nnoremap <C-x> :IndentationSameDown<CR>

Plug 'rust-lang/rust.vim', {'for': 'rust' }

Plug 'rhysd/vim-go-impl'

Plug 'wellle/targets.vim'

Plug 'kovetskiy/vim-bash'

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

    func! _chain_wrap(first)
        let match = search(').', 'cs', line('.'))
        if match == 0
            return
        endif
        call cursor(match, 0)

        let cmd = "lli\r"
        if a:first == 1
            let l:cmd = l:cmd . "\t"
        endif

        exec "normal" l:cmd

        call _chain_wrap(0)
    endfunc!

    nnoremap <silent> @h :call _chain_wrap(1)<CR>

Plug 'kovetskiy/sxhkd-vim'

Plug 'PotatoesMaster/i3-vim-syntax', {'for': 'i3'}

"Plug 'brooth/far.vim'
"    "nmap <Leader>f :Farp<CR>
"    augroup _far_settings
"        au!
"        au FileType far_vim nmap <buffer> <Leader>d :Fardo<CR>
"    augroup end

"Plug 'reconquest/vim-autosurround'
"Plug 'kovetskiy/vim-autoresize'

Plug 'kovetskiy/ale'
    let g:ale_enabled = 0

    let g:ale_fixers = {
    \   'go': [function("synta#ale#goimports#Fix"), function("synta#ale#goinstall#Fix")],
    \   'ruby': [function('ale#fixers#rufo#Fix')],
    \   'java': [function('ale#fixers#google_java_format#Fix')],
    \   'rust': ['rustfmt'],
    \   'sh':   ['shfmt'],
    \   'bash': ['shfmt'],
    \   'javascript': ['prettier', 'eslint'],
    \   'pug': [function('ale#fixers#prettier#Fix')],
    \   'scss': [function('ale#fixers#prettier#Fix')],
    \}
    let g:ale_linters = {
    \   'go': ['gobuild'],
    \}

    let g:ale_fix_on_save = 1

    augroup _go_codestyle
        au FileType go
            \ call ale#Set('go_goimports_executable',
            \ 'gofumports')
    augroup end

    augroup _java_codestyle
        au!
        au BufRead,BufNewFile *.java setlocal ts=2 sts=2 sw=2 expandtab
        au BufRead,BufNewFile *.java
            \ call ale#Set('java_google_java_format_executable',
            \ 'palantir-java-format')
        au BufRead,BufNewFile *.java
            \ call ale#Set('java_google_java_format_options',
            \ '--skip-removing-unused-imports --skip-sorting-imports')
    augroup end

Plug 'mg979/vim-visual-multi'
    let g:VM_custom_remaps = {'<c-p>': '[', '<c-s>': 'q'}
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


Plug 'tpope/vim-dispatch'
    func! _cnext()
        try
            cnext
        catch
            try
                cfirst
            catch
                echom "No errors"
            endtry
        endtry
    endfunc!

    func! _cprev()
        try
            cprev
        catch
            try
                clast
            catch
                echom "No errors"
            endtry
        endtry
    endfunc!

    nmap ,d :call _cprev()<CR>
    nmap ,f :call _cnext()<CR>

    func! _spotbugs()
        setlocal errorformat=%f:%l:%m
        setlocal makeprg=/bin/cat\ target/spotbugs
        execute "make"
    endfunc!

    func! _atlas_compile()
        setlocal errorformat=[ERROR]\ %f:[%l\\,%v]\ %m
        setlocal makeprg=atlas-mvn\ compile\ -q
        execute "Dispatch"
    endfunc!

    func! _build_java()
        call coc#rpc#request('runCommand', ['java.action.organizeImports'])
        call CocAction('diagnosticFirst', 'error')
    endfunc!

    augroup _java_bindings
        au!
        au FileType java nmap <silent><buffer> <c-a> :ALEFix<CR>
        au FileType java nmap <silent><buffer> <c-p> :call _build_java()<CR>
        au FileType java nmap <silent><buffer> ;n <Plug>(coc-diagnostic-next-error)
        au FileType java nmap <silent><buffer> <Leader>; <Plug>(coc-diagnostic-prev-error)
        au FileType java nmap <silent><buffer> ,x :call _atlas_compile()<CR>
        au FileType java nmap <silent><buffer> ,s :call _spotbugs()<CR>
    augroup end

Plug 'fvictorio/vim-extract-variable'


Plug 'kovetskiy/coc.nvim', {'do': { -> coc#util#install()}}
    func! _coc_restart()
        redir @x
        silent execute "CocRestart"
        redir end
        echom "[coc] restarted"
    endfunc!
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)
    nmap <silent> <C-F><C-R> <Plug>(coc-refactor)
    nmap <silent> <C-F><C-E> <Plug>(coc-rename)
    nmap <C-F><C-A>  <Plug>(coc-codeaction-selected)l
    nmap <silent> <C-F><C-O>  :call _coc_restart()<CR>
    nmap <silent> gi :call CocActionAsync('doHover')<CR>
    nmap <silent> gd <Plug>(coc-definition)
    nmap <leader>rn <Plug>(coc-rename)
    nmap <C-F> <NOP>

    nmap <leader>f  <Plug>(coc-format)
    vmap <leader>f  <Plug>(coc-format-selected)

    func! _coc_timer_hold()
        if exists('b:_coc_timer_moved') && b:_coc_timer_moved == 1
            call CocActionAsync('showSignatureHelp')
            let b:_coc_timer_moved = 0
        endif
    endfunc!

    func! _coc_timer_moved()
        let b:_coc_timer_moved = 1
    endfunc!

    autocmd CursorHold  * call _coc_timer_hold()
    autocmd CursorHoldI  * call _coc_timer_hold()
    autocmd CursorMoved * call _coc_timer_moved()
    autocmd CursorMovedI * call _coc_timer_moved()

    func! ChooseTypeToImport(candidates)
        echo string(a:candidates)
    endfunc!

Plug 'majutsushi/tagbar'

Plug 'kovetskiy/sherlock.vim'
    cnoremap <C-P> <C-\>esherlock#completeBackward()<CR>
    cnoremap <C-N> <C-\>esherlock#completeForward()<CR>

Plug 'uiiaoo/java-syntax.vim'

Plug 'lambdalisue/gina.vim'
    let g:gina#command#blame#formatter#format="%su%=%au on %ti %ma%in"

Plug 'tpope/vim-fugitive'
    nmap ,a :Git add .<CR>
    nmap ,s :Gstatus<CR>
    nmap ,c :Gcommit -v<CR>
    nmap ,t :Gpush origin<CR>
    nmap ,g :Dispatch lab ci trace<CR>

Plug 'junegunn/vim-easy-align'
    vmap <c-t> :EasyAlign<CR>*
    let g:easy_align_ignore_groups = []

Plug 'cespare/vim-toml'
" too greedy and too stupid
"Plug 'ggvgc/vim-fuzzysearch'
"    let g:fuzzysearch_prompt = '/'
"    let g:fuzzysearch_hlsearch = 1
"    let g:fuzzysearch_ignorecase = 1
"    let g:fuzzysearch_max_history = 30
"    let g:fuzzysearch_match_spaces = 0
"    nnoremap / :FuzzySearch<CR>

Plug 'tpope/vim-abolish'

Plug 'neoclide/coc-tslint-plugin', {'do': 'yarn install --frozen-lockfile'}

Plug 'lfilho/cosco.vim'
    "let g:cosco_filetype_whitelist = ['java']
    "let g:auto_comma_or_semicolon = 1
    "let g:auto_comma_or_semicolon_events = ["InsertLeave"]
    "let g:cosco_ignore_comment_lines = 1

Plug 'camspiers/animate.vim'
    let g:animate#duration = 100.0

Plug 'camspiers/lens.vim'
    let g:lens#disabled_filenames = ['coc:.*']

Plug 'digitaltoad/vim-pug'
    augroup _amber_pug
        au!
        au BufEnter *.amber setlocal ft=pug
        au FileType pug setlocal ts=2 sts=2 sw=2 et
    augroup end


Plug 'reedes/vim-lexical'
    let g:lexical#spell_key = '<leader><leader>s'

    if empty(glob('~/.vim/thesaurus/mthesaur.txt'))
      silent !mkdir -p ~/.vim/thesaurus/
      silent !curl -fLo ~/.vim/thesaurus/mthesaur.txt
        \ https://raw.githubusercontent.com/zeke/moby/master/words.txt
     autocmd VimEnter * PlugInstall
    endif

    func! _lexical_init()
        if expand('%:p') =~ 'coc:'
            return
        endif

        call lexical#init()
        let b:_lexical = '1'
    endfunc!

    func! _lexical_toggle()
        if !exists('b:_lexical') || b:_lexical == '0'
            :call _lexical_init()
        else
            setlocal spelllang=
            setlocal spellfile=
            setlocal nospell
            setlocal thesaurus=
            setlocal dictionary=
            let b:_lexical = '0'
        endif
    endfunc!

    nmap <leader>el :call _lexical_toggle()<CR>

    augroup lexical
      autocmd!
      autocmd FileType markdown,md call _lexical_init()
    augroup END

Plug 'rakr/vim-one'

Plug 'kovetskiy/vim-list-mappings'
    nmap <c-f><leader>f :call FzfListMap()<CR>

Plug 'ActivityWatch/aw-watcher-vim'

Plug 'hashivim/vim-terraform'
    let g:terraform_align=1
    let g:terraform_fmt_on_save=1

Plug 'ddrscott/vim-side-search'

    func! _sidesearch()
        let word = expand('<cword>')
        if word == ""
            let word = input('search: ')
        endif

        call SideSearch(word)
    endfunc!
    nmap <leader>s :call _sidesearch()<CR>

    nmap <leader>a :SideSearch<Space>

call plug#end()

augroup END

let g:EclimLoggingDisabled = 1
let g:EclimJavaCompilerAutoDetect = 0
let g:EclimShowCurrentError = 0
let g:EclimShowCurrentErrorBalloon = 0
let g:EclimMakeQfFilter = 0
let g:EclimSignLevel = 'off'
let g:EclimBuffersTabTracking = 0
let g:EclimMenus = 0
let g:EclimJavaCompilerAutoDetect = 0

au VimEnter * au! plugvim

au FileType go au! vim-go
au FileType go au! vim-go-buffer

set rtp-=~/.vim
set rtp^=~/.vim

syntax on
filetype plugin indent on

set shortmess+=sAIc

set encoding=utf-8
set printencoding=cp1251
set fileformat=unix

set textwidth=80
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
set clipboard=unnamedplus

set tags=./.tags;/

if has('nvim')
    set viminfo+=n~/.vim/runtime/neoviminfo
else
    set viminfo+=n~/.vim/runtime/viminfo
endif

au FileType help setlocal number

au BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif

set cc=80,100

map Q <nop>
map K <nop>

imap <C-F> tx<TAB>
vmap <C-F> ctx<TAB>
vmap <C-O> <TAB>oo<TAB>

imap <C-D> context.

let g:_pwd_startup = getcwd()
func! _cd_root()
    let l:root = system("git rev-parse --show-toplevel 2>/dev/null")
    if l:root == ""
        let l:root = g:_pwd_startup
    endif

    execute "cd" l:root
endfunc!

nnoremap <C-E><C-E> :cd %:p:h<CR>
nnoremap <C-E><C-R> :call _cd_root()<CR>

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

nnoremap <silent> ,q <ESC>:q<CR>
nnoremap <silent> <C-S> :w<CR>
"inoremap <silent> <C-S> <Esc>:w<CR>

" _close_it closes current window, but if current buffer is opened in two
" windows then only current window will be closed, desu
func! _close_it()
    py <<CODE
import vim

buffer = vim.current.buffer

found = 0
for window in vim.windows:
    if window.buffer.name == buffer.name:
        found += 1
        if found > 1:
            break

if found > 1:
    vim.command("wincmd q")
else:
    vim.command("bdelete!")
CODE
    call lens#run()
endfunc!

nnoremap <silent> <Leader>n <ESC>:call _close_it()<CR>
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

"nnoremap <C-E><C-E><C-R> :silent !rm -rf ~/.vim/view/*<CR>:redraw!<CR>

imap <C-A> <C-O>A

nmap <C-_> <C-W>=
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l

imap <C-J> <nop>
vmap <C-J> <nop>

imap <C-E> <C-R>=strpart(search("[)}\"'`\\]]", "c"), -1, 0)<CR><Right>

inoremap <C-H> <C-O>o

imap <C-U> <ESC>ua

imap <c-j> <nop>

nnoremap <c-b> :source ~/.vimrc<CR>:echom "vimrc sourced"<cr>

nnoremap Q qq
nnoremap @@ @q

tnoremap <Esc> <C-\><C-n>

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
    au BufRead,BufNewFile *.go set noet
    au FileType python setlocal et ts=4 sw=4 sts=4
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

imap <c-y> <C-O>:call CocActionAsync('showSignatureHelp')<CR>
nmap <c-y> :call CocActionAsync('showSignatureHelp')<CR>
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

"func! QueryWrap()
"    let l:line = line('.')
"    call search(').\w', '', l:line+1)

"    let l:line_data = getline('.')
"    let l:col = col('.')
"    echom l:col

"    let l:first_line = l:line_data[0:l:col]
"    let l:second_line = l:line_data[(l:col+1):-1]

"    call setline(l:line, l:first_line)
"    call append(l:line, l:second_line)
"    call cursor(l:line+1, 1)
"endfunc!

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
        profile stop
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

augroup window_resize
    au!
    au VimResized,BufNewFile,BufRead * wincmd =
augroup end

nnoremap <silent> <Leader>/ :noh<CR>

func! _get_github_link()
    silent call system("github-link " . expand('%:p') . " " . line('.'))
endfunc!

nnoremap <Leader>g :call _get_github_link()<CR>

func! _split_set_content()
    let l:dirname = expand('%:h')
    let l:ext = expand('%:e')
    return l:dirname . '/.' . l:ext
endfunc!

func! _split_move_cursor()
    let l:ext = expand('%:e')
    call setcmdpos(len(getcmdline()) - len(expand(l:ext)))
    return ""
endfunc!

nnoremap <Leader>w :e <C-R>=_split_set_content()<CR><C-R>=_split_move_cursor()<CR>
nnoremap <Leader>x :vsp <C-R>=_split_set_content()<CR><C-R>=_split_move_cursor()<CR>
nnoremap <Leader>t :sp <C-R>=_split_set_content()<CR><C-R>=_split_move_cursor()<CR>

func! _dir_up()
    let l:cmd = getcmdline()
    let l:pos = getcmdpos() - 1

    let l:before = strpart(l:cmd, 0, l:pos)
    let l:after = strpart(l:cmd, l:pos)

    let l:separator = strridx(l:before, "/")
    let l:before = strpart(l:before, 0, l:separator)

    let l:separator = strridx(l:before, "/")
    let l:before = strpart(l:before, 0, l:separator)

    let l:before = l:before . "/"

    call setcmdpos(len(l:before) + 1)

    let l:cmdline = l:before . l:after
    return l:cmdline
endfunc!

cnoremap <C-E> <C-\>e_dir_up()<CR>


func! _sys_read(cmdline)
    let l:result = system(a:cmdline)
    execute "normal" "a" . l:result
endfunc!

command! -nargs=1 SysRead call _sys_read("<args>")

if !has('nvim')
    set signcolumn=number
else
    set signcolumn=yes
endif

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

let g:echo_command =
\ '-command echo -p "<project>" -f "<file>" ' .
\ '-o <offset> -e <encoding>'

function! _generate_builder() " {{{
  if !eclim#project#util#IsCurrentFileInProject(0)
    return
  endif

  let project = eclim#project#util#GetCurrentProjectName()
  let file = eclim#project#util#GetProjectRelativeFilePath()

  let command = g:echo_command
  let command = substitute(command, '<project>', project, '')
  let command = substitute(command, '<file>', file, '')
  let command = substitute(command, '<offset>', eclim#util#GetOffset(), '')
  let command = substitute(command, '<encoding>', eclim#util#GetEncoding(), '')

  echom command
  let response = eclim#Execute(command)

  " if we didn't get back a dict as expected, then there was probably a
  " failure in the command, which eclim#Execute will handle alerting the user
  " to.
  if type(response) != g:DICT_TYPE
    return
  endif

  " simply print the response for the user.
  call eclim#util#Echo(string(response))
endfunction " }}}

noh
