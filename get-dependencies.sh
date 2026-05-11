#!/bin/sh

set -eu

ARCH=$(uname -m)

pacman -Syu --noconfirm \
    nodejs \
    npm \
    jq \
    binutils \
    fakeroot \
    git

get-debloated-pkgs --add-common --prefer-nano

git clone https://github.com/FluentFlame/fluentflame-reader.git
cd fluentflame-reader

npm install
npm run build
npm run package-deb

mv dist/*.deb ..
cd ..
