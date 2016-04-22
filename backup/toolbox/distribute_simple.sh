#!/usr/bin/env bash

BASENAME="$1"
scale="$2"

echo "Working with $BASENAME"

for i in `seq 1 $scale`; do
#  if [ $i -gt 32 ]; then
#	id=$i;
  	id=$(($i + 88));
#  else
#  	id=$i;
#  fi;
  echo "Distributing ${BASENAME}_$(printf "%02d" $(($i - 1))) to dco-node"$(printf "%03d" $id)
  scp ${BASENAME}_$(printf "%02d" $(($i - 1))) dco-node$(printf "%03d" $id):/media/hdd/${BASENAME}_s${scale}
  #echo "Distributing ${BASENAME}_s64_$(($i - 1)) to dco-node"$(printf "%03d" $id)
  #scp ${BASENAME}_s64_$(($i - 1)) dco-node$(printf "%03d" $id):/media/hdd/${BASENAME}_s${scale}
done
