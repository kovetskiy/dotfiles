#!/bin/bash

name="$6"

if [[ "$name" == "office" ]]; then
    /bin/resolvconf -u
fi
