#!/usr/bin/env bash

re='^[0-9]+$'

for i in `seq 5000 8000`; do 
  pid=`lsof -t -i:$i`
  if [[ $pid =~ $re ]] ; then
    echo "killing $pid"
    kill $pid
  fi
done

echo "all remaining processes killed"
