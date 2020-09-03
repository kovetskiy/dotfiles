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
    py3 <<CODE
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
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

function! _syn_group()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

func! _sys_read(cmdline)
    let l:result = system(a:cmdline)
    execute "normal" "a" . l:result
endfunc!

func! _dir_up()
    let l:cmd = getcmdline()
    let l:pos = getcmdpos() - 1

    let l:before = strpart(l:cmd, 0, l:pos)

    let l:separator = strridx(l:before, "/")
    let l:before = strpart(l:before, 0, l:separator)

    let l:separator = strridx(l:before, "/")
    let l:before = strpart(l:before, 0, l:separator)

    let l:before = l:before . "/"

    call setcmdpos(len(l:before) + 1)

    let l:cmdline = l:before
    return l:cmdline
endfunc!

func! _get_github_link()
    silent call system("github-link " . expand('%:p') . " " . line('.'))
endfunc!

func! _dir_cwd()
    let l:dirname = expand('%:h')
    if l:dirname == ''
        return ""
    endif
    return l:dirname . "/"
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

func! _goto_file()
    let file = expand("<cfile>")
    if file[:1] == "./"
        let dir = expand("%:h")
        let file = dir . file[1:]
    endif

    execute "edit" file
endfunc!

function! _get_fzf_colors()
  let rules =
  \ { 'fg':      [['Normal',       'fg']],
    \ 'bg':      [['Normal',       'bg']],
    \ 'hl':      [['Comment',      'fg']],
    \ 'fg+':     [['CursorColumn', 'fg'], ['Normal', 'fg']],
    \ 'bg+':     [['CursorColumn', 'bg']],
    \ 'hl+':     [['Statement',    'fg']],
    \ 'info':    [['PreProc',      'fg']],
    \ 'prompt':  [['Conditional',  'fg']],
    \ 'pointer': [['Exception',    'fg']],
    \ 'marker':  [['Keyword',      'fg']],
    \ 'spinner': [['Label',        'fg']],
    \ 'header':  [['Comment',      'fg']] }
  let cols = []
  for [name, pairs] in items(rules)
    for pair in pairs
      let code = synIDattr(synIDtrans(hlID(pair[0])), pair[1])
      echom pair[0]
      echom pair[1]
      echom string(code)
      if code != ''
        call add(cols, name.':'.code)
        break
      endif
    endfor
  endfor

  echom string(cols)
  echom join(cols, ',')
endfunc!
