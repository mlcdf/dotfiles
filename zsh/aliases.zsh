# Enable aliases to be sudo'ed
alias sudo="sudo "

alias mkdir="mkdir -pv"
alias dl="cd ~/Downloads"

# Launch Firefox
# See https://developer.mozilla.org/en-US/docs/Mozilla/Command_Line_Options
alias ff=firefox

# Open Firefox in permanent private browsing mode
alias ffp=firefox -private-window

alias df="df -Tha --total"

# Search through history
alias histg="history | grep"

# Shutdown the computer
alias reboot='sudo shutdown -r now'

# Get the local IP
alias lip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \$2}'"

# Download file and save it with filename of remote file
alias get="curl -O -L"
