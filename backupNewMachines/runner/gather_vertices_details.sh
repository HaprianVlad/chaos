#!/usr/bin/env sh

(($# != 2 )) && echo No arguments supplied! Expect: grah_scale, directed && exit 1

TARGET="dco-node[129-136]"

if [ $2 == 0 ]; then
  folder_name=out_degree_rmat$1
else 
  folder_name=out_degree_rmat$1_directed
fi

mkdir ~/chaos_sanbox/$folder_name/
for i in `seq 129 136`; do scp  dco-node$i.dco.ethz.ch:/media/ssd/stream.0.$((i-137))* ~/chaos_sandbox/$folder_name/ ; done


