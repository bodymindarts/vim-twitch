let g:twitch#test_file_endings = ['_test', '_spec']

function! twitch#open_alternate(vim_command)
  let file_path = expand('%')
  let path = expand('%:h')
  let file_name = expand('%:t:r')

  if file_path !~ s:test_file_test()
    let target_path = s:find_test_file(s:search_path(path), file_name)
  else
    let target_path = s:find_prob_file(s:search_path(path), file_name)
  endif

  if target_path == ''
    let target_path = input("Couldn't find alternate file. File name: ", '', 'file')
  endif

  exec a:vim_command . ' ' . target_path
endfunction

function! s:test_file_test()
  return '\v(' . join(g:twitch#test_file_endings, '|') . ')'
endfunction

function! s:search_path(path)
  if a:path == '.'
    return ''
  else
    return './' . substitute(a:path, '\v^(\./)?\w*', '*', '') . '/*'
  end
endfunction

function! s:find_test_file(search_path, file_name)
  for ending in g:twitch#test_file_endings
    let search_file_name = a:file_name . ending . '.*'
    let target_path = s:execute_find(a:search_path, search_file_name)

    if target_path != ''
      return target_path
    endif
  endfor
endfunction

function! s:find_prob_file(search_path, file_name)
    let search_file_name = substitute(a:file_name, s:test_file_test(), '', '') . '.*'
    return s:execute_find(a:search_path, search_file_name)
endfunction

function! s:execute_find(search_path, search_file_name)
  if a:search_path == ''
    let path_arg = '-depth 1'
  else
    let path_sections = strlen(substitute(a:search_path, '[^/]', '', 'g'))
    let path_arg = "-path '" . a:search_path . "' -depth " . path_sections
  end

  let g:find_args = path_arg . " -name '" . a:search_file_name . "' -type f"
  return system("find . " . g:find_args)
endfunction
