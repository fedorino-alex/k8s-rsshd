#!/usr/bin/env ash

# K8s-RsshD - SSH Reverse Tunnel Daemon
# 
# Based on original work by Emmanuel Frecon <efrecon@gmail.com>
# Copyright (c) 2016, Emmanuel Frecon
# Copyright (c) 2025, Alex Fedorino
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# See LICENSE file for full terms.
#

# This is the main startup script for the running sshd to keep client
# tunnels.

# Settings directory
SDIR=/etc/ssh

# Make sure we have a root password, since Alpine does not have a root
# password by default and we want to have this minimal level of security
if [ -z "$PASSWORD" ]; then
    PASSWORD=$(< /dev/urandom tr -dc A-Z-a-z-0-9 | head -c8)
    echo "==========="
    echo "== Root Password is $PASSWORD"
    echo "==========="
    echo
fi
echo "root:${PASSWORD}" | chpasswd

# Generate server keys if they don't exist
if [ ! -f "$SDIR/ssh_host_rsa_key" ]; then
    ssh-keygen -A
fi

# Allow external hosts to connect
sed -i "s;\GatewayPorts no;GatewayPorts yes;g" $SDIR/sshd_config
sed -i "s;\AllowTcpForwarding no;AllowTcpForwarding yes;g" $SDIR/sshd_config

# Disable password authentication if requested (force key-based auth only)
sed -i "s;.*PasswordAuthentication.*;PasswordAuthentication no;g" $SDIR/sshd_config
sed -i "s;.*PubkeyAuthentication.*;PubkeyAuthentication yes;g" $SDIR/sshd_config
sed -i "s;.*AuthenticationMethods.*;AuthenticationMethods publickey;g" $SDIR/sshd_config
sed -i "s;\#PermitRootLogin .*;PermitRootLogin prohibit-password;g" $SDIR/sshd_config
echo "PasswordAuthentication no" >> $SDIR/sshd_config
echo "PubkeyAuthentication yes" >> $SDIR/sshd_config
echo "AuthenticationMethods publickey" >> $SDIR/sshd_config

# Setup SSH directory and authorized keys
mkdir -p $HOME/.ssh
chown root $HOME/.ssh
chmod 700 $HOME/.ssh

# Copy authorized keys from ConfigMap if available
if [ -f "/tmp/ssh-keys/authorized_keys" ]; then
    cp /tmp/ssh-keys/authorized_keys $HOME/.ssh/authorized_keys
    chmod 600 $HOME/.ssh/authorized_keys
    chown root:root $HOME/.ssh/authorized_keys
    echo "Authorized keys copied from ConfigMap"
else
    echo "No authorized keys found in ConfigMap"
    touch $HOME/.ssh/authorized_keys
    chmod 600 $HOME/.ssh/authorized_keys
    chown root:root $HOME/.ssh/authorized_keys
fi

# Absolute path necessary! Pass all remaining arguments to sshd. This enables to
# override some options through -o, for example.
/usr/sbin/sshd -f ${SDIR}/sshd_config -D -e "$@"
