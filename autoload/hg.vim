scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:Process = vital#hg#import('System.Process')
let s:Prelude = vital#hg#import('Prelude')

function! hg#Hg(...) abort
  call s:Process.register('System.Process.Job')
  let options = {'clients': ['System.Process.Job']}

  let path = s:Prelude.path2project_directory(fnamemodify(bufname('%'), ':p:h'))
  let args = ['hg', '-R', path] + a:000
  let result = s:Process.execute(args, options)
  echo result['output']
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

