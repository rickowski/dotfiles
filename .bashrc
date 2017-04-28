# https://github.com/rickowski/linux-home-configs

# This configuration file originates from the Manjaro Linux distribution.
# It is modified and tweaked.

if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

alias cp="cp -i" # confirm before overwriting something
alias df='df -h' # human-readable sizes
alias free='free -m' # show sizes in MB
alias np='nano -w PKGBUILD'
alias ll="ls -lahF --group-directories-first"

# Force tmux to use 256 colors
alias tmux="tmux -2"

# Allow the use of aliases with sudo
alias sudo='sudo '

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# Use vim as default editor
export EDITOR=vim

# Don't write duplicates or lines starting with spaces in the history
HISTCONTROL=ignoreboth

use_color=false

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?} # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs} ]] \
  && type -P dircolors > /dev/null \
  && match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
  # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
  if type -P dircolors >/dev/null ; then
    if [[ -f ~/.dir_colors ]] ; then
      eval $(dircolors -b ~/.dir_colors)
    elif [[ -f /etc/DIR_COLORS ]] ; then
      eval $(dircolors -b /etc/DIR_COLORS)
    fi
  fi

  alias ls='ls --color=auto'
  alias grep='grep --colour=auto'
  alias egrep='egrep --colour=auto'
  alias fgrep='fgrep --colour=auto'
fi

# Dynamically generated ps1 prompt
# See here for details: https://wiki.archlinux.org/index.php/Bash/Prompt_customization
PROMPT_COMMAND=create_ps1

create_ps1() {
  local EXIT="$?" #Must be first
  PS1=""

  # Change the window title of X terminals
  case ${TERM} in
    xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
      echo -ne "\033]0;[${USER}] [${PWD/#$HOME/~}]\007"
      ;;
    screen*)
      echo -ne "\033_[${USER}] [${PWD/#$HOME/~}]\033\\"
      ;;
  esac

  if ${use_color} ; then
    ### Using the tput method is too slow
    #local cCLEAR="\[$(tput sgr0)\]"
    #local cBOLD="\[$(tput bold)\]"
    #local cGRAY="\[$(tput setaf 239)\]"
    #local cGRAYLIGHT="\[$(tput setaf 244)\]"
    #local cRED="\[$(tput setaf 1)\]"
    #local cPURPLE="\[$(tput setaf 201)\]"
    #local cBLUELIGHT="\[$(tput setaf 109)\]"
    #local cBLUE="\[$(tput setaf 69)\]"
    #local cGREEN="\[$(tput setaf 47)\]"
    local cCLEAR='\[\e[0m\]'
    local cBOLD='\[\e[1m\]'
    local cGRAY='\[\e[38;5;239m\]'
    local cGRAYLIGHT='\[\e[38;5;244m\]'
    local cRED='\[\e[0;31m\]'
    local cPURPLE='\[\e[38;5;197m\]'
    local cBLUELIGHT='\[\e[38;5;109m\]'
    local cBLUE='\[\e[38;5;69m\]'
    local cGREEN='\[\e[38;5;40m\]'

    # Conditional color
    if [[ ${EUID} == 0 ]]; then
      local cCOND="${cRED}"
      local cCONDALT="${cPURPLE}"
    else
      local cCOND="${cBLUE}"
      local cCONDALT="${cBLUELIGHT}"
    fi

    ### Put the PS1 together
    # Exit code
    if [[ ${EXIT} != 0 ]]; then
      PS1+="${cBOLD}${cRED}[${EXIT}]${cCLEAR} "
    fi
    # Username
    PS1+="${cGRAY}[${cCOND}\u${cGRAY}]"
    # @-sign
    PS1+="${cGRAYLIGHT}@"
    # Hostname
    PS1+="${cGRAY}[${cCOND}\h${cGRAY}] "
    # Folder
    PS1+="${cGRAY}[${cCONDALT}\w${cGRAY}] "
    # Git
    # Get name of git branch
    BRANCHNAME="$(git branch 2> /dev/null | grep '^*' | awk '{print $2}')"
    if [[ ! -z ${BRANCHNAME} ]]; then # If branch name available
      # Check if changes are made and adjust color accordingly
      if LC_ALL=C git status | grep "nothing to commit" > /dev/null 2>&1 ; then
        local cGIT="${cGREEN}"
      else
        local cGIT="${cRED}"
      fi
      PS1+="${cGIT}(${BRANCHNAME}) "
    fi
    # Last character ($/#)
    PS1+="${cCOND}\\$ ${cCLEAR}"
    ### Finished setting PS1
  else
    # If colors are not available
    if [[ ${EXIT} != 0 ]]; then
      PS1+="[${EXIT}] "
    fi

    BRANCHNAME="$(git branch 2> /dev/null | grep '^*' | awk '{print $2}')"
    if [[ ! -z ${BRANCHNAME} ]]; then # If branch name available
      PS1+="[\u]@[\h] [\w] (${BRANCHNAME}) \\$ "
    else
      PS1+="[\u]@[\h] [\w] \\$ "
    fi
  fi
}

unset use_color safe_term match_lhs sh

# better yaourt colors
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)
        tar xjf $1 ;;
      *.tar.gz)
        tar xzf $1 ;;
      *.bz2)
        bunzip2 $1 ;;
      *.rar)
        unrar x $1 ;;
      *.gz)
        gunzip $1 ;;
      *.tar)
        tar xf $1 ;;
      *.tbz2)
        tar xjf $1 ;;
      *.tgz)
        tar xzf $1 ;;
      *.zip)
        unzip $1 ;;
      *.Z)
        uncompress $1 ;;
      *.7z)
        7z x $1 ;;
      *)
        echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

colors() {
  local fgc bgc vals seq0

  printf "Color escapes are %s\n" '\e[${value};...;${value}m'
  printf "Values 30..37 are \e[33mforeground colors\e[m\n"
  printf "Values 40..47 are \e[43mbackground colors\e[m\n"
  printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

  # foreground colors
  for fgc in {30..37}; do
    # background colors
    for bgc in {40..47}; do
      fgc=${fgc#37} # white
      bgc=${bgc#40} # black

      vals="${fgc:+$fgc;}${bgc}"
      vals=${vals%%;}

      seq0="${vals:+\e[${vals}m}"
      printf "  %-9s" "${seq0:-(default)}"
      printf " ${seq0}TEXT\e[m"
      printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
    done
    echo; echo
  done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
