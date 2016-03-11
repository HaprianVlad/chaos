#!/usr/bin/env sh
((!$#)) && echo No arguments supplied! Expect in or out && exit 1

python ../python/create_new_partitions.py  ~/chaos/tests_chaos/data/out_degree_rmat4/stream.0.0.0 10 10



