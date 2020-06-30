"let g:extra_whitespace_ignored_filetypes = [
"    \ 'diff', 'markdown', 'go'
"\ ]

"func! _spaces_fix()
"    if ShouldMatchWhitespace()
"        keepjumps FixWhitespace
"        if &expandtab
"            retab!
"        endif
"    endif
"endfunc!

"augroup _whitespace_auto
"    au!
"    au BufWritePre * call _spaces_fix()
"augroup end
