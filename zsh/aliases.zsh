#!/bin/sh

# Enable aliases to be sudo'ed
alias sudo="sudo "

# Open a file
alias open='xdg-open'

# Create the directory
# -p  create all directories leading up to the given directory
# -v  display each directory that mkdir creates.
alias mkdir="mkdir -pv"

# copy file interactive
alias cp='cp -i'

# move file interactive
alias mv='mv -i'

# untar
alias untar='tar xvf'

# Shortcuts
alias _dl="cd ~/Downloads"
alias _code="cd ~/Code"
alias _dot="cd ~/.dotfiles"

# git undo
alias gu="git reset --soft HEAD~"

# run docker
alias docker='sudo -g docker docker'

# Launch Firefox
# See https://developer.mozilla.org/en-US/docs/Mozilla/Command_Line_Options
alias ff=firefox

# Open Firefox in permanent private browsing mode
alias ffp=firefox -private-window

# Open Firefox Developer Edition
alias ffd=firefox-dev

# Display the amount of available disk space for file systems
alias df="df -Tha --total"

# Search through history
alias histg="history | grep"

# Clean /boot
alias clean-boot="sudo dpkg --get-selections|grep 'linux-image*'|awk '{print $1}'|egrep -v \"linux-image-$(uname -r)|linux-image-generic\" |while read n;do sudo apt-get -y remove $n;done"

# Shutdown the computer
alias shutdown='sudo shutdown -h now'

# Get the local IP
alias lip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \$2}'"

# Download file and save it with filename of remote file
alias get="curl -O -L"
