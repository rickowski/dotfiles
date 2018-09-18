#!/bin/bash
# https://gitlab.com/rickowski/dotfiles.git

# Use emojis?
if [ $USE_EMOJI -eq 1 ]; then
  iPrefix="🔻"
  iZoom="🔍"
else
  iPrefix="▽"
  iZoom="⚲"
fi

# Indicators: prefix active, zoom active
echo "#{?client_prefix,${iPrefix} ,}#{?window_zoomed_flag,${iZoom} ,}"
