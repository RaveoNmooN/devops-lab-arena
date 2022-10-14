# Vagrant Labs
This is a repository that will be used to store a different Vagrant provisioning automations.
<br> Currently there is only one that can be used for provisioning of a `HA HashiCorp Vault Cluster with integrated Raft Storage`.




<br> Things that will be added as part of the provisioning of the [HA HashiCorp Vault Cluster deployed](https://github.com/RaveoNmooN/Vagrant-Labs/tree/master/HashiCorp%20Vault/HA_Raft_Cluster) via Vagrant / VirtualBox
- [ ] Add additional step in vault_follower_*.sh files that is starting and enabling the vault service for follower 1 and follower 2
- [ ] Create a provisioning step where Vault Cluster is automatically initialized, keys and root token are stored securly as variables which will be passed later on to the Unseal phase
- [ ] Create a provisioning step that is Unsealing all Vault nodes with the stored Shamir keys
- [ ] Convert the Shamir unseal keys into recovery keys
- [ ] As part of the provisioning, an additional step should Install **[Certbot](https://certbot.eff.org/)** and generate TLS certificate for encrypting the communication between the nodes and the TLS termination on port 8200 available for the GUI API interactions
- [ ] TLS encryption settings should be added to the vault.hcl config files
