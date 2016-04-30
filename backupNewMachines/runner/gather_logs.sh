
#!/usr/bin/env sh

((!$#)) && echo No arguments supplied! Expect: result name, files pattern to copy && exit 1

TARGET="dco-node[129-136]"

mkdir ~/runner/results/$1Logs/
#copy logs
for i in `seq 129 136`; do scp  dco-node$i.dco.ethz.ch:/media/ssd/hpgp-results/slipstream/_$(date +"%Y-%m-%d")/logs/$2*.log ~/runner/results/$1Logs/ ; done



