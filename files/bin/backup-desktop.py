# Performs local and remote backup of my Windows machine using restic and rclone.

import argparse
import dataclasses
import logging
import os
import shutil
import subprocess
import urllib.request
import zipfile
from typing import List, Optional

BINARIES = {
    "restic": "https://github.com/restic/restic/releases/download/v0.12.1/restic_0.12.1_windows_amd64.zip",
    "rclone": "https://github.com/rclone/rclone/releases/download/v1.57.0/rclone-v1.57.0-windows-amd64.zip",
}
BINARY_LOCATION = os.path.join(os.environ["USERPROFILE"], "Apps")
TEMP_DIR = os.path.join(os.environ["USERPROFILE"], "AppData", "Local", "Temp")


@dataclasses.dataclass
class Backup:
    src: str
    dest: str
    excludes: Optional[List[str]] = None


EXCLUDE_PATTERNS = [".DS_Store"]

# TODO: Email
LOCAL_BACKUPS = [
    Backup(
        src=r"F:\Images",
        dest=r"D:\Backups\Desktop\Images",
        excludes=["Exports", "Lightroom Catalog-3 Previews.lrdata"],
    ),
    Backup(src=r"F:\Documents", dest=r"D:\Backups\Desktop\Documents"),
]

REMOTE_BACKUPS = [
    Backup(src=r"D:\Backups\Desktop", dest="remote:desktop-restic"),
    Backup(src=r"F:\Musique", dest="remote:desktop/musique"),
    Backup(src=r"F:\Films", dest="remote:desktop/films"),
    Backup(src=r"C:\Users\max\Apple\MobileSync", dest="remote:desktop/iphone"),
]


class Executable:
    def __init__(self, name: str, force_install=False) -> None:
        self.name = name

        path = self.which(name)
        if path is None or force_install:
            path = self.install(name, BINARIES[name])
        self.path = path

        logging.info("Using %s %s", name, self.version())

    def exe(self, cmd: List, check=True, **kwargs) -> subprocess.CompletedProcess:
        cmd.insert(0, self.path)
        logging.info("%s", " ".join(cmd))
        return subprocess.run(cmd, check, **kwargs)

    def version(self) -> str:
        output = subprocess.run([self.path, "version"], check=True, capture_output=True)
        return output.stdout.decode("utf-8").split(" ")[1].replace("\n-", "")

    @staticmethod
    def install(name: str, url: str) -> str:
        urllib.request.urlretrieve(url, os.path.join(TEMP_DIR, name + ".zip"))

        with zipfile.ZipFile(os.path.join(TEMP_DIR, name + ".zip"), "r") as zip:
            binaries = [f.filename for f in zip.filelist if "exe" in f.filename]
            if len(binaries) > 1:
                raise Exception("Multiple binaries found in zip file")
            if len(binaries) > 0:
                raise Exception("No binary found in zip file")
            binary = binaries[0]

            extract_dir = os.path.join(
                os.environ["USERPROFILE"],
                "AppData",
                "Local",
                "Temp",
                "Extracted",
                name,
            )
            zip.extractall(extract_dir)

            dest = os.path.join(BINARY_LOCATION, name + ".exe")
            shutil.move(os.path.join(extract_dir, binary), dest)

        return dest

    @staticmethod
    def which(name: str) -> Optional[str]:
        path = shutil.which(name + ".exe")
        if path is None:
            return None
        else:
            logging.debug("%s executable found at %s", name, path)
            return path


def init(backup: Backup):
    """Initialize the backup repository"""
    if os.path.exists(os.path.join(backup.dest)):
        return
    logging.info("Initializing the backup repository")

    os.makedirs(os.path.join(backup.dest), exist_ok=True)

    restic.exe(
        ["init", "--repo", backup.dest],
        check=True,
        shell=True,
    )


def local_backup(backup: Backup):
    """Perform a local backup"""
    cmd = ["--repo", backup.dest, "backup", backup.src]

    for pattern in EXCLUDE_PATTERNS:
        cmd += ["--exclude", pattern]

    if backup.excludes:
        for pattern in backup.excludes:
            cmd += ["--exclude", pattern]

    restic.exe(cmd)


def check(backup: Backup):
    """Check the integrity of the local backup"""
    restic.exe(
        ["--repo", backup.dest, "check"],
        check=True,
        shell=True,
    )


def remote_backup(backup: Backup):
    """Push the local backup changes to the remote one"""
    # create the remote container if missing
    rclone.exe(
        ["mkdir", backup.dest],
        check=True,
        shell=True,
    )

    rclone.exe(
        ["sync", "-v", backup.src, backup.dest],
        check=True,
        shell=True,
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-i", "--install", help="(Re)install restic and rclone", action="store_true"
    )
    parser.add_argument(
        "-d",
        "--debug",
        help="Enable debug/verbose logging",
        action="store_const",
        const=logging.DEBUG,
        default=logging.INFO,
        dest="level",
    )

    args = parser.parse_args()

    logging.basicConfig(level=args.level, format="%(levelname)s - %(message)s")

    global restic
    restic = Executable("restic", force_install=args.install)

    global rclone
    rclone = Executable("rclone", force_install=args.install)

    if args.install:
        return

    for backup in LOCAL_BACKUPS:
        init(backup)
        local_backup(backup)
        check(backup)

    for backup in REMOTE_BACKUPS:
        remote_backup(backup)


if __name__ == "__main__":
    main()
