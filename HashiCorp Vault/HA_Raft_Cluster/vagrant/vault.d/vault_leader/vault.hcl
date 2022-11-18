# Full configuration options can be found at https://www.vaultproject.io/docs/configuration

ui = true

#mlock = true
disable_mlock = true

# HA parameters

api_addr = "http://vault.leader.lab.io:8200"
cluster_addr = "http://vault.leader.lab.io:8201"


# HTTPS listener
listener "tcp" {
  address       = "192.168.89.101:8200"
  cluster_address = "192.168.89.101:8201"
  tls_disable = "true"
}


storage "raft" {
  path = "/opt/vault/data"
  node_id = "vault_node_1"

  retry_join {
      leader_tls_servername   = "vault.follower1.lab.io"
      leader_api_addr = "http://vault.follower1.lab.io:8200"
  }

  retry_join {
      leader_tls_servername   = "vault.follower2.lab.io"
      leader_api_addr = "http://vault.follower2.lab.io:8200"
  }


}


## Enterprise license_path
# This will be required for enterprise as of v1.8
#license_path = "/etc/vault.d/vault.hclic"

# Example AWS KMS auto unseal
#seal "awskms" {
#  region = "us-east-1"
#  kms_key_id = "REPLACE-ME"
#}

# Example HSM auto unseal
#seal "pkcs11" {
#  lib            = "/usr/vault/lib/libCryptoki2_64.so"
#  slot           = "0"
#  pin            = "AAAA-BBBB-CCCC-DDDD"
#  key_label      = "vault-hsm-key"
#  hmac_key_label = "vault-hsm-hmac-key"
#}