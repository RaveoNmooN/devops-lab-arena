#!/bin/bash
echo "* Add hosts ..."
echo "192.168.89.101 vault.leader.lab.io vault.leader.lab.io" >> /etc/hosts
echo "192.168.89.102 vault.follower1.lab.io vault.follower1.lab.io" >> /etc/hosts
echo "192.168.89.103 vault.follower2.lab.io vault.follower2.lab.io" >> /etc/hosts

echo "* Addinb customized PS1 profile ..."
echo "export PS1='\[\e[0m\][\[\e[0;1;38;5;253m\]\u\[\e[0;1;38;5;98m\]@\[\e[0;1;38;5;98m\]\H\[\e[0m\]] \[\e[0;38;5;214m\]\t \[\e[0;1;38;5;75m\]\w \[\e[0;38;5;34m\]$(git branch 2>/dev/null | grep '"'"'^*'"'"' | colrm 1 2)\[\e[0;38;5;253m\]# \[\e[0m\]'" >> /home/vagrant/.bashrc

echo "* Adding vault variables and customizations ..."
echo -e "export VAULT_ADDR="http://vault.leader.lab.io:8200"\ncomplete -C /usr/bin/vault vault" >> /home/vagrant/.bashrc

echo "* Adding them for root account as well ..."
sudo cp /home/vagrant/.bashrc /root/.bashrc

echo "* Reload bashrc"
source ~/.bashrc

echo "* Install Software ..."
sudo dnf upgrade -y
sudo dnf install httpd git vim-enhanced jq telnet net-tools -y

echo "* Install HashiCorp Vault ..."
sudo dnf install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install vault
sudo systemctl enable vault

echo "* Add index.html file for HTTPD ..."
cp /vagrant/httpd/* /var/www/html/

echo "* Start HTTP ..."
sudo systemctl enable httpd
sudo systemctl start httpd

echo "* Firewall - open port 80, 443, 8200 and 8201 ..."
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --add-port=443/tcp --permanent
sudo firewall-cmd --add-port=8200/tcp --permanent
sudo firewall-cmd --add-port=8201/tcp --permanent
sudo firewall-cmd --reload

echo "* Copy vault configuration files to proper destionations ..."
sudo cp /vagrant/vault.d/vault_leader/* /etc/vault.d/
sudo chown vault:vault /etc/vault.d/*
sudo chmod 664 /etc/vault.d/*
sudo cp /vagrant/systemd/* /etc/systemd/system/
sudo cp /vagrant/unseal-vault /etc/init.d/


echo "* Create a cronjob that is enabling /etc/init.d/unseal-vault to be executed on reboots"
sudo echo "@reboot sleep 10 && sh /etc/init.d/unseal-vault" > /var/spool/cron/vagrant
sudo chown vagrant:vagrant /var/spool/cron/vagrant && sudo chmod 600 /var/spool/cron/vagrant


echo "* Reload the daemon ..."
sudo systemctl daemon-reload

echo "* Allow HTTPD to make network connections ..."
sudo setsebool -P httpd_can_network_connect=1

echo "* Vault Cluster Node 1 is Starting ..."
sudo systemctl start vault
sleep 5

echo "* Initializing Vault Cluster ..."
vault operator init >> /vagrant/unseal.conf

echo "* Waiting for Vault Cluster Initialization ..."
sleep 10

echo "* Unsealing Node 1"
awk '{print $4}' /vagrant/unseal.conf | sed -n 1p | xargs vault operator unseal
sleep 2
awk '{print $4}' /vagrant/unseal.conf | sed -n 2p | xargs vault operator unseal
sleep 2
awk '{print $4}' /vagrant/unseal.conf | sed -n 3p | xargs vault operator unseal
sleep 2

echo "* Check Vault Status"
vault status > /vagrant/vault_status.txt
