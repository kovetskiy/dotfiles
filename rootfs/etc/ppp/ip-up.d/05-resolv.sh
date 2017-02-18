#!/bin/bash

name="$6"

if [[ "$name" == "office" ]]; then
    /home/operator/bin/resolvconf-switch office
fi
