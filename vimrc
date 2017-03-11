" because compatibility with crap sucks
set nocompatible

" show the cursor position all the time
set ruler

" allow backspacing over everything in insert mode
set bs=indent,eol,start

" the greatest colorscheme of all time
set t_Co=256
colorscheme torte
highlight Search ctermbg=darkcyan

" incremental search while typing
set incsearch
set hlsearch

syntax on

set nowrap

" if disk is slow, this speeds things up
"set noswapfile
set directory=~/vimswp//

" undo history
set udf
set udir=~/vimswp/undo//

" normal tab settings
set ts=2 sw=2
set sts=0 smarttab expandtab nolist
set smartindent
"set cindent

" autoextend comments
set fo=cqtr
set comments=s1:/*,mb:*,ex:*/,://,:#

" happy scrolling?
set scrolloff=10

" always show the status line, even in a single file
set laststatus=2

" blame ftw
vmap gb :<C-U>!cd $(dirname $(realpath %)) && git blame $(basename %) -L<C-R>=line("'<") <CR>,<C-R>=line("'>") <CR><CR>
nmap gb :!cd $(dirname $(realpath %)) && git blame $(basename %)<CR>
vmap hb :<C-U>!hg blame -wbfcduqp <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" for cscope
nmap <C-@><C-@> :cs find s <C-R>=expand("<cword>")<CR><CR>
set nocscopetag
set csto=1

" search up the directory tree for tags
set tags=tags;/

filetype plugin indent on

" highlight tabs
au BufWinEnter * highlight BadTab ctermbg=darkblue
au BufWinEnter * let w:m1=matchadd('BadTab', '\t', -1)

" highlight trailing whitespace
au BufWinEnter * highlight TrailingWhitespace ctermbg=darkred
au BufWinEnter * let w:m1=matchadd('TrailingWhitespace', '\s\+$', -1)


" highlight long linesa
au BufWinEnter * highlight ColorColumn ctermbg=235
au BufWinEnter * set colorcolumn=81
" au BufWinEnter * highlight OverLength ctermbg=darkblue ctermfg=white 
" au BufWinEnter * let w:m2=matchadd('OverLength', '\%>80v.\+', -1)

" remember cursor position
set viminfo=<10000,s1000,'100,:200,%,h,n~/.viminfo

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

" match xhp
nmap <C-X> :set iskeyword=@,48-57,_,192-255<CR>
nmap <C-X><C-X> :set iskeyword=@,48-57,_,192-255,:,-<CR>

" special per-file directives
augroup filetypes
  au BufRead,BufNewFile *         set ts=2 sw=2
  au BufRead,BufNewFile *.as      set filetype=actionscript
  au BufRead,BufNewFile *.phpt    set filetype=php
  au BufRead,BufNewFile *.ic      set filetype=c
  au BufRead,BufNewFile *.py      set ts=4 sw=4
  au BufRead,BufNewFile *.cinc    set ts=4 sw=4 filetype=python
  au BufRead,BufNewFile *.cconf   set ts=4 sw=4 filetype=python
  au BufRead,BufNewFile TARGETS   set ts=4 sw=4 filetype=python
  au BufRead,BufNewFile Makefile* set ts=4 sw=4 noexpandtab
augroup END

augroup innodb
  au BufRead,BufNewFile */innobase/*        set noexpandtab ts=8 sw=8 fo-=r
  au BufRead,BufNewFile */innodb_plugin/*   set noexpandtab ts=8 sw=8 fo-=r
augroup END
