#!/usr/bin/env bash

TARGET=$1
KEY=$2

clush -w $TARGET -l lbindsch "cp ~/$KEY /tmp/."
clush -w $TARGET -l root "cat /tmp/$KEY >> /etc/supp/trusted-keys-temporary && /etc/supp/bin/trust-root"
