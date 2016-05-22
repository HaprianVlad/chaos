#!/bin/bash


(($# != 3)) && echo "No arguments supplied! Expect: <graph> <partition file> <row partitioning>" && exit 1

if [ $3 -eq 1 ]; then
  name="row"
else
  name="column"
fi 
rm -rf /media/ssd/grid/grid_partitions_$1_$name
mkdir /media/ssd/grid/grid_partitions_$1_$name
pypy ../python/grid_partitioning.py /media/hdd/generated_graphs/$1 $2 $1 $3



