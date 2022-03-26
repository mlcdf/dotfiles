import urllib.request
import hashlib

from .fs import *
from .log import *

__all__ = ["wget"]

def _hash_file(filename: str, blocksize: int = 4096) -> str:
    hsh = hashlib.sha256()
    with open(filename, "rb") as f:
        while True:
            buf = f.read(blocksize)
            if not buf:
                break
            hsh.update(buf)
    return hsh.hexdigest()

def wget(url: str, dest: str, sha256: str = "") -> None:
    urllib.request.urlretrieve(url, dest)

    if not sha256:
        return
    
    hash = _hash_file(dest)
    if hash != sha256:
        raise Exception("the file hash does not match the provided hash")