export GOROOT=""
export GOPATH="$HOME/go"
export PATH="$HOME/bin/:$HOME/go/bin/:$HOME/repos/git-scripts/:$PATH"
export EDITOR=vim
export TERM=rxvt-unicode-256color
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
export ZSH=~/.oh-my-zsh/

ssh-add ~/.ssh/id_rsa 2>/dev/null
stty -ixon

source ~/.zpreztorc

plugins=(git history-substring-search)
source ~/.oh-my-zsh/oh-my-zsh.sh

HISTFILE=$HOME/.history
HISTSIZE=10000
SAVEHIST=100000

unsetopt correct
unsetopt correct_all

setopt autocd
setopt auto_name_dirs
setopt auto_pushd
setopt pushd_ignore_dups
setopt interactivecomments
setopt rmstarsilent
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups 
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history

export KEYTIMEOUT=1

bindkey -s "\C-h" "history\r!"
bindkey -v

bindkey -v "^R" history-incremental-search-backward
bindkey -v "^P" history-substring-search-up
bindkey -v "^N" history-substring-search-down
bindkey -v "^A" beginning-of-line
bindkey -v "^Q" push-line
bindkey -v '^A' beginning-of-line
bindkey -v '^E' end-of-line
bindkey -v '^?' backward-delete-char
bindkey -v '^H' backward-delete-char
bindkey -v '^L' delete-char
bindkey -v '^W' backward-kill-word
bindkey -v '^K' vi-kill-eol
bindkey -v '^[[1;5D' vi-backward-word #ctrl+alt+H
bindkey -v '^[[1;5C' vi-backward-word #ctrl+alt+L

bindkey -a '^[' vi-insert

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

ashr () {
    vim -c ":Unite ash_review:$1"
}

autoload -U add-zsh-hook
autoload -U colors && colors

hash -d dotfiles=~/repos/dotfiles/
hash -d df=~/repos/dotfiles/

alias -g G='| grep'
alias -g L='| less'
alias -g H='| head -n'
alias -g T='| tail -n'
alias l='ls'
alias ls='ls -lah --color=always'
alias v='vim'
alias vi='vim'
alias vimm='vim'
alias rf='rm -rf' # like russiahhhhh
alias agi='sudo apt-get install'
alias ags='sudo apt-cache search'
alias agu='sudo apt-get update'
alias ..='cd ..'
alias ...='cd ../..'
alias zr='source ~/.zshrc && print "zsh config has been reloaded"'
alias ssh='TERM=xterm ssh'
alias chrome='google-chrome'
alias ashi='ash inbox'
alias gcl='git clone'
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
alias gcob='git checkout -b'
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
alias srn='php stat.php | sort | sort -nr'

function prepend-sudo() {
    if [[ "$BUFFER" != su(do|)\ * ]]; then
        BUFFER="sudo $BUFFER"
        (( CURSOR += 5 ))
    fi
}
zle -N prepend-sudo
bindkey '^s' prepend-sudo

function gdi()
{
    eval "git diff $1"
}
compctl -K git_diff_complete gdi

function gcof() {
    if [ ! -z $1 ]; then
        git checkout -b `jira-now print`-$1
    else
        git checkout `jira-now branch`
    fi
}

function gocd() {
    cd `find $GOPATH/src/ -name "$1*" -type d | head -n 1`
}

source ~/zsh-migrations/migrations.zsh

