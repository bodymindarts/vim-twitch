function! twitch#alternate(vim_command)
  let path = expand('%:h')
  let search_path = substitute(path, '^\w*', './*', '') . '*'

  let file_name = expand('%:t')

  if path !~ '\v(test|spec)'
      let target_file_name = substitute(file_name, '\.', '_test.', '')
      let target_path = s:execute_find(search_path, target_file_name)

    if target_path == ''
      let target_file_name = substitute(file_name, '\.', '_spec.', '')
      let target_path = s:execute_find(search_path, target_file_name)
    end

  else
    let target_file_name = substitute(file_name, '\v(_spec|_test)', '', '')
    let target_path = s:execute_find(search_path, target_file_name)
  endif

  exec a:vim_command . ' ' . target_path
endfunction

function! s:execute_find(target_path, target_file_name)
  let g:find_args = "-path '" . a:target_path . "' -name '" . a:target_file_name . "'"
  return system("find . " . g:find_args)
endfunction
