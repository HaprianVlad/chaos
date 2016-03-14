#!/usr/bin/env sh
((!$#)) && echo No arguments supplied!Expect graph name: rmat24 && exit 1
python ../python/test_degree.py  ~/chaos_sandbox/graph/$1  ~/chaos_sandbox/out_degree/stream.0.0.0  ~/chaos_sandbox/in_degree/stream.0.0.0 >  ~/chaos_sandbox/results/testTesults.txt
