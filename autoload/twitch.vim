let g:twitch#test_file_endings = ['_test', '_spec', 'Tests', 'Test']

function! twitch#open_alternate(vim_command)
  let file_path = expand('%')
  let path = expand('%:h')
  let file_name = expand('%:t:r')

  for path in s:search_paths(path)
    if file_path !~ s:test_file_test()
      let target_path = s:find_test_file(path, file_name)
    else
      let target_path = s:find_prod_file(path, file_name)
    endif
    if target_path != ''
      break
    endif
  endfor

  if target_path == ''
    let target_path = input("Couldn't find alternate file. File name: ", '', 'file')
  endif

  if target_path != ''
    exec a:vim_command . ' ' . target_path
  end
endfunction

function! s:test_file_test()
  return '\v(' . join(g:twitch#test_file_endings, '|') . ')'
endfunction

function! s:search_paths(path)
  let paths = []
  if a:path == '.'
    return paths + ['']
  else
    let base_path = './' . substitute(a:path, '\v^(\./)?\w*', '*', '') . '/*'
    let paths +=  [ './' . a:path . '/*' , base_path ]
    if a:path =~ '/main/'
      let paths += [ substitute(base_path, '/main/', '/test/', '') ]
    end
    if a:path =~ '/test/'
      let paths += [ substitute(base_path, '/test/', '/main/', '') ]
    end
    return paths
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

function! s:find_prod_file(search_path, file_name)
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
