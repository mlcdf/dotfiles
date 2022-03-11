#!/usr/bin/env python3
# Performs a local backup of SaaS data

import argparse
import json
import os
import subprocess
import platform
import urllib.request

BACKUPS_LOCATION = os.path.expanduser("~/Backups")
BINARIES_LOCATION = os.path.expanduser("~/.local/bin")


def arch() -> str:
    if platform.machine() == "x86_64":
        return "amd64"

    if "arm" in platform.machine():
        if "64" in platform.architecture()[0]:
            return "arm64"
        else:
            return "arm"


def system() -> str:
    return platform.system().lower()


def install():
    subprocess.run(["python3", "-m", "pip", "install", "github-backup"], shell=True, check=True)

    with urllib.request.urlopen(
        "https://api.github.com/repos/mlcdf/sc-backup/releases/latest"
    ) as response:
        release = json.load(response)

    for asset in release["assets"]:
        if f"{system()}-{arch()}" in asset["name"]:
            url = asset["browser_download_url"]

    urllib.request.urlretrieve(url, os.path.join(BINARIES_LOCATION, "sc-backup"))


def github():
    if "GITHUB_TOKEN" not in os.environ:
        print("Missing GITHUB_TOKEN in environment")
        exit(1)

    subprocess.run(
        [
            "github-backup",
            "mlcdf",
            "-t",
            os.environ["GITHUB_TOKEN"],
            "--starred",
            "--repositories",
            "--gists",
            "--private",
            "-o",
            os.path.join(BACKUPS_LOCATION, "GitHub"),
        ],
        shell=True,
        check=True,
    )


def senscritique():
    subprocess.run(["sc-backup", "--collection", "mlcdf"], shell=True, check=True)
    subprocess.run(
        [
            "sc-backup",
            "--list",
            "https://www.senscritique.com/liste/Vu_au_cinema/363578",
            "-o",
            os.path.join(BACKUPS_LOCATION, "SensCritique"),
        ],
        shell=True,
        check=True,
    )


def pinboard():
    if "PINBOARD_TOKEN" not in os.environ:
        print("Missing PINBOARD_TOKEN in environment")
        exit(1)

    os.makedirs(os.path.join(BACKUPS_LOCATION, "Pinboard"), exist_ok=True)
    urllib.request.urlretrieve(
        f"https://api.pinboard.in/v1/posts/all?format=json&auth_token={os.environ['PINBOARD_TOKEN']}",
        os.path.join(BACKUPS_LOCATION, "Pinboard", "posts.json"),
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--install", action="store_true", help="install prerequisites")
    parser.add_argument("--github", action="store_true", help="backup GitHub")
    parser.add_argument("--senscritique", action="store_true", help="backup SensCritique")
    parser.add_argument("--pinboard", action="store_true", help="backup Pinboard")

    args = parser.parse_args()

    if args.install:
        install()
        return

    if not args.github and not args.senscritique and not args.pinboard:
        github()
        senscritique()
        pinboard()
        return

    if args.github:
        github()

    if args.senscritique:
        senscritique()

    if args.pinboard:
        pinboard()


if __name__ == "__main__":
    main()
