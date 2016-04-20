. ~/bin/environment-variables

export TERM=rxvt-unicode-256color
if [ "$TMUX" ]; then
    export TERM=screen-256color-so
fi

export HISTFILE=$HOME/.history
export HISTSIZE=1000
export SAVEHIST=100000
export KEYTIMEOUT=1
export WORDCHARS=-
export BACKGROUND=$(cat ~/background)
export GO15VENDOREXPERIMENT=1


# :prezto
{
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
}

# :zgen
{
    if [ ! -d ~/.zgen ]; then
        git clone https://github.com/tarjoilija/zgen ~/.zgen
    fi

    if [ ! -d ~/.zpezto ]; then
        ln -sfT ~/.zgen/sorin-ionescu/prezto-master ~/.zprezto
    fi

    source ~/.zgen/zgen.zsh

    if ! zgen saved; then
        zgen load seletskiy/zsh-zgen-compinit-tweak

        zgen load sorin-ionescu/prezto

        zgen load kovetskiy/zsh-quotes
        zgen load kovetskiy/zsh-add-params
        zgen load kovetskiy/zsh-fastcd
        zgen load kovetskiy/zsh-smart-ssh
        zgen load kovetskiy/zsh-insert-dot-dot-slash

        zgen load seletskiy/zsh-prompt-lambda17
        zgen load seletskiy/zsh-ssh-urxvt
        zgen load seletskiy/zsh-ash-completion


        zgen load s7anley/zsh-geeknote

        ZGEN_AUTOLOAD_COMPINIT="-d $ZGEN_DIR/zcompdump"
        zgen save
    fi
}

# :reset
{
    unalias -a
    unsetopt cdablevars
    unsetopt noclobber
    unsetopt correct
    unsetopt correct_all
}

# :setup
{
    autoload -U add-zsh-hook

    autoload -Uz promptinit
    promptinit
    case $PROFILE in
        home)
            prompt lambda17 white black ω
            ;;
        laptop)
            prompt lambda17 white black ω
            ;;
        *)
            prompt lambda17
            ;;
    esac

    compinit -d $ZGEN_DIR/zcompdump

    autoload -U colors
    colors

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
}


# :binds
{
    bindkey -a '^[' vi-insert
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
    bindkey -v '^B' vi-backward-word
    bindkey -v '^E' vi-forward-blank-word
    bindkey -v "^L" clear-screen
    bindkey -v '^K' add-params
    bindkey -v '^O' toggle-quotes
    bindkey -v "^_" insert-dot-dot-slash
}


# :hash
{
    hash -d dotfiles=~/dotfiles/
    hash -d deadfiles=~/deadfiles/
    hash -d src=~/sources/
}

# :fastcd
{
    alias srcd="fastcd ~/sources/ 1"
    alias vicd="fastcd ~/.vim/bundle/ 1"
    alias gocd="fastcd ~/go/src/ 3"
    alias zgcd='fastcd ~/.zgen/ 2'
}

