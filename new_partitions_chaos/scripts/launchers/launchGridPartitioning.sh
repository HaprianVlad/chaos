#!/bin/bash


(($# != 3)) && echo "No arguments supplied! Expect: <graph> <partition file> <output name>" && exit 1

rm -rf grid_partitioning_$1
mkdir grid_partitioning_$1
pypy ../python/grid_partitioning.py ~/chaos_sandbox/graph/$1 $2 >> grid_partitioning_$1/$3



