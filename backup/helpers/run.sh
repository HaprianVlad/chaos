#!/usr/bin/env bash

export LD_LIBRARY_PATH="/usr/local/lib/:$LD_LIBRARY_PATH"

ROOT_DIR=$1
algorithm=$2
name=$3
machines=$4
cores=$5
memory=$6
bsize=$7
additional=$8

partitions=8

source ${ROOT_DIR}/global.sh

if [ -z $BLOCKED_MEMORY ]; then
  echo "Missing configuration!"
  exit -1
fi

blocked_memory=$BLOCKED_MEMORY


# --use_vertex_striping 
# --request_batching and --batch_size=$bsize (for edge stripping and batch I/O)
# --do_edge_stripe (for edge striped without batch I/O)
# --do_updates_stripe and --batch size=$bsize (for stripping and batch I/O the updates)
# --optimized_state_load_store (state load/store is done only once at the begening and at the end if work stealing is off and 1 partition per machine)

additional_args="--partitions $(($partitions * $partitions * $machines)) --super_partitions $(($partitions)) --fanout $(($partitions * $partitions * $machines)) --polling_client --polling_server --gather_io_drain --use_async_server --policy_heuristic_new"


if [ -z $additional ] || [ $additional == "heuristic" ]; then
  additional="heuristic"
  additional_args="${additional_args}"
elif [ $additional == "nohelp" ]; then
  additional_args="${additional_args} --policy_help_none"
elif [ $additional == "helpall" ]; then
  additional_args="${additional_args} --policy_help_all"
else
  echo "Unknown additional argument $additional!"
  exit -1
fi

# write here for undirected algorithms
if [ $algorithm == "out_degree_cnt"] ||  [ $algorithm == "bfs" ] || [ $algorithm == "bfs_filter" ] || [ $algorithm == "cc" ] || [ $algorithm == "bfs_forest" ] || [ $algorithm == "mcst" ] || [ $algorithm == "mis" ] || [ $algorithm == "sssp_forest" ]; then
  name=$(echo $name | sed -E "s/(.*)_s([0-9]+)/\1-und_s\2/")
  if [[ $name == twitter* ]] || [[ $name == fixed-twitter* ]]; then 
    additional_args="${additional_args} --bfs::root 10201"
  fi
fi

rx_cores=$((($cores - 2) / 2))
tx_cores=$((($cores - 2) / 2))
compute_cores=$((${rx_cores} + ${tx_cores}))
zmq_threads=2

CUR_DIR=$(pwd)
rev=$(cd $ROOT_DIR/hpgp && svn info | grep "Rev:" | sed -E "s/.* ([0-9]+)/\1/")

results_dir=$RESULTS_FOLDER/${rev}_$(date +"%Y-%m-%d")
mkdir -p "$results_dir"

filename=${algorithm}_${name}_m${machines}_${cores}_${memory}_${additional}_${bsize}__`cat $ROOT_DIR/id`.log
mkdir -p "${results_dir}/io"
mkdir -p "${results_dir}/net"
mkdir -p "${results_dir}/cpu"
mkdir -p "${results_dir}/logs"

fsize=$(stat -c %s ${ROOT_DIR}/$name)

sed -i '/^$/d' ${ROOT_DIR}/slipstore.ini
sed -i '/^uncomp/d' ${ROOT_DIR}/slipstore.ini
echo "uncomp_esize=$fsize" >> ${ROOT_DIR}/slipstore.ini

echo "Uncompressed file size=$fsize"

echo "Compressing file ${name}..."
rm -f ${ROOT_DIR}/${name}.lz4
#gzip < ${name} > ${name}.gz
#lz4 ${ROOT_DIR}/${name} ${ROOT_DIR}/${name}.lz4
echo "Done compressing!"

sync

# Protect against Calin
killall sync_logs.py

ulimit -c unlimited
ulimit -n $((128 * 1024))

cd $ROOT_DIR

killall iotop
killall bwm-ng
killall top

iotop -bkPqqq -d 1 | grep "% benchmark_driver" | grep -v grep > ${results_dir}/io/$filename &
bwm-ng -t 100 -o csv -F ${results_dir}/net/$filename &
top -b -d 1 | ${ROOT_DIR}/helpers/predate.sh | grep --line-buffered "benchmark_driver" | grep --line-buffered -v grep > ${results_dir}/cpu/$filename &

numactl --interleave=all $ROOT_DIR/hpgp/branches/slipstream/bin/benchmark_driver --physical_memory $(($memory * 1024 * 1024 * 1024)) --blocked_memory $(($blocked_memory * 1024 * 1024 * 1024)) --heartbeat -b $algorithm -g $name --partitions_offsets_file $name.part -p $cores $additional_args 2>&1 | $ROOT_DIR/helpers/predate.sh | tee ${results_dir}/logs/$filename

killall iotop
killall bwm-ng
killall top

sync

