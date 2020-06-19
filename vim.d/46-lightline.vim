let g:lightline = {
    \ 'component_function': {
    \   'filename': '_relative_filename'
    \ }
\ }

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
    let g:lightline.colorscheme = 'wombat'
endif
