#!/usr/bin/env sh

GROUP="dco-node[137-144]"

for device in ssd; do

clush -w dco-node[129-136] "rm -rf /media/${device}/helpers*"

rm -f helpers.zip
zip -r helpers.zip helpers

for i in `seq 129 136`; do scp helpers.zip dco-node$i:/media/${device}/.; done
clush -w dco-node[129-136] "cd /media/${device} && unzip helpers.zip"

done

