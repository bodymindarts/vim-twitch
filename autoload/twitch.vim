function! twitch#alternate(vim_command)
  let path = expand('%:h')

  let search_path = s:search_path(path)

  let file_name = expand('%:t:r')
  if !s:is_test_file(expand('%'))
    let search_file_name = file_name . '_test.*'
    let target_path = s:execute_find(search_path, search_file_name)

    if target_path == ''
      let search_file_name = file_name . '_spec.*'
      let target_path = s:execute_find(search_path, search_file_name)
    end
  else
    let target_file_name = substitute(file_name, '\v(_spec|_test)', '', '') . '.*'
    let target_path = s:execute_find(search_path, target_file_name)
  endif

  exec a:vim_command . ' ' . target_path
endfunction

function! s:search_path(path)
  if a:path == '.'
    return ''
  else
    return './' . substitute(a:path, '^\w*', '*', '') . '*'
  end
endfunction

function! s:is_test_file(file_name)
  return a:file_name =~ '\v(test|spec)'
endfunction

function! s:execute_find(search_path, search_file_name)
  if a:search_path == ''
    let path_arg = '-depth 1'
  else
    let path_arg = "-path '" . a:search_path . "' -mindepth 2"
  end

  let find_args = path_arg . " -name '" . a:search_file_name . "' -type f"
  return system("find . " . find_args)
endfunction
