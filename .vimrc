"----------------------------------------
" nocompatible
"----------------------------------------

set nocompatible

"----------------------------------------
" neobundle
"----------------------------------------

filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
    call neobundle#rc(expand('~/.vim/bundle/'))
endif

NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'mattn/gist-vim'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'nginx.vim'
NeoBundle 'hallison/vim-markdown'
NeoBundle 'nanotech/jellybeans.vim'

filetype plugin indent on

"----------------------------------------
" enable neocomplcache
"----------------------------------------

let g:neocomplcache_enable_at_startup = 1
" let g:neocomplcache_enable_insert_char_pre = 1
inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"
inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"

" ---------------------------------------
" syntax color
" ---------------------------------------

set t_Co=256
syntax on
colorscheme jellybeans
au BufRead,BufNewFile /etc/nginx/* set ft=nginx
au BufRead,BufNewFile /etc/php-fpm.conf set ft=php
au BufRead,BufNewFile /etc/php-fpm.d/* set syntax=dosini

"----------------------------------------
" display
"----------------------------------------

set scrolloff=10
set laststatus=2
set notitle
set number
let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ 'component': {
    \     'readonly': '%{&readonly?"x":""}',
    \ },
    \ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
    \ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" }
    \ }
"----------------------------------------
" tab
"----------------------------------------

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set shiftround
" set showtabline=2

"----------------------------------------
" edit
"----------------------------------------

set whichwrap=b,s,h,l,<,>,[,]
set autoindent
set smartindent
set backspace=indent,eol,start
"set showmatch
let loaded_matchparen = 1
vnoremap < <gv
vnoremap > >gv
set mouse=a
set ttymouse=xterm2
set pastetoggle=<C-e>

"----------------------------------------
" search
"----------------------------------------

set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>
set incsearch
set ignorecase
set wrapscan
set smartcase

"----------------------------------------
" backup
"----------------------------------------

set nobackup
set noswapfile

"----------------------------------------
" encoding
"----------------------------------------

set termencoding=utf-8
set encoding=utf-8

"-----------------------------------------
" NERDCommenter
"-----------------------------------------
let NERDSpaceDelims = 1
nmap ,, <Plug>NERDCommenterToggle
vmap ,, <Plug>NERDCommenterToggle

