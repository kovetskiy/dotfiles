func! go#list#Window(listtype, ...)
    if !a:0 || a:1 == 0
        cclose
        return
    endif

    botright copen
endfunc!
