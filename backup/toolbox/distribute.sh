#!/usr/bin/env bash

BASENAME="$1"
N_VERTICES="$2"
N_EDGES="$3"

echo "Working with $BASENAME"

for scale in 64 32 16 8 4 2; do
  echo "Splitting $BASENAME in $scale parts..."
  `dirname $0`/split_file.sh $scale ${BASENAME}
  echo "Distributing parts..."
  for i in `seq 1 $scale`; do
  	if [ $i -gt 32 ]; then
  		id=$(($i + 24));
  	else
  		id=$i;
  	fi;
  	echo "Distributing ${BASENAME}_$(printf "%02d" $(($i - 1))) to dco-node"$(printf "%03d" $id)
    	scp ${BASENAME}_$(printf "%02d" $(($i - 1))) dco-node$(printf "%03d" $id):/media/hdd/${BASENAME}_s${scale}

    	echo "Distributing ${BASENAME}_${scale}_$(printf "%02d" $(($i - 1))).ini..."
	ssh dco-node$(printf "%03d" $id) "cat << EOF > /media/hdd/${BASENAME}_s${scale}.ini
[graph]
type=1
name=${BASENAME}_s${scale}
vertices=${N_VERTICES}
edges=${N_EDGES}
EOF"
  done
  echo "Removing temp files..."
  rm -f ${BASENAME}_*
done

