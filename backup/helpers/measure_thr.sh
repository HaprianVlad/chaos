#!/usr/bin/env bash

file=$1

cat $file | awk '/RX_TIME/{t=$5} /RXBYTES/{b=$5} END {print b*8/(t*1024*1024*1024)}'
