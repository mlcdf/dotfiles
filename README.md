# dotfiles

Dotfiles for my Windows desktop and my Linux laptop.

I am *distro jumping* a lot and constantly switching between my two devices/OS. So I try to keep this repository
as simple as possible and ~~distro~~ OS independent.

This repository is managed using simple Python scripts.

## Usage

On the desktop:
```console
py desktop.py
```

On the laptop:
```console
python3 laptop.py
```

An `.extra` file in the `$HOME` can be use to put things that shouldn't be commited (This file will be `source` by the `.bashrc`).

## License

This project is licensed under the MIT license – see the [LICENSE](LICENSE) file for details.
