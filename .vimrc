set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'Raimondi/delimitMate'
Plugin 'Yggdroot/indentLine'
Plugin 'davidhalter/jedi-vim'
"Plugin 'fs111/pydoc.vim'
"Plugin 'ervandew/supertab'
Plugin 'majutsushi/tagbar'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'nvie/vim-flake8'
"Plugin 'thinca/vim-quickrun'
"Plugin 'morhetz/gruvbox'
Plugin 'chrisbra/csv.vim'
Plugin 'dense-analysis/ale'
Plugin 'bling/vim-bufferline'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Bundle 'rodnaph/vim-color-schemes'

" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
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

let g:airline_theme='badwolf'

"let g:airline_powerline_fonts = 1

syntax enable
colorscheme elflord
"set bg=dark
"set termguicolors
set noautoindent
set nohlsearch
set showmatch
set expandtab
set tabstop=4
set nocindent
set nosmartindent
"set showmode
set shiftwidth=4
set indentexpr=
"set number
"filetype indent off
"filetype plugin indent off

"highlight OverLength ctermbg=darkred ctermfg=white guibg=FFD9D9
"match OverLength /\%>80v.\+/

set t_Co=256

source ~/.vimrc_local
