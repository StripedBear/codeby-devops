#!/bin/bash

echo ">> Updating and installing open-ssh client"
apt-get update
apt-get install -y openssh-client

echo ">> Setting up user 'vagrant'"
if id "vagrant" &>/dev/null; then
    echo ">> User 'vagrant' already exists"
else
    useradd -m -s /bin/bash vagrant
    echo ">> vagrant:vagrant" | chpasswd
fi

echo ">> Setting up ssh and key"
mkdir -p /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh

if [ -f /vagrant/id_rsa ]; then
    cp /vagrant/id_rsa /home/vagrant/.ssh/id_rsa
    chown vagrant:vagrant /home/vagrant/.ssh/id_rsa
    chmod 600 /home/vagrant/.ssh/id_rsa
    echo ">> SSH private key copied to /home/vagrant/.ssh/id_rsa"
else
    echo ">> SSH private key not found in /vagrant/id_rsa"
fi
