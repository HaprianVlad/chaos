#!/usr/bin/env bash

# Global configuration
# Do not change unless you know what you're doing

ROOT_DIR="/media/ssd"

RESULTS_FOLDER="$ROOT_DIR/hpgp-results/slipstream"

USER="root"
SUDO=""

GROUP[8]="dco-node[137-144]"
GROUP[4]="dco-node0[25-28]"
GROUP[2]="dco-node0[29-30]"
GROUP[1]="dco-node031"

MACHINE[0]="dco-node137"
MACHINE[1]="dco-node138"
MACHINE[2]="dco-node139"
MACHINE[3]="dco-node140"
MACHINE[4]="dco-node141"
MACHINE[5]="dco-node142"
MACHINE[6]="dco-node143"
MACHINE[7]="dco-node144"

INPUTS="rmat-28"
ALGS="out_degree_cnt"
GEN_TYPE="directed"

ITERATIONS="20"
NUM_MACHINES="8"
CORES="8"
MEMORIES="2" #"25 50 100"
ADDITIONALS="nohelp"

BLOCKED_MEMORY=$((128 - 16))

AUTO_PUSH=1
