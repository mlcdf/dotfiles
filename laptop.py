#!/usr/bin/env python3
#
# This script is indented to be run after every changes. Therefore below commands
# should be idempotent.
#

import os
import subprocess
import sys
import shutil
import argparse


if sys.platform != "linux":
    print("Are you okay?")
    sys.exit(1)

subprocess.run(
    [sys.executable, "-m", "pip", "install", "-e", "lib", "--disable-pip-version-check"], check=True
)

from suzy import files, home, rm, wget, logger, get


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

    with open(home(".bashrc"), "r", encoding="utf-8") as fd:
        content = fd.read()

        if "source ~/.maxime" not in content:
            content += "\nsource ~/.maxime"

    with open(home(".bashrc"), "w", encoding="utf-8") as fd:
        fd.write(content)


def fonts():
    rm(home(".local/share/fonts"))
    os.symlink(files("fonts"), home(".local/share/fonts"), target_is_directory=True)


def go(version: str="latest"):
    """
    Download and install the Go programming language

    Args:
    - version: specify which Go release to install (ex: go1.22.1 or 1.21.8). Defaults to latest if empty.
    """
    logger.info("go: install")

    if version == "latest":
        data = get("https://go.dev/dl/?mode=json", json=True)
        version = data[0]["version"]

        for file in data[0]["files"]:
            if "amd64" not in file["arch"] or "linux" not in file["os"]:
                continue

            release_hash = file["sha256"]
            break
    # use the provided version 
    else:
        # support with both go1.xx.y and 1.xx.y version
        if not version.startswith("go"):
            version = "go" + version
    
        releases = get("https://go.dev/dl/?mode=json&include=all", json=True)
        for release in releases:
            if release["version"] == version:

                for file in release["files"]:
                    if "amd64" not in file["arch"] or "linux" not in file["os"]:
                        continue

                    release_hash = file["sha256"]
                    break

                break
    
    # check if Go is already installed
    if shutil.which("go"):
        if version in (installed_version := subprocess.run(["go", "version"], capture_output=True).stdout.decode("utf-8").rstrip()):
            logger.info("go: found %s", installed_version.replace("go ", ""))
            return
        else:
            logger.info("go: found %s", installed_version.replace("go ", ""))

    logger.info("go: installing %s", version)

    wget(f"https://go.dev/dl/{version}.linux-amd64.tar.gz", "/tmp/go.tar.gz", release_hash)
    subprocess.run("sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz", check=True, shell=True)


def tmux():
    logger.info("tmux: configure")
    rm(home(".tmux.conf"))
    os.symlink(files(".tmux.conf"), home(".tmux.conf"))

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--go", dest='go', action='store_true')

    args = parser.parse_args()

    if args.go:
        go()
        return

    apt()
    vim()
    git()
    bin()
    ssh()
    sh()
    fonts()
    go()
    tmux()

if __name__ == "__main__":
    main()
