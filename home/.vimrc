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
" Store swap files in fixed location, not current directory.
"set dir=~/.vimswap//,/var/tmp//,/tmp//,.
set noswapfile
set ignorecase
set incsearch
" terminal colors
set t_Co=256

" Extra leader key
map <Space> <Leader>

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
  set wildignore+=*.o
  set wildignore+=*build*
  "set wildignore+=*test*
endif

" Vundle stuff
filetype off " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'tpope/vim-pathogen'
Bundle 'SirVer/ultisnips'
Bundle 'tpope/vim-unimpaired'
Bundle 'tomtom/tcomment_vim'
"Bundle 'gilligan/vim-lldb'
"Bundle 'file:///Users/mg/dhp/git/lldb', {'rtp': 'utils/vim-lldb'}
Bundle 'vim-scripts/Conque-GDB'
Bundle 'sjl/gundo.vim'
Bundle 'tommcdo/vim-exchange'
Bundle 'tpope/vim-sleuth'
Bundle 'h1mesuke/vim-unittest'
Bundle 'tpope/vim-fugitive'
Bundle 'jlanzarotta/bufexplorer'
Bundle 'lyuts/vim-rtags', {'name': 'lyuts-vim-rtags'}
"Bundle 'CIB/vim-rtags'
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
Bundle 'xolox/vim-reload'
Bundle 'xolox/vim-session'
Bundle 'airblade/vim-gitgutter'
Bundle 'tpope/vim-surround'
Bundle 'vim-jp/cpp-vim'
Bundle 'bkad/CamelCaseMotion'
"Bundle 'git://github.com/vim-scripts/YankRing.vim.git'
Bundle 'vim-scripts/a.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'wincent/command-t'

Bundle 'rhysd/vim-clang-format'
" clang-format dependencies
Bundle 'kana/vim-operator-user'
Bundle 'Shougo/vimproc.vim'

filetype plugin indent on " required!


" Pathogen
"execute pathogen#infect()
execute pathogen#infect('bundle_pathogen/{}')


" Auto commands
" Check whether a file has been changed by an other process then vim.
autocmd BufEnter * silent! checktime
autocmd CursorHold * silent! checktime
autocmd CursorHoldI * silent! checktime
" Automatically fix whitspace errors in case of C++ files.
"autocmd BufWritePost *.hpp,*.cpp :FixWhitespace
map <Leader>s :autocmd BufWritePost * :FixWhitespace<cr>
" Automatically open quickfix window after e.g. :vimgrep
autocmd QuickFixCmdPost [^l]* nested cwindow


" BufExplorer
noremap <Leader>v :BufExplorer<CR>
" nunmap somehow is not working
"nunmap <Leader>bs
"nunmap <Leader>bv
noremap <Leader>_Bs :BufExplorerHorizontalSplit<CR>
noremap <Leader>_Bv :BufExplorerVerticalSplit<CR>


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
let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 100,
    \ 'x': 60,
    \ 'y': 88,
    \ 'z': 45,
    \ 'warning': 60
    \ }
let g:airline#extensions#default#layout = [
      \ [ 'a', 'c', 'b' ],
      \ [ 'x', 'y', 'z', 'warning' ]
      \ ]

" NERDTree config
map <Leader>n :NERDTreeFocus<cr>
map <Leader>f :NERDTreeFind<cr>
let g:NERDTreeDirArrows=0
let g:NERDTreeMapOpenSplit = 's'
let g:NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeIgnore = ['\.o$', '\.o-.*$']


" CommandT config
let g:CommandTNeverShowDotFiles = 1
let g:CommandTMaxFiles = 100000


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
let g:ycm_autoclose_preview_window_after_completion = 0
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
map gd :YcmCompleter GoTo<CR>
map <Leader>Y :YcmDiags<cr>
map <Leader>y :YcmForceCompileAndDiagnostics<cr>

" UltiSnips config
"let g:UltiSnipsExpandTrigger = '<c-l>'
"let g:UltiSnipsJumpForwardTrigger = '<c-j>'
"let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
" The following is a workaround to work with <tab> and <s-tab> and with YCM.
" http://stackoverflow.com/questions/14896327/ultisnips-and-youcompleteme
function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
               return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction
au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsListSnippets="<c-e>"
" this mapping Enter key to <C-y> to chose the current highlight item
" and close the selection list, same as other IDEs.
" CONFLICT with some plugins like tpope/Endwise
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" ConqueGdb
let g:ConqueGdb_Leader = '<Leader>g'


" Lusty Juggler
let g:LustyJugglerAltTabMode = 1
noremap <silent> <C-E> :LustyJuggler<CR>


" vim-session
:let g:session_autosave = 'no'
:let g:session_autoload = 'no'


" YankRing
" Note: Repeating paste with . is not possible with yankrink :(
"let g:yankring_min_element_length = 2
"let g:yankring_max_element_length = 4194304 " 4M
"nnoremap <silent> <Leader>p :YRShow<CR>


" a.vim
let g:alternateSearchPath="reg:/include/src//,reg:/include/source//,reg:/inc/src//,reg:/inc/source//,reg:/src/include//,reg:/source/include//,reg:/src/inc//,reg:/source/include//,sfr:..,sfr:../..,sfr:../../.."


" clang-format
let g:clang_format#style_options = {
  \ "AccessModifierOffset" : -4,
  \ "AllowShortIfStatementsOnASingleLine" : "true",
  \ "AllowShortLoopsOnASingleLine" : "true",
  \ "AlwaysBreakTemplateDeclarations" : "true",
  \ "Standard" : "Auto",
  \ "TabWidth" : 4,
  \ "UseTab" : "Always"}
let g:clang_format#code_style = 'google'
let g:clang_format#command = '/Users/mg/local/clang+llvm-3.4.2-x86_64-apple-darwin10.9/bin/clang-format'


" rtags
map \j :call rtags#JumpTo()<CR>
map \r :call rtags#FindRefs()<CR>


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
set pastetoggle=<Leader>P
" Select pasted text
nnoremap gV `[v`]
" Put full path on the paste register
nmap cp :let @" = expand("%:p")<cr>


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

