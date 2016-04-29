#!/usr/bin/env bash

# Utility functions
function fail {
  echo "Failure encountered! Exiting!"
  exit -1
}

function e {
  echo -e '\E[37;44m'"\033[1m$1\033[0m"
}

if [ $# -ne 2 ]; then
  echo "Usage: split_file.sh <# parts> <file>"
  exit 1
fi

if [ $1 -le 1 ]; then
  echo "Unable to split file in $1 parts!"
  echo "Usage: split_file.sh <# parts> <file>"
  exit 1
fi

if [ ! -f $2 ]; then
  echo "Please provide a valid file to split!"
  echo "Usage: split_file.sh <# parts> <file>"
  exit 1
fi

num_bytes=`wc -c < $2`

num_lines=`perl -e "print $num_bytes / 12.0"`

valid=`perl -e "if($num_lines == int($num_lines)) { print 1 } else { print 0 }"`

if [ $valid -ne 1 ]; then
  echo "Oops, looks like that's not a valid .xsc file!"
  exit 1
fi

lines_per_file=`perl -e "use POSIX; print ceil($num_lines / $1)"`

bytes_per_file=`perl -e "print $lines_per_file * 12"`

split -d -b $bytes_per_file "$2" "${2}_"
