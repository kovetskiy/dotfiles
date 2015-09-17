#!/bin/bash

query="$1"
xinput --list --name-only | grep -i "$query" | while read name; do
    if xinput --list-props "$name" | grep "Enabled" | grep -q "1$"; then
        xinput --disable "$name"
        echo "$name disabled"
    else
        xinput --enable "$name"
        echo "$name enabled"
    fi
done
