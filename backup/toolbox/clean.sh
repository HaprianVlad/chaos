#!/usr/bin/env bash

GROUP="@dco_rack[1,3]"

for device in hdd ssd; do

clush -w $GROUP -l root "cd /media/$device && rm -f x-scale.ini vertices* updates* edges* core.* stream* snap* chkpnt* && sync"

done;

clush -w $GROUP -l root "/media/hdd/helpers/killall.sh"
clush -w $GROUP -l root "killall benchmark_driver"
