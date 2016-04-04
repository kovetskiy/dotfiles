export TERM=rxvt-unicode-256color
if [ "$TMUX" ]; then
    export TERM=screen-256color-so
fi

export PATH="$(ruby -e 'print Gem.user_dir')/bin:$HOME/bin/:$HOME/private/bin/:$HOME/sources/dotfiles/deadfiles/bin/:$HOME/go/bin/:$PATH"

export EDITOR="$(which vim)"
export BACKGROUND="$(cat ~/background)"

export PROFILE="$(cat ~/profile)"

export GOROOT=""
export GOPATH="$HOME/go"

export HISTFILE=$HOME/.history
export HISTSIZE=1000
export SAVEHIST=100000

export KEYTIMEOUT=1
export WORDCHARS=-

export GO15VENDOREXPERIMENT=1

ssh-add ~/.ssh/id_rsa 2>/dev/null
stty -ixon

if [ ! -d ~/.zpezto ]; then
    ln -sfT ~/.zgen/sorin-ionescu/prezto-master ~/.zprezto
fi

autoload -Uz promptinit

zstyle ':prezto:*:*' color 'yes'
zstyle ':prezto:load' pmodule \
    'helper' \
    'environment' \
    'terminal' \
    'editor' \
    'history' \
    'directory' \
    'completion' \
    'history-substring-search' \
    'git'

zstyle ':prezto:module:editor' key-bindings 'vi'
zstyle ':completion:*' rehash true

if [ ! -d ~/.zgen ]; then
    git clone https://github.com/tarjoilija/zgen ~/.zgen
fi

autoload -Uz compinit
compinit

source ~/.zgen/zgen.zsh

if ! zgen saved; then
    zgen load seletskiy/zsh-zgen-compinit-tweak

    zgen load sorin-ionescu/prezto

    zgen load kovetskiy/zsh-quotes
    zgen load kovetskiy/zsh-add-params
    zgen load kovetskiy/zsh-fastcd
    zgen load seletskiy/zsh-prompt-lambda17
    zgen load seletskiy/zsh-ssh-urxvt
    zgen load seletskiy/zsh-ash-completion


    zgen load s7anley/zsh-geeknote

    zgen save
fi

promptinit

if [[ "$PROFILE" == "home" ]]; then
    prompt lambda17 white black ω
elif [[ "$PROFILE" == "laptop" ]]; then
    prompt lambda17 white black ω
else
    prompt lambda17
fi

bindkey -v '^K' add-params
bindkey -v '^O' toggle-quotes

hash -d dotfiles=~/sources/dotfiles/
hash -d df=~/sources/dotfiles/
hash -d src=~/sources/

autoload -U add-zsh-hook
autoload -U colors && colors

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

bindkey -a '^[' vi-insert

bindkey -s "\C-h" "history\r!"
bindkey -s "\C-f" "fg\r"

bindkey -s "\C-x" "vim "

bindkey -v
bindkey -v "^R" history-incremental-search-backward
bindkey -v "^P" history-substring-search-up
bindkey -v "^N" history-substring-search-down
bindkey -v "^[[7~" beginning-of-line
bindkey -v "^A" beginning-of-line
bindkey -v "^Q" push-line
bindkey -v "^[[8~" end-of-line
bindkey -v '^?' backward-delete-char
bindkey -v '^H' backward-delete-char
bindkey -v '^[[3~' delete-char
bindkey -v '^W' backward-kill-word
bindkey -v '^B' vi-backward-word #ctrl+alt+H
bindkey -v '^E' vi-forward-blank-word #ctrl+alt+L
bindkey -v "^L" clear-screen

function apkg() {
    echo $@ >> ~/sources/dotfiles/packages
}

unalias -a

alias scd="fastcd ~/sources/ 1"
alias vicd="fastcd ~/.vim/bundle/ 1"
alias gocd="fastcd $GOPATH/src/ 3"

#alias ssh='ssh-urxvt'

