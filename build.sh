#!/usr/bin/env bash
BUILD_DIR=`mktemp --tmpdir --directory tltk-build-debian.XXXX`
BUILD_VER="0.7-0"
CURRENT_DIR=`pwd`

mkdir $BUILD_DIR/{DEBIAN/,usr/,usr/bin/}

touch $BUILD_DIR/DEBIAN/control

cat <<EOF >>$BUILD_DIR/DEBIAN/control
Package: tltk
Architecture: all
Maintainer: Patrick Wu <wotingwu@live.com>
Depends: python3, python3-requests, python3-gi, python3-pip, python3-six
Priority: optional
Version: $BUILD_VER
Description: Tiny Little ToolKit
 This is a small collection of utilities by Patrick Wu using Python3. 
EOF

cp src/* $BUILD_DIR/usr/bin/

cd $BUILD_DIR
find . -type f ! -regex '.*.hg.*' ! -regex '.*?debian-binary.*' ! -regex '.*?DEBIAN.*' -printf '%P ' | xargs md5sum > DEBIAN/md5sums

find $BUILD_DIR -type d -exec chmod 0755 {} \;
find $BUILD_DIR/usr/bin/ -type f -exec chmod 0555 {} \;

[ -d $CURRENT_DIR/target ] || mkdir $CURRENT_DIR/target
cd $CURRENT_DIR/target/

sudo dpkg -b $BUILD_DIR/ tltk-${BUILD_VER}.deb

rm -rf $BUILD_DIR
cd $CURRENT_DIR
