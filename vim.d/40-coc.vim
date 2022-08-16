func! _coc_restart()
    redir @x
    silent execute "CocRestart"
    redir end
    if &ft == "java"
        call system("rm -rf ~/.config/coc/extensions/coc-java-data/jdt_ws_*")
    endif
    echom "[coc] restarted"
endfunc!

func! _coc_references()
    let g:lens#disabled = 1
    call CocAction('jumpReferences')
    let g:lens#disabled = 0
endfunc!

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> ]c :cfirst<CR>
nmap <silent> [c :cnext<CR>
nmap <silent> <tab> :next<CR>
nmap <silent> <s-tab> :Next<CR>
nmap <silent> <C-F><C-R> <Plug>(coc-refactor)
nmap <silent> <C-F><C-E> <Plug>(coc-rename)
nmap <C-F><C-A>  <Plug>(coc-codeaction-selected)l
nmap <C-F><C-D>  <Plug>(coc-codeaction)
nmap <silent> <C-F><C-O>  :call _coc_restart()<CR>
nmap <silent> gi :call CocActionAsync('doHover')<CR>
nmap <silent> gr :call _coc_references()<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gl :call CocActionAsync('jumpDefinition', 'vsplit')<CR>
nmap <silent> gk :call CocActionAsync('jumpDefinition', 'split')<CR>
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>ca  <Plug>(coc-codeaction)
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
nmap <C-F> <NOP>

nmap <leader>f    <Plug>(coc-format)
vmap <leader>f    <Plug>(coc-format-selected)

augroup _coc_highlight
    au!
    au VimEnter,BufRead * hi! CocErrorHighlight ctermbg=52 ctermfg=NONE cterm=NONE
    au VimEnter,BufRead * hi! CocListBgRed ctermbg=52 ctermfg=NONE cterm=NONE
    au VimEnter,BufRead * hi! SpellBad ctermbg=52 ctermfg=NONE cterm=NONE
augroup end

nnoremap <expr><down> coc#pum#visible() ? coc#pum#next(1) : "\<down>"
nnoremap <expr><up> coc#pum#visible() ? coc#pum#prev(1) : "\<up>"
inoremap <expr><down> coc#pum#visible() ? coc#pum#next(1) : "\<down>"
inoremap <expr><up> coc#pum#visible() ? coc#pum#prev(1) : "\<up>"
