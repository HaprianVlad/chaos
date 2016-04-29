#!/usr/bin/env bash

export LD_LIBRARY_PATH=/usr/local/lib

m=$1 # Maximum number of machines
s=$2 # Scale of graph (24 25 26 27 28, etc.)

for i in $s; do
  for (( j=1; j<=$m; j=$j+$j )); do
    for (( k=0; k<$j; k++ )); do
      name=graph_${i}_${j}_${k}
      ./hpgp/branches/x-scale/generators/rmat --scale $(($i - 4)) --edges $((2 ** $i)) --xscale_interval $j --xscale_node $k --name ${name}.xsc --symmetric
    done
    name=graph_${i}_1_0
    python ./hpgp/branches/x-scale/format/xstream2pegasus.py ${name}.xsc ${name}.tsv
  done
done
