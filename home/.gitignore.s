# .gitignore.s
# The simple .gitignore file can not be stored under home, because that
# would make it impossible to add the files listed in it.
# Such a problematic file is .ycm_extra_conf.py .
# The solution is to store .gitignore.s instead of .gitignore in the castle.
# Also a symlink in ~ needed to be created to gitignore:
# ls -l ~/.giti*
# lrwxrwxr-x  1 mg  staff  52 Nov  2 16:32 /Users/mg/.gitignore -> /Users/mg/.homesick/repos/dotfiles/home/.gitignore.s
# lrwxrwxr-x  1 mg  staff  52 Nov  2 16:31 /Users/mg/.gitignore.s -> /Users/mg/.homesick/repos/dotfiles/home/.gitignore.s
.ycm_extra_conf.py*
mymake
.gradletasknamecache
*.orig
bin/
