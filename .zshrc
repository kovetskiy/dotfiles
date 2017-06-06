. ~/bin/environment-variables

export TERM=rxvt-unicode-256color
if [ "$TMUX" ]; then
    export TERM=screen-256color-so
fi

export HISTSIZE=1000
export SAVEHIST=100000
export KEYTIMEOUT=1
export WORDCHARS=-

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

        zgen load hlissner/zsh-autopair autopair.zsh
        zgen load mafredri/zsh-async
        zgen load seletskiy/zsh-fuzzy-search-and-edit
        zgen load Tarrasch/zsh-bd

        #zgen load brnv/zsh-too-long

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
    bindkey -v "^R" fzf-history-widget
    bindkey -v "^[[A" history-substring-search-up
    bindkey -v "^[[B" history-substring-search-down
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
    bindkey "^T" :rtorrent:select
}

# :setup
{
    autoload -U add-zsh-hook
    autoload -Uz promptinit

    promptinit
    prompt lambda17

    :prompt-pwd() {
        if [[ "$PWD" == "$HOME" || "$PWD" == "$HOME/" ]]; then
            lambda17:print ''
            return
        fi

        local branch=$(basename "$PWD")
        local tree=$(
            dirname "$PWD" \
                | sed "s|$HOME|~|" \
                | sed -r 's#(/\w)[^/]+#\1#g'
        )

        lambda17:print "$tree/$branch"
    }

    zstyle -d 'lambda17:00-main' transform
    zstyle -d 'lambda17:25-head' when
    zstyle 'lambda17:05-sign' text "$"
    zstyle 'lambda17>00-root>00-main>00-status>10-dir' 15-pwd :prompt-pwd
    # uncomment if got troubles with async
    # zstyle -d 'lambda17::async' pre-draw

    zstyle 'lambda17:00-banner' right " "
    zstyle 'lambda17:09-arrow' transition ""

    :lambda17:read-terminal-background () {
        :
    }


    case $PROFILE in
        laptop)
            zstyle lambda17:05-sign fg "white"
            zstyle 'lambda17:00-banner' bg "red"
            ;;
        *)
            zstyle 'lambda17:00-banner' bg "green"
            zstyle lambda17:05-sign fg "white"
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
        lambda17:update
        zle reset-prompt
        ls -lah --color=always
        git status -s
    }
}

