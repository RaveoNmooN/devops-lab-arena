# Instructions

The following guide will help you to setup a Kubernetes cluster involving manual steps after VM build up, with one master node and two worker nodes using Vagrant and VirtualBox. The master node will be used to manage the cluster and the worker nodes will be used to run applications. The cluster will be setup with Tigera operator and Calico network plugin for network policy enforcement. The guide is divided into two sections, the first section is for the prerequisites and the second section is for the setup of the Kubernetes cluster.

## Prerequisites for the VM's (Master and Worker Nodes) - Windows OS

1. Install VirtualBox (<https://www.virtualbox.org/wiki/Downloads>)

2. Install Vagrant (<https://www.vagrantup.com/downloads.html>) - You will need to restart your computer after installing VirtualBox and Vagrant

3. Install Vagrant reload plugin to manage boot_timeout in Virtualbox `vagrant plugin install vagrant-reload`

4. Clone this repository `git clone https://github.com/RaveoNmooN/devops-labgrounds.git` or download the zip file and extract it

5. Validate the vagrantfile `vagrant validate` and if everything is OK, then proceed with the next step

6. Run `vagrant up` to provision the VM's (Master and Worker Nodes)

## Initialize the Kubernetes Cluster

1. Update and Upgrade the VM's, then reboot them `sudo apt-get update && sudo apt-get upgrade -y` and `sudo reboot`

2. Connect to the master node `vagrant ssh kubernetes.node1.lab.io` and initialize the cluster. Depending on your configuration and preferences you can change the `--apiserver-advertise-address` and `--pod-network-cidr` flag values to match your network configuration
`sudo kubeadm init --node-name control-node --apiserver-advertise-address=192.168.0.101 --pod-network-cidr 10.244.0.0/16`

3. Install Tigera Operator and Calico network plugin, which is necessarry for kubernetes cluster api server communication

   ```shell
   kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/tigera-operator.yaml
   wget -q https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/custom-resources.yaml -O /tmp/calico-custom-resources.yaml
   ```

   Replace the `CALICO_IPV4POOL_CIDR` with your network CIDR in the `/tmp/calico-custom-resources.yaml` file

   ```shell
   sed -i 's/192.168.0.0/10.244.0.0/g' /tmp/calico-custom-resources.yaml
   kubectl create -f /tmp/calico-custom-resources.yaml
   ```

4. Set up local kubeconfig for root and vagrant user

   ```shell
   mkdir -p /root/.kube
   cp -i /etc/kubernetes/admin.conf /root/.kube/config
   chown -R root:root /root/.kube
   ```

   ```shell
   mkdir -p /home/vagrant/.kube
   cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
   chown -R vagrant:vagrant /home/vagrant/.kube
   ```

5. Join worker nodes to the cluster with the command provided by the master node `kubeadm join ...`

6. Restart kubelet `sudo systemctl daemon-reload && sudo systemctl restart kubelet` on all nodes (master and workers) and verify that all nodes are ready `kubectl get nodes` (it may take a few minutes for all nodes to be ready).

7. Verify that all pods are running `kubectl get pods -o wide --all-namespaces`

8. Verify that all services are running `kubectl get svc -o wide --all-namespaces`

9. Verify that all nodes are ready `kubectl get nodes -o wide`

## Troubleshooting the Kubernetes Cluster

1. Check the status of the nodes

   ```shell
   kubectl get nodes -o wide
   kubectl describe node <node-name> (e.g. kubectl describe node kubernetes.node1.lab.io)
   ```

2. Check the status of the pods

   ```shell
   kubectl get pods -o wide --all-namespaces
   akubectl describe pod <pod-name> -n <namespace-name> (e.g. kubectl describe pod calico-kube-controllers-<pod-id> -n kube-system)
   ```

3. Check the status of the services

   ```shell
   kubectl get svc -o wide --all-namespaces 
   kubectl describe svc <service-name> -n <namespace-name> (e.g. kubectl describe svc calico-kube-controllers -n kube-system)
   ```

4. If you have issues with the cluster you can reset it with `kubeadm reset` and then initialize it again with 

   ```shell
   sudo kubeadm init --node-name control-node --apiserver-advertise-address=192.168.0.101 --pod-network-cidr 10.244.0.0/16
   ```

5. You can also check the status of the cluster

   ```shell
   kubectl cluster-info dump
   kubectl cluster-info dump --output-directory=/tmp/cluster-state (e.g. kubectl cluster-info dump --output-directory=/tmp/cluster-state)
   ```
