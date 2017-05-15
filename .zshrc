#!/bin/zsh

source ~/Apps/antigen/antigen.zsh

# Load the oh-my-zsh's library
antigen use oh-my-zsh

# Bundles from the default repo (oh-my-zsh)
antigen bundle git

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle rupa/z

antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure

antigen apply

# Load our dotfiles like ~/.bash_prompt, etc…
#   ~/.extra can be used for settings you don’t want to commit,
#   Use it to configure your PATH, thus it being first in line.
for file in ~/.{extra,aliases,functions}; do
    [ -r "$file" ] && source "$file"
done
unset file

source ~/.rvm/scripts/rvm

# zsh-autosuggestions color
# needs to be exported here otherwise, it is overridden
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=black,bold"
