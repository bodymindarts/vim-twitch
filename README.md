# vim-twitch
Vim plugin to switch between test and production code with multi language support.

This plugin aims to support multiple conventions of structuring test/prod code and switching between them (similar to [vim-test](https://github.com/janko-m/vim-test) for running tests).

Please help making this plugin universal by pointing out common conventions that are not yet supported, or contribute directly via a pull-request.

## Setup

```vim
Plug[in] 'bodymindarts/vim-twitch'
```

Add your preferred mappings to your `.vimrc` file:

```vim
nnoremap <silent> <leader>t :Twitch<CR>
nnoremap <silent> <leader>vt :VTwitch<CR>
```

|Command | Description
|:------|:-------|
|`:Twitch`| If you are in a test file it will open the associated production file and vica versa |
|`:VTwitch`| Like `:Twitch` just that it will open the file in a vertical split |
