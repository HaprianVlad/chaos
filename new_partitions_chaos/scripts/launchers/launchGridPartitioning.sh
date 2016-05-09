#!/bin/bash


(($# != 2)) && echo "No arguments supplied! Expect: <graph> <partition file> <row partitioning>" && exit 1

rm -rf /media/ssd/grid/grid_partitions_$1
mkdir /media/ssd/grid/grid_partitions_$1
pypy ../python/grid_partitioning.py ~/chaos_sandbox/graph/$1 $2 $1 $3



