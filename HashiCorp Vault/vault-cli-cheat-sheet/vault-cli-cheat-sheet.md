## Table of contents
* [Highly Available Vault Cluster - Raft integrated storage](ha-raft-vault-cluster)
* [Audit commands](#audit-commands)
* [API's usage](#api-commands)

# This is Draft

## Working with Secrets Engines

##### List existing secrets engines
```
vault secrets list
```
##### Enable a new secrets engine
```
vault secrets enable [options] TYPE 
```
```
example: vault secrets enable -path=ExampleKV -version=2 kv
example: vault secrets enable -path=dbas transit
```

##### Tune a secrets engine setting
```
vault secrets tune [options] PATH
vault secrets tune -description="Example Default KV" ExampleKV
```

##### Move an existing secrets engine - 
```
vault secrets move [options] Source DEST
vault secrets move ExampleKV ExampleKV1
```

##### Disable a secrets engine
```
vault secrets disable [options] PATH
example: vault secrets disable ExampleKV1
```
`< ! Disabling a secret engine destroys all data stored by that engine and it's configuration ! >`

##### Create policy from HCL file
```
vault policy write example-policy kv-policy.hcl
```

##### Generate a token for the example k/v engine based on policy
```
vault token create -policy="example-policy"
```

##### Add a secret to the engine
```
vault kv put ExampleKV/apitokens/new_secret token=8675309
```

##### Get the value of a secret
```
vault kv get ExampleKV/apitokens/new_secret
```

##### Delete secret from the engine
```
vault kv delete ExampleKV/apitokens/new_secret
```

##### Log in as particular user with different authentication methods - (ldap and userpass are given as examples)
```
LDAP      - vault login -method=ldap username=dev_user
USERPASS  - vault login -method=userpass username=dev_user
```

> ### Encrypt/Decrypt data with transit engine
##### Login with the user able to do the operations
```
vault login
```
##### Encrypt some data 
```
vault write transit/encrypt/key1_example plaintext=$(base64 <<< "I_am_the_encrypted_text")
```

##### Let's now try to decrypt the text
```
1. ciphertext=vault:v1:<ADD_GENERATED_VALUE_HERE>
2. vault write transit/decrypt/key1_example ciphertext=$ciphertext
3. echo <ADD_PLAINTEXT_BASE64_VALUE_HERE> | base64 -d
```
<b>This should give the output "I_am_the_encrypted_text"


<a name="audit-commands"></a>

## Audit Commands

##### Enable audit device
```
vault audit enable [options] TYPE [settings]
vault audit enable -path=file-audit file file_path=/opt/vault/logs/auditlog
*(logrotate is not handled by Vault)
```
##### Disable audit device
```
vault audit disable PATH
vault audit disable file-audit
```
##### List audit device
```
vault audit list [options]
```

##### Draft

vault operator init
vault operator status
vault operator unseal
vault operator raft list-peers
vault operator raft autopilot state
vault operator raft snapshot save demo.snapshot


vault write sys/auth/token/tune default_lease_ttl=768h
vault write sys/auth/token/tune max_lease_ttl=768h
vault read sys/auth/token/tune

