## !IMPORTANT:
## this file needs to live at ~/ move it to that directory
## and be renamed to .bash_profile
## it is committed here just for reference

#   Simple Aliases
. ~/bash_scripts/scripts/aliases.sh

# Imports for Project workflows
. ~/bash_scripts/scripts/morning-start.sh
. ~/bash_scripts/scripts/bash-styling.sh
. ~/bash_scripts/scripts/extract.sh

# GIT COMPLETION
. ~/bash_scripts/utilities/git-completion.bash

# Set default paths
export EDITOR=atom

## !IMPORTANT:
## Delete these if not needed
export PYTHONPATH="/usr/local/google_appengine/:$PYTHONPATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f /Users/wanderson/Downloads/google-cloud-sdk/path.bash.inc ]; then
  source '/Users/wanderson/Downloads/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /Users/wanderson/Downloads/google-cloud-sdk/completion.bash.inc ]; then
  source '/Users/wanderson/Downloads/google-cloud-sdk/completion.bash.inc'
fi

# Added by Grow SDK Installer (2016-12-12 11:20:03.257844)
alias grow="/Users/wanderson/bin/grow"
