#!/usr/bin/env sh

((!$#)) && echo No arguments supplied! Expect result name && exit 1

TARGET="dco-node[129-136]"


mkdir ~/runner/results/$1Partitions
clush -w $TARGET "ls -lh /media/ssd/stream.2* > /media/ssd/edgePartitions_$1.txt"
for i in `seq 129 136`; do scp dco-node$i.dco.ethz.ch:/media/ssd/edgePartitions_$1.txt ~/runner/results/$1Partitions/edgePartitions_$1_Machine_$i.txt ; done
clush -w $TARGET "rm /media/ssd/edgePartitions_$1.txt"




