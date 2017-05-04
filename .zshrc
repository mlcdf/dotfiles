#!/bin/zsh

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="pure"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
    cp # use cpv to copy files using rsync
    git # tons of aliases
    ubuntu # tons of aliases
    zsh-syntax-highlighting # syntax highlighting in the terminal
)

# Load our dotfiles like ~/.bash_prompt, etc…
#   ~/.extra can be used for settings you don’t want to commit,
#   Use it to configure your PATH, thus it being first in line.
for file in ~/.{extra,aliases,functions}; do
    [ -r "$file" ] && source "$file"
done
unset file

fpath+=~/.zfunc

# Load rvm, z & oh-my-zsh
source $ZSH/oh-my-zsh.sh
source ~/.rvm/scripts/rvm
source ~/.oh-my-zsh/plugins/z/z.sh

# Alias hub as git
eval "$(hub alias -s)"

# Initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit
