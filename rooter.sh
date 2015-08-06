#!/bin/bash

set -e -u
zsnap

src_dir=$(readlink -f root)
dest_dir="/"

for src_file in `find $src_dir | tail -n +2`; do
    dest_file=$dest_dir$(sed "s@$src_dir/@@g" <<< "$src_file")

    if [[ $dest_file == *.git* ]]; then
        continue
    fi

    if [[ $dest_file == *README.* ]]; then
        continue
    fi

    mkdir -p "$(dirname "$dest_file")"
    if test -f "$src_file"; then
        if test -f "$dest_file"; then
            diff -u "$src_file" "$dest_file"
            if [ $? -ne 0 ]; then
                exit 1
            fi
        fi

        echo cp "$src_file" "$dest_file"
        sudo cp -ruT $src_file $dest_file
    fi
done
