function module() {
    eval `/app/modules/0/bin/modulecmd bash "$@"`
}

function swap()         
{
	local file1=$1
	local file2=$2
	local tmpfile=$(mktemp $(dirname "$file1")/XXXXXX)
	mv "$file1" "$tmpfile"
	mv "$file2" "$file1"
	mv "$tmpfile" "$file2"
}

function printView() {
    if [ -n "$CURRENT_VIEW" ]; then
        echo -en "($CURRENT_VIEW)"
    fi
}

function setupPrompt() {
    local standardBranchDisplay='\[\e[0;94m\]$(__git_ps1)\[\e[0m\]'
    local branchDisplay
    if [ -n "$NO_GITSTATUS" ]; then
        branchDisplay="$standardBranchDisplay"
    else
        local color
        local symbolColor
        local symbol
        local branchName
        {
            read -r color
            read -r symbolColor
            read -r symbol
            read -r branchName
        } < <(printBranch all)
       if [ -z "$branchName" ]; then
           branchDisplay="$standardBranchDisplay"
        else
            branchDisplay="\\[${color}\\](\\[${symbolColor}\\]${symbol}\\[${color}\\]${branchName})\\[\\e[0m\\]"
        fi
    fi
    export PS1='\[\e[0;95m\]$? \[\e[0;91m\]$(printView)\[\e[0m\]'"$branchDisplay"'$(ppwd \l)\h:$(printdir 2)> '
}

CURRENT_VIEW=$(cleartool pwv -setview | sed -re 's/^Set view: (.*)$/\1/' | sed -re "s|($USER)_(.*)|\\2|" | grep -v "NONE")

NO_GITSTATUS="yes"
PROMPT_COMMAND=setupPrompt

source ~/.common_zsh_bash.rc

