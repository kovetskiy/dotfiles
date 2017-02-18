#!/bin/bash

name="$6"

if [[ "$name" == "office" ]]; then
    cat /home/operator/.unban | xargs -n1 /home/operator/bin/unban
fi
