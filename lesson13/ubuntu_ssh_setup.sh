#!/bin/bash

ROOT_HOME="/root"
ROOT_SSH="$ROOT_HOME/.ssh"
ROOT_KEYS="$ROOT_SSH/authorized_keys"
VAGRANT_HOME="/home/vagrant"
VAGRANT_SSH="$VAGRANT_HOME/.ssh"
VAGRANT_KEYS="$VAGRANT_SSH/authorized_keys"

# Check .ssh directories exist
mkdir -p "$ROOT_SSH"
mkdir -p "$VAGRANT_SSH"

# Append the id_rsa.pub key to keys for root user
if [ -f "$VAGRANT_HOME/id_rsa.pub" ]; then
    cat "$VAGRANT_HOME/id_rsa.pub" >> "$ROOT_KEYS"
    chmod 644 "$ROOT_KEYS"
fi

# Append the id_rsa.pub key to keys for vagrant user
if [ -f "$VAGRANT_HOME/id_rsa.pub" ]; then
    cat "$VAGRANT_HOME/id_rsa.pub" >> "$VAGRANT_KEYS"
    chmod 644 "$VAGRANT_KEYS"
    chown -R vagrant:vagrant "$VAGRANT_SSH"
fi

