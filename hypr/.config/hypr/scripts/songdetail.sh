#!/usr/bin/env bash
set -euo pipefail

song_info=""

# Try playerctl first
if command -v playerctl &>/dev/null; then
    song_info=$(playerctl metadata --format '{{title}}  {{artist}}' || true)
fi

# Fallback to mpc if empty
if [[ -z "$song_info" ]] && command -v mpc &>/dev/null; then
    song_info=$(mpc current -f '%artist%  %title%' || true)
fi

# Final output
if [[ -n "$song_info" ]]; then
    echo "$song_info"
else
    echo "No song playing"
fi
