#!/usr/bin/env bash

ROOT_DIR="/media/hdd"
BASENAME="$1"
CUR_DIR=`dirname $0`

GROUP[64]="dco-node0[01-64]"
GROUP[32]="dco-node[089-120]"
GROUP[16]="dco-node[089-104]"
GROUP[8]="dco-node0[89-96]"
GROUP[4]="dco-node0[89-92]"
GROUP[2]="dco-node0[89-90]"
GROUP[1]="dco-node089"

for scale in 32 16 8 4; do
  clush -w ${GROUP[$(($scale / 2))]} -l lbindsch "$CUR_DIR/assemble.sh ${BASENAME}_s${scale} $(($scale / 2)) ${BASENAME}_s$(($scale / 2))"
  #clush -w ${GROUP[$(($scale / 2))]} -l lbindsch "$CUR_DIR/assemble_tsv.sh ${BASENAME}_s${scale}.tsv $(($scale / 2)) ${BASENAME}_s$(($scale / 2)).tsv"
done
