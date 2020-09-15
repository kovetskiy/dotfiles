let g:VM_silent_exit = 1
let g:VM_quit_after_leaving_insert_mode = 1
let g:VM_highlight_matches = 'hi Search guibg=#FFDD40 guifg=#543E5B'

let g:VM_disable_syntax_in_imode = 1
let g:VM_no_meta_mappings = 1
let g:VM_maps = {
    \ 'Select All': '<C-A>',
    \ "Add Cursor At Pos": '<C-Z>'
    \ }

let g:VM_leader = "\\"

fun! VM_Start()
    unmap f
    unmap F
    unmap t
    unmap T
    unmap ,
    unmap ;

    if &filetype == "go"
        call pythonx#unmap_autoimport()
    endif
endfun

fun! VM_Exit()
    map f <Plug>Sneak_f
    map F <Plug>Sneak_F
    map t <Plug>Sneak_t
    map T <Plug>Sneak_T
    map , <Plug>Sneak_,
    map ; <Plug>Sneak_;

    if &filetype == "go"
        call pythonx#map_autoimport()
    endif
endfun

function! s:SelectAllMark()
    exec 'VMSearch'.msearch#joint_pattern()
    call feedkeys("\<Plug>(VM-Select-All)")
    call feedkeys("\<Plug>(VM-Goto-Prev)")
endfunction

function! s:VSelectAllMark()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    exec line_start.','.line_end-1.' VMSearch '.msearch#joint_pattern()
endfunction

function! s:VSelectAllMark()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    exec line_start.','.line_end.' VMSearch '.msearch#joint_pattern()
endfunction

nnoremap <leader>a :call <sid>SelectAllMark()<cr>
vnoremap <leader>a :<c-u>call <sid>VSelectAllMark()<cr>
