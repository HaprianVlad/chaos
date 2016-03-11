#!/usr/bin/env sh

((!$#)) && echo No arguments supplied!Expect graph name: rmat24 && exit 1
python ./python/test_degree.py ~/chaos/tests_chaos/graph/$1 ~/chaos/tests_chaos/out_degree/stream.0.0.0 ~/chaos/tests_chaos/in_degree/stream.0.0.0 > testTesults.txt
