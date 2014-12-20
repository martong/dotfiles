" Generic Editor Configs
set number
" Highlight search results (turn off :nohlsearch)
"set hlsearch
set scrolloff=2
set autoindent

set tabstop=4
set shiftwidth=4
set softtabstop=4

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
set smartcase
set incsearch
" terminal colors
set t_Co=256
" tab completion
" bash style
set wildmode=longest,list
" zsh style
"set wildmenu
"set wildmode=full
" set command history size
set history=500
" Mute bell
"set vb t_vb=
" Match if-endif like pairs, not just parens
runtime macros/matchit.vim
highlight Cursor guifg=black guibg=white

set autoread
set mouse=a
" Indent linebreaks
set breakindent
set showbreak=↪
set breakat-=-
set breakat-=*
set breakat+=()


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

  let MYMAKE=expand("./mymake")
  if filereadable(MYMAKE)
    "echo "MYMAKE"
    set makeprg=./mymake
    " Match the assertion errors (in gtest)
    set errorformat+=%m\\,\ file\ %f\\,\ line\ %l%.
  endif

  let DIRNAME=fnamemodify(fnamemodify(".", ":p:h"), ":t")
  let &titlestring=DIRNAME
endif


" Tagbar
let g:tagbar_ctags_bin = '/Users/mg/archives/ctags-code/ctags'


" Vundle stuff
filetype off " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'JazzCore/ctrlp-cmatcher'
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'martong/vim-visual-star-ag'
Bundle 'file:///Users/mg/WORK/git/vim-compiledb-path'
Bundle 'ciaranm/detectindent'
Bundle 'tpope/vim-repeat'
Bundle 'Peeja/vim-cdo'
Bundle 'henrik/vim-qargs'
Bundle 'tpope/vim-abolish'
Bundle 'nelstrom/vim-visual-star-search'
Bundle 'majutsushi/tagbar'
Bundle 'git://git.code.sf.net/p/vim-latex/vim-latex'
Bundle 'rking/ag.vim'
Bundle 'mileszs/ack.vim'
Bundle 'tpope/vim-pathogen'
Bundle 'SirVer/ultisnips'
Bundle 'tpope/vim-unimpaired'
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
Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree'
Bundle 'bling/vim-airline'
Bundle 'bronson/vim-trailing-whitespace'
"Bundle 'ntpeters/vim-better-whitespace'
Bundle 'BufOnly.vim'
Bundle 'headerguard'
Bundle 'Valloric/YouCompleteMe'
" :Bdelete --> does not close windows, just the buffer.
Bundle 'moll/vim-bbye'
" vim-reload, vim-session depends on it
Bundle 'xolox/vim-misc'
" automatically reloads various types of Vim scripts as you're editing them
Bundle 'xolox/vim-reload'
Bundle 'xolox/vim-session'
Bundle 'airblade/vim-gitgutter'
Bundle 'tpope/vim-surround'
Bundle 'vim-jp/cpp-vim'
Bundle 'bkad/CamelCaseMotion'
Bundle 'vim-scripts/a.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'wincent/command-t'

" clang-format dependencies
"Bundle 'kana/vim-operator-user'
"Bundle 'Shougo/vimproc.vim'
"Bundle 'rhysd/vim-clang-format'

filetype plugin indent on " required!


" Pathogen
"execute pathogen#infect()
execute pathogen#infect('bundle_pathogen/{}')


" Auto commands
" Check whether a file has been changed by an other process then vim.
autocmd BufEnter * silent! checktime
autocmd CursorHold * silent! checktime
autocmd CursorHoldI * silent! checktime
" Automatically open quickfix window after e.g. :vimgrep
autocmd QuickFixCmdPost [^l]* nested cwindow


" Tex
" http://tex.stackexchange.com/questions/62134/how-to-disable-all-vim-latex-mappings
let g:Tex_SmartKeyBS = 0
let g:Tex_SmartKeyQuote = 0
let g:Tex_SmartKeyDot = 0
let g:Imap_UsePlaceHolders = 0
let g:Tex_Leader = '`tex'
let g:Tex_Leader2 = ',tex'

let g:tex_flavor='latex'
let g:Tex_TreatMacViewerAsUNIX = 1
let g:Tex_ExecuteUNIXViewerInForeground = 1
let g:Tex_ViewRule_ps = 'open -a Preview'
let g:Tex_ViewRule_pdf = 'open -a Preview'


