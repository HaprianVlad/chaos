#!/usr/bin/env bash

BASENAME="$1"

ROOT_DIR="/media/hdd"
TARGET_DIR="/media/ssd"

GROUP[64]="dco-node0[01-64]"
GROUP[32]="@dco_rack1"
GROUP[16]="@dco_block[1,2]"
GROUP[8]="@dco_block1"
GROUP[4]="dco-node00[1-4]"
GROUP[2]="dco-node00[1-2]"
GROUP[1]="dco-node002"

echo "Working with $BASENAME"

for scale in 64 32 16 8 4 2 1; do
  echo "Distributing scale $scale..."
  clush -w ${GROUP[$scale]} -l lbindsch cp $ROOT_DIR/${BASENAME}_s$scale $TARGET_DIR/.
  clush -w ${GROUP[$scale]} -l lbindsch cp $ROOT_DIR/${BASENAME}_s$scale.ini $TARGET_DIR/.
done

