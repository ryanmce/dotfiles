# Determines the "branch" of the current repo and emits it.
# For use in generating the prompt.
# This is portable to both zsh and bash and works in both
# git and mercurial repos and aims to avoid invoking the
# command line utilities for speed of prompt updates

# To use from zsh:
#  NOTE! the single quotes are important; if you use double quotes
#  then the prompt won't change when you chdir or checkout different
#  branches!
#
#  . /mnt/vol/engshare/admin/scripts/scm-prompt
#  setopt PROMPT_SUBST
#  export PS1='$(_dotfiles_scm_info)$USER@%m:%~%% '

# To use from bash:
#
#  . /mnt/vol/engshare/admin/scripts/scm-prompt
#  export PS1="\$(_dotfiles_scm_info)\u@\h:\W\$ "
#
# NOTE! You *EITHER* need to single-quote the whole thing *OR* back-slash
# the $(...) (as above), but not both. Which one you use depends on if
# you need the rest of your PS1 to interpolate variables.

_dotfiles_scm_info()
{
  # find out if we're in a git or hg repo by looking for the control dir
  local d git hg fmt
  fmt=$1
  if [[ -z "$fmt" ]]; then
    if [ -n "$WANT_OLD_SCM_PROMPT" ]; then
      fmt="%s"
    else
      # Be compatable with __git_ps1. In particular:
      # - provide a space for the user so that they don't have to have
      #   random extra spaces in their prompt when not in a repo
      # - provide parens so it's differentiated from other crap in their prompt
      fmt=" (%s)"
    fi
  fi
  d=$PWD
  while : ; do
    if test -d "$d/.git" ; then
      git=$d
      break
    elif test -d "$d/.hg" ; then
      hg=$d
      break
    fi
    test "$d" = / && break
    # portable "realpath" equivalent
    d=$(cd "$d/.." && echo "$PWD")
  done

  local br
  if test -n "$hg" ; then
    local extra
    if [ -f "$hg/.hg/bisect.state" ]; then
      extra="|BISECT"
    elif [ -f "$hg/.hg/histedit-state" ]; then
      extra="|HISTEDIT"
    elif [ -f "$hg/.hg/graftstate" ]; then
      extra="|GRAFT"
    elif [ -f "$hg/.hg/unshelverebasestate" ]; then
      extra="|UNSHELVE"
    elif [ -f "$hg/.hg/rebasestate" ]; then
      extra="|REBASE"
    elif [ -d "$hg/.hg/merge" ]; then
      extra="|MERGE"
    fi
    local dirstate=$(test -f $hg/.hg/dirstate && \
      hexdump -vn 20 -e '1/1 "%02x"' $hg/.hg/dirstate || \
      echo "empty")
    local current="$hg/.hg/bookmarks.current"
    if  [[ -f "$current" ]]; then
      br=$(cat "$current")
      # check to see if active bookmark needs update
      local marks="$hg/.hg/bookmarks"
      if [[ -z "$extra" ]] && [[ -f "$marks" ]]; then
        local markstate=$(grep --color=never " $br$" "$marks" | cut -f 1 -d ' ')
        if [[ $markstate != $dirstate ]]; then
          extra="|UPDATE_NEEDED"
        fi
      fi
    else
      br=$(echo $dirstate | cut -c 1-7)
    fi
    local branch
    if [[ -f $hg/.hg/branch ]]; then
      branch=$(cat $hg/.hg/branch)
      if [[ $branch != "default" ]]; then
        br="$br|$branch"
      fi
    fi
    br="$br$extra"
  elif test -n "$git" ; then
    if test -f "$git/.git/HEAD" ; then
      read br < "$git/.git/HEAD"
      case $br in
        ref:\ refs/heads/*) br=${br#ref: refs/heads/} ;;
        *) br=$(echo $br | cut -c 1-7) ;;
      esac
      if [ -f "$git/.git/rebase-merge/interactive" ]; then
        b="$(cat "$git/.git/rebase-merge/head-name")"
        b=${b#refs/heads/}
        br="$br|REBASE-i|$b"
      elif [ -d "$git/.git/rebase-merge" ]; then
        b="$(cat "$git/.git/rebase-merge/head-name")"
        b=${b#refs/heads/}
        br="br|REBASE-m|$b"
      else
        if [ -d "$git/.git/rebase-apply" ]; then
          if [ -f "$git/.git/rebase-apply/rebasing" ]; then
            br="$br|REBASE"
          elif [ -f "$git/.git/rebase-apply/applying" ]; then
            br="$br|AM"
          else
            br="$br|AM/REBASE"
          fi
        elif [ -f "$git/.git/MERGE_HEAD" ]; then
          br="$br|MERGE"
        elif [ -f "$git/.git/BISECT_LOG" ]; then
          br="$br|BISECT"
        fi
      fi
    fi
  fi
  if [ -n "$br" ]; then
    printf "$fmt" "$br"
  fi
}
