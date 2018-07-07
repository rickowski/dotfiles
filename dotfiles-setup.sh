#!/bin/bash

# https://github.com/rickowski/linux-home-configs

# Check if git is available
if ! which git > /dev/null 2>&1 ; then
  echo -e "\nIs git really not installed?!\n"
  exit 1
fi

# Check if git is available
if ! which vim > /dev/null 2>&1 ; then
  echo -e "\nThis script is intended for the vim modifications."
  echo -e "Please install vim and try again!\n"
  exit 1
fi

# Install vim plugin Vundle
echo -e "Installing vim plugin: Vundle ...\n"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo -e "\nInstalling vim plugins ..."
echo -e "\tWait until completed and then exit vim!"
sleep 10
vim +PluginInstall

echo -e "\nPlugins installed!\n"

echo -e "\n###########################################################"
echo "For the YouCompleteMe plugin you need to install the following"
echo "packages (or the equivalent for your distribution):"
echo -e "\tbuild-essential cmake python-dev python3-dev"
echo -e "\nFinally compile YouCompleteMe:"
echo -e "\t~/.vim/bundle/YouCompleteMe/install.py --clang-completer"
echo "###########################################################"
