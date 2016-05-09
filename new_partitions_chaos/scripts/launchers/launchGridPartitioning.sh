#!/bin/bash


(($# != 2)) && echo "No arguments supplied! Expect: <graph> <partition file> <row partitioning>" && exit 1

if [ $3 -eq 1 ]; then
  name="row"
else
  name="column"
fi 
rm -rf /media/ssd/grid/grid_partitions_$1_$name
mkdir /media/ssd/grid/grid_partitions_$1_$name
pypy ../python/grid_partitioning.py ~/chaos_sandbox/graph/$1 $2 $1 $3



