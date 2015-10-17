if exists('g:loaded_twitch')
  finish
endif
let g:loaded_twitch = 1

command!          -bar Twitch   call twitch#open_alternate(':edit')
command!          -bar VTwitch   call twitch#open_alternate(':vsplit')
