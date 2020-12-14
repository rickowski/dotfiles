#!/bin/bash
# https://git.rickowski.de/rickowski/dotfiles.git

iPrefix="V"
iZoom="+"

# Indicators: prefix active, zoom active
echo "#{?client_prefix,${iPrefix} ,}#{?window_zoomed_flag,${iZoom} ,}"
