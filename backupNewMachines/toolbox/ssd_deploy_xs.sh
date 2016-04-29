#!/usr/bin/env sh

cd && zip -r hpgp.zip hpgp

clush -w @dco_rack[1,3] -l lbindsch "rm -rf /media/ssd/hpgp && cp ~/hpgp.zip /media/ssd/. && cd /media/ssd && unzip hpgp.zip && rm -f hpgp.zip"

clush -w @dco_rack[1,3] -l lbindsch "rm -rf /media/ssd/helpers && cp -R ~/helpers2 /media/ssd/helpers"

rm -f hpgp.zip

clush -w @dco_rack[1,3] -l lbindsch "cd /media/ssd/hpgp/branches/x-scale && make clean && make"
