
#! /bin/bash

if [ $# -ne 2 ]; then
	echo "No arguments supplied! Expect: result name, files pattern to copy"
	exit 1
fi

TARGET="dco-node[137-144]"

mkdir ~/runner/results/$1Logs/
#copy logs
for i in `seq 137 144`; do scp  dco-node$i.dco.ethz.ch:/media/ssd/hpgp-results/slipstream/_$(date +"%Y-%m-%d")/logs/$2*.log ~/runner/results/$1Logs/ ; done




