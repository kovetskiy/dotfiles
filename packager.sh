#!/bin/bash

install() {
    local package="$1"

export MAKEPKG="makepkg --skipinteg"
    yes | yaourt -S --noconfirm $package --force
}

yaourt -Sy

for package in `cat packages`; do
    echo checking package $package...
    if ! pacman -Q $package 2>&1; then
        if [ "$1" != "-s" ];then
            echo installing package $package... >> /tmp/p
            install $package
        fi
    fi
done
