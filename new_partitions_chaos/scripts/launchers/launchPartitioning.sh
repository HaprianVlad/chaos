#!/usr/bin/env sh
(($# != 4)) && echo "No arguments supplied!Expect: <out degrees folder name: out_degree_rmat24> <sum of Out degrees>  <max edges per partition> <result file>" && exit 1

cat ~/chaos/tests_chaos/data/$1/stream* >> ~/chaos/new_partitions_chaos/data/$1/stream.merge
python ../python/create_new_partitions.py  ~/chaos/new_partitions_chaos/data/$1/stream.merge $2 $3 $4
rm  -f ~/chaos/new_partitions_chaos/data/$1/stream.merge


