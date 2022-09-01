set termguicolors
set cursorline

if $BACKGROUND == "dark"
    func! _setup_colorscheme()
        colorscheme dracula
        "set background="dark"

        if !has("gui_running")
            hi! Normal guibg=NONE
        endif
        hi! GitDeleted ctermfg=NONE ctermbg=NONE guibg=NONE guifg=#dc322f gui=bold
        hi! GitAdded ctermfg=NONE ctermbg=NONE guibg=NONE guifg=#2aa198 gui=bold
        hi! GitModified ctermfg=NONE ctermbg=NONE guibg=NONE guifg=#6c71c4 gui=bold
        "hi! ColorColumn ctermbg=NONE guibg=#e6e6e6 guifg=NONE ctermfg=NONE

        hi! CocCursorRange guibg=#b16286 guifg=#ebdbb2 ctermbg=5 ctermfg=3
        hi! Pmenu guibg=#262626 guifg=#ffffff
        hi! CocErrorHighlight guibg=NONE guifg=#dc322f
        hi! CocErrorSign guifg=#dc322f guibg=#262626
    endfunc!
endif

if $BACKGROUND == "light"
    func! _setup_colorscheme()
        colorscheme onehalflight
        set background=light

        hi! Normal ctermfg=NONE ctermbg=NONE guibg=NONE guifg=#657b83
        hi! GitDeleted ctermfg=NONE ctermbg=NONE guibg=NONE guifg=#dc322f gui=bold
        hi! GitAdded ctermfg=NONE ctermbg=NONE guibg=NONE guifg=#2aa198 gui=bold
        hi! GitModified ctermfg=NONE ctermbg=NONE guibg=NONE guifg=#6c71c4 gui=bold
        "hi! String guifg=#859900
        "hi! SpecialKey ctermfg=250
        "hi! String ctermfg=33
        "hi! PreProc ctermfg=19
        hi! LineNr guibg=NONE
        hi! CursorLineNr guibg=NONE guifg=#cb4b16

        hi! CocCursorRange guibg=#b16286 guifg=#ebdbb2 ctermbg=5 ctermfg=3
        hi! Pmenu guibg=#ffffff guifg=#141518
        hi! CocErrorHighlight guibg=NONE guifg=#e45649
        hi! CocErrorSign guifg=#e45649 guibg=NONE
    endfunc!
endif
