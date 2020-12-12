#!/bin/bash
# https://git.rickowski.de/rickowski/dotfiles

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null 2>&1 && pwd )"

if ! which git > /dev/null 2>&1 ; then
  echo -e "\nCouldn't find git. Please install this dependency first!\n"
  exit 1
fi

function install_vim_plugins() {
  echo -e "\nInstalling vim plugin: Vundle ..."
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

  echo -e "\nInstalling vim plugin: Zenburn ..."
  git clone https://github.com/jnurmine/Zenburn.git ~/.vim/bundle/Zenburn

  echo -e "\nInstalling vim plugin: nerdtree ..."
  git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
}

function copy_dotfiles_desktop() {
  echo -e "\nCopying desktop dotfiles to home directory ${HOME}/ ..."
  /usr/bin/cp "${SCRIPTDIR}/include/.Xmodmap" "${HOME}/"
  /usr/bin/cp "${SCRIPTDIR}/include/.bashrc" "${HOME}/"
  /usr/bin/cp "${SCRIPTDIR}/include/.bash_profile" "${HOME}/"
  /usr/bin/cp "${SCRIPTDIR}/include/.profile" "${HOME}/"
  /usr/bin/cp "${SCRIPTDIR}/include/.tmux.conf" "${HOME}/"
  /usr/bin/cp "${SCRIPTDIR}/include/.vimrc" "${HOME}/"
  /usr/bin/cp -a "${SCRIPTDIR}/include/.dotfiles" "${HOME}/"
}

function copy_dotfiles_server() {
  echo -e "\nCopying server dotfiles to home directory ${HOME}/ ..."
  /usr/bin/cp "${SCRIPTDIR}/include/.bashrc" "${HOME}/"
  /usr/bin/cp "${SCRIPTDIR}/include/.bash_profile" "${HOME}/"
  /usr/bin/cp "${SCRIPTDIR}/include/.profile" "${HOME}/"
  /usr/bin/cp "${SCRIPTDIR}/include/.tmux.conf" "${HOME}/"
  /usr/bin/cp "${SCRIPTDIR}/include/.vimrc" "${HOME}/"
  /usr/bin/cp -a "${SCRIPTDIR}/include/.dotfiles" "${HOME}/"
}

while true
do
  clear
  echo "Dotfiles setup script"
  echo "#####################"
  echo -e "\nMenu"
  echo "----"
  echo "(Keep in mind that existing files will be overwritten)"
  echo "1: Install everything (desktop)"
  echo "2: Install everything (server)"
  echo -e "\nq: Quit\n"

  read -p "Choice: " choice
  case ${choice} in
    1)
      install_vim_plugins
      copy_dotfiles_desktop
      ;;
    2)
      install_vim_plugins
      copy_dotfiles_server
      ;;
    q)
      break
      ;;
  esac

  echo ""
  read -p "Enter to continue ..."
done
