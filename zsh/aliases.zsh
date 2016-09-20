# Enable aliases to be sudo'ed
alias sudo="sudo "

alias mkdir="mkdir -pv"
alias dl="cd ~/Downloads"
alias ff=firefox
alias ffp=firefox --private

# Get the local IP
alias myip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \$2}'"

# Download file and save it with filename of remote file
alias get="curl -O -L"
