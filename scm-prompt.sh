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
#  NOTE! the single quotes are important; if you use double quotes
#  then the prompt won't change when you chdir or checkout different
#  branches!
#
#  . /mnt/vol/engshare/admin/scripts/scm-prompt
#  export PS1='$(_dotfiles_scm_info)\u@\h:\W\$ '

_dotfiles_scm_info()
{
  # find out if we're in a git or hg repo by looking for the control dir
  local d git hg
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
    br=$(hexdump -n 5 -e '1/1 "%02x"' $hg/.hg/dirstate)
    local file
    for file in "$hg/.hg/bookmarks.current"; do
      test -f "$file" && { read br < "$file" ; break; }
    done
  elif test -n "$git" ; then
    if test -f "$git/.git/HEAD" ; then
      read br < "$git/.git/HEAD"
      case $br in
        ref:\ refs/heads/*) br=${br#ref: refs/heads/} ;;
        *)
          r="DETACHED"
          if [ -f "$git/.git/rebase-merge/interactive" ]; then
            r="REBASE-i"
            b="$(cat "$git/.git/rebase-merge/head-name")"
          elif [ -d "$git/.git/rebase-merge" ]; then
            r="REBASE-m"
            b="$(cat "$git/.git/rebase-merge/head-name")"
          else
            if [ -d "$git/.git/rebase-apply" ]; then
              if [ -f "$git/.git/rebase-apply/rebasing" ]; then
                r="REBASE"
              elif [ -f "$git/.git/rebase-apply/applying" ]; then
                r="AM"
              else
                r="AM/REBASE"
              fi
            elif [ -f "$git/.git/MERGE_HEAD" ]; then
              r="MERGING"
            elif [ -f "$git/.git/BISECT_LOG" ]; then
              r="BISECTING"
            fi
          fi
        br="${br:0:7}|$r" ;;
      esac
    fi
  fi
  test -n "$br" && printf %s "($br)" || :
}
