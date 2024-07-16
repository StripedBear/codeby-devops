#!/bin/bash

echo ">> Updating and installing open-ssh client"
apt-get update
apt-get install -y openssh-server

echo ">> Setting up user 'vagrant'"
if id "vagrant" &>/dev/null; then
    echo "User 'vagrant' already exists"
else
    useradd -m -s /bin/bash vagrant
    echo "vagrant:vagrant" | chpasswd
fi

echo ">> Setting up ssh and key"
mkdir -p /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh

if [ ! -f /home/vagrant/.ssh/id_rsa ]; then
    sudo -u vagrant ssh-keygen -t rsa -b 2048 -f /home/vagrant/.ssh/id_rsa -N ""
fi

grep -q -F "$(cat /home/vagrant/.ssh/id_rsa.pub)" /home/vagrant/.ssh/authorized_keys || cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys

cp /home/vagrant/.ssh/id_rsa /vagrant/id_rsa
chown vagrant:vagrant /vagrant/id_rsa
echo ">> SSH private key copied to shared folder"
