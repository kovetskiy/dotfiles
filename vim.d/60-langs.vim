augroup _sh_filetype
    au!
    au BufRead,BufNewFile ~/.zshrc set ft=zsh.sh
    au BufRead,BufNewFile *.zsh    set ft=zsh.sh
    au BufRead,BufNewFile */bin/* set ft=sh
augroup end

augroup _codestyle
    au!
    au BufRead,BufNewFile *.py setlocal ts=4 sts=4 sw=4 expandtab
    au BufEnter *.amber setlocal ft=pug
    au FileType pug setlocal ts=2 sts=2 sw=2 et
    au BufNewFile,BufRead *.dump set filetype=dump
    au BufNewFile,BufRead *.yaml,*.yml setlocal ts=2 sts=2 sw=2 expandtab

    au FileType snippets set textwidth=0
    au FileType dockerfile set textwidth=0
    au FileType vira set textwidth=0

    au BufRead,BufNewFile *.md set filetype=markdown
    au BufRead,BufNewFile *.md set fo-=l
    au BufRead,BufNewFile *.md setlocal tw=120
augroup end

