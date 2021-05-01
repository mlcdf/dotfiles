# dotfiles

I am *distro jumping* too much and this makes maintaining a do-everything dotfiles repo a pain. So I now try keep this repository
as simple as possible and distro independent.

## Prerequisites

- [Git >= 2](https://git-scm.com/)

## Install

Clone this repository in **~/.dotfiles**
```bash
git clone https://github.com/mlcdf/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

## Usage

Install softwares
```console
./install.sh
```

Symlink files
```console
./link.sh
```

Use a `.extra` file in your `$HOME` to put things you don't want to commit

## License

This project is licensed under the MIT license – see the [LICENSE](LICENSE) file for details.
