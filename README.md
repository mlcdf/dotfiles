# dotfiles

I am *distro jumping* too much and this makes maintaining a do-everything dotfiles repo a pain. So I try to keep this repository
as simple as possible and distro independent.

This repository is manage using `stow`, most directories only containing stuff that will be symlinked. The few exceptions are:
- `/backup`: scripts to backup my data
- `/homelab`: used to deploy my modest homelab

## Usage

```sh
./install.sh
```

Use a `.extra` file in your `$HOME` to put things you don't want to commit

## License

This project is licensed under the MIT license – see the [LICENSE](LICENSE) file for details.
