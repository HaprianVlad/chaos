#!/usr/bin/env sh
((!$#)) && echo No arguments supplied!Expect graph name: rmat24 && exit 1
python ../python/test_degree.py ~/chaos/new_partitions_chaos/data/graph/$1 ~/chaos/new_partitions_chaos/out_degree/stream.0.0.0 ~/chaos/new_partitions_chaos/data/in_degree/stream.0.0.0 > testTesults.txt
