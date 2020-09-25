augroup _filetypes
    au!
    au BufRead,BufNewFile *.service set noet ft=systemd
    au BufRead,BufNewFile PKGBUILD set et ft=pkgbuild.sh
    au BufRead,BufNewFile *.snippets set noet ft=snippets.python
    au BufRead,BufNewFile *.skeleton set noet ft=snippets.python
    au BufRead,BufNewFile *.chart set noet ft=mermaid
    au BufRead,BufNewFile *.go set noet
    au FileType python setlocal et ts=4 sw=4 sts=4
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
