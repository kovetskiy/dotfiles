# requirement: jira-issue-create
# https://github.com/deadcrew/deadfiles/blob/master/bin/jira-issue-create

:issues:query() {
    batrak -L --show-name "$@" \
        | sed -r 's/Открыта/open/g; s/Завершена/closed/g'
}

:issues:list:open() {
    :issues:query -f 16131
}

:issues:list:open:me() {
    :issues:query -f 16130
}

:issues:list:me() {
    :issues:query -f 16053
}

:issues:list() {
    :issues:query -f 16047
}

:issues:close() {
    local issue_key=$1
    batrak-move 21 $issue_key
}

:issues:rename() {
    local issue_key=$1
    shift
    local new_title="$*"

    batrak -R $issue_key "$new_title"
}

:issues:create-current-month() {
    local label_date=$(date +'%Y-%B' | tr '[:upper:]' '[:lower:]')

    jira-issue-create -l schedule -l "$label_date" "$@"
}

:issues:create-next-month() {
    local label_date=$(date +'%Y-%B' --date='next month' \
        | tr '[:upper:]' '[:lower:]')

    jira-issue-create -l schedule -l "$label_date" "$@"
}

alias knc=':issues:create-current-month'
alias knn=':issues:create-next-month'
alias kc=':issues:close'
alias kr=':issues:rename'

alias kl=':issues:list'
alias ko=':issues:list:open'
alias km=':issues:list:me'
alias kk=':issues:list:open:me'
