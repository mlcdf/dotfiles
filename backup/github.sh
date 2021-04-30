#! /usr/bin/env bash
set -e

if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "Must provide GITHUB_TOKEN in environment" 1>&2
    exit
fi

python3 -V
python3 -m pip install github-backup
github-backup mlcdf -t $GITHUB_TOKEN --starred --repositories --gists  --private -o github-backup
