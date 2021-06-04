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

source ~/WORK/llvm0/git/llvm-project/llvm/utils/gdb-scripts/prettyprinters.py
source ~/bin/gdb-always-skip-current-function.py
skip function llvm::Optional<clang::Stmt const*>::operator*() &
skip function llvm::IntrusiveRefCntPtr<clang::ento::ProgramState const>::IntrusiveRefCntPtr(llvm::IntrusiveRefCntPtr<clang::ento::ProgramState const> const&)
skip function clang::ento::SVal::castAs<clang::ento::NonLoc>() const
skip function std::__shared_ptr_access<(anonymous namespace)::StdLibraryFunctionsChecker::ValueConstraint, (__gnu_cxx::_Lock_policy)2, false, false>::operator->() const
skip function llvm::Optional<clang::ento::DefinedOrUnknownSVal>::operator*() &
skip function std::unique_ptr<clang::ento::ConstraintManager, std::default_delete<clang::ento::ConstraintManager> >::operator->() const
skip function clang::ento::SVal::castAs<clang::ento::DefinedSVal>() const
skip function llvm::IntrusiveRefCntPtr<clang::ento::ProgramState const>::IntrusiveRefCntPtr(clang::ento::ProgramState const*)
