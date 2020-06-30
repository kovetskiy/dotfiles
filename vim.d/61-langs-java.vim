augroup _code_java
    au!

    au BufRead,BufNewFile *.java setlocal ts=2 sts=2 sw=2 expandtab

    au BufRead,BufNewFile *.java
        \ call ale#Set('java_google_java_format_executable',
        \ 'palantir-java-format')
    au BufRead,BufNewFile *.java
        \ call ale#Set('java_google_java_format_options',
        \ '--skip-removing-unused-imports --skip-sorting-imports')
    au FileType go
        \ call ale#Set('go_goimports_executable',
        \ 'gofumports')

    au FileType java nmap <silent><buffer> <c-a> :ALEFix<CR>
    au FileType java nmap <silent><buffer> <c-s> :call _save_java()<CR>
    au FileType java nmap <silent><buffer> <c-p> :call _diagnostic_java()<CR>
    au FileType java nmap <silent><buffer> <c-g> :call _diagnostic_java_project()<CR>
    au FileType java nmap <silent><buffer> ;n <Plug>(coc-diagnostic-next-error)
    au FileType java nmap <silent><buffer> <Leader>; <Plug>(coc-diagnostic-prev-error)
    au FileType java nmap <silent><buffer> ,s :call _spotbugs()<CR>

    au CursorHold *.java call __java_timer_hold()
    au CursorHoldI *.java call __java_timer_hold()
    au CursorMoved *.java call __java_timer_moved()
    au CursorMovedI *.java call __java_timer_moved()

    au FileType java imap <buffer> <c-y> <C-O>:call CocActionAsync('doHover')<CR>
    au FileType java nmap <buffer> <c-y> :call CocActionAsync('doHover')<CR>
augroup end

nmap <silent> ,x :call PythonxCocDiagnosticNext()<CR>

func! __java_timer_hold()
    if exists('b:__java_timer_moved') && b:__java_timer_moved == 1
        redir @x
        silent call CocAction('showSignatureHelp')
        redir end
        let b:__java_timer_moved = 0
    endif
endfunc!

func! __java_timer_moved()
    let b:__java_timer_moved = 1
endfunc!

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

func! _diagnostic_java()
    call CocAction(
        'diagnosticFirst',
        'error'
    )
endfunc!

func! _diagnostic_java_project()
    call PythonxCocDiagnosticFirst()
endfunc!

func! _save_java()
    call coc#rpc#request('runCommand', ['java.action.organizeImports'])
    call coc#rpc#request('runCommand', ['java.action.organizeImports'])

    call ale#fix#Fix(bufnr(''), '')
    write
endfunc!

func! _expand_braces()
    let l:pattern = '\v\{\}'

    call search(l:pattern, 'cs')

    call feedkeys("a")
    call feedkeys("\<tab>")
endfunc!

nmap <C-x> :call _expand_braces()<CR>
