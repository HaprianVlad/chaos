#!/bin/bash

echo "Fixing the problem..."

cp -R /usr/local/boost_1_54_0/lib /usr/local && cp -R /usr/local/boost_1_54_0/include /usr/local && cd /tmp && tar xvfz boost-numeric-bindings-20081116.tar.gz && cd boost-numeric-bindings && ./configure --prefix=/usr/local && make install && cd .. && rm -rf boost-numeric*

echo "Done"

