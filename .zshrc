export GOROOT=""
export GOPATH="$HOME/go"
export PATH="$HOME/bin/:$HOME/go/bin/:$HOME/repos/git-scripts/:$PATH"
export EDITOR=vim
export TERM=rxvt-unicode-256color

ssh-add ~/.ssh/id_rsa 2>/dev/null
stty -ixon

setopt autocd
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

autoload -U colors && colors
zstyle ':completion:*:processes' command 'ps -ax'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

zstyle ':completion:*:processes-names' command 'ps -e -o comm='
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always

compress () {
  if [ $1 ] ; then
    case $1 in
      tbz)  tar cjvf $2.tar.bz2 $2   ;;
      tgz)  tar czvf $2.tar.gz  $2   ;;
      tar)  tar cpvf $2.tar  $2      ;;
      bz2)  bzip $2                  ;;
      gz)   gzip -c -9 -n $2 > $2.gz ;;
      zip)  zip -r $2.zip $2         ;;
      7z)   7z a $2.7z $2            ;;
      *)    echo "'$1' cannot be packed via >compress<" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2) tar xvjf $1   ;;
            *.tar.gz)  tar xvzf $1   ;;
            *.bz2)     bunzip2 $1    ;;
            *.rar)     unrar x $1    ;;
            *.gz)      gunzip $1     ;;
            *.tar)     tar xvf $1    ;;
            *.tbz2)    tar xvjf $1   ;;
            *.tgz)     tar xvzf $1   ;;
            *.zip)     unzip $1      ;;
            *.Z)       uncompress $1 ;;
            *.7z)      7z x $1       ;;
            *)         echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

alias agi='sudo apt-get install'
alias ags='sudo apt-cache search'
alias agu='sudo apt-get update'

alias v='vim'
alias vi='vim'
alias vimm='vim'

alias -g G='| grep'
alias -g L='| less'
alias ls='ls -a --color=always'
hash -d dotfiles=~/repos/dotfiles/
hash -d df=~/repos/dotfiles/
alias ..='cd ..'
alias ...='cd ../..'
alias zr='source ~/.zshrc && print "zsh config has been reloaded"'
alias ssh='TERM=xterm ssh'
alias chrome='google-chrome'
alias volume='pactl set-sink-volume 0 '
alias ashi='ash inbox'

ASH_LAST_PR=""
ashr () {
    url=$1
    vim -c ":Unite ash_review:$url"
    ASH_LAST_PR=$url
}

asha () {
    url=$ASH_LAST_PR
    ash $url approve
}

autoload -U add-zsh-hook

function gdi()
{
    eval "git diff $1"
}

compctl -K git_diff_complete gdi

alias gd='git diff'
alias gs='git status --short'
alias ga='git add'
alias gp='git push'
alias gpo='git push origin'
alias gpl='git pull'
alias gpr='git pull --rebase'
alias gf='git fetch'
alias gc='git commit'
alias gc!='git commit --amend'
alias gcm='git commit -m'
alias gcm!='git commit --amend -m'
alias gco='git checkout'
alias gb='git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3'
alias gpot='git push origin `git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3`'
alias gpot!='git push origin +`git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3`'
alias gput='git pull --rebase origin `git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3`'
alias gfr='git-forest --all --sha | less -XR'
alias -g gcbr='`git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3`'
alias ggc='git gc --prune --aggressive'
alias gpor='git pull --rebase origin master'
alias gsh='git stash'
alias gshp='git stash pop'
alias gr='git reset'
alias gcom='git checkout origin/master'
alias gl='git log'
alias gd='git diff'

alias gob='go build'
alias goi='go install'
alias gobi='go build && go install'

alias pdw='date; pwd'

function precmd()
{
    export PROMPT="[%m:%#] "
}

source ~/.zsh/local.zsh

bindkey '5D' emacs-backward-word
bindkey '5C' emacs-forward-word

bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;' emacs-backward-word

function prepend-sudo() {
    if [[ "$BUFFER" != su(do|)\ * ]]; then
        BUFFER="sudo $BUFFER"
        (( CURSOR += 5 ))
    fi
}

zle -N prepend-sudo

bindkey '^s' prepend-sudo
