# Create a directory and cd into it
function mdk() {
	mkdir -p "$@" && cd "$@"
}

# Find shorthand
function f() {
	find . -name "$1" 2>&1 | grep -v 'Permission denied'
}

# Get gzipped size
function gz() {
	echo "orig size    (bytes): "
	cat "$1" | wc -c
	echo "gzipped size (bytes): "
	gzip -c "$1" | wc -c
}
