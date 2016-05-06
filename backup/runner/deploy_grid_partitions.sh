#!/usr/bin/env sh

if [ $# != 2 ]; then
  echo No arguments supplied! Expect: graph name, row_partitioning  && exit 1
fi

TARGET="dco-node[137-144]"

for i in `seq 137 144`; do 
index=$(($i-137))
	if [ $2 -eq 0 ]; then
		/media/ssd/grid/grid_partitions_$1/stream.2.$index.* >> s.2.$index.0 
	
	else 

		/media/ssd/grid/grid_partitions_$1/stream.2.*.$index >> s.2.$index.0 
	fi
scp /media/ssd/grid/grid_partitions_$1/s.2.$index.0 dco-node$i.dco.ethz.ch:/media/ssd/stream.2.$index.0;
rm -f s.2.$index.0 

done



