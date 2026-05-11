#!/bin/sh

set -eu

ARCH=$(uname -m)

pacman -Syu --noconfirm \
    nodejs \
    npm \
    jq \
    binutils \
    fakeroot \
    git \
    libxcrypt-compat

get-debloated-pkgs --add-common --prefer-nano

git clone https://github.com/FluentFlame/fluentflame-reader.git
cd fluentflame-reader

npm install
npm run build
npm run package-deb

mkdir -p ../AppDir/bin
cp bin/linux/x64/*.deb ../AppDir/

cd ../AppDir
ar x *.deb
tar xf data.tar.*

mv opt/"Fluentflame Reader"/* ./bin/
cp usr/share/applications/fluentflame-reader.desktop ./
cp usr/share/icons/hicolor/512x512/apps/fluentflame-reader.png ./icon.png
cp ./icon.png ./.DirIcon

sed -i 's/Exec=Fluentflame/Exec=fluentflame-reader/g' ./fluentflame-reader.desktop
sed -i 's/Exec="Fluentflame"/Exec=fluentflame-reader/g' ./fluentflame-reader.desktop

rm -rf opt usr *.deb data.tar.* control.tar.* debian-binary
cd ..
