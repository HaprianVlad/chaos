#!/usr/bin/env bash

GROUP=$1

USER="root"
SUDO="bash -c"

clush -w $GROUP -l $USER "${SUDO} \"echo 'net.core.rmem_max=12582912' >> /etc/sysctl.conf\""
clush -w $GROUP -l $USER "${SUDO} \"echo 'net.core.wmem_max=12582912' >> /etc/sysctl.conf\""

clush -w $GROUP -l $USER "${SUDO} \"echo 'net.ipv4.tcp_rmem= 10240 87380 12582912' >> /etc/sysctl.conf\""
clush -w $GROUP -l $USER "${SUDO} \"echo 'net.ipv4.tcp_wmem= 10240 87380 12582912' >> /etc/sysctl.conf\""

clush -w $GROUP -l $USER "${SUDO} \"echo 'net.ipv4.tcp_window_scaling = 0' >> /etc/sysctl.conf\""
clush -w $GROUP -l $USER "${SUDO} \"echo 'net.ipv4.tcp_timestamps = 1' >> /etc/sysctl.conf\""
clush -w $GROUP -l $USER "${SUDO} \"echo 'net.ipv4.tcp_sack = 1' >> /etc/sysctl.conf\""
clush -w $GROUP -l $USER "${SUDO} \"echo 'net.ipv4.tcp_no_metrics_save = 1' >> /etc/sysctl.conf\""
clush -w $GROUP -l $USER "${SUDO} \"echo 'net.core.netdev_max_backlog = 5000' >> /etc/sysctl.conf\""

clush -w $GROUP -l $USER "${SUDO} \"sysctl -p\""
