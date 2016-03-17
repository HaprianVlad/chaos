#!/usr/bin/env sh
(($# != 6)) && echo "No arguments supplied!Expect: <out degrees folder name: out_degree_rmat24> <sum of Out degrees>  <max edges per partition> <result file> <number of partitions> <vertices per partition>" && exit 1

cat ~/chaos_sandbox/$1/stream.0.* >> ~/chaos_sandbox/$1/stream.merge
python ../python/create_new_partitions.py ~/chaos_sandbox/$1/stream.merge $2 $3 $4 $5 $6
rm  -f ~/chaos_sandbox/$1/stream.merge


