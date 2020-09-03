augroup _auto_nohlsearch
    au!
    au CursorMoved * call _auto_nohlsearch_moved()
    au InsertEnter,CursorMovedI * set nohlsearch
augroup end

func! _auto_nohlsearch_moved()
    if !&hlsearch
        return
    endif

    if get(g:, '_auto_nohlsearch_timer', 0)
        call timer_stop(g:_auto_nohlsearch_timer)
    endif

    let g:_auto_nohlsearch_timer = timer_start(1000, '_auto_nohlsearch_timed_out', {'repeat': 1})
endfunc!

func! _auto_nohlsearch_timed_out(...)
    set nohlsearch
endfunc!

func! _auto_nohlsearch_wrap(seq)
    if mode() == 'c' && stridx('/?', getcmdtype()) < 0
        return a:seq
    endif

    set hlsearch

    return a:seq
endfunc!

map  <expr> n    _auto_nohlsearch_wrap('n')
map  <expr> N    _auto_nohlsearch_wrap('N')
map  <expr> *    _auto_nohlsearch_wrap('*')
map  <expr> #    _auto_nohlsearch_wrap('#')
cmap <expr> <cr> _auto_nohlsearch_wrap("\<cr>")
