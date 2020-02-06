#!/bin/sh

export EDITOR="vim"

setopt HIST_IGNORE_SPACE

# Set language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PATH="$PATH:/usr/bin:/bin:/usr/sbin:/sbin"

# Nodejs
export NPM_PACKAGES="/home/max/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules${NODE_PATH:+:$NODE_PATH}"
export PATH="$PATH:$NPM_PACKAGES/bin"
export PATH="$PATH:$HOME/.config/yarn/global/node_modules/.bin/"

export MANPATH="$MANPATH:/usr/local/man"
export MANPATH="$MANPATH:$NPM_PACKAGES/share/man"



# Python / Pip
export PATH="$PATH:$HOME/.local/bin"


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


# Manage the clipboard via xsel
cb() {
  if [ -z "$1" ]; then
    xsel --clipboard --output
  else
    echo "$1" | xsel --clipboard --input
  fi
}

# Download .gitignore files
gi() {
  curl -L -s "https://www.gitignore.io/api/$@" | tail -n +5 | head -n -2
}


# find shorthand
f() {
  find . -name "$1" 2>&1 | grep -v 'Permission denied'
}

# List all files, long format, colorized, permissions in octal
laa(){
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
