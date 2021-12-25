#!/usr/bin/env python3

"""
Transform AdobeRGB images into SRGB images using imagemagick.

It requires the following packages:
- icc-profiles
- imagemagick
"""

import argparse
import logging
import os
import subprocess
import sys
import dataclasses

logging.basicConfig(level=logging.INFO)

DEFAULT_DEST = "/tmp/convert"


@dataclasses.dataclass(repr=True)
class Image:
    path: str
    dest: str
    basename: str

    def __init__(self, path: str, output: str) -> None:
        self.path = path
        self.dest = os.path.join(output, os.path.basename(path))
        self.basename = os.path.basename(path)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("source", help="source directory", metavar="SOURCE")
    parser.add_argument(
        "-d",
        "--dest",
        help=f"destination directory. Defaults to {DEFAULT_DEST}.",
        metavar="DEST",
        default=DEFAULT_DEST,
    )

    if len(sys.argv) == 1:
        parser.print_help()
        parser.exit()

    args = parser.parse_args()

    try:
        os.makedirs(args.dest)
    except FileExistsError:
        logging.debug("File already exists, ignoring this error", exc_info=True)

    for file in os.listdir(args.source):
        path = os.path.join(args.source, file)
        if os.path.isfile(path):
            image = Image(path, args.dest)
            convert_file(image)


def convert_file(image: Image):
    logging.info("Converting %s -> %s", image.basename, image.dest)
    result = subprocess.run(
        f"convert '{image.path}' -profile /usr/share/color/icc/AdobeRGB1998.icc -profile /usr/share/color/icc/sRGB.icc '{image.dest}'",
        shell=True,
    )
    result.check_returncode()


if __name__ == "__main__":
    main()
