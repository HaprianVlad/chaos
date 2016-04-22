#!/usr/bin/env bash

name=$1

cd ~/disk && python ~/hpgp/branches/x-scale/format/xstream2pegasus.py ${name}.xsc ${name}.tsv

