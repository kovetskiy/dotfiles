augroup _code_typescript
    au!

    au BufRead,BufNewFile *.ts,*.js,*.tsx
        \ call ale#Set('typescript_gts_executable',
        \ 'npx')
    au BufRead,BufNewFile *.ts,*.js,*.tsx
        \ call ale#Set('typescript_gts_options',
        \ 'gts fix')

    au BufNewFile,BufRead *.json set filetype=json
    au BufNewFile,BufRead *.ts,*.js,*.tsx setlocal ts=2 sts=2 sw=2 expandtab

    au FileType typescript,typescriptreact nnoremap <silent><buffer> <c-p> :call _format_typescript()<CR>
    au FileType typescript,typescriptreact nnoremap <silent><buffer> <c-s> :w<CR>:call _save_typescript()<CR>
augroup end

func! _filter_typescript_codeactions(titles)
    if len(a:titles) == 0
        return []
    endif

    let ids = []
    for i in range(0, len(a:titles)-1)
        let title = a:titles[i]
        if match(title, '^Import') != -1
            call add(ids, i)
        endif
    endfor

    return ids
endfunc!

func! _format_typescript()
    mark e

    let l:lastline = line('$')
    execute '1,' . l:lastline . "call CocAction('applyCodeActions', '_filter_typescript_codeactions')"

    normal `e

    call CocAction('runCommand', 'tsserver.organizeImports')
endfunc!

func! _save_typescript()
    call CocAction('diagnosticFirst', 'error')
endfunc!

function! _ale_gts_fixer(buffer) abort
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
let g:ale_fixers['typescriptreact'] = ['eslint', 'prettier']
let g:ale_fixers['javascript'] = ['prettier', 'eslint']
let g:ale_fixers['json'] = ['fixjson']
let g:ale_linter_aliases = {'typescriptreact': 'typescript'}
