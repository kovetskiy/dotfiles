export GOROOT=""
export GOPATH="$HOME/go"
export PATH="$HOME/bin/:$HOME/go/bin/:$HOME/repos/git-scripts/:$PATH"
export EDITOR=vim
export TERM=rxvt-unicode-256color

ssh-add ~/.ssh/id_rsa 2>/dev/null

setopt autocd
#setopt extendedglob
setopt auto_name_dirs
setopt auto_pushd
setopt pushd_ignore_dups

bindkey "^[OB" down-line-or-search
bindkey "^[OC" forward-char
bindkey "^[OD" backward-char
bindkey "^[OF" end-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[3~" delete-char
bindkey "^[[4~" end-of-line
bindkey "^[[5~" up-line-or-history
bindkey "^[OB" down-line-or-history
bindkey "^?" backward-delete-char
bindkey '5D' emacs-backward-word
bindkey '5C' emacs-forward-word

HISTFILE=$HOME/.history
HISTSIZE=10000
SAVEHIST=100000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data

bindkey '^r' history-incremental-search-backward
bindkey -s "\C-h" "history\r!"

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

#autoload -Uz compinit
#compinit -C
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''

zstyle ':completion::complete:*' cache-path $HOME/.zsh/cache/

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

source ~/.zsh/functions.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/git/functions.zsh
source ~/.zsh/git/aliases.zsh
source ~/.zsh/go/common.zsh
source ~/.zsh/go/aliases.zsh

function preexec()
{
	print -Pn "\e]0;[`whoami`@`hostname`] $1\a" 
}

function precmd()
{
	export PROMPT="[%n@%m]─[%~] %# "
}

source ~/.zsh/local.zsh

bindkey '5D' emacs-backward-word
bindkey '5C' emacs-forward-word
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word

export WORDCHARS=''
