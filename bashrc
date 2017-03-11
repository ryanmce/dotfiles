# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, then exit now:
if [ ! "$PS1" ]; then
  return
fi

if [ -f ~/.bashrc_fb ]; then
  source ~/.bashrc_fb
fi

# don't make ctrl-s stop the terminal
stty stop undef

umask 002

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

# immediately append history
#export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
#shopt -s checkwinsize

case ${TERM} in
  screen*)
    # update screen window names with cwd
    export PROMPT_COMMAND='echo -ne "\033k$(basename "$PWD")\033\\"'
    ;;
  *)
    # otherwise update title of window with hostname
    export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}\007"'
    ;;
esac

# show up to three previous dirs
export PROMPT_DIRTRIM=3

export EDITOR=vim
export PAGER=less
export LESS=FRX
export PATH=$PATH:~/bin

color="\[\033"
teal="$color[01;36m\]"
green="$color[01;32m\]"
purple="$color[01;35m\]"
blue="$color[01;34m\]"
red="$color[1;31m\]"
grey="$color[1;30m\]"
none="$color[00m\]"

function prompt_status {
  local pipes="${PIPESTATUS[*]}"
  local allZeros=true
  for status in ${pipes[@]}; do
    if [ $status != 0 ]; then
      allZeros=false
    fi
  done
  if [ $allZeros != true ]; then
    printf " [Exit: ${pipes[@]}]"
    true
  fi
}

source ~/dotfiles/scm-prompt.sh
scminfo='$(_dotfiles_scm_info "(%s)")'
pstatus='$(prompt_status)'
export PS1="$grey[\D{%F %H:%M:%S}] $teal\u@$green${HOSTNAME%.facebook.com}:$blue\w$purple$scminfo $green[\j]$red${pstatus}$none\n\$ "

# useful git aliases
alias gs="git status"
alias gd="git diff --numstat HEAD^"
alias ga="git ci --amend --reset-author"
alias gaa="git ci -a --amend -C HEAD --reset-author"

# useful mercurial aliases
alias hs='hg st'
alias ha='hg commit --amend --date now -X "*"'
alias haa='hg commit --amend --date now --message "$(hg log -T {desc} -r .)"'

export SSH_AUTH_SOCK=/var/run/ssh-agent/agent.2400
