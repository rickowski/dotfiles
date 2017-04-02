#!/bin/bash

# https://github.com/rickowski/linux-home-configs

# Check if git is available
if ! which git > /dev/null 2>&1 ; then
  echo -e "\nIs git really not installed?!\n"
  exit 1
fi

# Install vim plugin Vundle
echo -e "Installing vim plugin: Vundle ...\n"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
echo -e "\nDone! Please run :PluginInstall inside vim!"