zstyle ':smart-ssh' username e.kovetskiy
zstyle ':smart-ssh' ssh-options '-t' 'TERM=xterm sudo -i'
zstyle ':smart-ssh' whitelist '.s' '.in.ngs.ru'
alias h='ssh-smart'

alias m='man'

mf() {
    man --regex -wK "$@" \
        | sed 's#.*/##g' \
        | cut -d. -f1 \
        | uniq
}

md() {
    man $1 | less +"/^\s{7}$2"
}
compdef md=man

alias hi='fc -ln 0'

sed-s() {
    local from=$(sed 's@/@\\/@g' <<< "$1")
    local to=$(sed 's@/@\\/@g' <<< "$2")
    sed "s/$from/$to/g"
}
alias ss='sed-s'

sed-remove-all-before() {
    local symbol=$(sed 's@/@\\/@g' <<< "$1")
    sed "s/.*$symbol//g"
}
alias sb='sed-remove-all-before'
alias -g Sb='| sed-remove-all-before'

sed-remove-all-after() {
    local symbol=$(sed 's@/@\\/@g' <<< "$1")
    sed "s/$symbol.*//g"
}
alias sa='sed-remove-all-after'
alias -g Sa='| sed-remove-all-after'

alias td='tr -d'
alias -g Td='tr -d'
alias -g Tr='| tr'

cu() {
    local d="$1"
    shift
    cut -d"$d" -f"$@"
}
alias -g Cu='| cu'

f() {
    local query="$1"
    shift
    find -iname "*$query*" -not -path '.' -printf '%P\n' "$@"
}

alias s='sift -e'
alias -g SR='--replace'
alias -g ST='--targets'
alias -g SX='--exclude-path'

alias z='sudo zfs'
alias zl='sudo zfs list'
alias rto='rtorrent "$(/usr/bin/ls --color=never -t ~/Downloads/*.torrent | head -n1)"'
alias mp='mplayer '
alias mpa='mplayer *'
alias e='echo'
alias au='yes | EDITOR=cat yaourt '
alias aus='au -S'
alias aur='au -R'
alias p='sudo pacman'
alias pmr='sudo pacman -R'
alias pq='sudo pacman -Q'
alias pql='sudo pacman -Ql'
alias pqo='sudo pacman -Qo'
alias pqi='sudo pacman -Qi'
alias pms='sudo pacman -S'
alias psyu='zfs-snapshot && sudo pacman -Syu'
alias pmu='sudo pacman -U'
alias pf='pkgfile'
alias -g P='| perl -n -e'
alias -g F='| fzf'
alias -g G='| grep --color'
alias -g L='| less'
alias -g H='| head -n'
alias -g T='| tail -n'
alias -g EN='2>/dev/null'
alias -g EO='2>&1'
alias -g W='| wc -l'
alias -g E='-l e.kovetskiy'
alias -g U='-t "sudo -i"'
alias -g Xa='| xargs -n1 -I{} '
alias -g X='| xarger-zsh'
xarger-zsh() {
    local cmd="$@"
    local args=()
    for i in "$@"; do
        case $i in
            '`'*)  args+=($i) ;;
            *'`')  args+=($i) ;;
            *'>'*) args+=($i) ;;
            *'<'*) args+=($i) ;;
            *'&')  args+=($i) ;;
            '|')   args+=($i) ;;
            *)     args+=(\""$i"\")
        esac
    done

    xargs -n1 -I{} \
        echo "( exec ${args[@]} ) <<< '{}'" \
        | while read -r subcmd; do
            eval "${subcmd[@]}"
    done
}

ssh-environment-host() {
    local env=$(sed 's/^\(.*.ru\.\|\.\)//' <<< "$1")

    local host
    host=$(deployer -Qe "$env" \
        | grep '^node0:$' -A 3 \
        | awk '/host:/ {print $2}')
    ssh-smart $host
}
alias he='ssh-environment-host'

