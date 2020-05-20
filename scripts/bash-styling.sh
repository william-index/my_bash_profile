setopt PROMPT_SUBST

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM='gnome-256color';
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM='xterm-256color';
fi;

parse_git_branch() {
    in_wd="$(git rev-parse --is-inside-work-tree 2>/dev/null)" || return
    test "$in_wd" = true || return
    state=''
    git update-index --refresh -q >/dev/null # avoid false positives with diff-index
    if git rev-parse --verify HEAD >/dev/null 2>&1; then
        git diff-index HEAD --quiet 2>/dev/null || state='*'
    else
        state='#'
    fi
    (
        d="$(git rev-parse --show-cdup)" &&
        cd "$d" &&
        test -z "$(git ls-files --others --exclude-standard .)"
    ) >/dev/null 2>&1 || state="${state}+"
    branch="$(git symbolic-ref HEAD 2>/dev/null)"
    test -z "$branch" && branch='<detached-HEAD>'
    gitprint="on ${yellow}${branch#refs/heads/}${state}"
    echo $gitprint
}

is_git() {
  echo "no"
}

# color reference: https://i.stack.imgur.com/a2S4s.png
black=$(tput setaf 0);
blue=$(tput setaf 33);
cyan=$(tput setaf 115);
green=$(tput setaf 106);
orange=$(tput setaf 166);
purple=$(tput setaf 125);
red=$(tput setaf 125);
violet=$(tput setaf 61);
white=$(tput setaf 15);
yellow=$(tput setaf 226);
pink=$(tput setaf 213);

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
    userStyle="${red}";
else
    userStyle="${orange}";
fi;

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
    hostStyle="${bold}${red}";
else
    hostStyle="${yellow}";
fi;

# Set the terminal title to the current working directory.
PS1="
"; #new line
PS1+='%B' #bold
PS1+='%F${cyan}%d ' #working directory
PS1+='%f$(parse_git_branch)'; # Git repository details
PS1+='
'; #new line
PS1+='${pink}💛  🦄  💛  ~ %f%b'; # `heart` (and reset color)
export PS1;

PS2="\[${yellow}\]→ \[${reset}\]";
export PS2;
