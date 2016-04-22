#!/usr/bin/env bash

target=$1
key=$2

clush -w $target -l root -c "$key" --dest /tmp/id_rsa.pub && clush -w $target -l root "cat /tmp/id_rsa.pub >>/etc/supp/trusted-keys-temporary && /etc/supp/bin/trust-root"

