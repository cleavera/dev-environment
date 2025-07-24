#!/bin/sh

CURRENT_USER=$(whoami)

if passwd -S "$CURRENT_USER" 2>/dev/null | grep -q " NP "; then
    echo "Password for user '$CURRENT_USER' is not set."
    echo "Please set your password now to enable 'sudo' access."
    passwd
fi

exec "$SHELL"