{
    :fzf:cd() {
        local target
        target=$(find ${1:-.} -type d -printf '%P\n' 2>/dev/null \
            | fzf-tmux +m)
        eval cd "$target"
        zle -R
        lambda17:update
        zle reset-prompt
    }

    bindkey -v '^X' :fzf:cd
    zle -N :fzf:cd
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
        find -iname "*$query*" -not -path '.' -printf '%P\n' "$@" 2>/dev/null
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
        cd $@ && ls -lah --color=always
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

    git-remote-set-devops() {
        local name=${1}
        if [[ ! "$name" ]]; then
            name=$(basename $(pwd))
        fi

        git remote remove origin
        git remote add origin "git+ssh://git.rn/devops/$name"
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

        go-makepkg -n "$package" -d . -c "$desc" "$git"
        mksrcinfo
        git add PKGBUILD .SRCINFO
    }

    aur-clone() {
        local package=$1

        :sources:get "ssh://aur@aur.archlinux.org/$package.git"
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
        if [[ "$1" = "-h" || $# == 0 ]]; then
            echo "<package> <description> [repo]" >&2
            return 1
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
        local branch=$(:git:branch)

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
        cat PKGBUILD
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
        repoctl -A arch-ngs-stable -f $(/bin/ls *.xz)
    }

    makepkg-clean-upload-testing() {
        makepkg-clean "$@"
        repoctl -A arch-ngs-testing -f $(/bin/ls *.xz)
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
        sed-replace "$from" "$to" $(sift "$from" -l) "$@"
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
            ${SUDO:+":sudo"} $(echo "${RESOLVER:+stalk -s $RESOLVER -- }") "$binary" "$@"
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


    :orgalorg:copy() {
        local server="$1"
        local remotepath="$2"
        shift 2
        orgalorg -o $server -vx -u e.kovetskiy -er $remotepath -U "${@}"
    }

    :is-interactive() {
        (
            exec 9>&1
            if [[ "$(readlink /dev/fd/9)" == *"pipe:"* ]]; then
                return 1
            else
                return 0
            fi
        )
        return $?
    }

    :nodes:query() {
        local flags=""
        if ! :is-interactive; then
            flags="-pp"
        fi

        local filters=()
        if [[ "$1" == "amf" ]]; then
            filters=("amf:true")
            shift
        fi

        if [[ "$1" && "$1" != *":"* ]]; then
            filters=("spec:$1")
            shift
        fi

        nodectl ${flags} -S ${filters[@]} ${@}
    }

    :orgalorg:exec() {
        local flags=()
        while [[ $# -ne 0 ]]; do
            if [[ "$1" == "-"* ]]; then
                flags+=("$1")
                shift
            else
                break
            fi
        done

        orgalorg -y -d 4 -t -w -s -x -u e.kovetskiy -p $(echo ${flags[@]}) -C "${@}"
    }

    :orgalorg:exec-root() {
        local flags=()
        while [[ $# -ne 0 ]]; do
            if [[ "$1" == "-"* ]]; then
                flags+=("$1")
                shift
            else
                break
            fi
        done

        orgalorg -y -d 4 -t -w -s -u root -p $(echo ${flags[@]}) -C "${@}"
    }


    :orgalorg:identify() {
        orgalorg -t -w -s -p \
            -i ~/.ssh/id_rsa.pub -u e.kovetskiy \
            -C mkdir -p /home/e.kovetskiy/.ssh \&\& tee -a /home/e.kovetskiy/.ssh/authorized_keys
    }

    compdef guess=which

    :nmap:online() {
        nmap -sP -PS22 $@ -oG - \
            | awk '/Status: Up/{ print $2; }' \
            | tee /dev/stderr \
    }

    :machines:scan:vpn() {
        local network="192.168.34."
        :nmap:online ${network}1/24 \
            | orgalorg -t -w -s -p -u $(whoami) -C hostname
    }

    :machines:laptop() {
        local machines=$(:machines:scan:vpn)
        local address=$(awk '/ laptop$/{ print $1 }' <<< "$machines")
        if [[ "$address" ]]; then
            ssh-keygen -R "$address"
            ssh $(whoami)@$address
        fi
    }

    :sources:get() {
        local target="$1"
        target=$(sed -r '
            s|^gh:|git@github.com:|;
            s|^rn:|ssh://git@git.rn/|;
            s|^(git@github.com:)?k/|git@github.com:kovetskiy/|;
            s|^(git@github.com:)?s/|git@github.com:seletskiy/|;
            s|^(git@github.com:)?r/|git@github.com:reconquest/|;
            s|^(ssh://git@git.rn/)?c(ore)?/|ssh://git@git.rn/core/|;
            s|^(ssh://git@git.rn/)?d(evops)?/|ssh://git@git.rn/devops/|;
            ' <<< "$target"
        )
        local dir=$(sed -r 's|^.*://[^/]+/||; s|^.*:||; ' <<< "$target")
        echo ":: $target -> $dir"
        if [[ ! -d ~/sources/$dir ]]; then
            git clone "$target" ~/sources/$dir
        fi

        cd ~/sources/$dir
    }

    :ash:print() {
        local review=""
        local approves=""

        review=$(ash "$@" -e /bin/cat)

        approves=$(grep -P '^### .* approved' <<< "$review" \
            | cut -d'<' -f2- \
            | cut -d'@' -f1)

        review=$(sed -r '/^###/d; /^(#)?$/d' <<< "$review")
        printf '%s\n' "$review" \
            | sed -re "
                /^#\s+---$/,/^\-\-\-/{/^(\+|\-[^\-]| )/d};
                /^\-\-\-/d;
                /^@/,+8d;
                s/^(#.*)$/$(highlight fg yellow)\\1$(highlight reset)/;
                s/^(\+\+\+.*)$/$(highlight fg blue)\\1$(highlight reset)/;
                s/^(\+.*)$/$(highlight fg light_green)\\1$(highlight reset)/;
                s/^(\-.*)$/$(highlight fg light_red)\\1$(highlight reset)/;
            "

        if [[ "$approves" ]]; then
            echo
            echo "$(highlight fg green):: "\
                "[approved] $(wc -l <<< "$approves"):" \
                "$(tr '\n' ' ' <<< "$approves")$(highlight reset)"
        fi
    }

    compdef :ash:print=ash

    :aur:spawn() {
        yes | EDITOR=cat yaourt --color "$@"
    }

    :aur:search() {
        local search=$(:aur:spawn -Ss "$@")
        {
            bmo -b '/^\033/'  '/^\033/' \
                -v 'name' '/^\033/' \
                -c "! match(name, /$@/)" <<< "$search"

            bmo -b '/^\033/'  '/^\033/' \
                -v 'name' '/^\033/' \
                -c "match(name, /$@/)" <<< "$search"
        } | grep -P "$@|"
    }

    :aur:install-or-search() {
        if [[ "$#" -eq 2 && "$2" == ":" ]]; then
            :aur:search "$1"
        else
            :aur:spawn -S "$@"
        fi
    }

    :git:master() {
        git fetch && \
            git checkout origin/master && \
            git branch -D master && \
            git checkout master

        if [[ "$1" ]]; then
            git checkout -b "$1"
        fi
    }

    :git:merge() {
        local branch=$(:git:branch)
        git checkout master
        git merge origin/"$branch"
    }

    :git:branch() {
         git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3
    }

    :rtorrent:select() {
        torrent=$(
            find ~/Downloads/ -maxdepth 1 -type f -name '*.torrent' \
                | while read filename; do
                name=$(transmission-show "$filename" \
                    | grep -P '^Name: ' \
                    | sed -r 's/Name:\s+//')
                echo "$(basename "$filename") :: $name"
            done \
                | fzf
        )

        if [[ "$torrent" ]]; then
            torrent=$(sed 's/ :: .*$//' <<< "$torrent")
            qbittorrent ~/Downloads/"$torrent"
        fi
    }

    :mplayer:run() {
        #if [[ $# -eq 0 ]]; then
            #mplayer $(/bin/ls | grep -vP '\.(jpg|jpeg|png|log|txt|cue)$')
        #else
            mplayer "$@"
        #fi
    }

    zle -N :rtorrent:select

    :move() {
        local from=""
        if [[ -f /var/run/$(id -u)/buffer-move ]]; then
            from="$(cat /var/run/$(id -u)/buffer-move)"
        fi

        if [[ ! "$from" ]]; then
            if [[ ! "$1" ]]; then
                echo "target is not specified" >&2
                return 1
            fi

            echo "$(readlink -f "$1")" > /var/run/$(id -u)/buffer-move
            return 0
        fi

        to="$1"
        if [[ ! "$to" ]]; then
            to=$(basename "$from")
        fi

        echo "$from -> $to" >&2
        mv "$from" "$to"
    }

    :rsync() {
        rsync -av --stats --progress "$@"
    }

    :w:sync() {
        :rsync home.local:$1 $1
    }

    :axel() {
        local link=$1
        local threads=${2:-10}

        axel -a -n $threads "$link"
    }

    :process:info() {
        local name="$1"
        local processes=$(pgrep -d, -x "$name")
        if [[ ! "$processes" ]]; then
            return 1;
        fi

        ps uf -p "$processes"
    }

    :watcher() {
        local timeout=0.5
        if [[ $1 =~ ^-?[.0-9]+$ ]]; then
            timeout=$1
            shift
        fi

        echo "$(highlight bold){$timeout} ${@}$(highlight reset)";
        while :; do
            eval "${@}"
            sleep $timeout
        done
    }

    :process:kill() {
        local name="$1"
        pkill -9 "$name" || pkill -f -9 "$name"
    }
    compdef :process:kill=pkill

    :gitignore:add() {
        while [[ "$1" ]]; do
            echo "$1" >> .gitignore
            shift
        done
    }

    :pacman:filter-executable() {
        while read package file; do
            if [[ -f "$file" && -x "$file" ]]; then
                echo "$package $file"
            fi
        done
    }

    :alias:register() {
        local name="$1"
        local value="$2"

        value=":alias:use \"$name\"; $value"
        alias "$name"="$value"
    }

    :alias:use() {
        local name="$1"
        echo "$name" >> ~/.zalias
    }

    :mplayer:dir-audio() {
        (
        local playlist="$(mktemp)"
        find ${1:-.} \
            -type f \
            -iregex ".*\.\(m4a\|aac\|flac\|mp3\|ogg\|wav\)$" \
            -print0 \
            | xargs -0 -n1 readlink -f \
            | sort > "$playlist"
        trap "rm $playlist" EXIT
        mplayer -novideo -playlist "$playlist"
        )
    }
}

{
    alias -g SX='--exclude-path'
    alias -g sb='| sed-remove-all-before'
    alias -g sa='| sed-remove-all-after'
    alias -g -- '#o'='| :orgalorg:exec'
    alias -g -- '#or'='| :orgalorg:exec-root'
    alias -g -- '#i'='| :orgalorg:identify'
    alias -g I='<<<'
    alias -g S='| sed-replace'
    alias -g J='| jq .'
    alias -g O='| :orgalorg:exec'
}

# :alias
{
    :alias:register 'srcd' 'cd ~/sources/'
    :alias:register 'ol' ':mplayer:dir-audio'
    :alias:register 'zl' 'zfs list'
    alias -g '#pe'='| :pacman:filter-executable'
    :alias:register 'gia' ':gitignore:add'
    :alias:register 'pk' ':process:kill'
    :alias:register 'wa' ':watcher'
    :alias:register 'pp' ':process:info'
    :alias:register 'xc' 'marvex-erase-reserves && crypt'
    :alias:register 'a' 'cat'
    :alias:register 'ax' ':axel'
    :alias:register 'vlc' '/usr/bin/vlc --no-metadata-network-access' # fffuuu
    :alias:register 'mc' 'make clean'
    :alias:register 'm' 'make'
    :alias:register 'icv' '() { iconv -f WINDOWS-1251 -t UTF-8 $1 | vim - }'
    :alias:register 'sss' 'ssh -oStrictHostKeyChecking=no'
    :alias:register 'urb' '() { curl -d url=$1 uroboro.s/api/v1/tasks/ }'
    :alias:register 'awf' '(){ audiowaveform -o "/tmp/$(basename "$1").png" -i "$1" -w 1920 -h 500 && catimg "/tmp/$(basename "$1").png" } '
    :alias:register 'svo' 'scs vpn-office'
    :alias:register 'svt' 'sct vpn-office'
    :alias:register 'rg' 'resolvconf-switch google'
    :alias:register 'goc' 'journalctl --user -u gocode.service -f'
    :alias:register 'gocleanup' "find . -type d -name '*-pkgbuild' -exec rm -rf {} \;"
    :alias:register 'wsc' ':w:sync'
    :alias:register 'j' ':move'
    :alias:register 'k' 'task-project'
    :alias:register 'o' ':mplayer:run'
    :alias:register 'op' ':mplayer:run -playlist ~/torrents/audio/.playlist -loop 0'
    :alias:register 'xd' 'RESOLVER=cname.d :launch-binary'
    :alias:register 'xs' 'RESOLVER=cname.s :launch-binary'
    :alias:register 'rt' ':rtorrent:select'
    :alias:register 'u' ':aur:install-or-search'
    :alias:register 'e' 'less'
    :alias:register 'ap' ':ash:print'
    :alias:register 'sg' ':sources:get'
    :alias:register 'ver' 'sudo vim /etc/resolv.conf'
    :alias:register 'hcp' ':orgalorg:copy'

    :alias:register 'gm' ':git:master'
    :alias:register 'ge' ':git:merge'
    :alias:register 'q' ':nodes:query'
    :alias:register 'grr' 'gri --root'
    :alias:register 'g' 'guess'
    :alias:register 'dca' 'ssh deadcrew.org aurora -A '
    :alias:register 'dcr' 'ssh deadcrew.org aurora -R '
    :alias:register 'dcq' 'ssh deadcrew.org aurora -Q '
    :alias:register 'dc' 'ssh deadcrew.org'
    :alias:register 'cs' ':cd-sources'
    :alias:register 'pmp' 'sudo pacman -U $(/bin/ls -t *.pkg.*)'
    :alias:register 'psyuz' 'psyu --ignore linux,zfs-linux-git,zfs-utils-linux-git,spl-linux-git,spl-utils-linux-git'
    :alias:register 'sudo' 'sudo -E '
    :alias:register 'mkl' 'sudo mkinitcpio -p linux'
    :alias:register 'x' ':launch-binary'
    :alias:register 'pcaa' 'sudo pacmanconfctl -A arch-ngs'
    :alias:register 'pcra' 'sudo pacmanconfctl -R arch-ngs'
    :alias:register 'wh' 'which'
    :alias:register 'ii' "ash \$(ash inbox | fzf | awk '{print \$1}')"
    :alias:register 'alq' 'alsamixer -D equal'
    :alias:register 'al' 'alsamixer'
    :alias:register 'p' 'vimpager'
    :alias:register 'sf' 'sed-files'
    :alias:register 'pas' 'packages-sync && { cd ~/dotfiles; git diff -U0 packages; }'
    :alias:register 'dud' 'cake --id 41882909 -L && cal -m'
    :alias:register 'dup' 'cake --id 39095231 -L && cal -m'
    :alias:register 'npu' 'npm-to-aur'
    :alias:register 'rx' 'sudo systemctl restart x@vt7.service xlogin@operator.service'
    :alias:register 'z' 'zabbixctl'
    :alias:register 'zp' 'zabbixctl -Tp -xxxx'
    :alias:register 'zgr' 'zgen reset'
    :alias:register 'mpk' 'makepkg-clean'
    :alias:register 'mpks' 'makepkg-clean-upload-stable'
    :alias:register 'mpkt' 'makepkg-clean-upload-testing'
    :alias:register 'ddo' 'debian-do'
    :alias:register 'ddoai' 'ddo apt-get install'
    :alias:register 'asht' 'ash-this'
    :alias:register 'urot' 'uroboros-this'
    :alias:register 'ia' 'ip a'
    :alias:register 'il' 'ip l'
    :alias:register 'td' 'touch  /tmp/debug; tail -f /tmp/debug'
    :alias:register 'stpr' 'stacket-pull-request-create'
    :alias:register 'stprr' 'reviewers-add'
    :alias:register 'strcd' 'stacket repositories create devops'
    :alias:register 'strcs' 'stacket repositories create specs'
    :alias:register 'vbs' 'vim-bundle-save'
    :alias:register 'vbr' 'vim-bundle-restore'
    :alias:register 'gbs' 'git-submodule-branch-sync'
    :alias:register 'ic' 'incidents-create'
    :alias:register 'iu' 'incidents -U'
    :alias:register 'irt' 'incidents -Rt'
    :alias:register 'irb' 'incidents -Rb'
    :alias:register 'iru' 'incidents -Ru'
    :alias:register 'str' 'strace -ff -s 100'
    :alias:register 'r' _z
    :alias:register 'cld' 'clusterctl dev'
    :alias:register 'cldl' 'clusterctl dev -L'
    :alias:register 'clp' 'clusterctl prod'
    :alias:register 'clpl' 'clusterctl prod -L'
    :alias:register 'pso' 'pdns soa update -n s'
    :alias:register 'pra' 'pdns records add'
    :alias:register 'prl' 'pdns records list'
    :alias:register 'prr' 'pdns records remove'
    :alias:register 'prda' 'pdns records add -t A -d 80'
    :alias:register 'prdac' 'pdns records add -t CNAME -d 80'
    :alias:register 'prdl' 'pdns records list -t A -d 80'
    :alias:register 'prdlc' 'pdns records list -t CNAME -d 80'
    :alias:register 'prdr' 'pdns records remove -t A'
    :alias:register 'prdrc' 'pdns records remove -t CNAME'
    :alias:register 'bhl' 'bithookctl -L'
    :alias:register 'bx' 'chmod +x ~/bin/*; chmod +x ~/deadfiles/bin/*'
    :alias:register 'ck' 'create-and-change-directory'
    :alias:register 'mf' 'man-find'
    :alias:register 'md' 'man-directive'
    :alias:register 'c' 'cd-and-ls'
    :alias:register 'ss' 'sed-replace'

    :alias:register 'h' 'ssh-enhanced'

    :alias:register 'f' 'find-iname'

    :alias:register 'si' 'ssh-copy-id'

    :alias:register 'cdp' 'cd-pkgbuild'
    :alias:register 'gog' 'go-get-enhanced'
    :alias:register 'gogd' 'go-get-enhanced-devops'
    :alias:register 'gme' 'go-makepkg-enhanced'
    :alias:register 'gmev' 'FLAGS="-p version" go-makepkg-enhanced'
    :alias:register 'gmevs' 'FLAGS="-p version -s" go-makepkg-enhanced'
    :alias:register 'gmel' 'gmev'
    :alias:register 'vw' 'vim-which'
    :alias:register 'ur' 'packages-upload-repo.s'
    :alias:register 'urx' 'packages-upload-repo.s "$(/usr/bin/ls --color=never -t *.xz | head -n1)"'
    :alias:register 'urxl' 'packages-upload-repo.s "$(/usr/bin/ls --color=never -t *.xz | head -n1)" latest'
    :alias:register 'urxc' 'packages-upload-repo.s "$(/usr/bin/ls --color=never -t *.xz | head -n1)" current'
    :alias:register 'tim' 'terminal-vim'

    :alias:register 'history' 'fc -ln 0'
    :alias:register 'rf' 'rm -rf'
    :alias:register 'ls' 'ls -lah --group-directories-first -v --color=always'
    :alias:register 'l' 'ls'
    :alias:register 'sls' 'ls'
    :alias:register 'sl' 'ls'
    :alias:register 'mp' 'mplayer -slave'
    :alias:register 'v' 'vim'
    :alias:register 'vi' 'vim'
    :alias:register 'se' 'sed -r'
    :alias:register 't' 'ssh operator@home.local'
    :alias:register 'py' 'python'
    :alias:register 'py2' 'python2'
    :alias:register 'god' 'godoc-search'
    :alias:register 'nhh' 'ssh'
    :alias:register 'nhu' 'container-status'
    :alias:register 'nhr' 'container-restart'
    :alias:register 'rto' 'qbittorrent "$(/usr/bin/ls --color=never -t ~/Downloads/*.torrent | head -n1)"'
    :alias:register 'mcan' 'mcabber-account ngs-team'
    :alias:register 'mcap' 'mcabber-account postdevops'
    :alias:register 'mcao' 'mcabber-account office'
    :alias:register 'mtd' 'migrate-to-deadfiles'
    :alias:register 'dt' 'cd ~/dotfiles; PAGER=cat git diff; git status -s ; '
    :alias:register 'rr' 'cd ~/torrents/'
    :alias:register 'de' 'cd ~/deadfiles; git status -s'
    :alias:register 'hf' 'hub fork && grsm'
    :alias:register 'hc' 'hub create'
    :alias:register 'hr' 'hub pull-request -f'
    :alias:register 'cc' 'copy-to-clipboard'
    :alias:register 'bmpk' 'bithookctl -p post -A makepkg primary'
    :alias:register 'bsl' 'bithookctl -p pre -A sould primary'
    :alias:register 'bur' 'bithookctl -p post -A uroboros uroboros'

    :alias:register 's' 'sift -i -e'
    {
    }


    # :aur
    {
        :alias:register 'au' ':aur:spawn'
        :alias:register 'auk' 'au -S --nameonly -s'
        :alias:register 'aus' 'au -S'
        :alias:register 'aur' 'au -R'
        :alias:register 'aug' 'aur-get-sources'
        :alias:register 'aq' 'yaourt -Q'
        :alias:register 'pcr' 'packages-remove'
    }

    # :pacman
    {
        :alias:register 'pmr' 'sudo pacman -R'
        :alias:register 'pq' 'sudo pacman -Q'
        :alias:register 'pql' 'sudo pacman -Ql'
        :alias:register 'pqo' 'sudo pacman -Qo'
        :alias:register 'pqi' 'sudo pacman -Qi'
        :alias:register 'pms' 'sudo pacman -S'
        :alias:register 'psyu' 'pcra && zfs-snapshot && sudo pacman -Syu'
        :alias:register 'pmu' 'sudo pacman -U'
        :alias:register 'pf' 'pkgfile'
    }

    # :packages-local
    {
        :alias:register 'pl' 'packages-local'
        :alias:register 'pla' 'packages-local -a'
    }


    # :zsh
    {
        :alias:register 'viz' 'vim ~/.zshrc'
        :alias:register 'tiz' 'terminal-vim ~/.zshrc'
        :alias:register 'zr' 'source ~/.zshrc && print "zsh config has been reloaded"'
    }


    # :git
    {
        :alias:register 'gcp' 'git cherry-pick'
        :alias:register 'gcl' 'git clone'
        :alias:register 'gh' 'git show'
        :alias:register 'gd' 'git diff'
        :alias:register 'gdo' 'git diff origin/master'
        :alias:register 'gs' 'git status --short'
        :alias:register 'ga' 'git add --no-ignore-removal'
        :alias:register 'gb' 'github-browse'
        :alias:register 'gbr' 'git branch'
        :alias:register 'gn' 'git-clean-powered'
        :alias:register 'gi' 'git add -pi'
        :alias:register 'gp' 'git push'
        :alias:register 'gpo' 'git push origin'
        :alias:register 'gpl' 'git pull'
        :alias:register 'gpr' 'git pull --rebase'
        :alias:register 'gf' 'git fetch'
        :alias:register 'gcn' 'git commit'
        alias gcn!='git commit --amend'
        :alias:register 'gc' 'git-commit'
        :alias:register 'gck' 'git commit --amend -C HEAD'
        :alias:register 'gco' 'git checkout'

        :alias:register 'gci' 'git-create-and-commit-empty-gitignore'
        :alias:register 'gclg' 'git-clone-github'
        :alias:register 'gcla' 'aur-clone'
        :alias:register 'grsd' 'git-remote-set-devops'
        :alias:register 'gclp' 'git-clone-profiles'
        :alias:register 'gcoo' 'git-checkout-orphan'
        :alias:register 'gcls' 'git-clone-sources'

        :alias:register 'gcb' 'git checkout -b'
        :alias:register 'gbn' ':git:br'
        :alias:register 'gpot' 'git push origin $(:git:branch) && { ghc || bhc }'
        alias gpot!='git push origin +$(:git:branch) && { ghc || bhc }'
        :alias:register 'gt' 'gpot'
        alias gt!='gpot!'
        :alias:register 'gut' 'gu && gt'
        :alias:register 'gu' 'git-pull'
        :alias:register 'gus' 'git stash && gu && git stash pop'
        :alias:register 'ggc' 'git gc --prune --aggressive'
        :alias:register 'gor' 'git pull --rebase origin master'
        :alias:register 'gsh' 'git stash'
        :alias:register 'gshp' 'git stash pop'
        :alias:register 'grt' 'git reset'
        :alias:register 'grh' 'git reset --hard'
        :alias:register 'grts' 'git reset --soft'
        :alias:register 'gr' 'git rebase'
        :alias:register 'grc' 'git rebase --continue'
        :alias:register 'gri' 'git-rebase-interactive'
        :alias:register 'gcom' 'git checkout master'
        :alias:register 'glo' 'git log --oneline --graph --decorate --all'
        :alias:register 'gl' 'PAGER=cat git log --oneline --graph --decorate --all --max-count=30'
        :alias:register 'gd' 'git diff'
        :alias:register 'gin' 'git init'
        :alias:register 'gdh' 'git diff HEAD'
        :alias:register 'psx' 'ps fuxa | grep'
        :alias:register 'gra' 'git remote add origin '
        :alias:register 'gro' 'git remote show'
        :alias:register 'gru' 'git remote get-url origin'
        :alias:register 'grg' 'git remote show origin -n'
        :alias:register 'grs' 'git remote set-url origin'
        :alias:register 'grsm' 'git-remote-set-origin-me'
        :alias:register 'grb' 'git rebase --abort'
        :alias:register 'ghu' 'hub browse -u'
        :alias:register 'ghc' 'hub browse -u -- commit/$(git rev-parse --short HEAD) 2>/dev/null'
        :alias:register 'glu' 'git submodule update --recursive --init'
        :alias:register 'gle' 'git submodule'
        :alias:register 'gla' 'git submodule add'
        :alias:register 'gld' 'git submodule deinit'
        :alias:register 'glf' 'git submodule foreach --recursive'
        :alias:register 'grm' 'git rm -rf'
        :alias:register 'gic' 'git add . ; git commit -m "initial commit"'
        :alias:register 'gig' 'touch .gitignore; git add .gitignore ; git commit -m "gitignore"'
        :alias:register 'bhc' 'BROWSER=/bin/echo bitbucket browse commits/$(git rev-parse --short HEAD) 2>/dev/null | sed "s@//projects/@/projects/@" '
        :alias:register 'ai' 'ash inbox'
        :alias:register 'i' 'ash inbox reviewer'
        :alias:register 'aa' 'ash-approve'
        :alias:register 'am' 'ash-merge'
    }


    # :poe
    {
        :alias:register 'po' 'poe -L -t 60'
        :alias:register 'pox' 'poe -X -v'
        :alias:register 'pof' 'poe -F -v'
    }

    # :go
    {
        :alias:register 'gob' 'go-fast-build'
        :alias:register 'b' 'go-fast-build'
        :alias:register 'goi' 'go install'
    }


    # :systemd
    {
        :alias:register 'sc' 'sudo systemctl'
        :alias:register 'scr' 'sudo systemctl restart'
        :alias:register 'scs' 'sudo systemctl start'
        :alias:register 'sce' 'sudo systemctl enable'
        :alias:register 'sct' 'sudo systemctl stop'
        :alias:register 'scd' 'sudo systemctl disable'
        :alias:register 'scu' 'sudo systemctl status'
        :alias:register 'scl' 'sudo systemctl list-units'
        :alias:register 'sdr' 'sudo systemctl daemon-reload'

        :alias:register 'us' 'systemctl --user'
        :alias:register 'uss' 'systemctl --user start'
        :alias:register 'ust' 'systemctl --user stop'
        :alias:register 'usr' 'systemctl --user restart'
        :alias:register 'use' 'systemctl --user enable'
        :alias:register 'usd' 'systemctl --user disable'
        :alias:register 'usu' 'systemctl --user status'
        :alias:register 'usl' 'systemctl --user list-units'
        :alias:register 'udr' 'systemctl --user daemon-reload'
    }

    # :journald
    {
        :alias:register 'jx' 'sudo journalctl -xe'
        :alias:register 'jxf' 'sudo journalctl -xef'
        :alias:register 'jxg' 'sudo journalctl -xe | grep '
        :alias:register 'jxfg' 'sudo journalctl -xef | grep '
        :alias:register 'ju' 'sudo journalctl -u'
        :alias:register 'juf' 'sudo journalctl -f -u'
    }

    :alias:register 'bs' '.bootstrap'
    :alias:register 'ss' '.sync'
}

{
    source ~/.zsh/issues.zsh
}


ssh-add ~/.ssh/id_rsa 2>/dev/null
stty -ixon

FZF_TMUX_HEIGHT=0
FZF_ARGS=""

source ~/.zgen/fzf.zsh || {
    cat > ~/.zgen/fzf.zsh <<< "$(
        cat $(pacman -Ql fzf | grep '.zsh$' | cut -d' ' -f2) \
            | sed -r -e 's/\+s//' -e '/bindkey/d'
    )"
    source ~/.zgen/fzf.zsh
}

eval $(dircolors ~/.dircolors.$BACKGROUND)

unset -f colors

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
