let g:twitch#test_file_endings = ['_test', '_spec', 'Tests', 'Test']

function! twitch#open_alternate(vim_command)
  let g:twitch#last_commands = []
  let g:twitch#found_paths = []

  let file_path = expand('%')
  let path = expand('%:h')
  let file_name = expand('%:t:r')

  for path in s:search_paths(path)
    if file_path !~ s:test_file_test()
      let target_path = s:find_test_file(path, file_name)
    else
      let target_path = s:find_prod_file(path, file_name)
    endif
    let g:twitch#found_paths += [target_path]
    if target_path != ''
      break
    endif
  endfor

  if target_path == ''
    let target_path = input("Couldn't find alternate file. File name: ", '', 'file')
  endif

  if target_path != ''
    try
      exec a:vim_command . ' ' . target_path
    catch
      let n = 0
      while n < len(g:twitch#last_commands)
        echom "Vim-Twitch ERR: '" . get(g:twitch#last_commands, n) . "' returned '" . get(g:twitch#found_paths, n) . "'."
        let n += 1
      endwhile
      echoerr "Vim-Twitch ERR: couldn't open file"
    endtry
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
    " we want all paths to begin with ./ and end with /*
    let raw_path = substitute(a:path, '^\.\/', '', '')

    let same_dir = './' . raw_path . '/*'
    let fuzzy_first_dir = './' . substitute(raw_path, '^\w*', '*', '') . '/*'

    let paths +=  [  same_dir, fuzzy_first_dir ]

    " For maven type projects
    if raw_path =~ '/main/'
      let paths += [ substitute(same_dir, '/main/', '/test/', '') ]
    end
    if raw_path =~ '/test/'
      let paths += [ substitute(same_dir, '/test/', '/main/', '') ]
    end
    " for ReasonML
    if raw_path =~ '/src/'
      let paths += [ substitute(same_dir, '/src/', '/__tests__/', '') ]
    end
    if raw_path =~ '/__tests__/'
      let paths += [ substitute(same_dir, '/__tests__/', '/src/', '') ]
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
    let path_arg = '-mindepth 1 -maxdepth 1'
  else
    let path_sections = strlen(substitute(a:search_path, '[^/]', '', 'g'))
    let path_arg = "-path '" . a:search_path . "' -mindepth " . path_sections . " -maxdepth " . path_sections
  end

  let g:twitch#find_cmd = "find . " . path_arg . " -name '" . a:search_file_name . "' -type f"
  let g:twitch#last_commands += [g:twitch#find_cmd]
  return system(g:twitch#find_cmd)
endfunction