# :func
{
    packages-add() {
        echo $@ >> ~/sources/dotfiles/packages
    }

    ssh-enhanced() {
        local hostname="$1"
        shift

        local cmd="TERM=xterm sudo -i"
        if [ $# -ne 0 ]; then
            cmd="TERM=xterm sudo -i \$SHELL -ic ${(q)*}"
        fi
        smart-ssh -t "$hostname" "$cmd"
    }
    compdef ssh-enhanced=ssh

    man-find() {
        man --regex -wK "$@" \
            | sed 's#.*/##g' \
            | cut -d. -f1 \
            | uniq
    }

    man-directive() {
        man $1 | less +"/^\s{7}$2"
    }
    compdef man-directive=man

    sed-replace() {
        local from=$(sed 's@/@\\/@g' <<< "$1")
        local to=$(sed 's@/@\\/@g' <<< "$2")
        shift 2
        sed -ri "s/$from/$to/g" $@
    }

    sed-remove-all-before() {
        local symbol=$(sed 's@/@\\/@g' <<< "$1")
        sed -r "s/.*$symbol//g"
    }
    sed-remove-all-after() {
        local symbol=$(sed 's@/@\\/@g' <<< "$1")
        sed -r "s/$symbol.*//g"
    }
    cut-d-t() {
        local d="$1"
        shift
        cut -d"$d" -f"$@"
    }
    find-iname() {
        local query="$1"
        shift
        find -iname "*$query*" -not -path '.' -printf '%P\n' "$@"
    }

    xargs-eval() {
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
            echo "( eval ${args[@]} ) <<< '{}'" \
            | \
            while read -r subcmd; do
                echo eval "${subcmd[@]}"
            done
    }

    ssh-node0-host() {
        local env=$(sed 's/^\(.*.ru\.\|\.\)//' <<< "$1")

        local host
        host=$(deployer -Qe "$env" \
            | grep '^node0:$' -A 3 \
            | awk '/host:/ {print $2}')
        ssh-enhanced $host
    }

    cd-and-ls() {
        cd $@
        ls -lah --color=always
    }

    git-clone-github() {
        git clone "https://github.com/$1"
    }

    git-commit-m() {
        git commit -m "$*"
    }

    git-commit-m-amend() {
        git commit --amend -m "$*"
    }

    git-checkout-orphan() {
        git checkout --orphan "$1"
        git status -s | awk '{print $2}' | xargs -n1 rm -rf
        git add .
    }

    git-create-and-commit-empty-gitignore() {
        gcor $1
        touch .gitignore
        git add .gitignore
        git commit -m ".gitignore added"
    }

    alias-search() {
        alias | grep -- "$*"
    }

    github-remote-set-origin-as-upstream() {
        git remote rename origin upstream
        upstream_info=$(git remote show upstream)
        upstream_url=$(awk '/Fetch URL:/{print $3}' <<< "$upstream_info")
        upstream_user=$(cut -d/ -f4 <<< "$upstream_url")
        origin_url=$(sed "s/$upstream_user/kovetskiy/" <<< $upstream_url)
        git remote add origin "$origin_url"
    }

    github-remote-fix-origin-protocol() {
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

    go-get-enhanced() {
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


    create-and-change-directory() {
        mkdir -p "$@"
        cd "$@"
    }

    aur-create-project() {
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

    aur-import-project-golang() {
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

    cd-pkgbuild() {
        local dir=$(basename "$(pwd)")
        local dir_pkgbuild="${dir}-pkgbuild"

        if [ -d "$dir_pkgbuild" ]; then
            cd "$dir_pkgbuild"
            return
        fi

        cp -r "../$dir" "../$dir_pkgbuild"

        cd "../$dir_pkgbuild"

        if [ "$(git rev-parse --abbrev-parse HEAD)" = "pkgbuild" ]; then
            return
        fi

        if git branch | grep -q pkgbuild; then
            git checkout pkgbuild
            return
        fi

        git-checkout-orphan pkgbuild
    }

    go-makepkg() {
        local package="$1"
        local description="$2"
        local repo="$3"
        shift 3

        if [[ ! "$repo" ]]; then
            repo=$(git remote get-url origin)
            if grep -q "github.com" <<< "$repo"; then
                repo=$(sed-replace '.*@' 'https://' <<< "$repo")
                repo=$(sed-replace '.*://' 'https://' <<< "$repo")
            fi
        fi

        go-makepkg -g -c -n $package -d . "$description"  "$repo" $@
    }

    copy-to-clipboard() {
        if [ $# -ne 0 ]; then
            if [ -e "$1" ]; then
                xclip -selection clipboard < "$1"
                return
            fi

            xclip -selection clipboard <<< "$@"
            return
        fi

        cat | xclip-selection clipboard
    }
}

# :funcaliases
{
    alias ck='create-and-change-directory'
    alias mf='man-find'
    alias md='man-directive'
    alias c='cd-and-ls'
    alias he='ssh-node0-host'
    alias ss='sed-replace'
    alias -g sb='| sed-remove-all-before'
    alias -g sa='| sed-remove-all-after'
    alias -g C='| cut-d-t'

    zstyle :smart-ssh whitelist .s .in.ngs.ru
    alias h='ssh-enhanced'

    alias f='find-iname'
    alias -g X='| xargs-eval'

    alias A='alias-search'

    alias cdp='cd-pkgbuild'
}


# :alias
{
    alias history='fc -ln 0'
    alias m='man'
    alias rf='rm -rf'
    alias ls='ls -lah --color=always'
    alias l='ls'
    alias sls='ls'
    alias sl='ls'
    alias mp='mplayer -slave'
    alias v='vim'
    alias vi='vim'
    alias se='sed -r'
    alias t='ssh operator@home.local'
    alias a='alias'
    alias py='python'
    alias py2='python2'

    # :globals
    {
        alias -g G='EO | grep --color'
        alias -g L='EO | less -r'
        alias -g H='EO | head -n'
        alias -g T='EO | tail -n'
        alias -g W='| wc -l'
        alias -g Xa='| xargs -n1 -I{} '
        alias -g EO='2>&1'
        alias -g EN='2>/dev/null'
    }

    alias s='sift -e'
    {
        alias -g SX='--exclude-path'
    }


    alias rto='rtorrent "$(/usr/bin/ls --color=never -t ~/Downloads/*.torrent | head -n1)"'


    # :aur
    {
        alias au='yes | EDITOR=cat yaourt '
        alias aus='au -S'
        alias aur='au -R'
        alias aug='cd /tmp/; au -G'
    }

    # :pacman
    {
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
    }


    # :zsh
    {
        alias viz='vim ~/.zshrc ; zreload'
        alias tiz='terminal-vim ~/.zshrc'
        alias zreload='source ~/.zshrc && print "zsh config has been reloaded"'
    }


    # :git
    {
        alias gcl='git clone'
        alias gh='git show'
        alias gd='git diff'
        alias gs='git status --short'
        alias ga='git add --no-ignore-removal'
        alias gb='git branch'
        alias gn='git clean -fd; git clean -fdX'
        alias gi='git add -pi'
        alias gp='git push'
        alias gpo='git push origin'
        alias gpl='git pull'
        alias gpr='git pull --rebase'
        alias gf='git fetch'
        alias gcn='git commit'
        alias gcn!='git commit --amend'
        alias gc='git-commit-m'
        alias gc!='git-commit-m-amend'
        alias gck='git commit --amend -C HEAD'
        alias gco='git checkout'

        alias gci='git-create-and-commit-empty-gitignore'
        alias gclg='git-clone-github'
        alias gcoo='git-checkout-orphan'

        alias gcb='git checkout -b'
        alias gbn='git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3'
        alias gpot='git push origin `git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3` && { ghc || bhc }'
        alias gpot!='git push origin +`git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3` && { ghc || bhc }'
        alias gpt='gpot'
        alias gpt!='gpot!'
        alias gput='git pull --rebase origin `git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3`'
        alias ggc='git gc --prune --aggressive'
        alias gpor='git pull --rebase origin master'
        alias gsh='git stash'
        alias gshp='git stash pop'
        alias grt='git reset'
        alias grth='git reset --hard'
        alias grts='git reset --soft'
        alias gr='git rebase'
        alias grc='git rebase --continue'
        alias gri='git rebase -i'
        alias gcom='git checkout origin/master'
        alias glo='git log --oneline --graph --decorate --all'
        alias gl='PAGER=cat git log --oneline --graph --decorate --all --max-count=30'
        alias gd='git diff'
        alias gin='git init'
        alias gdh='git diff HEAD'
        alias sudo='sudo -E '
        alias psx='ps fuxa'
        alias gra='git remote add origin '
        alias gro='git remote show'
        alias grog='git remote show origin -n'
        alias gros='git remote set-url origin'
        alias grb='git rebase --abort'
        alias ghu='hub browse -u'
        alias ghc='hub browse -u -- commit/$(git rev-parse --short HEAD) 2>/dev/null'
        alias gsu='git submodule update --init'
        alias bhc='BROWSER=/bin/echo bitbucket browse commits/$(git rev-parse --short HEAD) 2>/dev/null | sed "s@//projects/@/projects/@" '
    }


    alias dt='cd ~/dotfiles; git status -s ; PAGER=cat git diff'
    alias pr='hub pull-request -f'

    # :poe
    {
        alias po='poe -L'
        alias pox='poe -X -v'
        alias pof='poe -F -v'
    }

    # :go
    {
        alias gob='go build'
        alias goi='go install'
        alias gog='go get'
    }


    # :systemd
    {
        alias sc='sudo systemctl'
        alias scs='sudo systemctl start'
        alias scd='sudo systemctl disable'
        alias sct='sudo systemctl stop'
        alias sce='sudo systemctl enable'
        alias scu='sudo systemctl status'
    }

    # :journald
    {
        alias jcx='sudo journalctl -xe'
        alias jcxf='sudo journalctl -xef'
        alias jcu='sudo journalctl -u'
        alias jcuf='sudo journalctl -f -u'
    }
}

# @TODO move to plugin
prepend-sudo() {
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


#############################################################################
#############################################################################
#############################################################################
#############################################################################
#
ssh-add ~/.ssh/id_rsa 2>/dev/null
stty -ixon

compdef vim-which=which

eval $(dircolors ~/.dircolors.$BACKGROUND)

[ -f /etc/profile.d/fzf.zsh ] && source /etc/profile.d/fzf.zsh

fzf-history-widget() {
  local selected num
  selected=( $(fc -l 1 | $(__fzfcmd) --tac +m -n2..,.. --tiebreak=index -q "${LBUFFER//$/\\$}") )
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle redisplay
}

copy-to-http() {
    local src="$1"
    local dest=$(basename "$src")
    if [ $# -ne 1 ]; then
        dest=$2
    fi
    cp "$src" "/srv/http/$dest"
    echo -n "http://home.local/$dest" | xclip -selection clipboard
    echo "http://home.local/$dest"
}
