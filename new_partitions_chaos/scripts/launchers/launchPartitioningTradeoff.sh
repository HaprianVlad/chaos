#!/usr/bin/env sh
(($# != 10)) && echo "No arguments supplied!Expect: <out degrees folder name: out_degree_rmat24> <vertex_state_size>  <edge_state_size> <scale> <alpha> <undirected> <number of partitions> <result file> <number of partitions> <vertices per partition> " && exit 1

cat /media/ssd/degrees/$1/stream.0.* >> /media/ssd/degrees/$1/stream.merge
pypy ../python/create_new_partitions_tradeoff.py /media/ssd/degrees/$1/stream.merge $2 $3 $4 $5 $6 $7 $8 $9 ${10}
rm  -f /media/ssd/degrees/$1/stream.merge


