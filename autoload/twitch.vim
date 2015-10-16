function! twitch#alternate(vim_command)
  let file_name = expand('%:t')

  if file_name !~ '_spec.rb$'
    let target_file_name = substitute(file_name, '\.rb$', '_spec.rb', '')
  else
    let target_file_name = substitute(file_name, '_spec', '', '')
  endif

  let target_path = system("find . -path '*/" . target_file_name . "'")

  exec a:vim_command . ' ' . target_path
endfunction
