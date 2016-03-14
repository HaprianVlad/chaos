#!/usr/bin/env sh
((!$#)) && echo No arguments supplied. Expect graph name! && exit 1

python ../python/degree_cnt.py ~/chaos_sandbox/graph/$1 > ~/chaos_sandbox/results/graph$1Expected.txt
