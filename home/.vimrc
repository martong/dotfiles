" Generic Editor Configs
set number
" Highlight search results (turn off :nohlsearch)
"set hlsearch
set scrolloff=2
set autoindent
set tabstop=4
set shiftwidth=4
set linebreak
" Enable syntax highlighting
syntax on
" Select case-insenitiv search (not default)
"set ignorecase
" Show cursor line and column in the status line
set ruler
" Show matching brackets
set showmatch
" Changes special characters in search patterns (default)
"set magic
" Required to be able to use keypad keys and map missed escape sequences
set esckeys
set nocompatible
"set timeoutlen=1000 ttimeoutlen=10
" make backspace work like most other apps
set backspace=2
" margin
set colorcolumn=81
" Control the position of the new window
set splitbelow
set splitright
" Allow hiding an unsaved buffer
set hidden


" Solarized colorscheme
" http://stackoverflow.com/questions/12774141/strange-changing-background-color-in-vim-solarized
":set t_ut=
let g:solarized_termtrans=1
"let g:solarized_termcolors=256
"let g:solarized_degrade=1
"let g:solarized_contrast="high"
"let g:solarized_visibility="high"
set background=dark
colorscheme solarized

if $VIMIDE != "ide"
	let g:loaded_youcompleteme = 1
else
	"echo "VIMIDE"
endif

" Vundle stuff
filetype off " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree'
Bundle 'bling/vim-airline'
Bundle 'bronson/vim-trailing-whitespace'
Bundle 'fholgado/minibufexpl.vim'
Bundle 'BufOnly.vim'
Bundle 'headerguard'
Bundle 'Valloric/YouCompleteMe'
Bundle 'sjbach/lusty'
Bundle 'moll/vim-bbye'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-session'
Bundle 'airblade/vim-gitgutter'
Bundle 'tpope/vim-surround'
Bundle 'vim-jp/cpp-vim'
Bundle 'bkad/CamelCaseMotion'
"Bundle 'Raimondi/delimitMate'
Bundle 'git@github.com:Raimondi/delimitMate.git'
"Bundle 'YankRing'
Bundle 'git://github.com/vim-scripts/YankRing.vim.git'

Bundle 'rhysd/vim-clang-format'
" clang-format dependencies
Bundle 'kana/vim-operator-user'
Bundle 'Shougo/vimproc.vim'

filetype plugin indent on " required!


" Pathogen
execute pathogen#infect()


" Auto commands
" Check whether a file has been changed by an other process then vim.
autocmd BufEnter * checktime
autocmd CursorHold * checktime
autocmd CursorHoldI * checktime
" Automatically fix whitspace errors in case of C++ files.
"autocmd BufWritePost *.hpp,*.cpp :FixWhitespace
map <Leader>s :autocmd BufWritePost * :FixWhitespace<cr>


" Mini BufExplorer
map <Leader>e :MBEFocus<cr>
map <Leader>m :MBEToggle<cr>
let g:miniBufExplorerAutoStart = 0
let g:miniBufExplBRSplit = 0
let g:miniBufExplShowBufNumbers = 0
"hi link MBENormal Identifier
hi link MBEChanged WarningMsg
hi link MBEVisibleNormal airline_x
hi link MBEVisibleChanged airline_x_red
"hi MBEVisibleNormal term=bold,underline cterm=bold,underline ctermfg=10
"hi MBEVisibleChanged term=bold,underline cterm=bold,underline ctermfg=9
hi link MBEVisibleActiveNormal airline_b
hi link MBEVisibleActiveChanged airline_warning


" Airline config
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set laststatus=2


" NERDTree config
map <Leader>n :NERDTreeFocus<cr>
map <Leader>f :NERDTreeFind<cr>
let g:NERDTreeDirArrows=0
let g:NERDTreeMapOpenSplit = 's'
let g:NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeIgnore = ['\.o$', '\.o-.*$']


