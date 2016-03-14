#!/usr/bin/env bash
(($#!=2)) && echo Need scale and output name! && exit 1
scale=$1
edges=$((2 ** ($scale + 4)))
export LD_LIBRARY_PATH="/usr/local/lib/:$LD_LIBRARY_PATH"
/media/ssd/hpgp/branches/slipstream/generators/rmat --scale $(($scale)) --edges $edges --xscale_interval 1 --xscale_node 0 --name $2 --symmetr$



