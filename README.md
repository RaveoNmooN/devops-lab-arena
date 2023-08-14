# 🚀 DevOps Lab Arena

![GitHub last commit](https://img.shields.io/github/last-commit/RaveoNmooN/devops-lab-arena.svg) ![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

This repository will be used to store a different lab environments, hands-on learnings, experiments and cheatsheets related to DevOps tools & practices.
At the moment I am working on expanding a lab environment for `HA HashiCorp Vault Cluster with integrated Raft Storage`

## Table of Contents

* [Provision HA HashiCorp Vault Cluster with integrated Raft Storage](https://github.com/RaveoNmooN/devops-lab-arena/tree/master/HashiCorp%20Vault/ha-raft-cluster)

## To Do

<br> Things that will be added as part of the provisioning of the [HA HashiCorp Vault Cluster](https://github.com/RaveoNmooN/devops-lab-arena/tree/master/HashiCorp%20Vault/ha-raft-cluster) via Vagrant / VirtualBox
- [x] Add additional step in vault_follower_*.sh files that is starting and enabling the vault service for follower 1 and follower 2
- [x] Create a provisioning step where Vault Cluster is automatically initialized, keys and root token are stored securly as variables which will be passed later on to the Unseal phase
- [x] Create a provisioning step that is Unsealing all Vault nodes with the stored Shamir keys
- [ ] Develop automatic cluster upgrade via Ansible with automatic startup and unseal
- [x] Develop automatic service startup and node unseal via Bash scripting
- [ ] Develop automatic service startup and node unseal via Python scripting
- [ ] Add TLS issuance and installation over all nodes to be part of the cluster provisioning, so the cluster can be access over HTTPS
- [ ] ~~As part of the provisioning, an additional step should Install **[Certbot](https://certbot.eff.org/)** and generate TLS certificate for encrypting the communication between the nodes and the TLS termination on port 8200 available for the GUI API interactions~~
- [ ] TLS encryption settings should be added to the vault.hcl config files

## License

See [License](LICENSE).
