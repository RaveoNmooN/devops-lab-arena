#!/bin/bash

echo "* Add hosts ..."
echo "192.168.0.106 vault.leader.lab.io vault.leader.lab.io" >> /etc/hosts
echo "192.168.0.107 vault.follower1.lab.io vault.follower1.lab.io" >> /etc/hosts
echo "192.168.0.108 vault.follower2.lab.io vault.follower2.lab.io" >> /etc/hosts

echo "* Addinb customized PS1 profile ..."
echo "export PS1='\[\e[0m\][\[\e[0;1;38;5;253m\]\u\[\e[0;1;38;5;98m\]@\[\e[0;1;38;5;98m\]\H\[\e[0m\]] \[\e[0;38;5;214m\]\t \[\e[0;1;38;5;75m\]\w \[\e[0;38;5;34m\]$(git branch 2>/dev/null | grep '"'"'^*'"'"' | colrm 1 2)\[\e[0;38;5;253m\]# \[\e[0m\]'" >> /home/vagrant/.bashrc

echo "* Adding vault variables and customizations ..."
echo -e "export VAULT_ADDR="http://vault.follower2.lab.io:8200"\ncomplete -C /usr/bin/vault vault" >> /home/vagrant/.bashrc

echo "* Adding them for root account as well ..."
sudo cp /home/vagrant/.bashrc /root/.bashrc

echo "* Reload bashrc"
source ~/.bashrc

echo "* Install Software ..."
sudo dnf upgrade -y
sudo dnf install git vim-enhanced jq telnet net-tools -y

echo "* Install HashiCorp Vault ..."
sudo dnf install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install vault
sudo systemctl enable vault

echo "* Firewall - open port 80, 443, 8200 and 8201 ..."
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --add-port=443/tcp --permanent
sudo firewall-cmd --add-port=8200/tcp --permanent
sudo firewall-cmd --add-port=8201/tcp --permanent
sudo firewall-cmd --reload

echo "* Copy vault configuration files to proper destionations ..."
sudo cp /vagrant/vault.d/vault_follower_2/* /etc/vault.d/
sudo chown vault:vault /etc/vault.d/*
sudo chmod 664 /etc/vault.d/*
sudo cp /vagrant/systemd/* /etc/systemd/system/

echo "* Reload the daemon ..."
sudo systemctl daemon-reload

echo "* Vault Cluster Node 3 is Starting ..."
sudo systemctl start vault
sleep 5

echo "* Unsealing Node 3"
cat /vagrant/unseal.conf | awk '{print $4}' | sed -n 1p | xargs vault operator unseal
sleep 1
cat /vagrant/unseal.conf | awk '{print $4}' | sed -n 2p | xargs vault operator unseal
sleep 1
cat /vagrant/unseal.conf | awk '{print $4}' | sed -n 3p | xargs vault operator unseal
sleep 1

echo "* Check Vault Status"
vault status >> /vagrant/vault_status.txt