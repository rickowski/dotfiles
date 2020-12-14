#!/bin/bash
# https://git.rickowski.de/rickowski/dotfiles

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null 2>&1 && pwd )"
LNBACKUP="FALSE"
LNFLAGS="-sfvT"

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

function set_ln_flags() {
  if [ "${LNBACKUP}" = "FALSE" ]; then
    LNFLAGS="-sfvT"
  else
    LNFLAGS="-sfbvT"
  fi

}

function copy_dotfiles_desktop() {
  set_ln_flags

  echo -e "\nCreating symlinks for desktop dotfiles to home directory: ${HOME}/ ..."
  /usr/bin/ln ${LNFLAGS} "${SCRIPTDIR}/include/.Xmodmap" "${HOME}/.Xmodmap"
  /usr/bin/ln ${LNFLAGS} "${SCRIPTDIR}/include/.bashrc" "${HOME}/.bashrc"
  /usr/bin/ln ${LNFLAGS} "${SCRIPTDIR}/include/.bash_profile" "${HOME}/.bash_profile"
  /usr/bin/ln ${LNFLAGS} "${SCRIPTDIR}/include/.profile" "${HOME}/.profile"
  /usr/bin/ln ${LNFLAGS} "${SCRIPTDIR}/include/.tmux.conf" "${HOME}/.tmux.conf"
  /usr/bin/ln ${LNFLAGS} "${SCRIPTDIR}/include/.vimrc" "${HOME}/.vimrc"
  /usr/bin/ln ${LNFLAGS} "${SCRIPTDIR}/include/.dotfiles" "${HOME}/.dotfiles"
}

function copy_dotfiles_server() {
  set_ln_flags

  echo -e "\nCreating symlinks for server dotfiles to home directory: ${HOME}/ ..."
  /usr/bin/ln ${LNFLAGS} "${SCRIPTDIR}/include/.bashrc" "${HOME}/.bashrc"
  /usr/bin/ln ${LNFLAGS} "${SCRIPTDIR}/include/.bash_profile" "${HOME}/.bash_profile"
  /usr/bin/ln ${LNFLAGS} "${SCRIPTDIR}/include/.profile" "${HOME}/.profile"
  /usr/bin/ln ${LNFLAGS} "${SCRIPTDIR}/include/.tmux.conf" "${HOME}/.tmux.conf"
  /usr/bin/ln ${LNFLAGS} "${SCRIPTDIR}/include/.vimrc" "${HOME}/.vimrc"
  /usr/bin/ln ${LNFLAGS} "${SCRIPTDIR}/include/.dotfiles" "${HOME}/.dotfiles"
}

while true; do
  confirm_continue=true
  clear
  echo "Dotfiles setup script"
  echo "#####################"
  echo -e "\nMenu"
  echo "----"
  echo "1: Install everything (desktop)"
  echo "2: Install everything (server)"
  echo -e "\nb: Use -b flag with ln: ${LNBACKUP} "
  echo -e "   (creates backup before overwriting with symlink)"
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
    b)
      if [ "${LNBACKUP}" = "FALSE" ]; then
        LNBACKUP="TRUE"
      else
        LNBACKUP="FALSE"
      fi
      confirm_continue=false
      ;;
    q)
      break
      ;;
  esac

  if [ ${confirm_continue} = true ]; then
    echo ""
    read -p "Enter to continue ..."
  fi
done
