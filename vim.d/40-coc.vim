func! _coc_restart()
    redir @x
    silent execute "CocRestart"
    redir end
    echom "[coc] restarted"
endfunc!

func! _coc_references()
    call lens#disable()
    call CocAction('jumpReferences')
    call lens#enable()
endfunc!
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> <C-F><C-R> <Plug>(coc-refactor)
nmap <silent> <C-F><C-E> <Plug>(coc-rename)
nmap <C-F><C-A>  <Plug>(coc-codeaction-selected)l
nmap <silent> <C-F><C-O>  :call _coc_restart()<CR>
nmap <silent> gi :call CocActionAsync('doHover')<CR>
nmap <silent> gr :call _coc_references()<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gl :call CocActionAsync('jumpDefinition', 'vsplit')<CR>
nmap <silent> gk :call CocActionAsync('jumpDefinition', 'split')<CR>
nmap <leader>rn <Plug>(coc-rename)
nmap <C-F> <NOP>

nmap <leader>f    <Plug>(coc-format)
vmap <leader>f    <Plug>(coc-format-selected)

augroup _coc_highlight
    au!
    au VimEnter * hi! CocErrorHighlight ctermbg=52 ctermfg=none cterm=none
augroup end
