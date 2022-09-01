let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'filename', 'readonly', 'cocstatus', 'method', 'modified' ] ]
    \ },
    \ 'component_function': {
        \   'filename': '_relative_filename',
        \   'cocstatus': '_coc_status_cut',
        \   'method': '_nearest_method_or_func',
    \ }
\ }

func! _coc_status_cut()
    let l:status = coc#status()
    return l:status[:33]
endfunc!

function! _relative_filename()
  return expand('%')
endfunction

function! _nearest_method_or_func() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

let g:lightline.enable = {
    \ 'statusline': 1,
    \ 'tabline': 0
    \ }

if &background == "light"
    let g:lightline.colorscheme = 'onehalflight'
else
    let g:lightline.colorscheme = 'dracula'
endif
