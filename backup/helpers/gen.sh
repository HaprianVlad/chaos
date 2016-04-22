#!/usr/bin/env bash

export LD_LIBRARY_PATH="/usr/local/lib/:$LD_LIBRARY_PATH"

ROOT_DIR=$1
name=$2
scale=$3
i=$4
additional=$5

source ${ROOT_DIR}/global.sh

if [ -z $BLOCKED_MEMORY ]; then
  echo "Missing configuration!"
  exit -1;
fi

if [ -z $additional ] || [ $additional == "both" ] || [ $additional == "directed" ]; then
  cd $ROOT_DIR && test -f $name || $ROOT_DIR/hpgp/branches/slipstream/generators/rmat --scale $(($scale)) --edges $((2 ** ($scale + 4))) --xscale_interval $i --xscale_node `cat $ROOT_DIR/id` --name ${name}
fi;

if [ -z $additional ] || [ $additional == "both" ] || [ $additional == "undirected" ]; then
  name=$(echo $name | sed -E "s/(.*)_s([0-9]+)/\1-und_s\2/")
  cd $ROOT_DIR && test -f $name || $ROOT_DIR/hpgp/branches/slipstream/generators/rmat --scale $(($scale)) --edges $((2 ** ($scale + 4))) --xscale_interval $i --xscale_node `cat $ROOT_DIR/id` --name ${name} --symmetric
fi;

