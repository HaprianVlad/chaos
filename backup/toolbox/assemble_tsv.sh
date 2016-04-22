#!/usr/bin/env bash

ROOT_DIR=/media/hdd

filename="$1"
scale="$2"
out="$3"

other_machine_id=$(($(hostname | sed -E 's/[^0-9]+0+([1-9]+0*)[^0-9]+/\1/') + $scale))
if [ $other_machine_id -gt 32 ]; then
  echo ""
  # other_machine_id=$(($other_machine_id + 24))
fi;

other_machine="dco-node$(printf "%03d" $other_machine_id)"

echo "Merging TSV on $(hostname) and ${other_machine}.dco.ethz.ch (cat $filename $filename > $out)..."
cat $ROOT_DIR/$filename | grep -v '^[[:space:]]*$' > $ROOT_DIR/$out && ssh $other_machine "cat $ROOT_DIR/$filename | grep -v '^[[:space:]]*$'" >> $ROOT_DIR/$out
