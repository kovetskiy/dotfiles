#!/bin/bash

src_dir=$(readlink -f root)
dest_dir="/"

for src_file in `find $src_dir`; do
    dest_file=$dest_dir$(sed "s@$src_dir/@@g" <<< "$src_file")
    if test -f $src_file; then
        if test -f $dest_file; then
            diff -u $src_file $dest_file
            if [ $? -ne 0 ]; then
                exit 1
            fi
        fi
    fi

    echo cp $src_file $dest_file
    #cp -ruT $src_file $dest_file
done
