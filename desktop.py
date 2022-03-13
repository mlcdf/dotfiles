#
# This script is indented to be run after every changes. Therefore below commands
# should be idempotent.
#
from __future__ import annotations
import os
import platform
import shutil
import sys
import winreg
from typing import Any, List

if platform.system().lower() != "windows":
    print("Are you okay?")
    sys.exit(1)


class RegistryHKEY:
    def __init__(self, path) -> None:
        self.path = path

    def __enter__(self):
        self.reg = winreg.ConnectRegistry(None, winreg.HKEY_CURRENT_USER)
        self.key = winreg.OpenKey(self.reg, self.path, 0, winreg.KEY_ALL_ACCESS)
        return self

    def __exit__(self, exc_type, exc_value, exc_traceback):
        winreg.CloseKey(self.key)
        winreg.CloseKey(self.reg)

    def get(self, name: str) -> Any:
        value, _ = winreg.QueryValueEx(self.key, name)
        return value

    def set(self, name: str, value: str):
        winreg.SetValueEx(self.key, name, 0, winreg.REG_EXPAND_SZ, value)

    def append(self, name: str, value: str):
        value = self.get(name) + ";" + value
        self.set(name, value)


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

    with RegistryHKEY("Environment") as env:
        if home("Bin") not in env.get("Path"):
            env.append("Path", home("Bin"))

        if home("Apps") not in env.get("Path"):
            env.append("Path", home("Apps"))


def main():
    vim()
    git()
    bin()


if __name__ == "__main__":
    main()
