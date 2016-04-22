#!/usr/bin/env bash

ROOT_DIR="/media/hdd"
BASENAME="$1"
CUR_DIR=`dirname $0`

GROUP[64]="@dco_rack[1,3]"
GROUP[32]="@dco_rack1"
GROUP[16]="@dco_block[1,2]"
GROUP[8]="@dco_block1"
GROUP[4]="dco-node00[1-4]"
GROUP[2]="dco-node00[1-2]"
GROUP[1]="dco-node002"

clush -w ${GROUP[64]} -l lbindsch "python ${CUR_DIR}/xsc2tsv.py ${ROOT_DIR}/${BASENAME}_s64 ${ROOT_DIR}/${BASENAME}_s64.tsv"

for scale in 32 16 8 4 2 1; do
  clush -w ${GROUP[$scale]} -l lbindsch "$CUR_DIR/assemble.sh ${BASENAME}_s${scale}.tsv $scale ${BASENAME}_s$(($scale / 2)).tsv
done
