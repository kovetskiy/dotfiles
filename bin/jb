#!/bin/bash

source ~/.config/jira

branch=$1
issue=$2

if [ -z $branch ]; then
    branch=`git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3`;
fi
 
if [ -z $issue ]; then 
    issue=`echo $branch | grep -oP '([A-Z]{1,}\-[0-9]{1,})'`
fi

host='jira.rn'

branchField="customfield_10131"

curl -u $user:$password \
    -H "X-Atlassian-Token: no-check" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -X PUT -d "{\"fields\":{\"$branchField\":\"$branch\"}}" \
    "http://$host/rest/api/2/issue/$issue"

echo "Success ($issue -> $branch)"
exit 0
