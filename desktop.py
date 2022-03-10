#
# This script is indented to be run after every changes. Therefore below commands
# should be idempotent.
#

import os
import platform
import sys
import shutil
from typing import List


if platform.system().lower() != "windows":
    print("Are you okay?")
    sys.exit(1)


def home(path: str | List) -> str:
    if isinstance(path, list):
        return os.path.join(os.environ["USERPROFILE"], *path)

    return os.path.join(os.environ["USERPROFILE"], path)


def files(path: str | List) -> str:
    if isinstance(path, list):
        return os.path.join("files", *path)

    return os.path.join("files", path)


def vim():
    shutil.copyfile(files(".vimrc"), home(".vimrc"))


def git():
    shutil.copyfile(files(".gitconfig"), home(".gitconfig"))
    shutil.copyfile(files(".gitignore"), home(".gitignore"))


def bin():
    shutil.copytree(files("bin"), home("Bin"), dirs_exist_ok=True)

    with open(
        home(
            [
                "AppData",
                "Roaming",
                "Microsoft",
                "Windows",
                "Start Menu",
                "Programs",
                "Startup",
                "Maxime.bat",
            ]
        ),
        "w",
    ) as fd:
        fd.write(
            f"""SETX /M PATH "%PATH%;{home("Bin")}"
"""
        )


def main():
    vim()
    git()
    bin()


if __name__ == "__main__":
    main()
