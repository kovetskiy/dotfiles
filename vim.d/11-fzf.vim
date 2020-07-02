let g:fzf_prefer_tmux = 1
let g:fzf_layout = { 'down': '~40%' }

func! _select_file(...)
    let dir = ""
    if a:0 > 0
        let dir = a:1
    endif

    "call _snippets_stop()

    call fzf#run(fzf#wrap({
        \ 'source': 'prols ' . dir,
        \ 'options': '--sort --no-exact --tiebreak=index'
    \ }))
endfunc!

func! _select_file_cwd()
    call _select_file(expand('%:h'))
endfunc!

func! _select_buffer()
    call _snippets_stop()
    call fzf#vim#buffers({'options': '--sort --no-exact --tiebreak=index'})
endfunc!

nnoremap <silent> <c-t> :call _select_file()<CR>
nnoremap <silent> <c-e><c-t> :call _select_file_cwd()<CR>

let g:grep_last_query = ""

func! _grep(query, dir)
    let query = a:query
    let dir = a:dir

    let g:grep_last_query = query
    let @/ = query

    if query == ''
        let query = '^(?=.)'
    endif

    if dir == ''
        let dir = '.'
    endif

    call fzf#vim#grep(
        \ "ag --nogroup --column --color  -- " . fzf#shellescape(query) . ' ' . fzf#shellescape(dir),
        \ 1,
        \ {'options': '--delimiter : --nth 4..'}
    \ )
endfunc!


func! _grep_slash()
    let l:slash = strpart(@/, 2)
    call _grep(l:slash, "")
endfunc!

func! _grep_cwd()
    call _grep('', expand('%:h'))
endfunc!

func! _grep_recover()
    call _grep(g:grep_last_query, '')
endfunc!

nnoremap <silent> <C-F><C-F> :call _grep('', '')<CR>
nnoremap <silent> <C-E><C-F> :call _grep_cwd()<CR>
nnoremap <silent> <C-F>/ :call _grep_slash()<CR>

"func! _lstags()
"    call fzf#vim#ag("", {'source':    'lstags', 'options': '--delimiter : --nth 4..'})
"endfunc!
"
"nnoremap <silent> <c-g> :call _lstags()<CR>
