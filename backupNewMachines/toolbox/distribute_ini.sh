#!/usr/bin/env bash

DIR=tmp

mkdir -p $DIR

GROUP[64]="dco-node0[01-64]"
GROUP[32]="@dco_rack1"
GROUP[16]="@dco_block[1,2]"
GROUP[8]="@dco_block1"
GROUP[4]="dco-node00[1-4]"
GROUP[2]="dco-node00[1-2]"
GROUP[1]="dco-node002"

for s in 64 32 16 8 4 2 1; do
cat << EOF > $DIR/sk-2005_s$s.ini
[graph]
type=2
name=sk-2005_s$s
vertices=50636154
edges=1949412601
EOF
cat << EOF > $DIR/sk-2005-und_s$s.ini
[graph]
type=2
name=sk-2005-und_s$s
vertices=50636154
edges=3898825202
EOF
cat << EOF > $DIR/twitter_rv_s$s.ini
[graph]
type=2
name=twitter_rv_s$s
vertices=61578414
edges=1468365182
EOF
cat << EOF > $DIR/twitter_rv-und_s$s.ini
[graph]
type=2
name=twitter_rv-und_s$s
vertices=61578414
edges=2936730364
EOF

clush -w ${GROUP[$s]} -l lbindsch "cp $DIR/*_s$s.ini /media/hdd/."
done


