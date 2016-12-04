# Create a directory and cd into it
function mdk() {
	mkdir -p "$@" && cd "$@" || exit
}

# Cd into a directory and list this directory contents
function cdl() {
	cd "$@" && ls
}

# Find shorthand
function f() {
	find . -name "$1" 2>&1 | grep -v 'Permission denied'
}

# Get gzipped size
function gz() {
	echo "orig size    (bytes): "
	wc -c < "$1"
	echo "gzipped size (bytes): "
	gzip -c "$1" | wc -c
}

# Manage the clipboard via xsel
function cb() {
  if [ -z "$1" ]; then
    xsel --clipboard --output
  else
    echo "$1" | xsel --clipboard --input
  fi
}
