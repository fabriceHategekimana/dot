" ___  _             _           
"|  _ \| |_   _  __ _(_)_ __  ___ 
"| |_) | | | | |/ _` | | '_ \/ __|
"|  __/| | |_| | (_| | | | | \__ \
"|_|   |_|\__,_|\__, |_|_| |_|___/
"               |___/             
call plug#begin('~/.vim/plugged')

Plug 'vimwiki/vimwiki'
Plug 'https://github.com/wikitopian/hardmode.git'
Plug 'https://github.com/ptzz/lf.vim.git'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'scrooloose/nerdtree'

call plug#end()

set splitbelow
term
autocmd VimEnter * NERDTree
