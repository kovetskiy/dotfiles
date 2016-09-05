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

        zgen load seletskiy/zsh-prompt-lambda17
        zgen load seletskiy/zsh-ssh-urxvt
        zgen load seletskiy/zsh-ash-completion
        zgen load seletskiy/zsh-hash-aliases

        zgen load deadcrew/deadfiles

        zgen load s7anley/zsh-geeknote
        zgen load seletskiy/zsh-smart-kill-word

        zgen load rupa/z  z.sh
        zgen load hlissner/zsh-autopair autopair.zsh
        zgen load mafredri/zsh-async
        zgen load seletskiy/zsh-fuzzy-search-and-edit
        zgen load Tarrasch/zsh-bd

        zgen load brnv/zsh-too-long

        zgen load seletskiy/zsh-autosuggestions
        zgen load kovetskiy/zsh-alias-search
        #zgen load seletskiy/zsh-syntax-highlighting
        #zgen load hchbaw/auto-fu.zsh

        zgen oh-my-zsh plugins/sudo

        ZGEN_AUTOLOAD_COMPINIT="-d $ZGEN_DIR/zcompdump"
        zgen save
    fi
}


#function zle-line-init () {
    #auto-fu-init
#}
#zle -N zle-line-init
#zstyle ':completion:*' completer _oldlist _complete

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
    bindkey -v '^B' backward-word
    bindkey -v '^E' forward-word
    bindkey -v "^L" clear-screen
    bindkey -v '^K' add-params
    bindkey -v '^O' toggle-quotes

    bindkey '^W' smart-backward-kill-word
    bindkey '^F' smart-forward-kill-word
    bindkey '^P' fuzzy-search-and-edit

    bindkey "^S" sudo-command-line
    bindkey "^F" alias-search
}

# :setup
{
    autoload -U add-zsh-hook
    autoload -Uz promptinit

    promptinit
    prompt lambda17

    case $PROFILE in
        laptop)
            prompt-pwd() {
                local branch=$(basename "$PWD")
                local tree=$(
                    dirname "$PWD" \
                        | sed "s|$HOME|~|" \
                        | sed -r 's#(/\w)[^\./]+#\1#g'
                )

                lambda17:printf '%s' "$tree/$branch"
            }
            zstyle 'lambda17>10-dir' 15-pwd prompt-pwd
            zstyle lambda17:05-sign text "ω"
            zstyle lambda17:05-sign fg "white"
            ;;
        *)
            zstyle lambda17:15-pwd text "%~"
            zstyle lambda17:05-sign text "ω"
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
    alias srcd='cd ~/sources/'
    bindkey -v '^N' cd-to-directory-favorites
    zle -N cd-to-directory-favorites
    cd-to-directory-favorites() {
        local __dir="$(fzf-choose-favorite)"
        if [[ ! "$__dir" ]]; then
            return
        fi

        eval cd "$__dir"

        unset __dir

        clear
        zle -R
        prompt_lambda17_precmd
        zle reset-prompt
        ls -lah --color=always
        git status -s
    }
}

# :func
{
    packages-add() {
        echo $@ >> ~/sources/dotfiles/packages
    }

    man-find() {
        man --regex -wK "$@" \
            | sed 's#.*/##g' \
            | cut -d. -f1 \
            | uniq
    }

    man-directive() {
        man $1 | less +"/^\s{7}$2\s"
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

        local cmd="$(sed 's/@/"@"/g' <<< $@)"

        local line="{ $cmd ; }"
        if $pass_stdin; then
            line="$line <<< '@'"
        fi

        local main_input="$(cat)"

        xargs -n1 -I@ echo "$line" <<< "$main_input" \
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
        smash -z $host $@
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
        local uri="$1"
        local dir="$2"
        local user=$(cut -d/ -f1 <<< "$uri")
        local project=$(cut -d/ -f2 <<< "$uri")

        if ! grep -q "/" <<< "$uri"; then
            project="$user"
            user="kovetskiy"
        fi
        if [[ "$user" = "s" ]]; then
            user="seletskiy"
        fi
        if [[ "$user" = "r" ]]; then
            user="reconquest"
        fi
        if [[ "$user" = "k" ]]; then
            user="kovetskiy"
        fi

        uri="https://github.com/$user/$project"
        echo "$uri"
        git clone "$uri" $dir
    }

    git-clone-devops() {
        git clone "git+ssh://git.rn/specs/$1" \
            || git clone "git+ssh://git.rn/devops/$1"
        cd $(basename "$1")
    }

    git-remote-set-devops() {
        local name=${1}
        if [[ ! "$name" ]]; then
            name=$(basename $(pwd))
        fi

        git remote remove origin
        git remote add origin "git+ssh://git.rn/devops/$name"
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

    alias-grep() {
        local query="$*"
        if declare -f "$query" 2>/dev/null; then
            return
        fi

        alias | grep -F -- "$*"
    }

    git-remote-set-origin-me() {
        if ! git remote | grep -q upstream; then
            git remote rename origin upstream
        fi
        local new_url=$(
            git remote show -n upstream \
            | awk '/Fetch URL:/{print $3}' \
            | sed-replace '([:/])([a-zA-Z0-9_-]+)/(\w+)' '\1me/\3'
        )
        git remote rm origin
        echo "$new_url"
        git remote add origin "$new_url"
    }

    go-get-enhanced-devops() {
        go-get-enhanced "git.rn/devops/$1"
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

        if [[ "$package" == "" || "$package" == "-h" ]]; then
            echo "aur-create-project <package> [<file>]..."
            return
        fi

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

        if [[ "$package" == "" || "$package" == "-h" ]]; then
            echo "aur-import-project-golang <package> <description> <url>"
            return
        fi

        local dir=$(mktemp -d --suffix=$package)

        local url="ssh://aur@aur.archlinux.org/$package.git"

        git clone $url $dir
        cd $dir

        git=$(sed-replace 'https?://' 'git://' <<< "$git")

        go-makepkg -d . -c "$desc" "$git"
        mksrcinfo
        git add PKGBUILD .SRCINFO
    }

    cd-pkgbuild() {
        local dir=$(basename "$(pwd)")
        if grep -q '\-pkgbuild' <<< "$dir"; then
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
            git stash
            git checkout pkgbuild
            git-clean-powered
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

        go-makepkg -g -c -n "$package" -d . $(echo $FLAGS) "$description" "$repo" $@
    }

    copy-to-clipboard() {
        if [ $# -ne 0 ]; then
            if [ -e "$1" ]; then
                xclip -selection clipboard < "$1"
            else
                xclip -selection clipboard <<< "$@"
            fi
        else
            xclip -selection clipboard
        fi

        xclip -o -selection clipboard | xclip -selection primary
    }

    restore-pkgver-pkgrel() {
        sed-replace 'pkgver=.*' 'pkgver=${PKGVER:-autogenerated}' ${1:-PKGBUILD}
        sed-replace 'pkgrel=.*' 'pkgrel=${PKGREL:-1}' ${1:-PKGBUILD}
    }

    migrate-to-deadfiles() {
        local subject="$1"
        shift

        (
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

        git pull --stat --rebase $origin $branch
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

    ash-merge() {
        local review="$1"
        ash "$1" merge
    }
    compdef ash-merge=ash

    compdef vim-which=which
    compdef smash=ssh

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

    incidents-create() {
        incidents -C \
            && cd ~/.incidents/"$(
            /usr/bin/ls --color=never -t ~/.incidents/ | head -n1)"
    }

    jira-issue-create-schedule-current() {
        local label_date=$(date +'%Y-%B' | tr '[:upper:]' '[:lower:]')
        jira-issue-create -l schedule -l $label_date "$@"
    }

    jira-issue-create-schedule-next() {
        local label_date=$(date +'%Y-%B' --date='next month' \
            | tr '[:upper:]' '[:lower:]')
        jira-issue-create -l schedule -l $label_date "$@"
    }

    git-clean-powered() {
        git clean -ffdx
    }

    batrak-move() {
        local transition="$1"
        local issue="$2"
        batrak -M $issue $transition
    }

    ssh-enhanced() {
        local hostname="$1"
        tmux set status on
        tmux set status-left "# $hostname"
        smash -z "$@"
        tmux set status off
    }

    reviews-message() {
        local project=$(basename $(pwd))
        local branch=$(git rev-parse --abbrev-ref HEAD)
        local url=$(
            git config --get \
                pull-request.$branch.url
        )
        local to=$(
            git config --get \
                pull-request.$branch.to
        )
        local log=$(
            git log \
                --pretty="%h: %s"\
                --abbrev-commit --decorate origin/$to..
        )
        local code='```'

        copy-to-clipboard <<DATA
@here:

[$project] $branch -> $to

$code
$log
$code

$url
DATA

        xclip -o -selection clipboard
    }

    ash-this() {
        local branch="$(git rev-parse --abbref-ref HEAD)"
        ash $(
            ash inbox \
                | grep -F "$(git rev-parse --abbrev-ref HEAD)" \
                | grep -F "$(basename $(git rev-parse --show-toplevel))" \
                | awk '{print $1}'
        )
    }

    uroboros-this() {
        curl -d "url=$(
            git config --get \
                pull-request.$(git rev-parse --abbrev-ref HEAD).url
        )" http://uroboro.s/api/v1/tasks/
    }

    amf-new() {
        cd ~/sources/
        stacket repositories create specs "$1"
        git clone "git+ssh://git.rn/specs/$1"
        cd "$1"
        bithookctl -p pre -A sould primary
        touch amfspec
        git add .
        git commit -m "ethernal void"
        git push origin master
    }

    makepkg-clean() {
        local branch="$1"
        rm -rf *.xz
        rm -rf src pkg
        BRANCH="$branch" makepkg -f
        restore-pkgver-pkgrel
    }

    makepkg-clean-upload-stable() {
        makepkg-clean "$@"
        packages-upload-repo.s $(/bin/ls *.xz) stable
    }

    makepkg-clean-upload-testing() {
        makepkg-clean "$@"
        packages-upload-repo.s $(/bin/ls *.xz) testing
    }

    dns-new-a() {
        local hostname="$1"
        local address="$2"
        pdns records add -t A -d 80 -n "$hostname" -c "$address"
        pdns records add -t CNAME -d 80 \
            -n "$(cut -d. -f1 <<< "$hostname").cname.s" \
            -c "$hostname"
        pdns soa update -n s
    }

    dns-new-srv() {
        local name="$1"
        local hostname="$2"
        local port="${3:-80}"

        pdns records add -n "$name._tcp.s" -c "0 $port $hostname" -t SRV -d 80 -l 60
        pdns soa update -n s
    }

    npm-to-aur() {
        local pkg="$1"
        aur-create-project "nodejs-$pkg"
        npm2PKGBUILD "$pkg" > PKGBUILD
        sed 's/ # All lowercase//' -i PKGBUILD
        sed '/^#/d' -i PKGBUILD
        echo
        cat PKGBUILD
        echo
        mksrcinfo
        git add .
        git commit -m "update pkgbuild"
        git push origin master
        makepkg
        sudo pacman -U *.xz
    }

    sed-files() {
        local from="$1"
        local to="$2"
        shift 2
        sed-replace "$from" "$to" $(sift --targets) "$@"
    }

    :launch-binary() {
        local pwd="$(pwd)"
        local name="$(basename "$pwd")"
        local binary="$pwd/$name"

        if grep -q "$GOPATH" <<< "$pwd"; then
            if ! go-fast-build; then
                return 1
            fi
        fi

        if stat "$binary" &>/dev/null; then
            ${SUDO:+":sudo"} "$binary" "$@"
        else
            echo "nothing to launch" >&2
            return 1
        fi
    }

    :sudo() {
        local cmd="$1"
        if [[ "${cmd[1]}" == ":" ]]; then
            SUDO=true "$@"
        else
            /bin/sudo -E "$@"
        fi
    }

    git-clone-sources() {
        cd ~/sources/
        git clone "$1"
    }

    :cd-sources() {
        cd ~/sources/"$@"
    }
}

# :alias
{
    alias g='guess'
    alias dca='ssh deadcrew.org aurora -A '
    alias dcr='ssh deadcrew.org aurora -R '
    alias dcq='ssh deadcrew.org aurora -Q '
    alias dc='ssh deadcrew.org'
    alias cs=':cd-sources'
    alias pmp='sudo pacman -U $(/bin/ls -t *.pkg.*)'
    alias psyuz='psyu --ignore linux,zfs-linux-git,zfs-utils-linux-git,spl-linux-git,spl-utils-linux-git'
    alias sudo=':sudo '
    alias mkl='sudo mkinitcpio -p linux'
    alias x=':launch-binary'
    alias pcaa='sudo pacmanconfctl -A arch-ngs'
    alias pcra='sudo pacmanconfctl -R arch-ngs'
    alias wh='which'
    alias ii="ash \$(ash inbox | fzf | awk '{print \$1}')"
    alias alq='alsamixer -D equal'
    alias al='alsamixer'
    alias p='vimpager'
    alias sf='sed-files'
    alias pas='packages-sync && { cd ~/dotfiles; git diff -U0 packages; }'
    alias duty='cake --id 41882909 -L && cal -m'
    alias npu='npm-to-aur'
    alias -g I='<<<'
    alias -g S='| sed-replace'
    alias -g J='| jq .'
    alias rx='sudo systemctl restart x@vt7.service xlogin@operator.service'
    alias -g K='| orgalorg -t -w -s -p -x -u e.kovetskiy -C'
    alias -g O='| orgalorg -t -w -s -p -x -u e.kovetskiy'
    alias z='zabbixctl'
    alias zp='zabbixctl -Tp -xxxx'
    alias zgr='zgen reset'
    alias mpk='makepkg-clean'
    alias mpks='makepkg-clean-upload-stable'
    alias mpkt='makepkg-clean-upload-testing'
    alias ddo='debian-do'
    alias ddoai='ddo apt-get install'
    alias asht='ash-this'
    alias urot='uroboros-this'
    alias ia='ip a'
    alias il='ip l'
    alias td='touch  /tmp/debug; tail -f /tmp/debug'
    alias np='nodectl -pp -S'
    alias ns='nodectl -S'
    alias stpr='stacket-pull-request-create'
    alias stprr='reviewers-add'
    alias strcd='stacket repositories create devops'
    alias strcs='stacket repositories create specs'
    alias vbs='vim-bundle-save'
    alias vbr='vim-bundle-restore'
    alias gbs='git-submodule-branch-sync'
    alias bkl='batrak -L -f 16053'
    alias bkk='batrak -L'
    alias bkc='batrak-move 21'
    alias bkr='batrak -R'
    alias kc='jira-issue-create-schedule-current'
    alias kn='jira-issue-create-schedule-next'
    alias ic='incidents-create'
    alias iu='incidents -U'
    alias irt='incidents -Rt'
    alias irb='incidents -Rb'
    alias iru='incidents -Ru'
    alias str='strace -ff -s 100'
    alias r=_z
    alias cld='clusterctl dev'
    alias cldl='clusterctl dev -L'
    alias clp='clusterctl prod'
    alias clpl='clusterctl prod -L'
    alias pso='pdns soa update -n s'
    alias pra='pdns records add'
    alias prl='pdns records list'
    alias prr='pdns records remove'
    alias prda='pdns records add -t A -d 80'
    alias prdac='pdns records add -t CNAME -d 80'
    alias prdl='pdns records list -t A -d 80'
    alias prdlc='pdns records list -t CNAME -d 80'
    alias prdr='pdns records remove -t A'
    alias prdrc='pdns records remove -t CNAME'
    alias bhl='bithookctl -L'
    alias bx='chmod +x ~/bin/*; chmod +x ~/deadfiles/bin/*'
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

    alias A='alias-grep'

    alias si='ssh-copy-id'

    alias cdp='cd-pkgbuild'
    alias gog='go-get-enhanced'
    alias gogd='go-get-enhanced-devops'
    alias gme='go-makepkg-enhanced'
    alias gmev='FLAGS="-p version" go-makepkg-enhanced'
    alias gmevs='FLAGS="-p version -s" go-makepkg-enhanced'
    alias gmel='gmev'
    alias vw='vim-which'
    alias ur='packages-upload-repo.s'
    alias urx='packages-upload-repo.s "$(/usr/bin/ls --color=never -t *.xz | head -n1)"'
    alias urxl='packages-upload-repo.s "$(/usr/bin/ls --color=never -t *.xz | head -n1)" latest'
    alias urxc='packages-upload-repo.s "$(/usr/bin/ls --color=never -t *.xz | head -n1)" current'
    alias tim='terminal-vim'

    alias history='fc -ln 0'
    alias m='man'
    alias rf='rm -rf'
    alias ls='ls -lah --group-directories-first -v --color=always'
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
    alias hf='hub fork && grsm'
    alias hc='hub create'
    alias hr='hub pull-request -f'
    alias cc='copy-to-clipboard'
    alias bmpk='bithookctl -p post -A makepkg primary'
    alias bsl='bithookctl -p pre -A sould primary'
    alias bur='bithookctl -p post -A uroboros uroboros'


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

    alias s='sift -i -e'
    {
        alias -g SX='--exclude-path'
    }


    # :aur
    {
        alias au='yes | EDITOR=cat yaourt '
        alias auk='au -S --nameonly -s'
        alias aus='au -S'
        alias aur='au -R'
        alias aug='aur-get-sources'
        alias aq='yaourt -Q'
        alias pcr='packages-remove'
    }

    # :pacman
    {
        alias pmr='sudo pacman -R'
        alias pq='sudo pacman -Q'
        alias pql='sudo pacman -Ql'
        alias pqo='sudo pacman -Qo'
        alias pqi='sudo pacman -Qi'
        alias pms='sudo pacman -S'
        alias psyu='pcra && zfs-snapshot && sudo pacman -Syu'
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
        alias viz='vim ~/.zshrc ; zr'
        alias tiz='terminal-vim ~/.zshrc'
        alias zr='source ~/.zshrc && print "zsh config has been reloaded"'
    }


    # :git
    {
        alias gcp='git cherry-pick'
        alias gcl='git clone'
        alias gh='git show'
        alias gd='git diff'
        alias gdo='git diff origin/master'
        alias gs='git status --short'
        alias ga='git add --no-ignore-removal'
        alias gb='github-browse'
        alias gbr='git branch'
        alias gn='git-clean-powered'
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
        alias grsd='git-remote-set-devops'
        alias gclp='git-clone-profiles'
        alias gcoo='git-checkout-orphan'
        alias gcls='git-clone-sources'

        alias gcb='git checkout -b'
        alias gbn='git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3'
        alias gpot='git push origin `git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3` && { ghc || bhc }'
        alias gpot!='git push origin +`git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3` && { ghc || bhc }'
        alias gt='gpot'
        alias gt!='gpot!'
        alias gut='gu && gt'
        alias gu='git-pull'
        alias gus='git stash && gu && git stash pop'
        alias ggc='git gc --prune --aggressive'
        alias gor='git pull --rebase origin master'
        alias gsh='git stash'
        alias gshp='git stash pop'
        alias grt='git reset'
        alias grh='git reset --hard'
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
        alias glu='git submodule update --recursive --init'
        alias gle='git submodule'
        alias gla='git submodule add'
        alias gld='git submodule deinit'
        alias glf='git submodule foreach --recursive'
        alias grm='git rm -rf'
        alias gic='git add . ; git commit -m "initial commit"'
        alias gig='touch .gitignore; git add .gitignore ; git commit -m "gitignore"'
        alias bhc='BROWSER=/bin/echo bitbucket browse commits/$(git rev-parse --short HEAD) 2>/dev/null | sed "s@//projects/@/projects/@" '
        alias ai='ash inbox'
        alias i='ash inbox reviewer'
        alias a='ash'
        alias aa='ash-approve'
        alias am='ash-merge'
    }


    # :poe
    {
        alias po='poe -L -t 60'
        alias pox='poe -X -v'
        alias pof='poe -F -v'
    }

    # :go
    {
        alias gob='go-fast-build'
        alias b='go-fast-build'
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


ssh-add ~/.ssh/id_rsa 2>/dev/null
stty -ixon

FZF_TMUX_HEIGHT=15
eval "$(
    cat $(pacman -Ql fzf | grep '.zsh$' | cut -d' ' -f2) \
        | sed-replace '^(\s+selected=.* )\+s(.*)$' '\1\2'
)"

eval $(dircolors ~/.dircolors.$BACKGROUND)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
