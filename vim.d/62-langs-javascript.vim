augroup _code_typescript
    au!

    au BufRead,BufNewFile *.ts,*.js,*.tsx,*.jsx
        \ call ale#Set('typescript_gts_executable',
        \ 'npx')
    au BufRead,BufNewFile *.ts,*.js,*.tsx,*.jsx
        \ call ale#Set('typescript_gts_options',
        \ 'gts fix')

    au BufNewFile,BufRead *.json set filetype=json
    au BufNewFile,BufRead *.ts,*.jsx,*.js,*.tsx setlocal ts=2 sts=2 sw=2 expandtab

    au FileType javascript,javascriptreact,typescript,typescriptreact nnoremap <silent><buffer> <c-p> :call _format_typescript()<CR>
    au FileType javascript,javascriptreact,typescript,typescriptreact nnoremap <silent><buffer> <c-s> :call _save_typescript()<CR>:w<CR>
    au FileType javascript,javascriptreact,typescript,typescriptreact nnoremap <silent><buffer> <c-a> :CocCommand tsserver.organizeImports<CR>
augroup end

let g:_prev_titles = []
func! _filter_typescript_codeactions(titles)
    if len(a:titles) == 0
        return []
    endif

    let ids = []
    let current_titles = []
    "echom 'before'
    "echom a:titles
    for i in range(0, len(a:titles)-1)
        let title = a:titles[i]

        if index(g:_prev_titles, title) != -1
            continue
        endif

        if match(title, "Import default 'React'") != -1
            continue
        endif

        if match(title, "Add import ") != -1
            continue
        endif

        if match(title, "Add all missing imports") != -1
            continue
        endif

        if match(title, '^Import') != -1 || match(title, '^Add ') != -1 || match(title, '^Remove import ') != -1
            call add(ids, i)
            call add (current_titles, title)
            break
        endif
    endfor

    let g:_prev_titles = current_titles
    "echom 'after'
    "echom tbd
    return ids
endfunc!

func! _apply_typescript_actions()
    return CocAction('applyCodeActions', '_filter_typescript_codeactions')
endfunc!

func! _format_typescript()
    call _apply_typescript_actions()
endfunc!

func! _save_typescript()
    exec "CocCommand" "prettier.formatFile"
    return 0
endfunc!

function! _ale_gts_fixer(buffer) abort
    return 0
    let l:executable = ale#Var(a:buffer, 'typescript_gts_executable')

    if !executable(l:executable)
        return 0
    endif

    let l:options = ale#Var(a:buffer, 'typescript_gts_options')

    return {
    \    'command': ale#Escape(l:executable)
    \        . ' ' . (empty(l:options) ? '' : ' ' . l:options)
    \        . ' %t',
    \    'read_temporary_file': 1,
    \}
endfunction

let g:ale_fixers['typescript'] = [function('_ale_gts_fixer')]
let g:ale_fixers['typescriptreact'] = ['prettier']
let g:ale_fixers['javascript'] = ['prettier', 'eslint']
let g:ale_fixers['javascriptreact'] = ['prettier', 'eslint']
let g:ale_fixers['json'] = ['fixjson']
let g:ale_linter_aliases = {'javascriptreact': 'javascript'}
let g:ale_linters = {'typescriptreact': ['tsserver']}
