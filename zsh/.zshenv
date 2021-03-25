#!/bin/sh

export EDITOR="vim"

# Golang
export PATH="$PATH:$GOPATH"

# Node.js
export NPM_PACKAGES="/home/max/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules${NODE_PATH:+:$NODE_PATH}"
export PATH="$PATH:$NPM_PACKAGES/bin"

# Python / Pip
export PATH="$PATH:$HOME/.local/bin"

# Enable aliases to be sudo'ed
alias sudo="sudo "

# Create the directory
# -p  create all directories leading up to the given directory
# -v  display each directory that mkdir creates.
alias mkdir="mkdir -pv"

# copy file interactive
alias cp='cp -i'

# move file interactive
alias mv='mv -i'

# List all files, long format, colorized, permissions in octal
laa() {
  ls -l  "$@" | awk '
    {
      k=0;
      for (i=0;i<=8;i++)
        k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));
      if (k)
        printf("%0o ",k);
      printf(" %9s  %3s %2s %5s  %8s  %s %s %s\n", $3, $6, $7, $8, $5, $9,$10, $11);
    }'
}

alias ll="ls -l"
alias lla="ls -la"
