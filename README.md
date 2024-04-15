# dotfiles

Dotfiles for my Linux machines.

I am *distro jumping* a lot, so I try to keep this repository as simple as possible.

## The good stuff

- [Python!](https://xkcd.com/353/)
- `/files/bin/backup-desktop.py` and `files/bin/backup-saas.py` respectively backs up my desktop computer and personal data from SAAS/websites I use.
- `/lib` contains my personal Python library (symlinked to site-packages at install).

## Usage

After configuring the SSH keys, run:

```console
sudo apt update && sudo apt install -y git && git clone git@github.com:mlcdf/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && python3 install.py
```

An `.extra` file in the `$HOME` can be use to put things that shouldn't be commited (This file will be `source` by the `.bashrc`).

## License

This project is licensed under the MIT license – see the [LICENSE](LICENSE) file for details.
