. ~/bin/environment-variables

export TERM=xterm-kitty
export TERM=screen-256color

export KEYTIMEOUT=1
export WORDCHARS=-

# :prezto
{
    zstyle ':prezto:*:*' color 'yes'
    zstyle ':prezto:load' pmodule \
        'helper' \
        'environment' \
        'terminal' \
        'history' \
        'directory' \
        'completion' \
        'git'

    zstyle ':prezto:module:editor' key-bindings 'vi'
    zstyle ':completion:*' rehash true
}

# :zle
{
    zle() {
        if [[ "$1" == "-R" || "$1" == "-U" ]]; then
            unset -f zle

            compinit

            :plugins:load
            :compdef:load
        fi

        builtin zle "${@}"
    }
}

# :zgen
{
    if [ ! -d ~/.zgen ]; then
        git clone https://github.com/tarjoilija/zgen ~/.zgen
    fi

    if [ ! -d ~/.zpezto ]; then
        ln -sfT ~/.zgen/sorin-ionescu/prezto-master ~/.zprezto
    fi


    AUTOPAIR_INHIBIT_INIT=1

    source ~/.zgen/zgen.zsh

    compinit

    if ! zgen saved; then
        zgen load seletskiy/zsh-zgen-compinit-tweak

        zgen load sorin-ionescu/prezto

        zgen load seletskiy/zsh-prompt-lambda17

        zgen load mafredri/zsh-async

        zgen save
    fi
}