" CommandT config
let g:CommandTNeverShowDotFiles = 1
set wildignore+=*.o
set wildignore+=*build*
set wildignore+=*lastrun*
"set wildignore+=*test*


" Taglist config
let Tlist_Show_One_File = 1


" EasyGrep
set grepprg=grep\ -n\ -P
let g:EasyGrepMode=3
let g:EasyGrepCommand=1
let g:EasyGrepRecursive=1
" let g:EasyGrepIgnoreCase=1
let g:EasyGrepDefaultUserPattern='*.cpp *.hpp *.cxx *.hxx *.cc *.hh *.c++ *.inl Makefile *.tup'
let g:EasyGrepFilesToExclude='build/*'
let g:EasyGrepOpenWindowOnMatch=1
let g:EasyGrepJumpToMatch=0


" In case of vimdiff, use a different colorscheme
"if &diff
"    colorscheme evening
"endif


" Headerguard
function! g:HeaderguardName()
	return toupper(expand('%:gs/[^0-9a-zA-Z_]/_/g'))
endfunction


" YouCompleteMe
"let g:ycm_server_use_vim_stdout = 1
"let g:ycm_server_log_level = 'debug'
let g:ycm_global_ycm_extra_conf = '/home/egbomrt/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']
let g:ycm_auto_trigger = 0
"let g:ycm_semantic_triggers =  {
"  \   'c' : ['->', '.'],
"  \   'objc' : ['->', '.'],
"  \   'perl' : ['->'],
"  \   'php' : ['->', '::'],
"  \   'cs,java,javascript,d,vim,ruby,python,perl6,scala,vb,elixir,go' : ['.'],
"  \   'lua' : ['.', ':'],
"  \   'erlang' : [':'],
"  \ }

" Syntastic Config
" syntastic requires pathogen
" syntastic is installed on a separate bundle dir
" to be able to load only when vimide is executed.
" execute pathogen#infect('bundle_pathogen_ycm/{}')
" disable temporary
"let g:syntastic_mode_map = { 'mode': 'passive',
                               "\ 'active_filetypes': ['ruby', 'php'],
                               "\ 'passive_filetypes': ['puppet'] }

map gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
map <Leader>y :YcmDiags<cr>
"map <F4> :YcmCompleter GoToDefinition<CR>
"map <F5> :YcmCompleter GoToDeclaration<CR>


" Lusty Juggler
let g:LustyJugglerAltTabMode = 1
noremap <silent> <C-E> :LustyJuggler<CR>


" vim-session
:let g:session_autosave = 'no'
:let g:session_autoload = 'no'


" YankRing
let g:yankring_min_element_length = 2
let g:yankring_max_element_length = 4194304 " 4M
nnoremap <silent> <Leader>p :YRShow<CR>


" DelimitMate
let g:delimitMate_autoclose = 0
let g:delimitMate_expand_cr = 1
let g:delimitMate_matchpairs = "{:}" 


" clang-format 
let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "Auto",
			\ "TabWidth" : 4,
			\ "UseTab" : "Always"}
let g:clang_format#code_style = 'google'
let g:clang_format#command = '/proj/cudbdm/tools/external/clang-3.4/SLED11/bin/clang-format'


" Custom mappings
" Moving lines up and down
"map <A-Down> :m .+1<CR>==
"map <A-Up> :m .-2<CR>==
" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d
" change editor mode
inoremap jj <Esc>
map <C-S> <PageUp>
map <Leader>3 :vertical resize 30<cr>
map <Leader>8 :vertical resize 89<cr>
map <Leader>w :set wrap!<cr>
map <Leader>h :set hlsearch!<cr>


" TMUX compatiblity for
" keys combined with modifiers such as Shift, Control, and Alt.
" See http://www.reddit.com/r/vim/comments/1a29vk/_/c8tze8p
if &term =~ '^screen'
  " Page keys http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
  execute "set t_kP=\e[5;*~"
  execute "set t_kN=\e[6;*~"

  " Arrow keys http://unix.stackexchange.com/a/34723
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

