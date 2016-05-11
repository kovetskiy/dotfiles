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

    AUTOPAIR_INHIBIT_INIT=1

    if ! zgen saved; then
        zgen load seletskiy/zsh-zgen-compinit-tweak

        zgen load sorin-ionescu/prezto

        zgen load kovetskiy/zsh-quotes
        zgen load kovetskiy/zsh-add-params
        zgen load kovetskiy/zsh-fastcd
        zgen load kovetskiy/zsh-smart-ssh
        zgen load kovetskiy/zsh-insert-dot-dot-slash
        zgen load knu/zsh-manydots-magic manydots-magic

        zgen load seletskiy/zsh-prompt-lambda17
        zgen load seletskiy/zsh-ssh-urxvt
        zgen load seletskiy/zsh-ash-completion
        zgen load seletskiy/zsh-hash-aliases

        zgen load deadcrew/deadfiles

        zgen load s7anley/zsh-geeknote
        zgen load seletskiy/zsh-smart-kill-word

        zgen load rupa/z  z.sh
        zgen load knu/zsh-manydots-magic manydots-magic
        zgen load hlissner/zsh-autopair autopair.zsh

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
    unsetopt interactivecomments
}

# :binds
{
    bindkey -a '^[' vi-insert
    bindkey -v "^R" history-incremental-search-backward
    bindkey -v "^N" history-substring-search-down
    bindkey -v "^[[7~" beginning-of-line
    bindkey -v "^A" beginning-of-line
    bindkey -v "^Q" push-line
    bindkey -v "^[[8~" end-of-line
    bindkey -v '^?' backward-delete-char
    bindkey -v '^H' backward-delete-char
    bindkey -v '^[[3~' delete-char
    bindkey -v '^B' vi-backward-word
    bindkey -v '^E' vi-forward-blank-word
    bindkey -v "^L" clear-screen
    bindkey -v '^K' add-params
    bindkey -v '^O' toggle-quotes
    bindkey -v "^_" insert-dot-dot-slash

    bindkey '^W' smart-backward-kill-word
    bindkey '^P' smart-forward-kill-word
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
    setopt rmstarsilent
    setopt append_history
    setopt extended_history
    setopt hist_expire_dups_first
    setopt hist_ignore_dups
    setopt hist_ignore_space
    setopt hist_verify
    setopt inc_append_history
    setopt share_history

    hash-aliases:install
    autopair-init
    zstyle ':smart-ssh' whitelist .s .in.ngs.ru

    zstyle ':zle:smart-kill-word' precise always
    zstyle ':zle:smart-kill-word' keep-slash true
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

        if [ $# -ne 0 ]; then
            echo "$*" \
                | smart-ssh -t "$hostname" \
                    "sudo -i \$SHELL" 2>/dev/null
        else
            smart-ssh -t "$hostname" "TERM=xterm sudo -i" 2>/dev/null
        fi
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
        shift

        local to=""
        if [ $# -ne 0 ]; then
            to=$(sed 's@/@\\/@g' <<< "$1")
            shift
        fi

        if [ $# -ne 0 ]; then
            local diff=false
            local files=()
            for file in $@; do
                if [ "$file" = "!" ]; then
                    diff=true
                else
                    files+=("$file")
                fi
            done

            for file in "${files[@]}"; do
                if $diff; then
                    after=$(mktemp -u)
                    sed -r "s/$from/$to/g" $file > $after
                    git diff --color $file $after | diff-so-fancy
                else
                    sed -ri "s/$from/$to/g" $file
                fi
            done

        else
            sed -r "s/$from/$to/g"
        fi
    }

    sed-remove-all-before() {
        local query="$1"
        shift
        sed-replace ".*$query" "" $@
    }

    sed-remove-all-after() {
        local query="$1"
        shift
        sed-replace "$query.*" "" $@
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
        local pass_stdin=false
        if [ "$1" = "-" ]; then
            pass_stdin=true
            shift
        fi

        local cmd="$@"

        local line="{ $cmd ; }"
        if $pass_stdin; then
            line="$line <<< '{}'"
        fi

        local main_input="$(cat)"

        xargs -n1 -I{} echo "$line" <<< "$main_input" \
            | while read subcmd; do
                eval "(${subcmd[@]})" </dev/tty
            done
    }

    container-host-ssh() {
        local env=$(sed 's/^\(.*.ru\.\|\.\)//' <<< "$1")
        shift

        local host
        host=$(deployer -Qe "$env" \
            | grep '^node0:$' -A 3 \
            | awk '/host:/ {print $2}')
        ssh-enhanced $host $@
    }

    container-status() {
        local env="$1"
        shift

        container-host-ssh "$env" heaver -L | ag -F "$env"
    }

    container-guess-and-fix-problem() {
        local env="$1"
        shift

        local env_status=$(container-status "$env")
        echo "container status:"
        echo "$env_status"

        local container=$(awk '/frozen/ { print $1 }' <<< "$env_status")
        if [ "$container" ]; then
            echo "container frozen by memory, restarting..."
            container-host-ssh $env heaver -T $container
            container-host-ssh $env heaver -S $container
        fi
    }

    cd-and-ls() {
        cd $@
        ls -lah --color=always
    }

    git-clone-github() {
        git clone "https://github.com/$1" $2
    }

    git-clone-devops() {
        git clone "git+ssh://git.rn/devops/$1" $2
    }

    git-clone-profiles() {
        git clone "git+ssh://git.rn/profiles/$1" $2
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

    git-remote-set-origin-me() {
        git remote rename origin upstream
        new_url=$(
            git remote show -n upstream \
            | awk '/Fetch URL:/{print $3}' \
            | sed-replace '(\w)([:/])\w+/' '\1:me/'
        )
        git remote remove origin
        git remote add origin "$new_url"
    }

    go-get-enhanced() {
        if [ $# -eq 0 ]; then
            go get
            return
        fi

        local url=""
        local dir=""
        local flags=("-v")
        local update=false
        if [ "$1" = "u" -o "$1" = "-u" -o "$1" = "-" ]; then
            flags+=("-u")
            update=true
            shift
        fi

        if [ $# -eq 0 ]; then
            go get ${flags[@]}
            return
        fi

        import=$(sed 's/.*:\/\///' <<< "$1")
        shift

        flags+=("$@")
        local slashes=$(grep -o '/'  <<< "$import" | wc -l)
        if [ $slashes = 1 ]; then
            user=$(cut -d/ -f1 <<< "$import")
            repo=$(cut -d/ -f2 <<< "$import")
            case "$user" in
                s)
                    import="seletskiy/$repo"
                    ;;

                r)
                    import="reconquest/$repo"
                    ;;

                d)
                    import="deadcrew/$repo"
                    ;;
            esac

            import="github.com/$import"
        fi

        if $update && [ $slashes = 0 ]; then
            dependency_import=$(
                go list -f \
                    '{{ range $dep := .Deps }}{{ $dep }}{{ "\n" }}{{ end }}' . \
                    | awk "/\/$import\$/ { print }"
            )
            if [ "$dependency_import" ]; then
                import=$dependency_import
            fi
        fi

        if [ ! "$dependency_import" ] && [ $slashes = 0 ]; then
            import="github.com/kovetskiy/$import"
        fi

        go get ${flags[@]} $import

        dir=$GOPATH/src/$import
        if [[ "$dir" == *.git ]]; then
            dir=$(sed 's/\.git//' <<< "$dir")
        fi

        if [ -d $dir ]; then
            cd $dir
            git submodule update --init
        fi
    }

    create-and-change-directory() {
        mkdir -p "$@"
        cd "$@"
    }

    aur-create-project() {
        local package="$1"
        local dir=$(mktemp -d --suffix=$package)
        local url="ssh://aur@aur.archlinux.org/$package.git"

        git clone $url $dir

        if [[ $# -gt 1 ]]; then
            while shift &>/dev/null; do
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
        if  grep -q '\-pkgbuild' <<< "$dir"; then
            cd ../$(sed -r 's/\-pkgbuild//g' <<< "$dir")
            return
        fi

        local dir_pkgbuild="${dir}-pkgbuild"

        if [ -d "../$dir_pkgbuild" ]; then
            cd "../$dir_pkgbuild"
            return
        fi

        cp -r "../$dir" "../$dir_pkgbuild"

        cd "../$dir_pkgbuild"

        if [ "$(git rev-parse --abbrev-parse HEAD)" = "pkgbuild" ]; then
            return
        fi

        git fetch

        if git branch -a | grep -q pkgbuild; then
            git checkout pkgbuild
            return
        fi

        git-checkout-orphan pkgbuild
    }

    go-makepkg-enhanced() {
        if [ "$1" = "-h" ]; then
            echo "package description [repo]"
            return
        fi

        local package="$1"
        local description="$2"
        local repo="$3"
        shift 2

        if [ "$repo" ]; then
            shift
        else
            repo=$(git remote get-url origin)
            if grep -q "github.com" <<< "$repo"; then
                repo=$(sed-replace '.*@' 'git://' <<< "$repo")
                repo=$(sed-replace '.*://' 'git://' <<< "$repo")
            fi
        fi

        set -x
        go-makepkg -g -c -n "$package" -d . $(echo $FLAGS) "$description" "$repo" $@
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

        cat | xclip -selection clipboard
    }

    restore-pkgver-pkgrel() {
        sed-replace 'pkgver=.*' 'pkgver=${PKGVER:-autogenerated}' ${1:-PKGBUILD}
        sed-replace 'pkgrel=.*' 'pkgrel=${PKGREL:-1}' ${1:-PKGBUILD}
    }

    migrate-to-deadfiles() {
        local subject="$1"
        shift

        (
            set -euo pipefail
            local dotfiles=~/dotfiles
            local deadfiles=~/deadfiles

            cd $dotfiles
            git stash
            git pull --rebase origin master

            cd $deadfiles
            git stash
            git pull --rebase origin master

            for file in $@; do
                install -DT $dotfiles/$file $deadfiles/$file
                rm -r $dotfiles/$file
            done

            cd $deadfiles
            git add .
            git commit -m "$subject migrated from kovetskiy/dotfiles"
            git push origin master
            git stash pop

            cd $dotfiles
            git add .
            git commit -m "$subject migrated to deadcrew/deadfiles"
            git push origin master
            git stash pop
        )
    }

    github-browse() {
        local file="$1"
        local line="${2:+#L$2}"
        hub browse -u -- blob/$(git rev-parse --abbrev-ref HEAD)/$file$line
    }
    compdef github-browse=ls

    git-pull() {
        local origin="origin"
        local branch=$(git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3)

        if [ $# -ne 0 ]; then
            local option=$1
            if [ "$option" = "upstream" ]; then
                origin=$option
            else
                branch=$option
            fi
        fi
        git pull --rebase $origin $branch
    }

    aur-get-sources() {
        local package=$1
        cd /tmp/
        yaourt -G "$package"
        cd "$package"
    }

    ash-approve() {
        local review="$1"
        ash "$1" approve
    }
    compdef ash-approve=ash

    compdef vim-which=which

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

    git-rebase-interactive() {
        if [[ "$1" =~ ^[0-9]+$ ]]; then
            git rebase -i "HEAD~$1"
            return $?
        fi

        git rebase -i $@
    }
}

# :alias
{
    alias str='strace -ff -s 100'
    alias r=_z
    alias cld='clusterctl dev'
    alias cldl='clusterctl dev -L'
    alias clp='clusterctl prod'
    alias clpl='clusterctl prod -L'
    alias pra='pdns records add'
    alias prl='pdns records list'
    alias prr='pdns records remove'
    alias prda='pdns records add -t A -d 80'
    alias prdac='pdns records add -t CNAME -d 80'
    alias prdl='pdns records list -t A -d 80'
    alias prdlc='pdns records list -t CNAME -d 80'
    alias prdr='pdns records remove -t A'
    alias prdrc='pdns records remove -t CNAME'
    alias bl='bithookctl -L'
    alias bx='chmod +x ~/bin/*'
    alias ck='create-and-change-directory'
    alias mf='man-find'
    alias md='man-directive'
    alias c='cd-and-ls'
    alias ss='sed-replace'
    alias -g sb='| sed-remove-all-before'
    alias -g sa='| sed-remove-all-after'
    alias -g C='| cut-d-t'

    alias h='ssh-enhanced'

    alias f='find-iname'
    alias -g X='| xargs-eval'

    alias A='alias-search'

    alias si='ssh-copy-id'

    alias cdp='cd-pkgbuild'
    alias gog='go-get-enhanced'
    alias gme='go-makepkg-enhanced'
    alias gmev='FLAGS="-p version" go-makepkg-enhanced'
    alias gmel='gmev'
    alias mpk='makepkg -fc; pkr'
    alias mpk!='rm -rf *xz; rm -rf {pkg,src}; makepkg -fc; pkr'
    alias mpkc='mpk! && urxc'
    alias vw='vim-which'
    alias ur='packages-upload-repo.s'
    alias urx='packages-upload-repo.s "$(/usr/bin/ls --color=never -t *.xz | head -n1)"'
    alias urxl='packages-upload-repo.s "$(/usr/bin/ls --color=never -t *.xz | head -n1)" latest'
    alias urxc='packages-upload-repo.s "$(/usr/bin/ls --color=never -t *.xz | head -n1)" current'
    alias tim='terminal-vim'
    alias pkr='restore-pkgver-pkgrel'

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
    alias py='python'
    alias py2='python2'
    alias god='godoc-search'
    alias nhh='ssh'
    alias nhu='container-status'
    alias nhr='container-restart'
    alias rto='rtorrent "$(/usr/bin/ls --color=never -t ~/Downloads/*.torrent | head -n1)"'
    alias mcan='mcabber-account ngs-team'
    alias mcap='mcabber-account postdevops'
    alias mcao='mcabber-account office'
    alias mtd='migrate-to-deadfiles'
    alias dt='cd ~/dotfiles; PAGER=cat git diff; git status -s ; '
    alias de='cd ~/deadfiles; git status -s'
    alias hf='hub fork'
    alias hc='hub create'
    alias hr='hub pull-request -f'
    alias cc='copy-to-clipboard'
    alias bmpk='bithookctl -p post -A makepkg primary'
    alias bsl='bithookctl -p pre -A sould primary'


    # :globals
    {
        alias -g G='EO | grep --color -P'
        alias -g L='EO | less -r'
        alias -g H='EO | head -n'
        alias -g T='EO | tail -n'
        alias -g Xa='| xargs -n1 -I{} '
        alias -g EO='2>&1'
        alias -g EN='2>/dev/null'
    }

    alias s='sift -e'
    {
        alias -g SX='--exclude-path'
    }


    # :aur
    {
        alias au='yes | EDITOR=cat yaourt '
        alias aus='au -S'
        alias aur='au -R'
        alias aug='aur-get-sources'
        alias aq='yaourt -Q'
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

    # :packages-local
    {
        alias pl='packages-local'
        alias pla='packages-local -a'
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
        alias gb='github-browse'
        alias gbr='git branch'
        alias gn='git clean -fd; git clean -fdX'
        alias gi='git add -pi'
        alias gp='git push'
        alias gpo='git push origin'
        alias gpl='git pull'
        alias gpr='git pull --rebase'
        alias gf='git fetch'
        alias gcn='git commit'
        alias gcn!='git commit --amend'
        alias gc='git-commit'
        alias gck='git commit --amend -C HEAD'
        alias gco='git checkout'

        alias gci='git-create-and-commit-empty-gitignore'
        alias gclg='git-clone-github'
        alias gcld='git-clone-devops'
        alias gclp='git-clone-profiles'
        alias gcoo='git-checkout-orphan'

        alias gcb='git checkout -b'
        alias gbn='git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3'
        alias gpot='git push origin `git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3` && { ghc || bhc }'
        alias gpot!='git push origin +`git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3` && { ghc || bhc }'
        alias gt='gpot'
        alias gt!='gpot!'
        alias gu='git-pull'
        alias gus='git stash && gu && git stash pop'
        alias ggc='git gc --prune --aggressive'
        alias gor='git pull --rebase origin master'
        alias gsh='git stash'
        alias gshp='git stash pop'
        alias grt='git reset'
        alias grth='git reset --hard'
        alias grts='git reset --soft'
        alias gr='git rebase'
        alias grc='git rebase --continue'
        alias gri='git-rebase-interactive'
        alias gcom='git checkout master'
        alias glo='git log --oneline --graph --decorate --all'
        alias gl='PAGER=cat git log --oneline --graph --decorate --all --max-count=30'
        alias gd='git diff'
        alias gin='git init'
        alias gdh='git diff HEAD'
        alias sudo='sudo -E '
        alias psx='ps fuxa | grep'
        alias gra='git remote add origin '
        alias gro='git remote show'
        alias gru='git remote get-url origin'
        alias grg='git remote show origin -n'
        alias grs='git remote set-url origin'
        alias grsm='git-remote-set-origin-me'
        alias grb='git rebase --abort'
        alias ghu='hub browse -u'
        alias ghc='hub browse -u -- commit/$(git rev-parse --short HEAD) 2>/dev/null'
        alias gsu='git submodule update --init'
        alias gic='git add . ; git commit -m "initial commit"'
        alias bhc='BROWSER=/bin/echo bitbucket browse commits/$(git rev-parse --short HEAD) 2>/dev/null | sed "s@//projects/@/projects/@" '
        alias ai='ash inbox'
        alias i='ash inbox reviewer'
        alias a='ash'
        alias aa='ash-approve'
    }


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
    }


    # :systemd
    {
        alias sc='sudo systemctl'
        alias scs='sudo systemctl start'
        alias sct='sudo systemctl stop'
        alias scr='sudo systemctl restart'
        alias sce='sudo systemctl enable'
        alias scd='sudo systemctl disable'
        alias scu='sudo systemctl status'
        alias scl='sudo systemctl list-unit-files'

        alias us='systemctl --user'
        alias uss='systemctl --user start'
        alias ust='systemctl --user stop'
        alias usr='systemctl --user restart'
        alias use='systemctl --user enable'
        alias usd='systemctl --user disable'
        alias usu='systemctl --user status'
        alias usl='systemctl --user list-unit-files'

        alias sdr='sudo systemctl daemon-reload'
    }

    # :journald
    {
        alias jx='sudo journalctl -xe'
        alias jxf='sudo journalctl -xef'
        alias jxg='sudo journalctl -xe | grep '
        alias jxfg='sudo journalctl -xef | grep '
        alias ju='sudo journalctl -u'
        alias juf='sudo journalctl -f -u'
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

ssh-add ~/.ssh/id_rsa 2>/dev/null
stty -ixon

eval "$(
    cat $(pacman -Ql fzf | grep '.zsh$' | cut -d' ' -f2) \
        | sed-replace '^(\s+selected=.* )\+s(.*)$' '\1\2'
)"

eval $(dircolors ~/.dircolors.$BACKGROUND)
