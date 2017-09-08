if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM='gnome-256color';
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM='xterm-256color';
fi;

prompt_git() {
    local s='';
    local branchName='';

    # Check if the current directory is in a Git repository.
    if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

        # check if the current directory is in .git before running git checks
        if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

            # Ensure the index is up to date.
            git update-index --really-refresh -q &>/dev/null;

            # Check for uncommitted changes in the index.
            if ! $(git diff --quiet --ignore-submodules --cached); then
                s+='+';
            fi;

            # Check for unstaged changes.
            if ! $(git diff-files --quiet --ignore-submodules --); then
                s+='!';
            fi;

            # Check for untracked files.
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                s+='?';
            fi;

            # Check for stashed files.
            if $(git rev-parse --verify refs/stash &>/dev/null); then
                s+='$';
            fi;

        fi;

        # Get the short symbolic ref.
        # If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
        # Otherwise, just give up.
        branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
            git rev-parse --short HEAD 2> /dev/null || \
            echo '(unknown)')";

        [ -n "${s}" ] && s=" [${s}]";

        echo -e "${1}${branchName}${blue}${s}";
    else
        return;
    fi;
}

parse_venv() {
  if [[ $VIRTUAL_ENV != "" ]]; then
    echo "${VIRTUAL_ENV##*/}"
  else
    return;
  fi
}

tput sgr0; # reset colors
bold=$(tput bold);
reset=$(tput sgr0);
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
PS1="\[\033]0;\w\007\]";
PS1+="\[${bold}\]\n"; # newline
PS1+="\[${cyan}\]\w"; # working directory
PS1+="\$(prompt_git \"${white} on ${yellow}\")"; # Git repository details
PS1+="\n";
PS1+="\[${pink}\]💛  🦄  💛  ~ \[${reset}\]"; # `heart` (and reset color)
export PS1;

PS2="\[${yellow}\]→ \[${reset}\]";
export PS2;