alias l='ls'
function c() {
    cd $@
    ls -lah --color=always
}
alias ls='ls -lah --color=always'
alias sls='ls'
alias sl='ls'
alias v='vim'
alias vt='vim ~/todo.md'
alias tt='tim ~/todo.md'
alias vi='vim'
alias viz='vim ~/.zshrc ; zreload'
alias tiz='tim ~/.zshrc'
function vims() {
    vim -O $1 $2 +"wincmd l|lcd %:p:h|wincmd h|lcd %:p:h"
}
alias rf='rm -rf' # like russiahhhhh
alias ..='cd ..'
alias ...='cd ../..'
alias zreload='source ~/.zshrc && print "zsh config has been reloaded"'
alias sci='ssh-copy-id'
alias gcl='git clone'
function gclg() { git clone "https://github.com/$1" }
alias gh='git show'
alias gd='git diff'
alias gs='git status --short'
alias ga='git add --no-ignore-removal'
alias gb='git branch'
alias gn='git clean -fd'
alias gnx='git clean -fdX'
alias gi='git add -pi'
alias gp='git push'
alias gpo='git push origin'
alias gpl='git pull'
alias gpr='git pull --rebase'
alias gf='git fetch'
alias gcn='git commit'
alias gcn!='git commit --amend'
function gc()  { git commit -m "$@" }
function gc!() { git commit --amend -m "$@" }
alias gck='git commit --amend -C HEAD'
alias gcoo='git checkout --orphan'
alias gco='git checkout'
function gcor() {
    git checkout --orphan "$1"
    git status -s | awk '{print $2}' | xargs -n1 rm -rf
    git add .
}
function gcorg() {
    gcor $1
    touch .gitignore
    git add .gitignore
    git commit -m ".gitignore added"
}
alias gdo='git diff origin'
alias gcob='git checkout -b'
alias gcon='gf && gcom && gcof'
alias gbn='git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3'
alias gpot='git push origin `git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3` && { ghc || bhc }'
alias gpot!='git push origin +`git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3` && { ghc || bhc }'
alias gpt='gpot'
alias gpt!='gpot!'
alias gput='git pull --rebase origin `git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3`'
alias gfr='git-forest --all --sha | less -XR'
alias -g gcbr='`git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3`'
alias ggc='git gc --prune --aggressive'
alias gpor='git pull --rebase origin master'
alias gsh='git stash'
alias gshp='git stash pop'
alias grt='git reset'
alias grth='git reset --hard'
alias grts='git reset --soft'
alias gr='git rebase'
alias grc='git rebase --continue'
function gri() { git rebase -i HEAD~$1 }
alias gcom='git checkout origin/master'
alias glo='git log --oneline --graph --decorate --all'
alias gl='PAGER=cat git log --oneline --graph --decorate --all --max-count=30'
alias gd='git diff'
alias gin='git init'
alias gdh='git diff HEAD'
alias ashi='ash inbox'
alias wow='whoami; pwd; date; weather'
alias srn='~/bin/st | sort -nr'
alias adbd='adb devices'
alias adbl='adb logcat'
alias adblg='adbg logcat | grep Go'

alias sudo='sudo -E '
alias rsstop='pkill redshift'
alias psx='ps fuxa'
alias gra='git remote add origin '
alias gro='git remote show'
alias grog='git remote show origin -n'
alias gros='git remote set-url origin'
alias grb='git rebase --abort'
alias ghu='hub browse -u'
alias ghc='hub browse -u -- commit/$(git rev-parse --short HEAD) 2>/dev/null'
alias bhc='BROWSER=/bin/echo bitbucket browse commits/$(git rev-parse --short HEAD) 2>/dev/null | sed "s@//projects/@/projects/@" '

alias t='ssh vxw@home.local'

alias ку='reconfig-kbd'
alias й='env-setup'
alias dt='cd ~df; git status -s ; PAGER=cat git diff'
alias pr='hub pull-request -f'
function rsc() {
    local file="$1"
    local dir=$(dirname "$file")
    mkdir -p ~/sources/dotfiles/root/$dir
    cp -ruT $file ~/sources/dotfiles/root/$file
}

alias po='poe -L'
alias pox='poe -X -v'
alias pof='poe -F -v'

