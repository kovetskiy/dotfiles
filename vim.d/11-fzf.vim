let g:fzf_prefer_tmux = 1
let g:fzf_layout = { 'down': '50%' }

func! _select_file(...)
    let dir = ""
    if a:0 > 0
        let dir = a:1
    endif

    let cmd = 'prols'

    let suffix = expand('%:e')
    if suffix != ""
        let rule = 'suffix:.' . suffix . ',score:50'
        let cmd = cmd . ' -r ' . fzf#shellescape(rule)
    endif

    let cmd = cmd . ' ' . dir

    call fzf#run(fzf#wrap({
        \ 'source': cmd,
        \ 'options': '--no-exact --tiebreak=index'
    \ }))
endfunc!

func! _select_file_cwd()
    call _select_file(expand('%:h'))
endfunc!

func! _select_buffer()
    call _snippets_stop()
    call fzf#vim#buffers({'options': '--sort --no-exact --tiebreak=index'})
endfunc!

func! _select_window()
    call _snippets_stop()
    call fzf#vim#windows({'options': '--sort --no-exact --tiebreak=index'})
endfunc!

nnoremap <silent> <c-t> :call _select_file()<CR>
"nnoremap <silent> <c-b> :call _select_buffer()<CR>
nnoremap <silent> <c-b> :call _select_window()<CR>

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


func! _select_dir()
    func! s:select_dir_sink(lines)
        " do nothing
    endfunc!

    let lines = fzf#run(fzf#wrap({
        \ 'source': 'prols -o',
        \ 'sink': function('s:select_dir_sink'),
        \ 'options': '--no-expect --sort --no-exact --tiebreak=index'
    \ }))

    if len(lines) == 0
        return ""
    endif

    return lines[0]
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
