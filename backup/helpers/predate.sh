#!/usr/bin/env bash

while read line ; do
    echo "$(date +%s%N | cut -b1-13)	${line}"
done

