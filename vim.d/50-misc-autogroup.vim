augroup _filetypes
    au!
    au BufRead,BufNewFile *.service setlocal noet ft=systemd
    au BufRead,BufNewFile PKGBUILD setlocal et ft=pkgbuild.sh
    au BufRead,BufNewFile *.snippets setlocal noet ft=snippets.python
    au BufRead,BufNewFile *.skeleton setlocal noet ft=snippets.python
    au BufRead,BufNewFile *.chart setlocal noet ft=mermaid
    au BufRead,BufNewFile *.go setlocal noet
    au BufRead,BufNewFile *.config setlocal et ft=json ts=2 sw=2 sts=2
    au FileType python setlocal et ts=4 sw=4 sts=4
augroup end

fun! _trim_whitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup _whitespaces
    au!
    au BufWritePre *.yml,*.yaml,*.config call _trim_whitespace()
augroup end


augroup _misc
    au!
    "au FileType go au! vim-go
    "au FileType go au! vim-go-buffer
    au BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif
    au FileType help setlocal number

    au VimEnter * call _setup_colorscheme()

    au VimResized,BufNewFile,BufRead * wincmd =
augroup end

augroup _batrak
    au!
    au BufRead,BufNewFile *.batrak set noet ft=gitcommit tw=80
augroup end
