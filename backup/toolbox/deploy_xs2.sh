#!/usr/bin/env sh

cd && zip -r hpgp.zip hpgp

clush -w @dco_block[5-7,12-15,20] -l lbindsch "rm -rf /media/hdd/hpgp && cp ~/hpgp.zip /media/hdd/. && cd /media/hdd && unzip hpgp.zip && rm -f hpgp.zip"

clush -w @dco_block[5-7,12-15,20] -l lbindsch "rm -rf /media/hdd/helpers && cp -R ~/helpers /media/hdd/helpers"

rm -f hpgp.zip

clush -w @dco_block[5-7,12-15,20] -l lbindsch "cd /media/hdd/hpgp/branches/x-scale && make clean && make"
