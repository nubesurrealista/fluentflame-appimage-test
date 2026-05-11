#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(jq -r '.version' fluentflame-reader/package.json)

export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"

mkdir -p ./AppDir/bin ./extract_deb
cp *.deb ./extract_deb/

cd ./extract_deb
ar x *.deb
tar xf data.tar.*

export ICON=$(pwd)/usr/share/icons/hicolor/512x512/apps/fluentflame-reader.png
export DESKTOP=$(pwd)/usr/share/applications/fluentflame-reader.desktop

mv opt/"Fluentflame Reader"/* ../AppDir/bin/

cd ..
rm -rf ./extract_deb

quick-sharun ./AppDir/bin/fluentflame-reader

echo 'DESKTOPINTEGRATION=0' >> ./AppDir/.env

quick-sharun --make-appimage
quick-sharun --test ./dist/*.AppImage
