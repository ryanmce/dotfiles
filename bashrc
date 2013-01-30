# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export EDITOR=vim
export PATH=$PATH:~/bin

# If running interactively, then:
if [ "$PS1" ]; then

    # don't put duplicate lines in the history. See bash(1) for more options
    # export HISTCONTROL=ignoredups

    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    #shopt -s checkwinsize

    # enable color support of ls and also add handy aliases
    if [ "$TERM" != "dumb" ]; then
      eval `dircolors -b`
      alias ls='ls --color=auto'
      #alias dir='ls --color=auto --format=vertical'
    	#alias vdir='ls --color=auto --format=long'
    fi

  # some more ls aliases
  alias ll='ls -l'
  alias la='ls -A'
  alias l='ls -CF'

	EDITOR="vim"
	export EDITOR
  
  source ~/.git-completion.bash
  export PS1='\[\033[01;36m\]\u@\[\033[01;32m\]\h:\[\033[01;34m\]\W$(__git_ps1 "(%s)") \[\033[01;36m\]$ \[\033[00m\]'

  HISTIGNORE="cd:ls:[bf]g:clear:exit"
  HISTCONTROL=ignoredups
  shopt -s histappend

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
