#set target-async 1
set pagination off
#set non-stop on
add-auto-load-safe-path /
#set follow-fork-mode child
set follow-fork-mode parent
set detach-on-fork off

set history save on
set history filename ~/.gdb_history
set unwindonsignal on

source ~/WORK/llvm3/git/llvm/utils/gdb-scripts/prettyprinters.py
