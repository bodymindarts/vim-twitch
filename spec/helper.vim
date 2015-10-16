source plugin/twitch.vim

function! Teardown() abort
  bufdo! bdelete!
endfunction
