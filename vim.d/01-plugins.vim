call plug#begin('~/.vim/bundle')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'kovetskiy/vim-hacks'
Plug 'kovetskiy/synta'
Plug 'fatih/vim-go', {'for': ['go', 'yaml', 'template']}
Plug 'vim-scripts/l9'
Plug 'sirver/ultisnips', { 'frozen': 1 }
Plug 'tpope/vim-surround'
Plug 'pangloss/vim-javascript', { 'for': 'js' }
Plug 'danro/rename.vim'
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
    let g:vim_markdown_folding_disabled=0
Plug 'AndrewRadev/sideways.vim'
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }
Plug 'justinmk/vim-sneak'
Plug 'reconquest/vim-pythonx', { 'do' : ':UpdateRemotePlugins' }
    let g:pythonx_highlight_completion = 0
    let g:pythonx_go_info_mode = 'coc'
Plug 'reconquest/snippets'
Plug 'kovetskiy/vim-empty-lines'
Plug 'kovetskiy/vim-ski'
    let g:skeletons_dir=$HOME . '/.vim/bundle/snippets/skeletons/'
Plug 'bronson/vim-trailing-whitespace'
Plug 'sjl/gundo.vim', { 'on': 'GundoShow' }
Plug 'kovetskiy/kb-train', { 'on': 'Train' }
Plug 'yssl/QFEnter'
Plug 'rust-lang/rust.vim', {'for': 'rust' }
Plug 'wellle/targets.vim'
Plug 'kovetskiy/vim-bash'
Plug 'FooSoft/vim-argwrap', {'on': 'ArgWrap'}
Plug 'kovetskiy/sxhkd-vim'
Plug 'PotatoesMaster/i3-vim-syntax', {'for': 'i3'}
Plug 'w0rp/ale'
    let g:ale_enabled = 0
    let g:ale_fixers = {
        \ 'ruby':       [function('ale#fixers#rufo#Fix')],
        \ 'java':       [function('ale#fixers#google_java_format#Fix')],
        \ 'rust':       ['rustfmt'],
        \ 'sh':         ['shfmt'],
        \ 'bash':       ['shfmt'],
        \ 'pug':        [function('ale#fixers#prettier#Fix')],
        \ 'scss':       [function('ale#fixers#prettier#Fix')],
    \}
    let g:ale_fix_on_save = 1
Plug 'mg979/vim-visual-multi'
Plug 'tmhedberg/matchit'
Plug 'markonm/traces.vim'
Plug 'tpope/vim-dispatch'
Plug 'fvictorio/vim-extract-variable'
Plug 'kovetskiy/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'majutsushi/tagbar'
Plug 'kovetskiy/sherlock.vim'
    cnoremap <C-P> <C-\>esherlock#completeBackward()<CR>
    cnoremap <C-N> <C-\>esherlock#completeForward()<CR>
Plug 'uiiaoo/java-syntax.vim'
Plug 'lambdalisue/gina.vim'
    let g:gina#command#blame#formatter#format="%su%=%au on %ti %ma%in"
Plug 'tpope/vim-fugitive'
    nmap ,a :Git add .<CR>
    nmap ,s :Gstatus<CR>
    nmap ,c :Gcommit -v<CR>
    nmap ,t :Gpush origin<CR>
    nmap ,g :Dispatch lab ci trace<CR>
Plug 'junegunn/vim-easy-align'
    vnoremap <c-t> :EasyAlign<CR>*
    let g:easy_align_ignore_groups = []
Plug 'cespare/vim-toml'
Plug 'tpope/vim-abolish'
Plug 'neoclide/coc-tslint-plugin', {'do': 'yarn install --frozen-lockfile'}
Plug 'lfilho/cosco.vim'
    "let g:cosco_filetype_whitelist = ['java']
    "let g:auto_comma_or_semicolon = 1
    "let g:auto_comma_or_semicolon_events = ["InsertLeave"]
    "let g:cosco_ignore_comment_lines = 1
Plug 'camspiers/animate.vim'
    let g:animate#duration = 100.0
Plug 'camspiers/lens.vim'
    let g:lens#disabled_filenames = ['coc:.*', 'list:.*']
Plug 'digitaltoad/vim-pug'
Plug 'reedes/vim-lexical'
Plug 'rakr/vim-one'
Plug 'kovetskiy/vim-list-mappings'
    nmap <c-f><c-l> :call FzfListMap()<CR>
Plug 'ActivityWatch/aw-watcher-vim'
Plug 'hashivim/vim-terraform', {'for': 'terraform'}
    let g:terraform_align=1
    let g:terraform_fmt_on_save=1
Plug 'ddrscott/vim-side-search'
Plug 'matze/vim-move'
Plug 'kovetskiy/neovim-move', { 'do' : ':UpdateRemotePlugins' }

Plug 'preservim/nerdtree'

Plug 'albfan/nerdtree-git-plugin'


if $BACKGROUND == "dark"
    Plug 'reconquest/vim-colorscheme'
    func! _setup_colorscheme()
        colorscheme reconquest

        hi! CursorLineNr ctermbg=1
        hi! GitDeleted ctermfg=88
        hi! GitAdded ctermfg=22
        hi! GitModified ctermfg=238
        hi! MoreMsg ctermbg=none ctermfg=238
    endfunc!
endif
if $BACKGROUND == "light"
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'sonph/onehalf', {'rtp': 'vim/'}

    func! _setup_colorscheme()
        set background="light"
        colorscheme papercolor

        hi! SpecialKey ctermfg=250
        hi! String ctermfg=33
        hi! PreProc ctermfg=19
        hi! CursorLineNr ctermbg=1
    endfunc!
endif

call plug#end()
