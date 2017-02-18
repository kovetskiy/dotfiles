#!/bin/bash

name="$6"

if [[ "$name" == "office" ]]; then
    resolvconf -u
fi
