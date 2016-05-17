#!/usr/bin/env sh

TARGET="dco-node[137-144]"
for i in `seq 137 144`; do scp /media/ssd/permutations/permutation_rmat28 dco-node$i.dco.ethz.ch:/media/ssd/ ; done
for i in `seq 137 144`; do scp vertex_relabeling.py dco-node$i.dco.ethz.ch:/media/ssd/ ; done

