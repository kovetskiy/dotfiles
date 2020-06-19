for f in split(glob('~/dotfiles/vim.d/*.vim'), '\n')
    exe 'source' f
endfor

noh
