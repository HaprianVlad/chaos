#!/usr/bin/env bash

GROUP=$1
DISK=$2
FILE=$3
N=$4

for i in `seq 0 $N`; do
  echo "Loop $i..."
  clush -w $GROUP "cat $FILE >> $DISK/fill"
done

