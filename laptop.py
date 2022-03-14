#!/usr/bin/env python3
#
# This script is indented to be run after every changes. Therefore below commands
# should be idempotent.
#

import os
import subprocess
import sys

from suzy import files, home, rm

if sys.platform != "linux":
    print("Are you okay?")
    sys.exit(1)


subprocess.run(
    [sys.executable, "-m", "pip", "install", "-e", "lib", "--disable-pip-version-check"], check=True
)


def apt():
    subprocess.run(
        [
            "sudo",
            "-S",
            "apt",
            "install",
            "-y",
            "curl",
            "tree",
            "htop",
            "vim",
            "keepassxc",
            "python3-pip",
            "software-properties-common",
            "inxi",
            "nmap",
        ],
        check=True,
    )

    subprocess.run(
        [
            "sudo",
            "-S",
            "apt",
            "autoremove",
            "-y",
        ],
        check=True,
    )


def vim():
    rm(home(".vimrc"))
    os.symlink(files(".vimrc"), home(".vimrc"))


def git():
    rm(home(".gitconfig"))
    os.symlink(files(".gitconfig"), home(".gitconfig"))

    rm(home(".gitignore"))
    os.symlink(files(".gitignore"), home(".gitignore"))


def bin():
    rm(home("Bin"))
    os.symlink(files("bin"), home("Bin"), target_is_directory=True)


def ssh():
    os.makedirs(home(".ssh"), exist_ok=True)
    os.symlink(files("ssh_config"), home([".ssh", "config"]))


def sh():
    rm(home(".maxime"))
    os.symlink(files(".maxime"), home(".maxime"))

    with open(home(".bashrc")) as fd:
        content = fd.read()

    if "source ~/.maxime" in content:
        content += "\nsource ~/.maxime"


def fonts():
    rm(home(".local/share/fonts"))
    os.symlink(files("fonts"), home(".local/share/fonts"), target_is_directory=True)


def main():
    apt()
    vim()
    git()
    bin()
    ssh()
    sh()
    fonts()


if __name__ == "__main__":
    main()
