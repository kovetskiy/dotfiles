augroup _go2
    au!
    au BufNewFile,BufRead *.go2 setlocal filetype=go2
    au BufNewFile,BufRead *.go2 runtime! syntax/go.vim
    au BufNewFile,BufRead *.go2 runtime! indent/go.vim
augroup end
augroup _code_go
    au!
    au BufRead,BufNewFile *.go,*.go2 call _setup_local_go()
    au BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
    "au BufWritePre *.go 

    au BufEnter *.template call _extend_templatego()
    au BufEnter *.sql.template call _extend_templatesql()
    au BufEnter *.yaml call _extend_yaml()

    au FileType go
        \ call ale#Set('go_goimports_executable',
        \ 'goimports')
augroup end

let g:_setup_local_go_finished = 0
func! _setup_local_go()
    if g:_setup_local_go_finished == 0
        let g:_job_go_mod_watch = jobstart(['go-mod-watch'])
        let g:_setup_local_go_finished = 1
    endif

    nnoremap <buffer><silent> @l :call _search_wrappable()<CR>ll:ArgWrap<CR>
    nnoremap <buffer><silent> @h :call _chain_wrap(1)<CR>

    nmap <buffer><silent> <C-Q> :call _goto_prev_func()<CR>
    nmap <silent><buffer> <c-s> :w<CR>
    nmap <silent><buffer> <c-p> :silent call synta#go#build()<CR>
    nmap <silent><buffer> <c-f><c-q> :call _go_mod_vendor()<CR>
    nmap <silent><buffer> <leader><c-p> :call synta#quickfix#next()<CR>
    nmap <silent><buffer> <c-p><c-n> :call PythonxCocDiagnosticNext()<CR>

    nnoremap <buffer> <Leader>r :call CocActionAsync('rename')<CR>
    nnoremap <buffer> <Leader><Leader>i :!go-install-deps<CR>

    vmap <buffer> <C-F> ctx<TAB>

    let b:argwrap_tail_comma = 1
    let b:ale_fix_on_save = 1
    call ale#Set('go_golines_max_length', '200')

    setlocal cc=80,100
endfunc!

func! _go_mod_vendor()
    call system('rm -rf vendor')
    call system('go mod vendor')
    call _coc_restart()
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

func! _extend_templatesql()
    call _extend_templatego()
    set filetype=sql
endfunc!

func! _search_wrappable()
    let l:bracket = '\([^\)]'
    let l:squares = '\[[^\]]'
    let l:braces  = '\{[^\}]'
    let l:pattern = '\v[^ ](' . l:bracket . '|' . l:squares . '|' . l:braces . ')'

    call search(l:pattern, 'cs')
endfunc!


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

let g:ale_fixers['go'] = [function("synta#ale#golines#Fix"), function("synta#ale#goimports#Fix")]
let g:ale_fixers['go2'] = ['gofmt']
let g:ale_linters = {'go': ['gobuild', 'golangci-lint'], 'rust': ['analyzer']}

let g:ale_go_golangci_lint_options = ''
let g:ale_go_golangci_lint_package = 1

let g:synta_go_highlight_calls = 0
let g:synta_go_highlight_calls_funcs = 1
let g:synta_use_sbuffer = 0
let g:synta_use_go_fast_build = 0
let g:synta_go_build_recursive = 1
let g:synta_go_build_recursive_cwd = 1

hi! link goCall Function
