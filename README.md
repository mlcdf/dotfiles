# dotfiles

I am *distro jumping* too much and this makes maintaining a do-everything dotfiles repo a pain. So I try to keep this repository
as simple as possible and distro independent.

This repository is managed using `stow`, most directories only containing stuff that will be symlinked from `$HOME`. The few exceptions are:
- `/backup`: scripts to backup my data
- `/homelab`: used to deploy my modest homelab
- `/snippets`: just code snippets

## Usage

```sh
./install.sh
```

An `.extra` file in the `$HOME` can be use to put things that shouldn't be commited (This file will be `source` by the `.bashrc`).

## License

This project is licensed under the MIT license – see the [LICENSE](LICENSE) file for details.
