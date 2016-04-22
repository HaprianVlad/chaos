#!/usr/bin/env bash

GROUP="@dco_rack1"

# GraphLab

clush -w $GROUP hostname

clush -w $GROUP -l root yum install -y git subversion
clush -w $GROUP -l root yum install -y mpich2 mpich2-devel
clush -w $GROUP -l root yum install -y java-1.7.0-openjdk
clush -w $GROUP -l root yum install -y iotop
clush -w $GROUP -l root yum install -y gcc-c++ automake libtool
clush -w $GROUP -l root yum install -y lz4-devel

# Disks

clush -w $GROUP -l root "mkdir /media/ssd && mkdir /media/hdd && chmod 777 /media/*"

clush -w $GROUP -l root "mkfs -t ext4 /dev/sdb1 && mkfs -t ext4 /dev/sdc1"

clush -w $GROUP -l root "echo 20 > /proc/sys/vm/vfs_cache_pressure"

clush -w $GROUP -l root "mount -o discard,noatime,barrier=0,data=writeback,nobh,commit=100,nouser_xattr /dev/sdb1 /media/ssd"
clush -w $GROUP -l root "mount -o noatime,barrier=0,data=writeback,nobh,commit=100,nouser_xattr /dev/sdc1 /media/hdd"

clush -w $GROUP -l root "chmod -R 777 /media/*"

clush -w $GROUP -l root "blockdev --setra 16384 /dev/sdb"
clush -w $GROUP -l root "blockdev --setra 16384 /dev/sdc"

# X-Scale

clush -w $GROUP -l root "yum install -y lapack lapack-devel zlib-devel bzip2-devel python-devel"

clush -w $GROUP -l root "wget -O /tmp/zeromq.tar.gz http://download.zeromq.org/zeromq-3.2.4.tar.gz && cd /tmp && tar xvfz /tmp/zeromq.tar.gz && cd /tmp/zeromq-* && ./configure && make install && rm -rf /tmp/zeromq* && cd && echo Done!"

clush -w $GROUP -l root "wget -O /tmp/boost.tar.gz https://www.dropbox.com/s/csukxa7aiju37jj/boost_1_55_0.zip?dl=1 && cd /tmp && unzip /tmp/boost* && cd /tmp/boost_* && ./bootstrap.sh --prefix=/usr/local && ./b2 install && rm -rf /tmp/boost* && cd && echo Done!"

clush -w $GROUP -l root "wget -O /tmp/boost-numeric-bindings.tar.gz http://mathema.tician.de/dl/software/boost-numeric-bindings/boost-numeric-bindings-20081116.tar.gz && cd /tmp && tar xvfz /tmp/boost-numeric-bindings.tar.gz && cd /tmp/boost-numeric-bindings && ./configure --prefix=/usr/local && make install && rm -rf /tmp/boost-numeric-* && cd && echo Done!"

clush -w $GROUP -l root "cd /tmp && rm -rf snappy* && git clone https://github.com/google/snappy.git && cd snappy && ./autogen.sh && ./configure && make && make install"

clush -w $GROUP -l root "cd /tmp && rm -rf snappy* && git clone https://github.com/hoxnox/snappystream.git && cd snappystream && cmake -DWITH_BOOST_IOSTREAMS=1 . && make && make install"

