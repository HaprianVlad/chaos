#!/usr/bin/env sh

TARGET="dco-node[137-144]"

clush -w $TARGET rm -f  dco-node$i.dco.ethz.ch:/media/ssd/hpgp-results/stream*
clush -w $TARGET rm -f  dco-node$i.dco.ethz.ch:/media/ssd/hpgp-results/core*
clush -w $TARGET rm -f  dco-node$i.dco.ethz.ch:/media/ssd/hpgp-results/graph*
clush -l root -w $TARGET 'rm -f dco-node$i.dco.ethz.ch:/media/ssd/hpgp-results/rmat*'







