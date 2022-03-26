#!/usr/bin/env python3
#
# This script is indented to be run after every changes. Therefore below commands
# should be idempotent.
#

import os
import subprocess
import sys
import shutil


if sys.platform != "linux":
    print("Are you okay?")
    sys.exit(1)

subprocess.run(
    [sys.executable, "-m", "pip", "install", "-e", "lib", "--disable-pip-version-check"], check=True
)

from suzy import files, home, rm, wget, logger


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
    rm(home([".ssh", "config"]))
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


def go():
    GO_VERSION = "go1.18"

    if shutil.which("go"):
        logger.info("go installation found")
        if GO_VERSION in (go_version := subprocess.run(["go", "version"], capture_output=True).stdout.decode("utf-8")):
            logger.info(go_version)
            return

    logger.info("installing %s", GO_VERSION)

    wget(f"https://go.dev/dl/{GO_VERSION}.linux-amd64.tar.gz", "/tmp/go.tar.gz", "e85278e98f57cdb150fe8409e6e5df5343ecb13cebf03a5d5ff12bd55a80264f")
    subprocess.run("sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz", check=True, shell=True)

def main():
    apt()
    vim()
    git()
    bin()
    ssh()
    sh()
    fonts()
    go()

if __name__ == "__main__":
    main()