" BufExplorer
noremap <Leader>v :BufExplorer<CR>
" nunmap somehow is not working
"nunmap <Leader>bs
"nunmap <Leader>bv
noremap <Leader>_Bs :BufExplorerHorizontalSplit<CR>
noremap <Leader>_Bv :BufExplorerVerticalSplit<CR>


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
      \ [ 'x', 'z', 'warning' ]
      \ ]
let g:airline#extensions#tagbar#enabled = 0


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
let g:CommandTMaxHeight = 10
let g:CommandTMatchWindowReverse = 1
"let g:CommandTMatchWindowAtTop = 1


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
let g:UltiSnipsListSnippets="<c-l>"
" this mapping Enter key to <C-y> to chose the current highlight item
" and close the selection list, same as other IDEs.
" CONFLICT with some plugins like tpope/Endwise
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"


" ConqueGdb
let g:ConqueGdb_Leader = '<Leader>g'


" vim-session
:let g:session_autosave = 'no'
:let g:session_autoload = 'no'


" a.vim
let g:alternateSearchPath="reg:/include/src//,reg:/include/source//,reg:/inc/src//,reg:/inc/source//,reg:/src/include//,reg:/source/include//,reg:/src/inc//,reg:/source/include//,sfr:..,sfr:../..,sfr:../../.."
"map <Leader>A :A<cr>


" clang-format
"let g:clang_format#style_options = {
  "\ "AccessModifierOffset" : -4,
  "\ "AllowShortIfStatementsOnASingleLine" : "true",
  "\ "AllowShortLoopsOnASingleLine" : "true",
  "\ "AlwaysBreakTemplateDeclarations" : "true",
  "\ "Standard" : "Auto",
  "\ "TabWidth" : 4,
  "\ "IndentCaseLabels" : "true",
  "\ "UseTab" : "Always"}
"let g:clang_format#code_style = 'google'
"let g:clang_format#command = '/Users/mg/local/clang+llvm-3.4.2-x86_64-apple-darwin10.9/bin/clang-format'
" Explicitly adding mark 'c' because clangformat blows up the position.
"nnoremap <Leader>cf :execute 'normal mc' <bar> ClangFormat<cr>
"function! ClangFormatWithMark()
    "call setpos("'c", getpos("'<"))
    "let openVis = getpos("'<")
    "let closeVis = getpos("'>")
    "execute "'<,'>ClangFormat"
    "call setpos("'<", openVis)
    "call setpos("'>", closeVis)
"endfunction
"vnoremap <Leader>cf <esc>:call ClangFormatWithMark()<cr>
map <Leader>cf :0,$pyf /Users/mg/local/clang-format.py<CR>
vmap <Leader>cf :pyf /Users/mg/local/clang-format.py<CR>


" rtags
map \j :call rtags#JumpTo()<CR>
map \r :call rtags#FindRefs()<CR>
noremap <Leader>J :call rtags#FindSymbolsOfWordUnderCursor()<CR>


" Tagbar
map <Leader>T :TagbarToggle<CR>


" better-whitespace
"map <Leader>s :ToggleStripWhitespaceOnSave<cr>
" unimpaired like toggling
"map cows :ToggleWhitespace<cr>


" CtrlP
let g:ctrlp_cmd = 'CtrlP `pwd`'
let g:ctrlp_by_filename = 1
"let g:ctrlp_follow_symlinks = 2
let g:ctrlp_user_command = 'ag %s --ignore-case --nocolor --nogroup
            \ --skip-vcs-ignores
            \ --ignore "*.o"
            \ --ignore "*.a"
            \ --ignore "*.png"
            \ --ignore "*.jpg"
            \ --ignore "boostLibs"
            \ --ignore "glm"
            \ -g ""'
let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
nnoremap <Leader>t :CtrlP `pwd`<cr>
nnoremap <Leader>o :CtrlP `pwd`<cr>
nnoremap <Leader>b :CtrlPBuffer<cr>
nnoremap <Leader>C :CtrlPChangeAll<cr>
map <leader>w :let @9 = expand("%:t:r")<cr>:CtrlP `pwd`<cr><C-\>r9


" Custom mappings
" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d
map <Leader>3 :vertical resize 30<cr>
map <Leader>8 :vertical resize 89<cr>
" Select pasted text
nnoremap gV `[v`]
" Put full path on the default register
nmap cp :let @" = expand("%:p")<cr>
" Set the <C-p> and <C-n> chords to go backward and forward through our command history.
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
" Extra leader key
map <Space> <Leader>
" Do not enter Ex mode
" http://www.bestofvim.com/tip/leave-ex-mode-good/
nnoremap Q <nop>

