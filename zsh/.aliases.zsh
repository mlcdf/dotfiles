#
# Aliases
#

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


#
# Functions
#

# create a directory and cd into it
function md() {
	mkdir -p "$@" && cd "$@"
}

# find shorthand
function f() {
	find . -name "$1" 2>&1 | grep -v 'Permission denied'
}

# get gzipped size
function gz() {
	echo "orig size    (bytes): "
	cat "$1" | wc -c
	echo "gzipped size (bytes): "
	gzip -c "$1" | wc -c
}
