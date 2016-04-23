
#!/usr/bin/env sh

((!$#)) && echo No arguments supplied! Expect: result name, files pattern to copy && exit 1

TARGET="dco-node[137-144]"

mkdir ~/results/$1Logs/
#copy logs
for i in `seq 137 144`; do scp  dco-node$i.dco.ethz.ch:/media/ssd/hpgp-results/slipstream/_$(date +"%Y-%m-%d")/logs/$2*.log ~/results/$1Logs/ ; done




