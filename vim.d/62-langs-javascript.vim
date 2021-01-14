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

func! _filter_typescript_codeactions(titles)
    if len(a:titles) == 0
        return []
    endif

    pythonx <<PYTHON
import vim
import re

titles = vim.eval('a:titles')
result = []

excludes = ["Import default 'React'", "Add import ", "Add all missing imports" ]
includes = ["Import '(.*)'", "Add '(.*)'", "Import default '(.*)'"]
seen = []
for t in range(len(titles)):
    title = titles[t]

    skip = False
    for exclude in excludes:
        if re.search(exclude, title):
            skip = True
            break

    if skip:
        continue

    lib = None
    for pattern in includes:
        matches = re.match(pattern, title)
        if matches:
            lib = matches.group(1)
            break

    if not lib:
        continue

    if lib not in seen:
        seen.append(lib)
        result.append(t)

PYTHON

    return pyxeval('result')
endfunc!

func! _apply_typescript_actions()
    return CocAction('applyCodeActions', '_filter_typescript_codeactions')
endfunc!

func! _format_typescript()
    call _apply_typescript_actions()
endfunc!

func! _save_typescript()
    call CocAction('runCommand', 'prettier.formatFile')
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
