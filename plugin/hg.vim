scriptencoding utf-8
if exists('g:loaded_hg')
  finish
endif
let g:loaded_hg = 1

command! -nargs=* Hg :call hg#Hg(<f-args>)

