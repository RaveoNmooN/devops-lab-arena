#!/bin/bash

echo "* Update server ..."
sudo apt-get update

echo "* Remove unwanted spaces ..."
sudo sed -i 's/\r//g' /vagrant-shared/*

echo "* Add hosts ..."
echo "192.168.89.101 node-1.k8s control-node" >> /etc/hosts
echo "192.168.89.102 node-2.k8s worker-1" >> /etc/hosts
echo "192.168.89.103 node-3.k8s worker-2" >> /etc/hosts

echo "* Addinb customized PS1 profile ..."
echo "export PS1='\[\e[0m\][\[\e[0;1;38;5;253m\]\u\[\e[0;1;38;5;98m\]@\[\e[0;1;38;5;98m\]\H\[\e[0m\]] \[\e[0;38;5;214m\]\t \[\e[0;1;38;5;75m\]\w \[\e[0;38;5;34m\]$(git branch 2>/dev/null | grep '"'"'^*'"'"' | colrm 1 2)\[\e[0;38;5;253m\]# \[\e[0m\]'" >> /home/vagrant/.bashrc
sudo cp /home/vagrant/.bashrc /root/.bashrc