#! /usr/bin/env bash
set -e

if [[ -z "$PINBOARD_TOKEN" ]]; then
    echo "Must provide PINBOARD_TOKEN in environment" 1>&2
    exit
fi

mkdir -p pinboard-backup
curl "https://api.pinboard.in/v1/posts/all?format=json&auth_token=${PINBOARD_TOKEN}" > pinboard-backup/links.json
