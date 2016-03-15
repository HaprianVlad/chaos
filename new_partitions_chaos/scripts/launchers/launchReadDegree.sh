#!/usr/bin/env sh
(($# != 3)) && echo No arguments supplied! Expect: in_degree_rmat or out_degree_rmat, number_of partitions, number_of_vertices_per_partitions && exit 1

python ../python/read_degree.py  ~/chaos_sandbox/$1/stream.0.0.0 $2 $3 >  ~/chaos_sandbox/results/$1.txt



