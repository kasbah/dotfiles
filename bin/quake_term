#!/bin/bash
if [[ -f ~/.yaql.pid ]]; then
    if kill -SIGUSR1 $(cat ~/.yaql.pid); then
        exit 0
    fi
fi
exec urxvt
