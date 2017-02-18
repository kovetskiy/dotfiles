#!/bin/bash

cat /home/operator/.unban | xargs -n1 /home/operator/bin/unban
