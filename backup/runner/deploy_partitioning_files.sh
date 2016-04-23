#!/usr/bin/env sh

if [ $# != 4 ]; then
  echo No arguments supplied! Expect: graph scale, number of machines, directed, file path  && exit 1
fi

TARGET="dco-node[137-144]"
if [ $3 == 0 ]; then
	name=rmat-$1-und-s$2.part
else
	name=rmat-$1_s$2.part 
fi

for i in `seq 137 144`; do scp $4  dco-node$i.dco.ethz.ch:/media/ssd/$name ; done



