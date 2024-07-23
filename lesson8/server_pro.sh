#!/bin/bash

echo ">> Updating and installing open-ssh client"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y openssh-server
sudo apt-get install -y apache2

echo "127.0.0.1 barbaris.local" >> /etc/hosts
sudo mkdir -p /etc/apache2/ssl
sudo touch /root/.rnd
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/barbaris.local.key -out /etc/ssl/certs/barbaris.local.crt -subj "/CN=barbaris.local"

echo ">> Setting up user 'vagrant'"
if id "vagrant" &>/dev/null; then
    echo ">> User 'vagrant' already exists"
else
    useradd -m -s /bin/bash vagrant
    echo "vagrant:vagrant" | chpasswd
fi

echo ">> Setting up apache configuration"
cp /vagrant/barbaris.local.conf /etc/apache2/sites-available/barbaris.local.conf
sudo a2enmod ssl
sudo a2ensite barbaris.local.conf
# sudo a2ensite default-ssl
sudo systemctl restart apache2

cp /etc/ssl/certs/barbaris.local.crt /vagrant
chown vagrant:vagrant /vagrant/barbaris.local.crt

echo ">> Setting up ssh and key"
mkdir -p /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 700 /vagrant/.ssh

if [ ! -f /home/vagrant/.ssh/id_rsa ]; then
    sudo -u vagrant ssh-keygen -t rsa -b 2048 -f /home/vagrant/.ssh/id_rsa -N ""
fi

grep -q -F "$(cat /home/vagrant/.ssh/id_rsa.pub)" /home/vagrant/.ssh/authorized_keys || cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys

cp /home/vagrant/.ssh/id_rsa /vagrant/id_rsa
chown vagrant:vagrant /vagrant/id_rsa
echo ">> SSH private key copied to shared folder"
