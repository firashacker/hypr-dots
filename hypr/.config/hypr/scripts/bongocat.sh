#!/usr/bin/env bash
set -euo pipefail

GROUP="input"

if command -v bongocat &>/dev/null; then
    if groups "$USER" | grep -qw "$GROUP"; then
        echo "User $USER is already in $GROUP."
    else
        echo "Adding $USER to $GROUP..."
        sudo usermod -a -G "$GROUP" "$USER"
        echo "Done. Please log out and back in to apply changes."
    fi

    bongocat --watch-config -c ~/.config/bongocat/bongocat.conf
else
    notify-send -t 1000 "BongoCat is not installed"
    exit 1
fi
