#!/usr/bin/env python3
# Performs a local backup of SaaS data

import argparse
import os
import subprocess
import shutil

_BACKUPS_LOCATION = os.path.expanduser("~/Backups")


def _setup():
    systemd_service = """
    [Unit]
    Backup data from SAAS softwares.

    [Service]
    ExecStart=/usr/bin/python3 ~/dotfiles/files/programs/backup-saas.py
    """

    systemd_timer = """
    [Unit]
    Description=Backup SAAS timer.

    [Timer]
    OnBootSec=2min
    OnCalendar=hourly
    AccuracySec=24h
    Persistent=true
    Unit=backup-saas.service

    [Install]
    WantedBy=default.target
    """

    os.makedirs(os.path.expanduser("~/.config/systemd/user/"), exist_ok=True)

    with open(os.path.expanduser("~/.config/systemd/user/backup-saas.service"), "w") as fd:
        fd.write(systemd_service)
    
    with open(os.path.expanduser("~/.config/systemd/user/backup-saas.timer"), "w") as fd:
        fd.write(systemd_timer)

    subprocess.run(["systemctl", "--user", "daemon-reload"], check=True)

    subprocess.run(["systemctl", "--user", "start", "backup-saas.timer"], check=True)

    subprocess.run(["systemctl", "--user", "enable", "backup-saas.timer"], check=True)

    subprocess.run(["systemctl", "--user", "list-timers"], check=True)


def _github():
    if "GITHUB_TOKEN" not in os.environ:
        print("Missing GITHUB_TOKEN in environment")
        exit(1)

    if not shutil.which("github-backup"):
        subprocess.run(
            ["python3", "-m", "pip", "install", "github-backup"],
            check=True,
        )

    subprocess.run(
        [
            "github-backup",
            "-t",
            os.environ["GITHUB_TOKEN"],
            "--starred",
            "--repositories",
            "--gists",
            "--private",
            "-o",
            os.path.join(_BACKUPS_LOCATION, "GitHub"),
            "mlcdf",
        ],
        check=True,
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--setup", action="store_true")
    args = parser.parse_args()

    if args.setup:
        _setup()
        return

    _github()


if __name__ == "__main__":
    main()
