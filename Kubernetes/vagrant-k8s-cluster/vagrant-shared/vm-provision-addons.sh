#!/bin/bash

echo "* Remove unwanted spaces ..."
sudo sed -i 's/\r//g' /vagrant-shared/*

echo "* Add hosts ..."
echo "192.168.0.101 kubernetes.node1.lab.io control-node" >> /etc/hosts
echo "192.168.0.102 kubernetes.node2.lab.io worker-1" >> /etc/hosts
echo "192.168.0.103 kubernetes.node3.lab.io worker-2" >> /etc/hosts

echo "* Adding customized PS1 profile ..."
echo "export PS1='\[\e[0m\][\[\e[0;1;38;5;253m\]\u\[\e[0;1;38;5;98m\]@\[\e[0;1;38;5;98m\]\H\[\e[0m\]] \[\e[0;38;5;214m\]\t \[\e[0;1;38;5;75m\]\w \[\e[0;38;5;34m\]$(git branch 2>/dev/null | grep '"'"'^*'"'"' | colrm 1 2)\[\e[0;38;5;253m\]# \[\e[0m\]'" >> /home/vagrant/.bashrc
sudo cp /home/vagrant/.bashrc /root/.bashrc