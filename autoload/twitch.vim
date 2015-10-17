let g:twitch#test_file_endings = ['_test', '_spec']

function! twitch#open_alternate(vim_command)
  let file_path = expand('%')
  let path = expand('%:h')
  let file_name = expand('%:t:r')

  let search_path = s:search_path(path)

  if file_path !~ s:test_file_test()
    let target_path = s:find_test_file(search_path, file_name)
  else
    let target_path = s:find_prob_file(search_path, file_name)
  endif

  exec a:vim_command . ' ' . target_path
endfunction

function! s:search_path(path)
  if a:path == '.'
    return ''
  else
    return './' . substitute(a:path, '\v^(\./)?\w*', '*', '') . '*'
  end
endfunction

function! s:test_file_test()
  return '\v(' . join(g:twitch#test_file_endings, '|') . ')'
endfunction

function! s:find_test_file(search_path, file_name)
    let search_file_name = a:file_name . '_test.*'
    let target_path = s:execute_find(a:search_path, search_file_name)

    if target_path == ''
      let search_file_name = a:file_name . '_spec.*'
      let target_path = s:execute_find(a:search_path, search_file_name)
    end
    return target_path
endfunction

function! s:find_prob_file(search_path, file_name)
    let search_file_name = substitute(a:file_name, '\v(_spec|_test)', '', '') . '.*'
    return s:execute_find(a:search_path, search_file_name)
endfunction

function! s:execute_find(search_path, search_file_name)
  if a:search_path == ''
    let path_arg = '-depth 1'
  else
    let path_arg = "-path '" . a:search_path . "' -mindepth 2"
  end

  let g:find_args = path_arg . " -name '" . a:search_file_name . "' -type f"
  return system("find . " . g:find_args)
endfunction
