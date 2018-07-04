#!/usr/bin/env bash
BUILD_DIR=`mktemp --tmpdir --directory tltk-build-debian.XXXX`
BUILD_VER="0.1-1"
CURRENT_DIR=`pwd`

mkdir $BUILD_DIR/{DEBIAN/,usr/,usr/bin/}

touch $BUILD_DIR/DEBIAN/{changelog,control}

cat <<EOF >>$BUILD_DIR/DEBIAN/changelog
tltk ($BUILD_VER) stable; urgency=low

 * First version.

-- Patrick Wu <wotingwu@live.com>  Wed, 04 Jul 2018 12:00:00 +0800

EOF

cat <<EOF >>$BUILD_DIR/DEBIAN/control
Package: tltk
Architecture: all
Maintainer: Patrick Wu <wotingwu@live.com>
Depends: python3
Priority: optional
Version: $BUILD_VER
Description: Tiny Little ToolKit
 This is a small collection of utilities by me using python3. 
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
