func! go#list#Window(x, ...)
    if !a:0 || a:1 == 0
        cclose
        return
    endif

    call _quickfix_reset()

    if len(getqflist()) <= 1
        cclose
        return
    endif
endfunc!

func! go#list#JumpToFirst(...)
    call _quickfix_go(0)
endfunc!
