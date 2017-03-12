" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not mofidify the code nor insert new lines before '" ___vital___'
if v:version > 703 || v:version == 703 && has('patch1170')
  function! vital#_hg#System#Process#Job#import() abort
    return map({'_vital_depends': '', 'execute': '', 'is_supported': '', 'is_available': '', '_vital_loaded': ''},  'function("s:" . v:key)')
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  execute join(['function! vital#_hg#System#Process#Job#import() abort', printf("return map({'_vital_depends': '', 'execute': '', 'is_supported': '', 'is_available': '', '_vital_loaded': ''}, \"function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
  delfunction s:_SID
endif
" ___vital___
function! s:_vital_loaded(V) abort
  let s:Job = a:V.import('System.Job')
  let s:Prelude = a:V.import('Prelude')
  let s:String = a:V.import('Data.String')
endfunction

function! s:_vital_depends() abort
  return ['System.Job', 'Prelude', 'Data.String']
endfunction

function! s:is_available() abort
  if has('nvim')
    return 1
  elseif has('patch-8.0.0027')
    return 1
  endif
  return 0
endfunction

function! s:is_supported(options) abort
  if get(a:options, 'background') && (
        \   s:Prelude.is_string(get(a:options, 'input')) ||
        \   get(a:options, 'timeout')
        \)
    return 0
  endif
  return 1
endfunction

function! s:execute(args, options) abort
  let cmdline = join(a:args)
  if a:options.debug > 0
      echomsg printf(
            \ 'vital: System.Process.Job: %s',
            \ cmdline
            \)
  endif
  let stream = copy(s:stream)
  let stream.timeout = get(a:options, 'timeout')
  let stream._content = []
  let job = s:Job.start(a:args, stream)
  if a:options.background
    return {
          \ 'status': 0,
          \ 'job': job,
          \ 'output': '',
          \}
  else
    let status = job.wait(a:options.timeout == 0 ? v:null : a:options.timeout)
    " Follow vimproc's status for backward compatibility
    let status = status == -1 ? 15 : status
    return {
          \ 'job': job,
          \ 'status': status,
          \ 'output': join(stream._content, "\n"),
          \}
  endif
endfunction


" Stream ---------------------------------------------------------------------
let s:stream = {}

function! s:stream.on_stdout(job, msg, event) abort
  let leading = get(self._content, -1, '')
  silent! call remove(self._content, -1)
  call extend(self._content, [leading . get(a:msg, 0, '')] + a:msg[1:])
endfunction

function! s:stream.on_stderr(job, msg, event) abort
  let leading = get(self._content, -1, '')
  silent! call remove(self._content, -1)
  call extend(self._content, [leading . get(a:msg, 0, '')] + a:msg[1:])
endfunction
