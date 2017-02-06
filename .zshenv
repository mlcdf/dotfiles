#!/bin/sh

export EDITOR="vim"

# Set language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export MANPATH="$MANPATH:/usr/local/man"

export PATH="$PATH:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$PATH:$HOME/.rvm/gems/ruby-2.3.0/bin"
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:$HOME/.cargo/bin"

export GOPATH="$HOME/Code"
export GOROOT="$HOME/go"
export PATH="$PATH:$GOROOT/bin"

export RUST_SRC_PATH="$HOME/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"
