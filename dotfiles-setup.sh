#!/bin/bash

# https://git.rickowski.de/rickowski/dotfiles

# Check if git is available
if ! which git > /dev/null 2>&1 ; then
  echo -e "\nCouldn't find git. Please install this dependency first!\n"
  exit 1
fi

function install_vim_plugins() {
  # Install vim plugin Vundle
  echo -e "\nInstalling vim plugin: Vundle ..."
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

  # Install vim plugin Zenburn
  echo -e "\nInstalling vim plugin: Zenburn ..."
  git clone https://github.com/jnurmine/Zenburn.git ~/.vim/bundle/Zenburn

  # Install vim plugin nerdtree
  echo -e "\nInstalling vim plugin: nerdtree ..."
  git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
}

install_vim_plugins
