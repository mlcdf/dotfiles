#!/bin/sh

export EDITOR="vim"

setopt HIST_IGNORE_SPACE

# Set language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export MANPATH="$MANPATH:/usr/local/man"
export MANPATH="$MANPATH:$NPM_PACKAGES/share/man"

export PATH="$PATH:/usr/bin:/bin:/usr/sbin:/sbin"

# Nodejs
export NPM_PACKAGES="/home/max/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules${NODE_PATH:+:$NODE_PATH}"
export PATH="$PATH:$NPM_PACKAGES/bin"
export PATH="$PATH:$HOME/.config/yarn/global/node_modules/.bin/"

unset MANPATH  # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# Ruby
export PATH="$PATH:$HOME/.rvm/gems/ruby-2.3.0/bin"
export PATH="$PATH:$HOME/.rvm/bin"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.cargo/env"
export RUST_SRC_PATH="$HOME/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"

# Go
export GOPATH="$HOME/Code/go"
export GOROOT="/usr/local/go"
export PATH="$PATH:$GOROOT/bin"
export PATH="$PATH:$GOPATH/bin"
