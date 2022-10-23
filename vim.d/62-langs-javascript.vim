let g:_python_plugins = expand('<sfile>:p:h') . '/pythonx/'

augroup _code_typescript
    au!
    au BufRead,BufNewFile *.ts,*.tsx,*.jsx call _setup_local_ts()
    au BufRead,BufNewFile *.js call _setup_local_js()
    au BufNewFile,BufRead *.json set filetype=json
augroup end

func! _setup_local_js()
    nnoremap <silent><buffer> <c-s> :w<CR>:call _save_typescript()<CR>:w<CR>
    nnoremap <silent><buffer> <c-p> :call CocAction('diagnosticFirst', ['warning', 'error'])<cr>
endfunc!

func! _setup_local_ts()
    nnoremap <buffer> <silent> @l :call _search_wrappable()<CR>l:ArgWrap<CR>
    nnoremap <silent><buffer> <c-p> :call _format_typescript()<CR>
    nnoremap <silent><buffer> <c-s> :w<CR>:call _save_typescript()<CR>:w<CR>
    nnoremap <silent><buffer> <c-a> :CocCommand tsserver.organizeImports<CR>

    call ale#Set('typescript_gts_executable', 'npx')
    call ale#Set('typescript_gts_options', 'gts fix')

    setlocal ts=2 sts=2 sw=2 expandtab
endfunc!

func! _filter_typescript_codeactions(titles)
    if len(a:titles) == 0
        return []
    endif

    pythonx <<PYTHON
_python_plugins = vim.eval("g:_python_plugins")
if _python_plugins not in sys.path:
    sys.path.append(vim.eval("g:_python_plugins"))
import cocx
result = cocx.cocx_filter_typescript_actions(vim.eval('a:titles'))
PYTHON

    return pyxeval('result')
endfunc!

func! _apply_typescript_actions()
    return CocAction('applyCodeActions', '_filter_typescript_codeactions')
    if get(g:, 'cocx_filter_typescript_actions', 0) == 1
        call _apply_typescript_actions()
    endif
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
"let g:ale_fixers['typescriptreact'] = ['prettier']
let g:ale_fixers['javascript'] = ['prettier', 'eslint']
let g:ale_fixers['javascriptreact'] = ['prettier', 'eslint']
let g:ale_fixers['json'] = ['fixjson']
let g:ale_linter_aliases = {'javascriptreact': 'javascript'}
let g:ale_linters = {'typescriptreact': ['tsserver']}
