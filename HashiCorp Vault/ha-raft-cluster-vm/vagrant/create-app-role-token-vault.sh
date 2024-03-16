#!/bin/bash

# Prompt for the Vault login token
VAULT_TOKEN="$(systemd-ask-password "Enter your Vault login token:")"

# Prompt for the role name
read -p "Enter the role name (e.g., network-nautobot): " ROLE_NAME

# Prompt for allowed policies
read -p "Enter allowed policies (comma-separated): " ALLOWED_POLICIES

# Login to Vault
echo "Logging in to Vault..."
LOGIN_RESPONSE=$(vault login -format=json $VAULT_TOKEN)

# Check if login was successful
if [ $? -ne 0 ]; then
  echo "Vault login failed. Please check your token and try again."
  exit 1
fi


# Tune token settings
echo "Tuning token settings..."
vault write sys/auth/token/tune max_lease_ttl=18000h default_lease_ttl=18000h


# Check token settings after tuning
echo "Checking token settings after tuning..."
TOKEN_TUNE_SETTINGS=$(vault read -format=json sys/auth/token/tune)
DEFAULT_LEASE_TTL_SECONDS=$(echo $TOKEN_TUNE_SETTINGS | jq -r .data.default_lease_ttl)
MAX_LEASE_TTL_SECONDS=$(echo $TOKEN_TUNE_SETTINGS | jq -r .data.max_lease_ttl)

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
vault write auth/token/roles/$ROLE_NAME allowed_policies=$ALLOWED_POLICIES orphan=false


# Create Token
echo "Creating Token..."
TOKEN=$(vault token create -field=token -role=$ROLE_NAME -no-default-policy=true)


# Check if token creation was successful
if [ $? -ne 0 ]; then
  echo "AppRole token creation failed."
  exit 1
fi


# Save the token to a file
TOKEN_FILE="vault_token_$ROLE_NAME.txt"
echo $TOKEN > $TOKEN_FILE
echo "Token created and saved to $TOKEN_FILE."


# Tune token settings
echo "Tuning token settings..."
vault write sys/auth/token/tune max_lease_ttl=768h default_lease_ttl=768h


echo "Checking token settings after tuning..."
TOKEN_TUNE_SETTINGS=$(vault read -format=json sys/auth/token/tune)
DEFAULT_LEASE_TTL_SECONDS=$(echo $TOKEN_TUNE_SETTINGS | jq -r .data.default_lease_ttl)
MAX_LEASE_TTL_SECONDS=$(echo $TOKEN_TUNE_SETTINGS | jq -r .data.max_lease_ttl)

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