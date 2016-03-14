#!/usr/bin/env sh
((!$#)) && echo No arguments supplied! Expect in_degree_rmat or out_degree_rmat && exit 1

python ../python/read_degree.py  ~/chaos_sandbox/$1/stream.0.0.0 >  ~/chaos_sandbox/results/$1.txt



