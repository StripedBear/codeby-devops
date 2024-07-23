#!/bin/bash

echo ">> Updating and installing open-ssh client"
sudo apt-get update
sudo apt-get install -y openssh-client
echo "192.168.56.18    barbaris.local" >> /etc/hosts
sudo mkdir -p /usr/local/share/ca-certificates
sudo cp /vagrant/barbaris.local.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates

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
chmod 700 /vagrant/.ssh

if [ -f /vagrant/id_rsa ]; then
    cp /vagrant/id_rsa /home/vagrant/.ssh/id_rsa
    chown vagrant:vagrant /home/vagrant/.ssh/id_rsa
    chmod 600 /home/vagrant/.ssh/id_rsa
    echo ">> SSH private key copied to /home/vagrant/.ssh/id_rsa"
else
    echo ">> SSH private key not found in /vagrant/id_rsa"
fi
