#!/bin/sh

# Create a directory and cd into it
mdk() {
	mkdir -p "$@" && cd "$@" || exit
}

# Cd into a directory and list this directory contents
cdl() {
	cd "$@" && ls
}

# Find shorthand
f() {
	find . -name "$1" 2>&1 | grep -v 'Permission denied'
}

# Get gzipped size
gz() {
	echo "orig size    (bytes): "
	wc -c < "$1"
	echo "gzipped size (bytes): "
	gzip -c "$1" | wc -c
}

# Manage the clipboard via xsel
cb() {
	if [ -z "$1" ]; then
		xsel --clipboard --output
	else
		echo "$1" | xsel --clipboard --input
	fi
}
