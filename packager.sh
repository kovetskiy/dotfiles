#!/bin/bash

install() {
    local package="$1"

    yes | yaourt -S --noconfirm $package
}

yaourt -Sy

for package in `cat packages`; do
    echo checking package $package...
    installed=$(pacman -Q $package)
    if [ $? -ne 0 ]; then
        if [[ "$1" -ne "-f" ]];then
            echo installing package $package...
            install $package
        fi
    fi
done
