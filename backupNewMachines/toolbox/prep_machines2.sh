#!/usr/bin/env bash

# GraphLab

clush -w @dco_block[5-7,12-15,20] hostname

clush -w @dco_block[5-7,12-15,20] -l root yum install -y git subversion
clush -w @dco_block[5-7,12-15,20] -l root yum install -y mpich2
clush -w @dco_block[5-7,12-15,20] -l root yum install -y java-1.7.0-openjdk
clush -w @dco_block[5-7,12-15,20] -l root yum install -y iotop

# Disks

clush -w @dco_block[5-7,12-15,20] -l root "mkdir /media/ssd && mkdir /media/hdd && chmod 777 /media/*"

clush -w @dco_block[5-7,12-15,20] -l root "mkfs -t ext4 /dev/sdb1 && mkfs -t ext4 /dev/sdc1"

clush -w @dco_block[5-7,12-15,20] -l root "mount /dev/sdb1 /media/ssd"
clush -w @dco_block[5-7,12-15,20] -l root "mount /dev/sdc1 /media/hdd"

clush -w @dco_block[5-7,12-15,20] -l root "chmod -R 777 /media/*"

# X-Scale

clush -w @dco_block[5-7,12-15,20] -l root "yum install -y lapack lapack-devel zlib-devel bzip2-devel python-devel"

clush -w @dco_block[5-7,12-15,20] -l root "wget -O /tmp/zeromq.tar.gz http://download.zeromq.org/zeromq-3.2.4.tar.gz && cd /tmp && tar xvfz /tmp/zeromq.tar.gz && cd /tmp/zeromq-* && ./configure && make install && rm -rf /tmp/zeromq* && cd && echo Done!"

clush -w @dco_block[5-7,12-15,20] -l root "wget -O /tmp/boost.tar.gz https://www.dropbox.com/s/csukxa7aiju37jj/boost_1_55_0.zip?dl=1 && cd /tmp && tar xvfz /tmp/boost.tar.gz && cd /tmp/boost_* && ./bootstrap.sh --prefix=/usr/local && ./b2 install && rm -rf /tmp/boost* && cd && echo Done!"

clush -w @dco_block[5-7,12-15,20] -l root "wget -O /tmp/boost-numeric-bindings.tar.gz http://mathema.tician.de/dl/software/boost-numeric-bindings/boost-numeric-bindings-20081116.tar.gz && cd /tmp && tar xvfz /tmp/boost-numeric-bindings.tar.gz && cd /tmp/boost-numeric-bindings && ./configure --prefix=/usr/local && make install && rm -rf /tmp/boost-numeric-* && cd && echo Done!"

clush -w @dco_block[5-7,12-15,20] -l root "cd /tmp && git clone https://github.com/google/snappy.git && cd snappy && ./autogen.sh && ./configure && make && make install"

