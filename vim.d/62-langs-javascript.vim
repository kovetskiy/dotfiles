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

    au FileType typescript,typescriptreact nnoremap <silent><buffer> <c-p> :call CocAction('runCommand', 'tsserver.organizeImports')<CR>
    au FileType typescript,typescriptreact nnoremap <silent><buffer> <c-s> :w<CR>:call _save_typescript()<CR>
augroup end

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
