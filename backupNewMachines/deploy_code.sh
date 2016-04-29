#!/usr/bin/env sh

GROUP="dco-node[129-136]"

for device in ssd; do

clush -w dco-node[129-136] "rm -rf /media/${device}/hpgp" 

clush -w dco-node[129-136] "mkdir -p /media/${device}/hpgp/branches"

clush -w dco-node[129-136] "rm -rf /media/${device}/hpgp/branches/slipstream*"

rm -f chaos.zip 
zip -r chaos.zip chaos

for i in `seq 129 136`; do scp chaos.zip dco-node$i:/media/${device}/hpgp/branches/.; done
clush -w dco-node[129-136] "cd /media/${device}/hpgp/branches/ && unzip chaos && mv chaos slipstream && cd slipstream && mkdir -p bin && mkdir -p object_files && make clean && make"

done

