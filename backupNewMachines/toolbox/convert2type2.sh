#!/usr/bin/env bash

ROOT_DIR="/media/hdd"
BASENAME="$1"

GROUP[64]="@dco_rack[1,3]"
GROUP[32]="@dco_rack1"
GROUP[16]="@dco_block[1,2]"
GROUP[8]="@dco_block1"
GROUP[4]="dco-node00[1-4]"
GROUP[2]="dco-node00[1-2]"
GROUP[1]="dco-node002"

for scale in 64 32 16 8 4 2 1; do
  clush -w ${GROUP[${scale}]} -l root "mv ${ROOT_DIR}/${BASENAME}_s${scale} ${ROOT_DIR}/${BASENAME}_s${scale}_tmp && python ${ROOT_DIR}/toolbox/xsc2type2.py ${ROOT_DIR}/${BASENAME}_s${scale}_tmp ${ROOT_DIR}/${BASENAME}_s${scale} && rm -f ${ROOT_DIR}/${BASENAME}_s${scale}_tmp"
done
