call plug#begin('~/.vim/bundle')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdcommenter'
    let g:NERDCustomDelimiters = { 'typescriptreact': { 'left': '//', 'leftAlt': '{/*', 'rightAlt': '*/}' } }
Plug 'kovetskiy/vim-hacks'
Plug 'kovetskiy/synta'
Plug 'fatih/vim-go', {'for': ['template']}
    "let g:go_def_mapping_enabled = 0
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
Plug 'kovetskiy/ale'
    let g:ale_enabled = 0
    let g:ale_fixers = {
        \ 'ruby':       [function('ale#fixers#rufo#Fix')],
        \ 'java':       [function('ale#fixers#google_java_format#Fix')],
        \ 'rust':       ['rustfmt'],
        \ 'pug':        [function('ale#fixers#prettier#Fix')],
        \ 'scss':       [function('ale#fixers#prettier#Fix')],
        \ 'sql':        ['sqlfmt'],
        \ '*': ['remove_trailing_lines', 'trim_whitespace']
    \}
    let g:ale_fix_on_save = 0
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
"Plug 'lfilho/cosco.vim'
"    "let g:cosco_filetype_whitelist = ['java']
"    let g:auto_comma_or_semicolon = 1
"    let g:auto_comma_or_semicolon_events = ["InsertLeave"]
"    let g:cosco_ignore_comment_lines = 1


" often resizes windows in a wrong way
"Plug 'camspiers/animate.vim'
"    let g:animate#duration = 100.0

Plug 'camspiers/lens.vim'
    let g:lens#disabled_filenames = ['coc:.*', 'list:.*']
    let g:lens#disabled_filetypes = ['']
    let g:lens#width_resize_min = 100
    let g:lens#width_resize_max = 120
    if &diff == 1
        let g:lens#disabled = 1
    endif
Plug 'digitaltoad/vim-pug'
Plug 'reedes/vim-lexical'
Plug 'rakr/vim-one'
Plug 'kovetskiy/vim-list-mappings'
    nmap <c-f><c-l> :call FzfListMap()<CR>
"Plug 'ActivityWatch/aw-watcher-vim'
Plug 'hashivim/vim-terraform', {'for': 'terraform'}
    let g:terraform_align=1
    let g:terraform_fmt_on_save=1
Plug 'kovetskiy/vim-side-search'
Plug 'kovetskiy/neovim-move', { 'do' : ':UpdateRemotePlugins' }

Plug 'rhysd/vim-grammarous'

Plug 'duganchen/vim-soy'

Plug 'mustache/vim-mustache-handlebars'

Plug 'dracula/vim'
Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'

Plug 'liuchengxu/vista.vim'
    let g:vista_executive_for = {
      \ 'typescriptreact': 'coc',
      \ }
    let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
Plug 'sebdah/vim-delve'
Plug 'puremourning/vimspector'
    let g:vimspector_enable_mappings = 'HUMAN'
    let g:vimspector_install_gadgets = ['vscode-go']
    let g:vimspector_base_dir = expand('$HOME/.config/vimspector')

Plug 'styled-components/vim-styled-components'

Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'MaxMEllon/vim-jsx-pretty'

Plug 'github/copilot.vim'
    imap <silent><script><expr> <C-Q> copilot#Accept("\<CR>")
    let g:copilot_no_tab_map = v:true

Plug 'mogelbrod/vim-jsonpath'
    noremap <buffer> <silent> <C-J><C-D> :call jsonpath#echo()<CR>
    noremap <buffer> <silent> <C-J><C-G> :call jsonpath#goto()<CR>

Plug 'ziglang/zig.vim'
Plug 'mfussenegger/nvim-dap'
Plug 'sonph/onehalf', { 'rtp': 'vim' }

Plug 'sebdah/vim-delve'


call plug#end()