{
    :plugins:load() {
        [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

        zgen load kovetskiy/zsh-quotes
        zgen load kovetskiy/zsh-add-params
        zgen load kovetskiy/zsh-fastcd
        zgen load kovetskiy/zsh-smart-ssh
        zgen load kovetskiy/zsh-insert-dot-dot-slash

        #zgen load seletskiy/zsh-ssh-urxvt
        zgen load seletskiy/zsh-hash-aliases

        zgen load deadcrew/deadfiles

        zgen load seletskiy/zsh-smart-kill-word

        zgen load hlissner/zsh-autopair autopair.zsh
        zgen load seletskiy/zsh-fuzzy-search-and-edit

        zgen load kovetskiy/zsh-alias-search

        zgen oh-my-zsh plugins/sudo
        zgen load zsh-users/zsh-history-substring-search

        zgen load zdharma/fast-syntax-highlighting

        zgen load seletskiy/zsh-hijack

        ZSH_AUTOSUGGEST_STRATEGY=("history")
        zgen load zsh-users/zsh-autosuggestions && _zsh_autosuggest_start

        hash-aliases:install
        autopair-init
    }
}

{
    :compdef:load() {
        compdef :process:kill=pkill
        compdef github-browse=ls
        compdef man-directive=man
        compdef vim-which=which
        compdef smash=ssh
        compdef guess=which
    }
}


{
    if [[ "$BACKGROUND" == "light" ]]; then
        #export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=9"
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
    setopt rcquotes
}

# :binds
{
    bindkey -a '^[' vi-insert
    bindkey -v "^R" fzf-history-widget
    bindkey -v "^[[A" history-substring-search-up
    bindkey -v "^[[B" history-substring-search-down
    #bindkey -v "^A" beginning-of-line
    bindkey "^[[1~" beginning-of-line
    bindkey "^[[7~" beginning-of-line
    #bindkey -v "^P" end-of-line
    bindkey "^[[4~" end-of-line
    bindkey "^[[8~" end-of-line
    bindkey -v "^A" push-line
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
    zstyle 'lambda17:05-sign' text "→"
    zstyle 'lambda17>00-root>00-main>00-status>10-dir' 15-pwd :prompt-pwd
    zstyle "lambda17:20-git" left " "

    zstyle 'lambda17:00-banner' right " "
    zstyle 'lambda17:09-arrow' transition ""

    zstyle -d 'lambda17:91-exit-code' text
    zstyle -d 'lambda17:91-exit-code' when
    zstyle -d 'lambda17:91-exit-code' fg

    if [[ "${PROFILE}" == "laptop" ]]; then
        zstyle 'lambda17:00-banner' bg 'black'
        zstyle 'lambda17:05-sign' fg 'white'
    else
        zstyle 'lambda17:00-banner' bg 'white'
        zstyle 'lambda17:05-sign' fg 'black'
    fi

    zstyle "lambda17:26-git-clean" fg "black"
    zstyle "lambda17:25-head" fg-branch "black"
    zstyle "lambda17:25-head" fg-tag "black"
    zstyle "lambda17:25-head" fg-empty "black"
    zstyle "lambda17:26-git-clean" fg "black"
    zstyle "lambda17:01-git-stash" fg "black"
    zstyle "lambda17:26-git-dirty" text " ↕"

    :lambda17:read-terminal-background () {
        :
    }

    # uncomment if got troubles with async
    zstyle -d 'lambda17::async' pre-draw

    autoload -U colors
    colors

    setopt prompt_sp
    PROMPT_EOL_MARK=''

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
    bindkey -v '^N' :favor
    zle -N :favor
    :favor() {
        local favor_dir="$(favor 2>/dev/null)"
        if [[ ! "$favor_dir" ]]; then
            return
        fi

        eval cd "$favor_dir"
        unset favor_dir

        #clear
        zle -R
        lambda17:update
        zle reset-prompt
    }

    bindkey -v '^Q' :fzf:git:file:cd
    zle -N :fzf:git:file:cd
    :fzf:git:file:cd() {
        local favor_dir="$(fzf-git-file)"
        if [[ ! "$__dir" ]]; then
            return
        fi

        eval cd "$(dirname "$__dir")"

        unset __dir

        zle -R
        lambda17:update
        zle reset-prompt
        ls -lah --color=always
    }

    bindkey -v '^P' :fzf:git:file:vim
    zle -N :fzf:git:file:vim
    :fzf:git:file:vim() {
        local __target="$(fzf-git-file)"
        if [[ ! "$__target" ]]; then
            return
        fi

        __target=$(grep -Po "$(pwd)/\K.*" <<< "$__target")

        BUFFER="vim $__target"
        zle accept-line -w
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

    :find() {
        ag -f -l -U -g "$*" --nocolor
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
        mkdir -p /tmp/go-makepkg-$package/
        cd /tmp/go-makepkg-$package/
        local description="$2"
        local repo="$3"
        shift 2

        if [ "$repo" ]; then
            shift
        else
            repo=$(git remote get-url origin)
        fi

        if grep -q "github.com" <<< "$repo"; then
            repo=$(sed-replace '.*@' 'git://' <<< "$repo")
            repo=$(sed-replace '.*://' 'git://' <<< "$repo")
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


    git-rebase-interactive() {
        if [[ "$1" =~ ^[0-9]+$ ]]; then
            git rebase -i "HEAD~$1"
            return $?
        fi

        git rebase -i $@
    }

    git-clean-powered() {
        git clean -ffdx
    }

    ssh-enhanced() {
        local hostname="$1"
        tmux set status on
        tmux set status-left "# $hostname"
        smash -z "$@"
        tmux set status off
    }
    makepkg-clean() {
        local branch="$1"
        rm -rf *.xz
        rm -rf src pkg
        BRANCH="$branch" makepkg -f
        restore-pkgver-pkgrel
    }

    sed-files() {
        local from="$1"
        local to="$2"
        shift 2
        sed-replace "$from" "$to" $(sift "$from" -l) "$@"
    }

    sed-delete() {
        local query="$1"
        shift 1

        delete_pattern="${query//\//\\/}"
        sed -r -i "/${delete_pattern}/d" $(sift "$query" -l) "$@"
    }

    git-clone-sources() {
        cd ~/sources/
        git clone "$1"
    }

    :cd-sources() {
        cd ~/sources/"$@"
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


    :nmap:online() {
        nmap -sP -PS22 $@ -oG - \
            | awk '/Status: Up/{ print $2; }' \
            | tee /dev/stderr \
    }

    :sources:get() {
        local target="$1"
        target=$(sed -r '
            s|^gh:|git@github.com:|;
            s|^(git@github.com:)?k/|git@github.com:kovetskiy/|;
            s|^(git@github.com:)?s/|git@github.com:seletskiy/|;
            s|^(git@github.com:)?r/|git@github.com:reconquest/|;
            ' <<< "$target"
        )
        if ! grep -q "://" <<< "$target"; then
            target="https://${target}"
        fi

        local dir=$(sed -r 's|^.*://[^/]+/||; s|^.*:||; ' <<< "$target")
        echo ":: $target -> $dir"
        if [[ ! -d ~/sources/$dir ]]; then
            git clone "$target" ~/sources/$dir
        fi

        cd ~/sources/$dir
    }

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
        git rev-parse --abbrev-ref HEAD
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
        if [[ -f /var/run/user/$(id -u)/buffer-move ]]; then
            from="$(cat /var/run/user/$(id -u)/buffer-move)"
        fi

        if [[ ! "$from" ]]; then
            if [[ ! "$1" ]]; then
                echo "target is not specified" >&2
                return 1
            fi

            echo "$(readlink -f "$1")" > /var/run/user/$(id -u)/buffer-move
            return 0
        fi

        to="$1"
        if [[ ! "$to" ]]; then
            to=$(basename "$from")
        fi

        echo "$from -> $to" >&2
        mv "$from" "$to"
        rm /var/run/user/$(id -u)/buffer-move
    }

    :rsync() {
        rsync -av --stats --progress "$@"
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
        source ~/deadfiles/bin/watchit
        :watchit "${@}"
    }

    :process:kill() {
        local name="$1"
        if [[ ! "$name" ]]; then
            echo "no name specified"
            return 1
        fi
        pkill -9 "$name" || pkill -f -9 "$name"
    }

    :gitignore:add() {
        while [[ "$1" ]]; do
            local filename="$1"
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

    :mplayer:dir-audio() {
        # subshell for trap
        (
            local playlist="$(mktemp)"
            trap "rm $playlist" EXIT
            while [[ "$1" ]]; do
                find "${1:-.}" \
                    -type f \
                    -iregex ".*\.\(m4a\|aac\|flac\|mp3\|ogg\|wav\)$" \
                    -print0 \
                    | xargs -0 -n1 readlink -f \
                    | sort >> "$playlist"
                shift
            done

            mplayer -novideo -playlist "$playlist"
        )
    }

    :copy-line() {
        head -n "$1" | tail -n 1 | copy-to-clipboard
    }

    :join_by() {
        local d=$1;
        shift;
        echo -n "$1";
        shift;
        printf "%s" "${@/#/$d}";
    }

    :search:go() {
        EXT=go :search "${@}"
    }

    :search() {
        sift -s "${@}"
    }

    :circleci:exec() {
        circleci-cli --token-file ~/.config/circleci/token "${@}"
    }

    :circleci:recent-build() {
        watch -c -n0.0 circleci-recent-build
    }

    :find-gem() {
        if gem=$(gem list \
            | grep "${1} " \
            | sed 's/ (/-/' \
            | sed 's/)//'); then
            echo "gem: ${gem}"
            cd /usr/lib/ruby/gems/2.5.0/gems/"$gem"
        fi
    }
}

{
    alias -g SX='--exclude-path'
    alias -g sb='| sed-remove-all-before'
    alias -g sa='| sed-remove-all-after'
    alias -g I='<<<'
    alias -g S='| sed-replace'
    alias -g J='| jq .'
    alias -g '#pe'='| :pacman:filter-executable'

    alias -g '#t'='| :copy-line'
    alias -g '#k'='| karma-grep'
}

ssha() {
    if [[ ! "${_ssh_added}" ]]; then
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_rsa
        _ssh_added=true
    fi
    /bin/ssh -A "$@"
}

:hosts:add() {
    local server="$1"
    local hostname="$2"

    if ! grep -qP '^[0-9\.]+$' <<< "$server"; then
        echo "$server is not an ip address" >&2
        return 1
    fi

    echo "$server $hostname" | sudo tee -a /etc/hosts
}

git-commit-branch() {
    local branch=$(git rev-parse --abbrev-ref HEAD)
    git-commit "${branch}" "${@}"
}

:until() {
    until ! eval "${@}"; do
        sleep 0.05
    done
}

:orgalorg:exec() {
    zparseopts -D -E -- u:=username
    orgalorg -y ${username:--uEgor.Kovetskiy} -x -C "${@}"
}

:orgalorg:exec-stdin() {
    zparseopts -D -E -- u:=username
    orgalorg -y ${username:--uEgor.Kovetskiy} -x -s -C "${@}"
}

:orgalorg:exec-host() {
    local host="$1"
    shift

    :orgalorg:exec -o "${host}" "${@}"
}

# :alias
{
    alias ox=':orgalorg:exec'
    alias oxs=':orgalorg:exec-stdin'
    alias oxh=':orgalorg:exec-host'
    alias un=':until'
    alias dg='guts-shell'
    alias ha=':hosts:add'
    alias se='ssha -l Egor.Kovetskiy '
    alias rs='rm -rf ~/.cache/ssh_*'
    alias mc='sudo machinectl'
    alias gg=':find-gem'
    alias mpa='mp *'
    alias mp='mpv --slang=eng --alang=eng -fs'
    alias ju='journalctl --user-unit'
    alias s='sift'
    alias e='less -i'
    alias 8='mtr 8.8.8.8'
    alias 'ccl'=':circleci:exec recent-builds'
    alias 'ccr'=':circleci:recent-build'
    alias 'giv'='go install ./vendor/...'
    alias 'ml'=':makefile:list'
    alias 'sl'='rm -rf ~/.ssh/connections/*'
    alias 'pg'='() { pwgen $1 1 }'
    alias 'sudo'='sudo -E '
    alias 'srcd'='cd ~/sources/'
    alias 'ol'=':mplayer:dir-audio'
    alias 'zl'='zfs list'
    alias 'gia'=':gitignore:add'
    alias 'pk'=':process:kill'
    alias 'wa'=':watcher'
    alias 'pp'=':process:info'
    alias 'xc'='marvex-erase-reserves && crypt'
    alias 'a'='cat'
    alias 'ax'=':axel'
    alias 'vlc'='/usr/bin/vlc --no-metadata-network-access' # fffuuu
    alias 'm'='make'
    alias 'icv'='() { iconv -f WINDOWS-1251 -t UTF-8 $1 | vim - }'
    alias 'sss'='ssh -oStrictHostKeyChecking=no'
    alias 'awf'='(){ audiowaveform -o "/tmp/$(basename "$1").png" -i "$1" -w 1920 -h 500 && catimg "/tmp/$(basename "$1").png" } '
    alias 'rg'='resolvconf-switch google'
    alias 'goc'='journalctl --user-unit gocode.service -f'
    alias 'gocleanup'="find . -type d -name '*-pkgbuild' -exec rm -rf {} \;"
    alias 'j'=':move'
    alias 'o'=':mplayer:run'
    alias 'op'=':mplayer:run -playlist ~/torrents/audio/.playlist -loop 0'
    alias 'rt'=':rtorrent:select'
    alias 'u'=':aur:install-or-search'
    alias 'sg'=':sources:get'
    alias 'ver'='sudo vim /etc/resolv.conf'

    alias 'gm'=':git:master'
    alias 'ge'=':git:merge'
    alias 'q'=':nodes:query'
    alias 'grr'='gri --root'
    alias 'g'='guess'
    alias 'cs'=':cd-sources'
    alias 'pmp'='sudo pacman -U $(/bin/ls -t *.pkg.*)'
    alias 'psyuz'='psyu --ignore linux,zfs-linux-git,zfs-utils-linux-git,spl-linux-git,spl-utils-linux-git'
    alias 'mkl'='sudo mkinitcpio -p linux'
    alias 'x'=':launch-binary'
    alias 'wh'='which'
    alias 'alq'='alsamixer -D equal'
    alias 'al'='alsamixer'
    alias 'p'='vimpager'
    alias 'sf'='sed-files'
    alias 'sd'='sed-delete'
    alias 'pas'='packages-sync && { cd ~/dotfiles; git diff -U0 packages; }'
    alias 'rx'='sudo systemctl restart x@vt7.service xlogin@operator.service'
    alias 'zgr'='zgen reset'
    alias 'mpk'='makepkg-clean'
    alias 'il'='ip l'
    alias 'td'='touch  /tmp/debug; tail -f /tmp/debug'
    alias 'vbs'='vim-bundle-save'
    alias 'vbr'='vim-bundle-restore'
    alias 'gbs'='git-submodule-branch-sync'
    alias 'str'='strace -ff -s 100'
    alias 'bx'='chmod +x ~/bin/*; chmod +x ~/deadfiles/bin/*'
    alias 'ck'='create-and-change-directory'
    alias 'mf'='man-find'
    alias 'md'='man-directive'
    alias 'c'='cd-and-ls'
    alias 'ss'='sed-replace'

    alias 'h'='ssh-enhanced'

    alias 'f'=':find'

    alias 'si'='ssh-copy-id'

    alias 'cdp'='cd-pkgbuild'
    alias 'gog'='go-get-enhanced'
    alias 'gme'='go-makepkg-enhanced'
    alias 'gmev'='FLAGS="-p version" go-makepkg-enhanced'
    alias 'gmevs'='FLAGS="-p version -s" go-makepkg-enhanced'
    alias 'gmel'='gmev'
    alias 'vw'='vim-which'
    alias 'tim'='terminal-vim'

    alias 'history'='fc -ln 0'
    alias 'rf'='rm -rf'
    alias 'ls'='ls -lah --group-directories-first -v --color=always'
    alias 'l'='ls'
    alias 'v'='vim'
    alias 'vi'='vim'
    #alias 'se'='sed -r'
    alias 'py'='python'
    alias 'py2'='python2'
    #alias 'god'='godoc-search'
    alias 'nhh'='ssh'
    alias 'nhu'='container-status'
    alias 'nhr'='container-restart'
    alias 'rto'='qbittorrent "$(/usr/bin/ls --color=never -t ~/Downloads/*.torrent | head -n1)"'
    alias 'mtd'='migrate-to-deadfiles'
    alias 'dt'='cd ~/dotfiles; PAGER=cat git diff; git status -s ; '
    alias 'rr'='cd ~/torrents/'
    alias 'de'='cd ~/deadfiles; git status -s'
    alias 'hf'='hub fork && grsm'
    alias 'hc'='hub create'
    alias 'hr'='hub pull-request -f'
    alias 'cc'='copy-to-clipboard'
    alias 'co'='xclip -o'

    alias '/'=':search'
    alias '/g'=':search:go'

    # :aur
    {
        alias 'au'=':aur:spawn'
        alias 'auk'='au -S --nameonly -s'
        alias 'aus'='au -S'
        alias 'aur'='au -R'
        alias 'aug'='aur-get-sources'
        alias 'aq'='yaourt -Q'
        alias 'pcr'='packages-remove'
    }

    # :pacman
    {
        alias 'pmr'='sudo pacman -R'
        alias 'pq'='sudo pacman -Q'
        alias 'pql'='sudo pacman -Ql'
        alias 'pqo'='sudo pacman -Qo'
        alias 'pqi'='sudo pacman -Qi'
        alias 'pms'='sudo pacman -S'
        alias 'psyu'='zfs-snapshot && sudo pacman -Syu'
        alias 'pmu'='sudo pacman -U'
        alias 'pf'='pkgfile'
    }

    # :packages-local
    {
        alias 'pl'='packages-local'
        alias 'pla'='packages-local -a'
    }


    # :zsh
    {
        alias 'viz'='vim ~/.zshrc'
        alias 'tiz'='terminal-vim ~/.zshrc'
        alias 'zr'='source ~/.zshrc && print "zsh config has been reloaded"'
    }


    # :git
    {
        alias 'gcp'='git cherry-pick'
        alias 'gcl'='git clone'
        alias 'gh'='git show'
        alias 'gd'='git diff'
        alias 'gdo'='git diff origin/master'
        alias 'gs'='git status --short'
        alias 'ga'='git add --no-ignore-removal'
        alias 'gb'='git-commit-branch'
        alias 'gbr'='git branch'
        alias 'gn'='git-clean-powered'
        alias 'gi'='git add -pi'
        alias 'gp'='git push'
        alias 'gpo'='git push origin'
        alias 'gpl'='git pull'
        alias 'gpr'='git pull --rebase'
        alias 'gur'='git pull --rebase origin'
        alias 'gf'='git fetch'
        alias 'gcn'='git commit'
        alias gcn!='git commit --amend'
        alias 'gc'='git-commit'
        alias 'gck'='git commit --amend -C HEAD'
        alias 'gco'='git checkout'

        alias 'gci'='git-create-and-commit-empty-gitignore'
        alias 'gclg'='git-clone-github'
        alias 'gcla'='aur-clone'
        alias 'gclp'='git-clone-profiles'
        alias 'gcoo'='git-checkout-orphan'
        alias 'gcls'='git-clone-sources'

        alias 'gcb'='git checkout -b'
        alias 'gbn'=':git:br'
        alias 'gpot'='git push origin "$(:git:branch)" && { ghc || bhc }'
        alias gpot!='git push origin +"$(:git:branch)" && { ghc || bhc }'
        alias 'gt'='gpot'
        alias gt!='gpot!'
        alias 'gut'='gu && gt'
        alias 'gu'='git-pull'
        alias 'gus'='git stash && gu && git stash pop'
        alias 'ggc'='git gc --prune --aggressive'
        alias 'gor'='git pull --rebase origin master'
        alias 'gsh'='git stash'
        alias 'gshp'='git stash pop'
        alias 'grt'='git reset'
        alias 'grh'='git reset --hard'
        alias 'grts'='git reset --soft'
        alias 'gr'='git rebase'
        alias 'grc'='git rebase --continue'
        alias 'gri'='git-rebase-interactive'
        alias 'gcom'='git checkout master'
        alias 'glo'='git log --oneline --graph --decorate --all'
        alias 'gl'='PAGER=cat git log --oneline --graph --decorate --all --max-count=30'
        alias 'gd'='git diff'
        alias 'gnt'='git init'
        alias 'gdh'='git diff HEAD'
        alias 'psx'='ps fuxa | grep'
        alias 'grp'='git remote update'
        alias 'gra'='git remote add origin '
        alias 'gro'='git remote show'
        alias 'gru'='git remote get-url origin'
        alias 'grg'='git remote show origin -n'
        alias 'grs'='git remote set-url origin'
        alias 'grsm'='git-remote-set-origin-me'
        alias 'grb'='git rebase --abort'
        alias 'ghu'='hub browse -u'
        alias 'ghc'='hub browse -u -- commit/$(git rev-parse --short HEAD) 2>/dev/null'
        alias 'glu'='git submodule update --recursive --init'
        alias 'gle'='git submodule'
        alias 'gla'='git submodule add'
        alias 'gld'='git submodule deinit'
        alias 'glf'='git submodule foreach --recursive'
        alias 'grm'='git rm -rf'
        alias 'gic'='git add . ; git commit -m "initial commit"'
        alias 'gig'='touch .gitignore; git add .gitignore ; git commit -m "gitignore"'
        alias 'bhc'='BROWSER=/bin/echo bitbucket browse commits/$(git rev-parse --short HEAD) 2>/dev/null | sed "s@//projects/@/projects/@" '
    }


    # :poe
    {
        alias 'po'='poe -L -t 60'
        alias 'pox'='poe -X -v'
        alias 'pof'='poe -F -v'
    }

    # :go
    {
        alias 'gob'='go-fast-build'
        alias 'b'='go-fast-build'
        alias 'goi'='go install'
    }


    # :systemd
    {
        alias 'sc'='sudo systemctl'
        alias 'scr'='sudo systemctl restart'
        alias 'scs'='sudo systemctl start'
        alias 'sce'='sudo systemctl enable'
        alias 'sct'='sudo systemctl stop'
        alias 'scd'='sudo systemctl disable'
        alias 'scu'='sudo systemctl status'
        alias 'scl'='sudo systemctl list-units'
        alias 'sdr'='sudo systemctl daemon-reload'

        alias 'us'='systemctl --user'
        alias 'uss'='systemctl --user start'
        alias 'ust'='systemctl --user stop'
        alias 'usr'='systemctl --user restart'
        alias 'use'='systemctl --user enable'
        alias 'usd'='systemctl --user disable'
        alias 'usu'='systemctl --user status'
        alias 'usl'='systemctl --user list-units'
        alias 'udr'='systemctl --user daemon-reload'
    }

    # :journald
    {
        alias 'jx'='sudo journalctl -xe'
        alias 'jxf'='sudo journalctl -xef'
        alias 'jxg'='sudo journalctl -xe | grep '
        alias 'jxfg'='sudo journalctl -xef | grep '
    }
}

{
    export QUADRO_DEBUG=1
    alias krun='() { :kubectl $1 run -i --tty --image radial/busyboxplus busybox-$RANDOM --restart=Never --rm }'

    alias k='tubectl'

    :helm-context() {
        helm --kube-context "${@}"
    }

    :kail-context() {
        local context="$1"
        shift
        kail --since 5m --context "${context}" "${@}"
    }

    alias he=':helm-context'
    alias ka=':kail-context'
    alias kap=':kail-app'

    alias kg='tubectl get'
    alias kgd='kg deployments'
    alias kgp='kg pods'
    alias kgn='() { kg pods "${@}" | grep -v Running }'
    alias kgs='kg sts'
    alias kp='kgp'

    alias kt='tubectl edit'

    alias kd='tubectl describe'
    alias kdp='kd pods'
    alias kdd='kd deployment'
    alias kds='kd sts'

    alias kx='tubectl delete'
    alias kxp='kx pods'
    alias kxd='kx deployment'
    alias kxs='kx sts'

    alias ks='() { tubectl scale "${@}" }'
    alias ksd='ks deployment'
    alias kss='ks statefulset'

    alias kl='tubectl logs'
    alias klf='() { kl "${@}" -f --tail 1 }'
    alias ke='tubectl exec'
    alias ki='() { tubectl exec "${@}" -it -- sh -c "bash -i || sh -i" }'
    alias kv='tubectl get events'

    alias -g -- '-ya'='-o yaml'
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

export HISTSIZE=100000
export SAVEHIST=100000

export HISTFILE=~/.guts/.history
if [[ "$HISTFILE_OVERRIDE" ]]; then
    export HISTFILE=$HISTFILE_OVERRIDE
fi

setopt share_history

set_title() {
    printf "\033]0;%s\007" "${1}"
}

preexec() {
    set_title "${1}"
}
