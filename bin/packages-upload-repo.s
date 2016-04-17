#!/bin/bash
set -u
set -e
pkg="$1"
epoch="$2"
scp "$pkg" root@repo.s:/tmp/
ssh root@repo.s "repos -AC -e $epoch arch-ngs /tmp/$pkg"
