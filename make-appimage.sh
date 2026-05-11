#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(jq -r '.version' fluentflame-reader/package.json)

export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"

export ICON=$(pwd)/AppDir/icon.png
export DESKTOP=$(pwd)/AppDir/fluentflame-reader.desktop

quick-sharun ./AppDir/bin/fluentflame-reader

echo 'DESKTOPINTEGRATION=0' >> ./AppDir/.env

quick-sharun --make-appimage
quick-sharun --test ./dist/*.AppImage
