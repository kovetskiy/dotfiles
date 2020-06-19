augroup lexical
  autocmd!
  autocmd FileType markdown,md call _lexical_init()
augroup END

if empty(glob('~/.vim/thesaurus/mthesaur.txt'))
  silent !mkdir -p ~/.vim/thesaurus/
  silent !curl -fLo ~/.vim/thesaurus/mthesaur.txt
    \ https://raw.githubusercontent.com/zeke/moby/master/words.txt
 autocmd VimEnter * PlugInstall
endif

func! _lexical_init()
    if expand('%:p') =~ 'coc:'
        return
    endif

    call lexical#init()
    let b:_lexical = '1'
endfunc!

func! _lexical_toggle()
    if !exists('b:_lexical') || b:_lexical == '0'
        :call _lexical_init()
    else
        setlocal spelllang=
        setlocal spellfile=
        setlocal nospell
        setlocal thesaurus=
        setlocal dictionary=
        let b:_lexical = '0'
    endif
endfunc!

let g:lexical#spell_key = '<leader><leader>s'

nmap <leader>el :call _lexical_toggle()<CR>
