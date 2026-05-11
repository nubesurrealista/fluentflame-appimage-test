#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(jq -r '.version' fluentflame-reader/package.json)

export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"

mkdir -p ./AppDir/bin
cp *.deb ./AppDir/

cd ./AppDir
ar x *.deb
tar xf data.tar.*
rm *.deb data.tar.* control.tar.* debian-binary

mv opt/"Fluentflame Reader"/* ./bin/
rm -rf opt

cd ..

quick-sharun ./AppDir/bin/fluentflame-reader

echo 'DESKTOPINTEGRATION=0' >> ./AppDir/.env

quick-sharun --make-appimage
quick-sharun --test ./dist/*.AppImage
