# Enable aliases to be sudo'ed
alias sudo="sudo "

# Create the directory
# -p  create all directories leading up to the given directory
# -v  display each directory that mkdir creates.
alias mkdir="mkdir -pv"

# Shortcut to Downloads dir
alias _dl="cd ~/Downloads"

# Shortcut to code dir
alias _code="cd ~/code"

# Shortcut to .dotfiles dir
alias _dot="cd ~/.dotfiles"

# Git undo
alias gu="git reset --soft HEAD~"

# Run docker
alias docker='sudo -g docker docker'

# Launch Firefox
# See https://developer.mozilla.org/en-US/docs/Mozilla/Command_Line_Options
alias ff=firefox

# Open Firefox in permanent private browsing mode
alias ffp=firefox -private-window

# Display the amount of available disk space for file systems
alias df="df -Tha --total"

# Search through history
alias histg="history | grep"

# Shutdown the computer
alias shutdown='sudo shutdown -h now'

# Get the local IP
alias lip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \$2}'"

# Download file and save it with filename of remote file
alias get="curl -O -L"
