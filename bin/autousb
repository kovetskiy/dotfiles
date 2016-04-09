#!/bin/bash

inotifywait --monitor --event create,delete --format '%e %w%f' /dev | \
    while read event device; do
        pattern='sd[b-z][1-9]$'
        if [[ $device =~ $pattern ]]; then
            case $event in
                CREATE)
                    logger "mounting $device"
                    sleep 1
                    udisksctl mount --block-device $device --no-user-interaction
                ;;
                DELETE)
                ;;
            esac
        fi
    done
