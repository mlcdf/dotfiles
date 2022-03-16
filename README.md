# dotfiles

Dotfiles for my Windows desktop and my Linux laptop.

I am *distro jumping* a lot and constantly switching between my two devices/OS. So I try to keep this repository
as simple as possible and distro/OS independent.

## The good stuff

- it's only some simple Python scripts (obligatory relevant xkcd: [#353](https://xkcd.com/353/))
- `/files/bin/backup-desktop.py` and `files/bin/backup-saas.py` respectively backs up my desktop computer and personal data from SAAS/websites I use.
- `/lib` contains my personal Python library (symlinked to site-packages at install).

## Usage

On the desktop:
```console
# requires Python 3.10+
py desktop.py
```

On the laptop:
```console
# requires Python 3.8+
python3 laptop.py
```

An `.extra` file in the `$HOME` can be use to put things that shouldn't be commited (This file will be `source` by the `.bashrc`).

## License

This project is licensed under the MIT license – see the [LICENSE](LICENSE) file for details.
