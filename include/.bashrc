# https://git.rickowski.de/rickowski/dotfiles.git

# This configuration file originates from the Manjaro Linux distribution.
# It is modified and tweaked.

if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s autocd

shopt -s expand_aliases

alias tgz='tar -pczf' # p = preserve permissions, c = create archive, z = gzip , f = file=...
alias ls='ls -vp --group-directories-first --time-style="+%F %T  " --color=auto'
alias ll='ls -lahF --group-directories-first --time-style="+%F %T  "'

# Force tmux to use 256 colors
alias tmux='tmux -2'

# Allow the use of aliases with sudo
alias sudo='sudo '

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# Use vim as default editor
export EDITOR=vim
export VISUAL="$EDITOR"

# Don't write duplicates or lines starting with spaces in the history
HISTCONTROL=ignoreboth

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
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]]

# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
if type -P dircolors >/dev/null ; then
  if [[ -f ~/.dir_colors ]] ; then
    eval $(dircolors -b ~/.dir_colors)
  elif [[ -f /etc/DIR_COLORS ]] ; then
    eval $(dircolors -b /etc/DIR_COLORS)
  fi
fi

alias grep="grep --colour=auto"
alias egrep="egrep --colour=auto"
alias fgrep="fgrep --colour=auto"

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
      # This fixes syntax hightlighting in vim -> "
      ;;
  esac

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
    PS1+="${cBOLD}${cRED}[${EXIT}]${cCLEAR}"
  fi
  # Username
  PS1+="${cGRAY}[${cCOND}\u${cGRAY}]"
  # @-sign
  PS1+="${cGRAYLIGHT}@"
  # Hostname
  PS1+="${cGRAY}[${cCOND}\h${cGRAY}]"
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
}

unset safe_term match_lhs sh

# better ls colors
export LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.svgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:"

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
