#!/usr/bin/env sh
(($# != 3)) && echo No arguments supplied!Expect out degrees folder name: out_degree_rmat24, sum of Out degrees and max edges per partition&& exit 1

cat ~/chaos/tests_chaos/data/$1/stream* >> ~/chaos/tests_chaos/data/$1/stream.merge
python ../python/create_new_partitions.py  ~/chaos/tests_chaos/data/$1/stream.merge $2 $3
rm  -f ~/chaos/tests_chaos/data/$1/stream.merge


