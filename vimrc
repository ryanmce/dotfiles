" because compatibility with crap sucks
set nocompatible

" show the cursor position all the time
set ruler

" allow backspacing over everything in insert mode
set bs=indent,eol,start

" the greatest colorscheme of all time
colorscheme torte
highlight Search ctermbg=darkcyan

" incremental search while typing
set incsearch

" normal tab settings
set ts=2 sw=2
set sts=0 smarttab expandtab nolist
set smartindent
set cindent

" autoextend comments
set fo=cqtr
set comments=s1:/*,mb:*,ex:*/,://,:#

" happy scrolling?
set scrolloff=10

" blame ftw
vmap gb :<C-U>!cd $(dirname $(realpath %)) && git blame $(basename %) -L<C-R>=line("'<") <CR>,<C-R>=line("'>") <CR><CR>
nmap gb :!cd $(dirname $(realpath %)) && git blame $(basename %)<CR>


" for cscope
nmap <C-@><C-@> :cs find s <C-R>=expand("<cword>")<CR><CR>
set nocscopetag
set csto=1

filetype plugin indent on

" special per-file directives
augroup filetypes
  au BufRead,BufNewFile *.phpt    set filetype=php
  au BufRead,BufNewFile *.ic      set filetype=c
  au BufRead,BufNewFile *.py      set ts=4 sw=4
  au BufRead,BufNewFile *.cinc    set ts=4 sw=4 filetype=python
  au BufRead,BufNewFile Makefile* set ts=4 sw=4 noexpandtab
augroup END

" kill any trailing whitespace on save
autocmd FileType c,cabal,cpp,haskell,javascript,php,python,readme,text
  \ autocmd BufWritePre <buffer>
  \ :call <SID>StripTrailingWhitespaces()

function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" highlight tabs
highlight BadTab ctermbg=darkblue
let w:m1=matchadd('BadTab', '\t', -1)

" highlight long lines
highlight OverLength ctermbg=darkblue ctermfg=white 
let w:m2=matchadd('OverLength', '\%>80v.\+', -1)

" remember cursor position
set viminfo='10,\"100,:20,%,n~/.viminfo

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

set hlsearch
set nowrap
