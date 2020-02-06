#!/bin/zsh

source ~/.local/bin/antigen.zsh

# Load the oh-my-zsh's library
# antigen use oh-my-zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

antigen bundle rupa/z
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure

antigen apply

# Use .extra to put things you don't want to commit
if [ -r .extra ]; then
  source .extra
fi

# zsh-autosuggestions color
# needs to be exported here otherwise, it is overridden
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=black,bold"
