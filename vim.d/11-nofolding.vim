augroup _no_foldings
    au!
    au VimEnter,WinEnter,BufRead,BufNewFile * set nofoldenable
    au VimEnter,WinEnter,BufRead,BufNewFile * au! matchparen
augroup end
