let g:VM_custom_remaps = {'<c-p>': '[', '<c-s>': 'q'}
let g:VM_no_meta_mappings = 1
let g:VM_maps = {
    \ 'Select All': '<C-A>',
    \ "Add Cursor At Pos": '<C-Z>'
    \ }

let g:VM_leader = "\\"

fun! VM_before_auto()
    unmap f
    unmap F
    unmap t
    unmap T
    unmap ,
    unmap ;
endfun

fun! VM_after_auto()
    map f <Plug>Sneak_f
    map F <Plug>Sneak_F
    map t <Plug>Sneak_t
    map T <Plug>Sneak_T
    map , <Plug>Sneak_,
    map ; <Plug>Sneak_;
endfun
