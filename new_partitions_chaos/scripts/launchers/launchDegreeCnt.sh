#!/usr/bin/env sh
((!$#)) && echo No arguments supplied. Expect graph name! && exit 1

python ../python/degree_cnt.py ~/chaos/new_partitions_chaos/data/graph/$1 > graph$1.txt
