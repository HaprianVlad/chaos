#!/usr/bin/env sh

GROUP="dco-node[137-144]"

cd chaos/
git pull origin trials
cd ..

for device in ssd; do

clush -w dco-node[137-144] "rm -rf /media/${device}/hpgp" 

clush -w dco-node[137-144] "mkdir -p /media/${device}/hpgp/branches"

clush -w dco-node[137-144] "rm -rf /media/${device}/hpgp/branches/slipstream*"

rm -f chaos.zip 
zip -r chaos.zip chaos

for i in `seq 137 144`; do scp chaos.zip dco-node$i:/media/${device}/hpgp/branches/.; done
clush -w dco-node[137-144] "cd /media/${device}/hpgp/branches/ && unzip chaos && mv chaos slipstream && cd slipstream && mkdir -p bin && mkdir -p object_files && make clean && make"

done

