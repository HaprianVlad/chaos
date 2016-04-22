
#!/usr/bin/env sh

((!$#)) && echo No arguments supplied! Expect result name && exit 1

TARGET="dco-node[137-144]"

#copy logs
for i in `seq 137 144`; do scp  dco-node$i.dco.ethz.ch:/media/ssd/hpgp-results/slipstream/_$(date +"%Y-%m-%d")/logs/$2*.log ~/results/$1Partitions/ ; done




