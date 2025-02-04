#!/usr/bin/env bash

set -e

RELEASE_TYPE=${RELEASE_TYPE:-"minor"}

cd tile/

# get next semversion
LATEST_VERSION=$(tail -n1 tile-history.yml | awk '{print $2}')
SPLIT_VERSION=${LATEST_VERSION//./ }

major=${SPLIT_VERSION[0]}
minor=${SPLIT_VERSION[1]}
patch=${SPLIT_VERSION[2]}

if [ "$RELEASE_TYPE" == "major" ]; then
    major=$(expr $major + 1)
    minor="0"
    patch="0"
elif [ "$RELEASE_TYPE" == "minor" ]; then
    minor=$(expr $minor + 1)
    patch="0"
elif [ "$RELEASE_TYPE" == "patch" ]; then
    patch=$(expr $patch + 1)
else
    echo "you must specify a valid RELEASE_TYPE. (major, minor, patch)"
    exit 1
fi

VERSION=${VERSION:-"$major.$minor.$patch"}

# install tile-generator
curl -L "https://github.com/cf-platform-eng/tile-generator/releases/download/v14.0.5/tile_linux-64bit" -o tile_linux-64bit
chmod +x tile_linux-64bit
mv tile_linux-64bit /usr/local/bin/tile

# build product file
tile build $VERSION
