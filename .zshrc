export GOROOT=""
export GOPATH="$HOME/go"
export PATH="$HOME/bin/:$HOME/go/bin/:$HOME/sources/git-scripts/:$PATH"
export EDITOR=vim
export TERM=rxvt-unicode-256color
export PATH=$PATH:/opt/android-ndk:/opt/android-sdk/platfrom-tools/
export BACKGROUND=$(cat ~/background)
export ZSH=~/.oh-my-zsh/

ssh-add ~/.ssh/id_rsa 2>/dev/null
stty -ixon

plugins=(git history-substring-search)
source ~/.oh-my-zsh/oh-my-zsh.sh

HISTFILE=$HOME/.history
HISTSIZE=800
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
bindkey -v "^[[7~" beginning-of-line
bindkey -v "^A" beginning-of-line
bindkey -v "^Q" push-line
bindkey -v "^[[8~" end-of-line
bindkey -v "^E" end-of-line
bindkey -v '^?' backward-delete-char
bindkey -v '^H' backward-delete-char
bindkey -v '^B' delete-char
bindkey -v '^[[3~' delete-char
bindkey -v '^W' backward-kill-word
bindkey -v '^K' vi-kill-eol
bindkey -v '^[[1;5D' vi-backward-word #ctrl+alt+H
bindkey -v '^[[1;5C' vi-forward-word #ctrl+alt+L
bindkey -v "^L" clear-screen

bindkey -a '^[' vi-insert

bindkey -s "\C-f" "fg\r"

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

ashr() {
    vim -c ":Unite ash_review:$1"
}

autoload -U add-zsh-hook
autoload -U colors && colors

hash -d dotfiles=~/sources/dotfiles/
hash -d df=~/sources/dotfiles/
hash -d src=~/sources/

alias -g P='| perl -n -e'
alias -g G='| grep'
alias -g L='| less'
alias -g H='| head -n'
alias -g T='| tail -n'
alias -g EN='2>/dev/null'
alias -g EO='2>&1'
alias l='ls'
alias ls='ls -lah --color=always'
alias v='vim'
alias vi='vim'
alias vimm='vim'
alias rf='rm -rf' # like russiahhhhh
alias ..='cd ..'
alias ...='cd ../..'
alias zreload='source ~/.zshrc && print "zsh config has been reloaded"'
alias ssh='TERM=xterm ssh'
alias gcl='git clone'
gclg() {
    git clone "https://github.com/$1"
}
alias gd='git diff'
alias gs='git status --short'
alias ga='git add'
alias gi='git add -pi'
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
alias gdo='git diff origin'
alias gcob='git checkout -b'
alias gcon='gf && gcom && gcof'
alias gbn='git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3'
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
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias ashi='ash inbox'
alias pdw='date; pwd'
alias srn='php stat.php | sort | sort -nr'
alias adbd='adb devices'
alias adbl='adb logcat'
alias adblg='adbg logcat | grep Go'
alias sudo='sudo env PATH=$PATH'
alias rsstop='pkill redshift'

function prepend-sudo() {
    if [[ "$BUFFER" != su(do|)\ * ]]; then
        BUFFER="sudo $BUFFER"
        (( CURSOR += 5 ))
    fi
}

zle -N prepend-sudo
bindkey '^s' prepend-sudo

# oh shi... i love this magic :3
#home() {
    #if [[ $LBUFFER = *// ]]; then
        #LBUFFER=${LBUFFER%/*/}
        #LBUFFER+="~"
    #else
        #LBUFFER+=/
    #fi
#}
#autoload -U home
#zle -N home
#bindkey / home


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

function gcf() {
    amend=""
    if [ "$1" = "!" ]; then
        amend="--amend"
        shift
    fi

    issue=$(jira-now print | grep -oP '([A-Za-z]{1,}\-[0-9]{1,})')
    issue=$(awk '{print toupper($0)}' <<< "$issue")
    eval "git commit $amend -m '$issue: ${@}'"
}

alias gcf!="gcf !"

function github-forked() {
    git remote rename origin upstream
    upstream_info=$(git remote show upstream)
    upstream_url=$(awk '/Fetch URL:/{print $3}' <<< "$upstream_info")
    upstream_user=$(cut -d/ -f4 <<< "$upstream_url")
    origin_url=$(sed "s/$upstream_user/kovetskiy/" <<< $upstream_url)
    git remote add origin "$origin_url"
}

function github-fix-host() {
    name=$1
    if [[ "$name" == "" ]]; then
        name="origin"
    fi

    remote_info=$(git remote show $name)
    remote_url=$(awk '/Fetch URL:/{print $3}' <<< "$remote_info")
    remote_host=$(cut -d/ -f3 <<< "$remote_url")
    remote_host=$(sed 's/\@/\\@/' <<< "$remote_host")
    new_url=$(sed "s/$remote_host/github.com/" <<< "$remote_url")
    git remote set-url $name $new_url
}

eval $(dircolors ~/.dircolors.$BACKGROUND)

source ~/.zpreztorc

unsetopt cdablevars
