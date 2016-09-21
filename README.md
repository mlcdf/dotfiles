# dotfiles
> Zsh, Oh-My-Zsh, Git, Node, Atom, ...

Based on [Zach Holman](https://github.com/holman)'s [dotfiles](https://github.com/holman/dotfiles).

## Overview

- Organised around topics: `git`, `node`, ...
- `zsh/*zsh`: Any files in the `zsh` directory ending in `.zsh`get loaded into your environment.
- `**/*.symlink`: Any files (or folders) ending in `*.symlink` get symlinked into your $HOME. This is so you can keep all of those versioned in your dotfiles but still keep those autoloaded files in your home directory. These get symlinked in when you run `bootstrap.sh`.

## Install

Requires git 2.0.0+ and ZSH 5.0.0+.

Clone this repository in **~/.dotfiles**
```bash
git clone https://github.com/mlcdf/dotfiles.git ~/.dotfiles
cd dotfiles
```

Make the files executable
```bash
chmod +x install.sh
chmod +x boostrap.sh
```

Read the two scripts, comment the part you don't want, and run them

```bash
./install
./boostrap
```
