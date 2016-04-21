#!/bin/bash

if [ $# -eq 0 ]; then
    echo "file epoch [repository]"
    exit 1
fi

pkg="$1"
epoch="$2"
repo="${3:-arch-ngs}"
scp "$pkg" root@repo.s:/tmp/
ssh root@repo.s "repos -AC -e $epoch $repo /tmp/$pkg"
