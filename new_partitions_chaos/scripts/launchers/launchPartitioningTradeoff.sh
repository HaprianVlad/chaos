#!/usr/bin/env sh
(($# != 8)) && echo "No arguments supplied!Expect: <out degrees folder name: out_degree_rmat24> <vertex_state_size>  <edge_state_size> <size_per_partition> <result file> <number of partitions> <vertices per partition> <partitions per super partition>" && exit 1

cat ~/chaos_sandbox/$1/stream.0.* >> ~/chaos_sandbox/$1/stream.merge
pypy ../python/create_new_partitions_tradeoff.py ~/chaos_sandbox/$1/stream.merge $2 $3 $4 $5 $6 $7 $8
rm  -f ~/chaos_sandbox/$1/stream.merge


