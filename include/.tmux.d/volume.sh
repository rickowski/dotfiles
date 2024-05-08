#!/bin/bash

if which amixer > /dev/null; then
  echo " ♫$(amixer get Master | grep -m1 -o -e [0-9]*%) ${SEP_RIGHT}"
fi
