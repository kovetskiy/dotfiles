augroup _go2
    au!
    au BufNewFile,BufRead *.go2 setlocal filetype=go2
    au BufNewFile,BufRead *.go2 runtime! syntax/go.vim
    au BufNewFile,BufRead *.go2 runtime! indent/go.vim
augroup end
augroup _code_go
    au!

    au FileType go,go2 nmap <buffer><silent> <C-Q> :call _goto_prev_func()<CR>
    au FileType go,go2 nmap <silent><buffer> <c-b> <ESC>
    au FileType go,go2 nmap <silent><buffer> <c-p> :call synta#go#build()<CR>
    au FileType go,go2 nmap <silent><buffer> <c-s> :call _save_go()<CR>:w<CR>
    au FileType go,go2 nmap <silent><buffer> <leader><c-p> :call synta#quickfix#next()<CR>
    au FileType go,go2 nmap <silent><buffer> <c-p><c-n> :call PythonxCocDiagnosticNext()<CR>
    au FileType go,go2 nnoremap <buffer> <Leader>r :call CocActionAsync('rename')<CR>
    au FileType go,go2 nnoremap <buffer> <Leader><Leader>i :!go-install-deps<CR>
    au FileType go,go2 vmap <C-F> ctx<TAB>

    au FileType go,go2 setlocal cc=80,100

    au BufRead,BufNewFile *.go,*.go2 let b:argwrap_tail_comma = 1
    "au BufRead,BufNewFile *.go,*.go2 let b:ale_fix_on_save = 1

    au BufEnter *.template call _extend_templatego()
    au BufEnter *.yaml call _extend_yaml()

    au FileType go
        \ call ale#Set('go_goimports_executable',
        \ 'gofumports')
augroup end

func! _save_go()
    call CocAction('runCommand', 'editor.action.organizeImport')
    call CocAction('format')
endfunc!

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

func! _search_wrappable()
    let l:bracket = '\([^\)]'
    let l:squares = '\[[^\]]'
    let l:braces  = '\{[^\}]'
    let l:pattern = '\v[^ ](' . l:bracket . '|' . l:squares . '|' . l:braces . ')'

    call search(l:pattern, 'cs')
endfunc!
nnoremap <silent> @l :call _search_wrappable()<CR>l:ArgWrap<CR>

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

let g:ale_fixers['go'] = [function("synta#ale#goimports#Fix")]
let g:ale_fixers['go2'] = ['gofmt']
let g:ale_linters = {'go': ['gobuild']}

"let g:ale_linters = {'go2': ['']}

"let g:go_template_autocreate = 0

"let g:go_fmt_fail_silently = 0
"let g:go_fmt_command = "gofumports"
"let g:go_fmt_autosave = 0
"let g:go_bin_path = $GOPATH . "/bin"
"let g:go_metalinter_command="golangci-lint run"
"let g:go_list_type = "quickfix"
"let g:go_auto_type_info = 0
"let g:go_gocode_autobuild = 1

"let g:go_doc_keywordprg_enabled = 0
"let g:go_def_mapping_enabled = 0
"let g:go_def_mode = 'godef'
"let g:go_rename_command = 'gopls'

let g:synta_go_highlight_calls = 0
let g:synta_go_highlight_calls_funcs = 1
let g:synta_use_sbuffer = 0
let g:synta_use_go_fast_build = 0
let g:synta_go_build_recursive = 1
let g:synta_go_build_recursive_cwd = 1


hi! link goCall Function

nnoremap <silent> @h :call _chain_wrap(1)<CR>
