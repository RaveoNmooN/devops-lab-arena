#!/bin/bash

# Set the number of snapshots to keep
NUM_SNAPSHOTS=5
export VAULT_ADDR="http://$(hostname):8200"

# Define the Vault token file
VAULT_TOKEN_FILE=/vault-data/.vault-snapshot-token

# Authenticate with Vault using the specified token file
vault login $(cat $VAULT_TOKEN_FILE)

# Check if this node is the leader in the cluster
LEADER=$(vault status -format=json | jq -r '.leader_address')
if [ "$LEADER" != "$VAULT_ADDR" ]; then
  echo "Not the leader, skipping snapshot"
  exit 0
fi

# Take a snapshot of the Vault data
SNAPSHOT_FILE="/vault-dev-snapshots/pre-upgrade-snapshots/snapshot-$(hostname)-$(date +"%Y-%m-%d-%H%M%S").snap"
vault operator raft snapshot save $SNAPSHOT_FILE

# Delete old snapshots to keep only the desired number of snapshots
SNAPSHOTS=($(ls -t /vault-dev-snapshots/pre-upgrade-snapshots/*.snap))
NUM_SNAPSHOTS_FOUND=${#SNAPSHOTS[@]}
if [ $NUM_SNAPSHOTS_FOUND -gt $NUM_SNAPSHOTS ]; then
  NUM_SNAPSHOTS_TO_DELETE=$((NUM_SNAPSHOTS_FOUND - NUM_SNAPSHOTS))
  SNAPSHOT_FILES_TO_DELETE=($(ls -t /vault-dev-snapshots/pre-upgrade-snapshots/*.snap | tail -n $NUM_SNAPSHOTS_TO_DELETE))
  rm -f ${SNAPSHOT_FILES_TO_DELETE[@]}
fi