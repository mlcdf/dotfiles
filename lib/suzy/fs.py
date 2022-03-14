from __future__ import annotations
import os
import sys

__all__ = ["home", "files", "rm"]


def home(path: str | list) -> str:
    if sys.platform == "win32":
        _home = os.environ["USERPROFILE"]
    elif sys.platform == "linux":
        _home = os.environ["HOME"]
    else:
        raise NotImplementedError("platform %s", sys.platform)
    if isinstance(path, list):
        return os.path.join(_home, *path)

    return os.path.join(_home, path)


def files(path: str | list) -> str:
    if isinstance(path, list):
        return os.path.join(os.getcwd(), "files", *path)

    return os.path.join(os.getcwd(), "files", path)


def rm(path: str):
    try:
        os.remove(path)
    except FileNotFoundError:
        pass
