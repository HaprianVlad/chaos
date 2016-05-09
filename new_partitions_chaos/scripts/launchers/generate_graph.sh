#!/usr/bin/env bash
(($#!=2)) && echo Need scale and directed! && exit 1
scale=$1
edges=$((2 ** ($scale + 4)))
export LD_LIBRARY_PATH="/usr/local/lib/:$LD_LIBRARY_PATH"
if [ $2 == 0 ]; then
	name=rmat$1
	/media/ssd/hpgp/branches/slipstream/generators/rmat --scale $(($scale)) --edges $edges --xscale_interval 1 --xscale_node 0 --name $name --symmetric 
else
	name=rmat$1_directed	
	/media/ssd/hpgp/branches/slipstream/generators/rmat --scale $(($scale)) --edges $edges --xscale_interval 1 --xscale_node 0 --name $name
fi
mv $name /media/ssd/generated_graphs/
rm -f *.ini


