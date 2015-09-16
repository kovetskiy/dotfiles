#!/bin/sh

~/bin/env-setup &

( sleep 0.1; xtrlock -b ) &
i3
