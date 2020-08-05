let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'filename', 'readonly', 'cocstatus',  'modified' ] ]
    \ },
    \ 'component_function': {
        \   'filename': '_relative_filename',
        \   'cocstatus': '_coc_status_cut',
    \ }
\ }

func! _coc_status_cut()
    let l:status = coc#status()
    return l:status[:33]
endfunc!

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
    let g:lightline.colorscheme = 'dracula'
endif
