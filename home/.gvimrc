"nnoremap <D-d> :Bdelete<CR>
"nnoremap <D-e> :e#<CR>
"nnoremap <D-b> :wa<CR>:make!<CR>

nnoremap <M-h> gT
nnoremap <M-l> gt

" Maximize window when start
"set lines=499 columns=499

" Disable vertical scrollbars
set guioptions-=L
set guioptions-=l
set guioptions-=R
set guioptions-=r

" Remove all menu items
"aunmenu *
" Remove some of the menu items
aunmenu Sessions
aunmenu Solarized
aunmenu Plugin
let g:Tex_Menus = 0

" Airline config
let g:airline_powerline_fonts = 1
"set guifont=Inconsolata\ for\ Powerline:h13
highlight Cursor guifg=black guibg=white

