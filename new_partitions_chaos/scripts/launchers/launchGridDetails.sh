#!/bin/bash


(($# != 2)) && echo "No arguments supplied! Expect: <graph> <partition file>" && exit 1

pypy ../python/grid_partitioning_details.py /media/ssd/generated_graphs/$1 $2 



