func! _snippets_stop()
    python "UltiSnips_Manager._leave_buffer()"
endfunc!

func! _snippets_fix()
    py3 import importlib; import UltiSnips.snippet_manager; importlib.reload(UltiSnips.snippet_manager); from UltiSnips.snippet_manager import UltiSnips_Manager;
endfunc!

augroup _ultisnips_fix_expand
    au!
    au WinEnter * call _snippets_fix()
augroup end

func! _snippets_get_filetype()
    let l:dot = strridx(&filetype, ".")
    if l:dot != -1
        return strpart(&filetype, 0, dot)
    endif

    return &filetype
endfunc!

func! _snippets_open_dotfiles()
    split
    execute "edit" g:snippets_dotfiles .
        \ _snippets_get_filetype() . ".snippets"
endfunc!

func! _snippets_open_reconquest()
    split
    execute "edit" g:snippets_reconquest .
        \ _snippets_get_filetype() .  ".snippets"
endfunc!

func! _expand_snippet()
    let g:_expand_snippet = 1
    call UltiSnips#ExpandSnippet()
    let g:_expand_snippet = 0

    if g:ulti_expand_res == 0
        if pumvisible()
            "&& !empty(v:completed_item)
            return coc#_select_confirm()
        else
            call coc#refresh()
            let col = col('.') - 1
            if !col || getline('.')[col - 1]  =~# '\s'
                return "\<tab>"
            end
        end
    else
        call coc#refresh()
        return ""
    end

    return "\<c-n>"
endfunc

nnoremap <C-E><C-D> :call _snippets_open_dotfiles()<CR>
nnoremap <C-E><C-S> :call _snippets_open_reconquest()<CR>

smap <C-E> <C-V><ESC>a
smap <C-B> <C-V>o<ESC>i

inoremap <silent> <Tab> <c-r>=_expand_snippet()<cr>
xnoremap <silent> <Tab> <Esc>:call UltiSnips#SaveLastVisualSelection()<cr>gvs

inoremap <expr> <DOWN> pumvisible() ? "\<C-N>" : "\<DOWN>"
inoremap <expr> <UP>   pumvisible() ? "\<C-P>" : "\<UP>"

let g:UltiSnipsJumpForwardTrigger="<C-J>"
let g:UltiSnipsJumpBackwardTrigger="<C-K>"

let g:UltiSnipsUsePythonVersion = 3

let g:snippets_dotfiles = $HOME . '/.vim/snippets/'
let g:snippets_reconquest = $HOME . '/.vim/bundle/snippets/'

let g:UltiSnipsSnippetDirectories = [
\       g:snippets_reconquest,
\       g:snippets_dotfiles,
\]

let g:UltiSnipsEnableSnipMate = 0
let g:UltiSnipsExpandTrigger="<NOP>"
let g:UltiSnipsEditSplit="horizontal"
