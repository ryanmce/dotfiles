# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If running interactively, then:
if [ "$PS1" ]; then
  # useful stuff for screen
  alias scr="screen -r -d"

  # enable color support of ls and also add handy aliases
  if [ "$TERM" != "dumb" ]; then
    eval `dircolors -b`
    alias ls='ls --color=auto -F'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
  fi

  # some more ls aliases
  alias ll='ls -l'
  alias la='ls -A'
  alias l='ls -CF'

  # http://blog.sanctum.geek.nz/better-bash-history/
  shopt -s histappend
  shopt -s cmdhist
  unset HISTFILESIZE
  export HISTSIZE=1000000
  export HISTCONTROL=ignoredups
  export HISTIGNORE="pwd:ls:ls -l:"
  export HISTTIMEFORMAT='%F %T '
  #export PROMPT_COMMAND='history -a; history -n'

  # check the window size after each command and, if necessary,
  # update the values of LINES and COLUMNS.
  #shopt -s checkwinsize

  # update screen window names with cwd
  case ${TERM} in
    screen*)
      export PROMPT_COMMAND='echo -ne "\033k$(basename "$PWD")\033\\"'
      ;;
    *)
      export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}\007"'
      ;;
  esac


  export EDITOR=vim
  export PAGER="LESS='FRX' less"
  export PATH=$PATH:~/bin

  source ~/.git-completion.bash
  export PS1='\[\033[01;36m\]\u@\[\033[01;32m\]\h:\[\033[01;34m\]\W$(__git_ps1 "(%s)") \[\033[01;36m\]$ \[\033[00m\]'

  # useful git aliases
  alias gs="git status"
  alias gd="git diff --numstat HEAD^"
  alias ga="git ci --amend --reset-author"
  alias gaa="git ci -a --amend -C HEAD --reset-author"

  # If this is an xterm set the title to user@host:dir
  #case $TERM in
  #xterm*)
  #    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
  #    ;;
  #*)
  #    ;;
  #esac

  # enable programmable completion features (you don't need to enable
  # this, if it's already enabled in /etc/bash.bashrc).
  #if [ -f /etc/bash_completion ]; then
  #  . /etc/bash_completion
  #fi

fi

umask 002
