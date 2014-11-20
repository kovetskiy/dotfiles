autoload -U add-zsh-hook

git_super_status() {
	BRANCH=`git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3`
	if [ ! -z $BRANCH ]; then 
		echo "[$BRANCH]"
	fi
}

function gdi()
{
	eval "git diff $1"
}

compctl -K git_diff_complete gdi
