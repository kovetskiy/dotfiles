let g:_pwd_startup = getcwd()

func! _cd_root()
    let l:root = system("git rev-parse --show-toplevel 2>/dev/null")
    if l:root == ""
        let l:root = g:_pwd_startup
    endif

    execute "cd" l:root
endfunc!

func! _delete_file()
    call system("rm " . expand("%"))
    call _close_it()
endfunc!

" _close_it closes current window, but if current buffer is opened in two
" windows then only current window will be closed, desu
func! _close_it()
    py <<CODE
import vim

buffer = vim.current.buffer

found = 0
for window in vim.windows:
    if window.buffer.name == buffer.name:
        found += 1
        if found > 1:
            break

if found > 1:
    vim.command("wincmd q")
else:
    vim.command("bdelete!")
CODE
    call lens#run()
endfunc!

func! _tab_space()
    keepjumps %s/\t/    /
    normal ''
endfunc!


func! _diff_apply_bottom()
    let start = line('.')
    call search("<<<<<", "bcs")
    let end = line('.')
    execute start.",".end "delete"
    call search(">>>>>", "bcs")
    execute "delete"
    nohlsearch
endfunc!

func! _diff_enable()
    nmap <buffer> <C-F><C-D> :Grep '\=\=\=\=\=\=\='<CR><CR>
    nmap <buffer> rr :/=====<CR>zz:noh<CR>
    nmap <buffer> rk :call DiffApplyTop()<CR>rr
    nmap <buffer> rj :call _diff_apply_bottom()<CR>rr
endfunc!

let g:profiling = 0
func! _profile_toggle()
    if g:profiling == 0
        let g:profiling = 1
        profile start /tmp/profile
        profile func *
        profile file *
        echom "Profiling enabled"
    else
        let g:profiling = 0
        profile stop
        echom "Profiling disabled"
    endif
endfunc!

function! _syn_stack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

func! _sys_read(cmdline)
    let l:result = system(a:cmdline)
    execute "normal" "a" . l:result
endfunc!

func! _dir_up()
    let l:cmd = getcmdline()
    let l:pos = getcmdpos() - 1

    let l:before = strpart(l:cmd, 0, l:pos)
    let l:after = strpart(l:cmd, l:pos)

    let l:separator = strridx(l:before, "/")
    let l:before = strpart(l:before, 0, l:separator)

    let l:separator = strridx(l:before, "/")
    let l:before = strpart(l:before, 0, l:separator)

    let l:before = l:before . "/"

    call setcmdpos(len(l:before) + 1)

    let l:cmdline = l:before . l:after
    return l:cmdline
endfunc!

func! _get_github_link()
    silent call system("github-link " . expand('%:p') . " " . line('.'))
endfunc!

func! _split_set_content()
    let l:dirname = expand('%:h')
    let l:ext = expand('%:e')
    return l:dirname . '/.' . l:ext
endfunc!

func! _split_move_cursor()
    let l:ext = expand('%:e')
    call setcmdpos(len(getcmdline()) - len(expand(l:ext)))
    return ""
endfunc!

func! _cnext()
    try
        cnext
    catch
        try
            cfirst
        catch
            echom "No errors"
        endtry
    endtry
endfunc!

func! _cprev()
    try
        cprev
    catch
        try
            clast
        catch
            echom "No errors"
        endtry
    endtry
endfunc!

func! _sidesearch()
    let word = expand('<cword>')
    if word == ""
        let word = input('search: ')
    endif

    call SideSearch(word)
endfunc!