alias gob='go build'
alias goi='go install'
alias gog='go get'

alias a='alias'
alias A='alias | grep '

alias si='sed -i'

alias slp='sleep 3600; poweroff'
function ww() {
    while :; do
        eval "$@"
    done
}

function ff() {
    local count=$1
    shift
    for x in `seq 1 $count`; do
        eval "$@"
    done
}

alias sc='sudo systemctl'
alias mc='sudo machinectl'
alias mcp='sudo machinectl poweroff'
alias mcs='sudo machinectl start'
alias mcl='sudo machinectl list'
alias mch='sudo systemd-nspawn --machine=testing --directory=$HOME/container'
function mcc() {
    sudo cp -r $1 ~/container/$2
}

alias pyt='python2'
alias py='python'

alias tl='/usr/bin/t --task-dir ~/tasks --list tasks'
alias tp='/usr/bin/t --task-dir ~/tasks --list plans'
alias tw='/usr/bin/t --task-dir ~/tasks --list work'

alias er='translator'

function prepend-sudo() {
    if [[ "$BUFFER" == "" ]]; then
        BUFFER="sudo $(fc -nl -1)"
        CURSOR=$#BUFFER
    elif [[ "$BUFFER" == su(do|)\ * ]]; then
        BUFFER=${BUFFER:5}
        (( CURSOR -= 4 ))
    else
        BUFFER="sudo $BUFFER"
        (( CURSOR += 5 ))
    fi
}

zle -N prepend-sudo
bindkey '^s' prepend-sudo

function gcof() {
    if [ ! -z $1 ]; then
        git checkout -b `jira-now print`-$1
    else
        git checkout `jira-now branch`
    fi
}

function gcf() {
    amend=""
    if [ "$1" = "!" ]; then
        amend="--amend"
        shift
    fi

    issue=$(gbn | grep -oP '([A-Za-z]{1,}\-[0-9]{1,})')
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
alias gfk='github-forked'

function github-fix-host() {
    name=$1
    if [[ "$name" == "" ]]; then
        name="origin"
    fi

    remote_info=$(git remote show -n $name)
    remote_url=$(awk '/Fetch URL:/{print $3}' <<< "$remote_info")
    url=$(echo "$remote_url" | sed 's/.*github\.com./github.com\//' | sed 's/\.git$//')
    url="ssh://git@$url.git"
    git remote set-url $name $url
}
alias gfh='github-fix-host'

function goget() {
    local url=$(sed 's/.*:\/\///' <<< $1)
    local dir=$GOPATH/src/$url
    if [[ "$dir" == *.git ]]; then
        dir=$(sed 's/\.git//' <<< "$dir")
    fi
    go get -v $url
    cd $dir
    git submodule init
    git submodule update
    go get -v
}

function ck() { mkdir -p "$@"; cd "$@" }

function aurcl() {
    local package="$1"
    local dir=$(mktemp -d --suffix=$package)
    local url="ssh://aur@aur4.archlinux.org/$package.git"

    git clone $url $dir

    if [[ $# -gt 1 ]]; then
        while shift; do
            cp -r $1 $dir/
        done
    fi

    cd $dir
}

function gitaur() {
    local package="$1"
    local desc="$2"
    local git="$3"

    local dir=$(mktemp -d --suffix=$package)

    local url="ssh://aur@aur4.archlinux.org/$package.git"

    git clone $url $dir
    cd $dir

    go-makepkg -d . -c "$desc" "$git"
    mksrcinfo
    git add PKGBUILD .SRCINFO
}

#vw it's bin/vw, which openning some software in $EDITOR.
compdef vw=which

function _kb() {
    cd ~/sources/kb
    reply=($(find ./ -not -iwholename '*.git*' | sed 's@./@@'))
    cd $OLDPWD
}
compctl -K _kb kb

eval $(dircolors ~/.dircolors.$BACKGROUND)

unsetopt cdablevars
unsetopt noclobber

[ -f /etc/profile.d/fzf.zsh ] && source /etc/profile.d/fzf.zsh
