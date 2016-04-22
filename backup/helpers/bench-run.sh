#!/usr/bin/env bash

export LD_LIBRARY_PATH="/usr/local/lib/:$LD_LIBRARY_PATH"

ROOT_DIR=$1
algorithm=$2
machines=$3
cores=$4
memory=$5
servers=$6
bsize=$7
additional=$8

source ${ROOT_DIR}/global.sh

if [ -z $BLOCKED_MEMORY ]; then
  echo "Missing configuration!"
  exit -1
fi

blocked_memory=$BLOCKED_MEMORY

additional_args="--polling_client --polling_server --slipbench_background_threads 6 --slipbench_align 12 --request_batching --batch_size=$bsize --slipbench_fsize $((16 * 1024 * 1024 * 1024))" #"--centralized --use_async_server --use_direct_io --slipbench_fsize $((16 * 1024 * 1024 * 1024))"

CUR_DIR=$(pwd)
rev=$(cd $ROOT_DIR/hpgp && svn info | grep "Rev:" | sed -E "s/.* ([0-9]+)/\1/")

results_dir=$RESULTS_FOLDER/${rev}_$(date +"%Y-%m-%d")
mkdir -p "$results_dir"

filename=${algorithm}_m${machines}_${cores}_${memory}_${servers}_${bsize}__`cat $ROOT_DIR/id`.log
mkdir -p "${results_dir}/logs"

sync

# Protect against Calin
killall sync_logs.py

ulimit -c unlimited
ulimit -n $((128 * 1024))

cd $ROOT_DIR

numactl --interleave=all $ROOT_DIR/hpgp/branches/slipstream/bin/slipbench --physical_memory $(($memory * 1024 * 1024 * 1024)) --blocked_memory $(($blocked_memory * 1024 * 1024 * 1024)) --heartbeat --$algorithm -g temp -a -p $cores $additional_args 2>&1 | $ROOT_DIR/helpers/predate.sh | tee ${results_dir}/logs/$filename

sync

