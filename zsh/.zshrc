#!/bin/zsh

# Fixes escape issues
bindkey -e

source ~/.local/bin/antigen.zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

antigen bundle rupa/z

antigen apply

# Use .extra to put things you don't want to commit
if [ -r .extra ]; then
  source .extra
fi

# zsh-autosuggestions color
# needs to be exported here otherwise, it is overridden
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=black,bold"


fpath+=("$HOME/.npm-packages/lib/node_modules/pure-prompt/functions")

autoload -U promptinit; promptinit
prompt pure
