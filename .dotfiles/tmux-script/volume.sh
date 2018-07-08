#!/bin/bash
# https://github.com/rickowski/dotfiles

# Show master volume?
if [ ${SHOW_VOLUME} -eq 0 ]; then
  exit 0
fi

# Use emojis?
if [ ${USE_EMOJI} -eq 1 ]; then
  iVol="📢"
else
  iVol="♫"
fi

echo " ${iVol}$(amixer get Master | grep -m1 -o -e [0-9]*%) ${SEP_RIGHT}"
