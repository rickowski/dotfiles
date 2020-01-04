#!/bin/bash
# https://gitlab.com/rickowski/dotfiles.git

iPrefix="▽"
iZoom="⚲"

# Indicators: prefix active, zoom active
echo "#{?client_prefix,${iPrefix} ,}#{?window_zoomed_flag,${iZoom} ,}"
