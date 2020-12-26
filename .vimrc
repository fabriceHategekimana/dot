
imap ( ()<Left>
nnoremap <C-J> }<CR>
nnoremap <C-K> {
nnoremap <F1> :tabnew $MYVIMRC<CR>
nnoremap vp :vsp .<CR>

inoremap <C-C> <Esc>

"Settings de base
set number
set splitright
set splitbelow


autocmd FileType python nnoremap <buffer> <F5> :terminal python3 %<CR>
autocmd Bufread *.m nnoremap <buffer> <F5> :terminal octave %<CR>
