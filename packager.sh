#!/bin/bash

install() {
    local package="$1"

    yes | yaourt -S --noconfirm $package
}

yaourt -Sy

for package in `cat packages`; do
    echo checking package $package...
    installed=$(pacman -Qi $package)
    if [ $? -ne 0 ]; then
        echo installing package $package...
        install $package
    fi
done
