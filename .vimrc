"
" VUNDLE
"

set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'valloric/youcompleteme'
Plugin 'othree/html5.vim'
Plugin 'honza/vim-snippets'

call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"
" END VUNDLE
"

set encoding=utf-8
set history=5112

" Spaces & tabs
syntax enable		" enable syntax processing
set tabstop=2		" number of visual spaces per TAB
set softtabstop=2	" number of spaces in tab when editing
set expandtab		" tab are spaces
set smartindent

" UI config
set number 		    " show line numbers
set showcmd 		" show command in bottom bar
" set cursorline	" highlight current line
set wildmenu		" visual autocomplete for command menu

" Search
set incsearch 		" search as characters are entered
set hlsearch		" highlight matches

" JavaScript auto-completion
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

" Python 3 completion
let g:ycm_python_binary_path = '/usr/bin/python3'
