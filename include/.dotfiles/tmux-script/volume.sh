#!/bin/bash
# https://git.rickowski.de/rickowski/dotfiles.git

iVol="♫"

echo " ${iVol}$(amixer get Master | grep -m1 -o -e [0-9]*%) ${SEP_RIGHT}"
