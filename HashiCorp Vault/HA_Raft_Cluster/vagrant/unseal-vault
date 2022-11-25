#!/bin/bash
# Description: Script that checks if Vault is started and if it is, then unseals it, if it's not then it starts Vault and unseal it.
# It is used once the whole cluster is provisioned and VM machines are restarted for auto-unseal method.
node_addr=$(hostname)
export VAULT_ADDR="http://$node_addr:8200"


# Check if vault is up and running
echo "* Checking if Vault service is running... $node_addr "
sudo systemctl status vault >> /dev/null

# If vault is stopped it will start it and unseal it, if vault is already up and running it will just unseal it.
if [ $? -ne 3 ];
then
  sleep 2;
  echo "* Vault service is up & running...";
  echo "* Unsealing Vault $node_addr...";
  cat /vagrant/unseal.conf | awk '{print $4}' | sed -n 1p | xargs vault operator unseal >> /dev/null;
  sleep 2;
  cat /vagrant/unseal.conf | awk '{print $4}' | sed -n 2p | xargs vault operator unseal >> /dev/null;
  sleep 2;
  cat /vagrant/unseal.conf | awk '{print $4}' | sed -n 3p | xargs vault operator unseal >> /dev/null;
  sleep 2;
  echo "* Vault $node_addr is unsealed!"
else
  sleep 2;
  echo "* Vault $node_addr is stopped, starting the node now..."
  sudo systemctl restart vault;
  sleep 5;
  echo "* Vault $node_addr is now up & running again..."
  echo "* Unsealing Vault $node_addr...";
  cat /vagrant/unseal.conf | awk '{print $4}' | sed -n 1p | xargs vault operator unseal >> /dev/null;
  sleep 2;
  cat /vagrant/unseal.conf | awk '{print $4}' | sed -n 2p | xargs vault operator unseal >> /dev/null;
  sleep 2;
  cat /vagrant/unseal.conf | awk '{print $4}' | sed -n 3p | xargs vault operator unseal >> /dev/null;
  sleep 2;
  echo "* Vault $node_addr is now unsealed!"
fi