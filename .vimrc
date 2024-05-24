" powered by vim gorilla
" https://knowledge.sakura.ad.jp/23121/

"""""""""""""""""""""
" auto install plugins
"""""""""""""""""""""
" need to set ~/.vim/dein.toml and ~/.vim/dein_lazy.toml

" dein.vim settings {{{
" install dir {{{
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" }}}

" dein installation check {{{
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif
" }}}

" begin settings {{{
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " .toml file
  let s:rc_dir = expand('~/.vim')
  if !isdirectory(s:rc_dir)
    call mkdir(s:rc_dir, 'p')
  endif
  let s:toml = s:rc_dir . '/dein.toml'
  let s:toml_lazy = s:rc_dir . '/dein_lazy.toml'
  
  " read toml and cache
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:toml_lazy, {'lazy': 1})
  
  " end settings
  call dein#end()
  call dein#save_state()
endif
" }}}

" plugin installation check {{{
if dein#check_install()
  call dein#install()
endif
" }}}

" plugin remove check {{{
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif
" }}}

"""""""""""""""""""""
" set plugins option
"""""""""""""""""""""
" en2ja {{{
set helplang=ja
" }}}

" iced {{{
let g:iced_enable_default_key_mappings = v:true
set splitright
let g:iced#buffer#stdout#mods = 'vertical'
let g:iced#buffer#error#height = 5
" }}}

"""""""""""""""""""""
" set option
"""""""""""""""""""""
" set encoding {{{
set fileencodings=utf-8,cp932
" }}}

" display number {{{
set number
" set relativenumber
" }}}

" add cursorline {{{
set cursorline
" }}}

" syntax hilight {{{
syntax enable
set hlsearch
filetype plugin indent on
" }}}

" conv search {{{
set incsearch
" }}}

" inf undo {{{
if has('persistent_undo')
	" need to create this dir
	let undo_path = expand('~/.vim/undo')
	exe 'set undodir=' .. undo_path
	set undofile
endif
" }}}

" use auto indent {{{
set smartindent
" }}}

" clipboard {{{
set clipboard+=unnamed
" }}}

" use status line {{{
set laststatus=2
" }}}

" cli cmd auto complate {{{
set wildmenu
" }}}
