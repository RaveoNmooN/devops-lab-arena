#!/bin/bash
# Prompt for the Vault address
read -p "Enter the Vault address (e.g., https://vault-address.example.com): " VAULT_URL

# Prompt for the Vault login token
VAULT_TOKEN="$(systemd-ask-password "Enter your Vault login token:")"

# Prompt for the role name
read -p "Enter the role name (e.g., network-nautobot): " ROLE_NAME

# Prompt for allowed policies
read -p "Enter allowed policies (comma-separated): " ALLOWED_POLICIES

# Verify the token using Vault's API
echo "Verifying Vault token..."
TOKEN_LOOKUP_RESPONSE=$(curl -sk --header "X-Vault-Token: $VAULT_TOKEN" "$VAULT_URL/v1/auth/token/lookup-self")

# Check if the response contains an "errors" field
if echo "$TOKEN_LOOKUP_RESPONSE" | jq -e '.errors' > /dev/null; then
  echo "Token verification failed. Please check your token and try again."
  exit 1
fi

# Tune token settings
echo "Tuning token settings..."
curl -sk --request POST --header "X-Vault-Token: $VAULT_TOKEN" --data '{"max_lease_ttl": "18000h", "default_lease_ttl": "18000h"}' "$VAULT_URL/v1/sys/auth/token/tune"

# Check token settings after tuning
echo "Checking token settings after tuning..."
TOKEN_TUNE_SETTINGS=$(curl -sk --header "X-Vault-Token: $VAULT_TOKEN" "$VAULT_URL/v1/sys/auth/token/tune")
DEFAULT_LEASE_TTL_SECONDS=$(echo "$TOKEN_TUNE_SETTINGS" | jq -r '.data.default_lease_ttl')
MAX_LEASE_TTL_SECONDS=$(echo "$TOKEN_TUNE_SETTINGS" | jq -r '.data.max_lease_ttl')

# Convert TTLs to hours
DEFAULT_LEASE_TTL_HOURS=$((DEFAULT_LEASE_TTL_SECONDS / 3600))
MAX_LEASE_TTL_HOURS=$((MAX_LEASE_TTL_SECONDS / 3600))

echo "DEFAULT_LEASE_TTL: ${DEFAULT_LEASE_TTL_HOURS}h"
echo "MAX_LEASE_TTL: ${MAX_LEASE_TTL_HOURS}h"

# Check if token settings are properly tuned to 18000h
if [ "${DEFAULT_LEASE_TTL_HOURS}h" != "18000h" ] || [ "${MAX_LEASE_TTL_HOURS}h" != "18000h" ]; then
  echo "Token settings are not properly tuned to 18000h. Please configure them correctly and try again."
  exit 1
else
  echo "Token settings are properly tuned to 18000h."
fi

# Create Token Role
echo "Creating Token Role..."
curl -sk --request POST --header "X-Vault-Token: $VAULT_TOKEN" --data "{\"allowed_policies\": \"$ALLOWED_POLICIES\", \"orphan\": false}" "$VAULT_URL/v1/auth/token/roles/$ROLE_NAME"

# Create Token
echo "Creating Token..."
TOKEN_RESPONSE=$(curl -sk --request POST --header "X-Vault-Token: $VAULT_TOKEN" "$VAULT_URL/v1/auth/token/create/$ROLE_NAME")
TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.auth.client_token')

# Check if token creation was successful
if [ $? -ne 0 ] || [ -z "$TOKEN" ]; then
  echo "AppRole token creation failed."
  exit 1
fi

# Save the token to a file
TOKEN_FILE="vault_token_$ROLE_NAME.txt"
echo "$TOKEN" > "$TOKEN_FILE"
echo "Token created and saved to $TOKEN_FILE."

# Tune token settings
echo "Tuning token settings..."
curl -sk --request POST --header "X-Vault-Token: $VAULT_TOKEN" --data '{"max_lease_ttl": "768h", "default_lease_ttl": "768h"}' "$VAULT_URL/v1/sys/auth/token/tune"

# Check token settings after tuning
echo "Checking token settings after tuning..."
TOKEN_TUNE_SETTINGS=$(curl -sk --header "X-Vault-Token: $VAULT_TOKEN" "$VAULT_URL/v1/sys/auth/token/tune")
DEFAULT_LEASE_TTL_SECONDS=$(echo "$TOKEN_TUNE_SETTINGS" | jq -r '.data.default_lease_ttl')
MAX_LEASE_TTL_SECONDS=$(echo "$TOKEN_TUNE_SETTINGS" | jq -r '.data.max_lease_ttl')

# Convert TTLs to hours
DEFAULT_LEASE_TTL_HOURS=$((DEFAULT_LEASE_TTL_SECONDS / 3600))
MAX_LEASE_TTL_HOURS=$((MAX_LEASE_TTL_SECONDS / 3600))

# Check if token settings are properly tuned to 768h
if [ "${DEFAULT_LEASE_TTL_HOURS}h" != "768h" ] || [ "${MAX_LEASE_TTL_HOURS}h" != "768h" ]; then
  echo "Token settings are not properly tuned to 768h. Please configure them correctly and try again."
  exit 1
else
  echo "Token settings are properly tuned to 768h."
fi