"""
""" In order for this config file to work, the plugin
""" Vundle needs to be installed:
""" https://github.com/VundleVim/Vundle.vim
"""

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Keep Plugin commands between vundle#begin/end.
Plugin 'scrooloose/nerdtree'
Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" YouCompleteMe: Close preview window automatically
let g:ycm_autoclose_preview_window_after_completion=1


""" Visibility options
" Make invisible characters visible
set list
set listchars=tab:→\ ,trail:+,space:·
" Display line numbers
set number
" Use relative line numbers for better navigation
set relativenumber
" Highlight the current line
set cursorline


""" Key mappings
" F4: Remove all trailing spaces
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" F8:Toggle invisibles
nnoremap <F8> :set list!<CR>
" F9: Toggle relative line numbers
nnoremap <F9> :set relativenumber!<CR>
" F10: Toggle line numbers
nnoremap <F10> :set number!<CR>


" Formatting options for python
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" Formatting options for shell scripts
au BufNewFile,BufRead *.sh,.bashrc
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |

