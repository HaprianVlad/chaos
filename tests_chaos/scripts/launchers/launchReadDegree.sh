#!/usr/bin/env sh
((!$#)) && echo No arguments supplied! Expect in or out && exit 1

python ../python/read_degree.py  ~/chaos/tests_chaos/data/$1/stream.0.0.0 > $1Degree.txt



