#!/usr/bin/env sh

GROUP="dco-node[001-032]"

for ROOT_DIR in "/media/ssd" "/media/hdd"; do

cd && zip -r hpgp.zip hpgp

clush -w $GROUP -l lbindsch "rm -rf $ROOT_DIR/hpgp && cp ~/hpgp.zip $ROOT_DIR/. && cd $ROOT_DIR && unzip hpgp.zip && rm -f hpgp.zip"

clush -w $GROUP -l lbindsch "rm -rf $ROOT_DIR/helpers && cp -R ~/helpers $ROOT_DIR/helpers"

rm -f hpgp.zip

clush -w $GROUP -l lbindsch "cd $ROOT_DIR/hpgp/branches/slipstream && make clean && make"

done
