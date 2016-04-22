#!/usr/bin/env bash

ROOT_DIR=/media/hdd

filename="$1"
scale="$2"
out="$3"

other_machine_id=$(echo "$(hostname | sed -E 's/[^0-9]+([0-9]+)[^0-9]+/\1/') + $scale" | bc -l)

other_machine="dco-node$(printf "%03d" $other_machine_id)"

echo "Merging file on $(hostname) and ${other_machine}.dco.ethz.ch (cat $filename $filename > $out)..."
cat $ROOT_DIR/$filename > $ROOT_DIR/$out && ssh $other_machine "cat $ROOT_DIR/$filename" >> $ROOT_DIR/$out
