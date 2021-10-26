#!/bin/bash
# https://git.rickowski.de/rickowski/dotfiles

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null 2>&1 && pwd )"

INSTALLTYPE="DESKTOP"
LNBACKUP="FALSE"
LNFLAGS="-sfvT"

if ! which git > /dev/null 2>&1 ; then
  echo -e "\nCouldn't find git. Please install this dependency first!\n"
  exit 1
fi

function install_vim_plugins() {
  echo -e "\nInstalling vim plugin: Vundle ..."
  git clone https://github.com/VundleVim/Vundle.vim.git "${HOME}/.vim/bundle/Vundle.vim"

  echo -e "\nInstalling vim plugin: Zenburn ..."
  git clone https://github.com/jnurmine/Zenburn.git "${HOME}/.vim/bundle/Zenburn"

  echo -e "\nInstalling vim plugin: nerdtree ..."
  git clone https://github.com/scrooloose/nerdtree.git "${HOME}/.vim/bundle/nerdtree"

  if [ "${INSTALLTYPE}" = "DESKTOP" ]; then
    echo -e "\nInstalling vim plugin: YouCompleteMe ..."
    git clone https://github.com/Valloric/YouCompleteMe.git "${HOME}/.vim/bundle/YouCompleteMe"

    echo -e "\nTrying to build YouCompleteMe ..."
    "${HOME}/.vim/bundle/YouCompleteMe/install.py"
    echo -e "\n\n#####################################"
    echo "Please check if build was successful."
    echo "If not dependencies could be missing."
    echo -e "#####################################\n"
  fi
}

function set_ln_flags() {
  if [ "${LNBACKUP}" = "FALSE" ]; then
    LNFLAGS="-sfvT"
  else
    LNFLAGS="-sfbvT"
  fi

}

function install_dotfiles() {
  set_ln_flags

  # Conditional dotfiles
  echo -e "\nCreating symlinks for dotfiles to home directory: ${HOME}/ ..."
  if [ "${INSTALLTYPE}" = "DESKTOP" ]; then
    ln ${LNFLAGS} "${SCRIPTDIR}/include/.Xmodmap" "${HOME}/.Xmodmap"
    ln ${LNFLAGS} "${SCRIPTDIR}/include/.vimrc" "${HOME}/.vimrc"
  elif [ "${INSTALLTYPE}" = "SERVER" ]; then
    ln ${LNFLAGS} "${SCRIPTDIR}/include/.vimrc.server" "${HOME}/.vimrc"
  fi

  # Install everywhere
  ln ${LNFLAGS} "${SCRIPTDIR}/include/.bashrc" "${HOME}/.bashrc"
  ln ${LNFLAGS} "${SCRIPTDIR}/include/.bash_profile" "${HOME}/.bash_profile"
  ln ${LNFLAGS} "${SCRIPTDIR}/include/.profile" "${HOME}/.profile"
  ln ${LNFLAGS} "${SCRIPTDIR}/include/.tmux.conf" "${HOME}/.tmux.conf"
  ln ${LNFLAGS} "${SCRIPTDIR}/include/.tmux.d" "${HOME}/.tmux.d"
}

function install_everything() {
  install_vim_plugins
  install_dotfiles
}


while true; do
  confirm_continue=true
  clear
  echo -e "\nDotfiles setup script"
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
      INSTALLTYPE="DESKTOP"
      install_everything
      ;;
    2)
      INSTALLTYPE="SERVER"
      install_everything
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
