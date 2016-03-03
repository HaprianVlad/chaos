#!/usr/bin/env sh

((!$#)) && echo No arguments supplied! Expect number of partitions && exit 1

TARGET="dco-node[137-144]"

#copy edge partition details in result folder

clush -w $TARGET "ls -lh /media/ssd/stream.2* > /media/ssd/edgePartitions_$1.txt"
for i in `seq 137 144`; do scp dco-node$i.dco.ethz.ch:/media/ssd/edgePartitions_$1.txt ~/results/$1Partitions/edgePartitions_$1_Machine_$i.txt ; done
clush -w $TARGET "rm /media/ssd/edgePartitions_$1.txt"




