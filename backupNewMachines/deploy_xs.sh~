#!/usr/bin/env sh

GROUP="dco-node[129-136]"

for device in ssd; do

clush -w dco-node[129-136] "rm -rf /media/${device}/hpgp /media/${device}/helpers"
clush -w dco-node[129-136] "mkdir -p /media/${device}/hpgp/branches"

rm -f chaos.zip 
zip -r chaos.zip chaos
clush -w dco-node[129-136] "rm -rf /media/${device}/hpgp/branches/slipstream*"
for i in `seq 137 144`; do scp chaos.zip dco-node$i:/media/${device}/hpgp/branches/.; done
clush -w dco-node[129-136] "cd /media/${device}/hpgp/branches/ && unzip chaos && mv chaos slipstream && cd slipstream && mkdir -p bin && mkdir -p object_files && make clean && make"

rm -f helpers.zip
zip -r helpers.zip helpers
for i in `seq 129 136`; do scp helpers.zip dco-node$i:/media/${device}/.; done
clush -w dco-node[129-136] "cd /media/${device} && unzip helpers.zip"

done
