#!/usr/bin/env bash

export LD_LIBRARY_PATH="/usr/local/lib/:$LD_LIBRARY_PATH"

NET_IF="eth5"
PORT=20000

ROOT_DIR=/media/hdd
RECEIVER=${ROOT_DIR}/hpgp/branches/x-scale/bin/receiver_thr

RESULTS_DIR=${ROOT_DIR}/zmq-results

mkdir -p ${RESULTS_DIR}

${RECEIVER} tcp://${NET_IF}:${PORT} $1 $2 $3 2>&1 | tee $RESULTS_DIR/receiver.log

