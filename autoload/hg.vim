scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#hg#new()
let s:Prelude = s:V.import('Prelude')

function! hg#Hg(...) abort
  let path = s:Prelude.path2project_directory(fnamemodify(bufname('%'), ':p:h'))
  let hg_path = get(g:, 'hg_path', 'hg')
  echo system_job#system([hg_path, '-R', path] + s:_quoteargs(a:000))
endfunction

function! s:_quoteargs(args) abort
  " a:args = ['a', '"b', 'c"']
  " return ['a', 'b c']

  let newargs = []
  let t = ''
  for a in a:args
    if len(t) == 0
      if a =~# '\v^".*"$'
        call add(newargs, a[1:-2])
      elseif a =~# '\v^"'
        let t = a[1:]
      else
        call add(newargs, a)
      endif
    else
      let t .= ' ' . a
      if a =~# '\v"$'
        call add(newargs, t[:-2])
        let t = ''
      endif
    endif
  endfor
  if len(t) != 0
    call add(newargs, t)
  endif

  return newargs
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

