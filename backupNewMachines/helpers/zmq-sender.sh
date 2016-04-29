#!/usr/bin/env bash

export LD_LIBRARY_PATH="/usr/local/lib/:$LD_LIBRARY_PATH"

NET_IF="eth5"
PORT=20000

ROOT_DIR=/media/hdd
SENDER=${ROOT_DIR}/hpgp/branches/x-scale/bin/sender_thr

RESULTS_DIR=${ROOT_DIR}/zmq-results

mkdir -p ${RESULTS_DIR}

target_id=$(((32 + `cat ${ROOT_DIR}/id`) % 64 + 1))

if [ ${target_id} -gt 32 ]; then
  target_id=$((${target_id} + 24))
fi

${SENDER} tcp://dco-node$(printf "%03d" ${target_id})-10g:${PORT} $1 $2 $3 2>&1 | tee ${RESULTS_DIR}/sender.log
