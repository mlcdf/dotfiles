# Performs local and remote backup of my Windows machine using restic and rclone.

import argparse
import dataclasses
import os
import shutil
import subprocess
import logging
import urllib.request
import zipfile


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


# TODO : Musique, Films, Email, Phone
LOCAL_BACKUPS = [
    # Backup(src="F:\Images", dest="D:\Backups\Desktop\Images"),
    Backup(src="F:\Documents", dest="D:\Backups\Desktop\Documents"),
]

REMOTE_BACKUPS = [
    Backup(src="D:\Backups\Desktop", dest="remote:desktop"),
]


def install():
    for name, url in BINARIES.items():
        urllib.request.urlretrieve(url, os.path.join(TEMP_DIR, name + ".zip"))

        with zipfile.ZipFile(os.path.join(TEMP_DIR, name + ".zip"), "r") as zip:
            binary = [f.filename for f in zip.filelist if "exe" in f.filename]
            if len(binary) > 1:
                raise Exception("Multiple binaries found in zip file")
            if len(binary) > 0:
                raise Exception("No binary found in zip file")
            binary = binary[0]

            extract_dir = os.path.join(
                os.environ["USERPROFILE"],
                "AppData",
                "Local",
                "Temp",
                "Extracted",
                name,
            )

            zip.extractall(extract_dir)

            shutil.move(
                os.path.join(extract_dir, binary),
                os.path.join(BINARY_LOCATION, name + ".exe"),
            )


def init(backup: Backup):
    """Initialize the backup repository"""
    if os.path.exists(os.path.join(backup.dest)):
        return

    os.makedirs(os.path.join(backup.dest), exist_ok=True)

    subprocess.run(
        [restic, "init", "--repo", backup.dest],
        check=True,
        shell=True,
    )


def local_backup(backup: Backup):
    """Perform a local backup"""
    subprocess.run(
        [restic, "--repo", backup.dest, "backup", backup.src],
        check=True,
        shell=True,
    )


def check(backup: Backup):
    """Check the integrity of the local backup"""
    subprocess.run(
        [restic, "--repo", backup.dest, "check"],
        check=True,
        shell=True,
    )


def remote_backup(backup: Backup):
    """Push the local backup changes to the remote one"""
    subprocess.run(
        [rclone, "sync", backup.src, backup.dest],
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
    restic = shutil.which("restic.exe")
    logging.debug("restic executable found at %s", restic)

    global rclone
    rclone = shutil.which("rclone.exe")
    logging.debug("rclone executable found at %s", rclone)

    if args.install:
        install()
        return

    for backup in LOCAL_BACKUPS:
        init(backup)
        local_backup(backup)
        check(backup)

    for backup in REMOTE_BACKUPS:
        remote_backup(backup)


if __name__ == "__main__":
    main()
