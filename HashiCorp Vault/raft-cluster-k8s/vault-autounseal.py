# This is a script that is used to unseal the HashiCorp Vault server. 
# It is recommended to use it only in development and testing environments! Don't use auto-unseal method in production environments.

import os
import sys
import time
import datetime
from pprint import pprint
import requests
import base64
import json
from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

VERSION = "0.1"
ENV_PREFIX = "VU_"

def debug_is_enabled():
    return ENV_PREFIX + "DEBUG" in os.environ

def log(string):
    timestamp = datetime.datetime.fromtimestamp(time.time()).strftime('%Y-%m-%d %H:%M:%S')
    sys.stdout.write(f"[{timestamp}] {string}\n")

def debug(string):
    if debug_is_enabled():
        log(f"DEBUG: {string}")

def print_param_error(name):
    log(f"Error: {name} is not specified. Specify it either in the Kubernetes Secret or as an environment variable prefixed with {ENV_PREFIX}")

def get_k8s_secret(secret_name):
    try:
        with open('/secrets/vault-tokens.json', 'rb') as file:
            base64_encoded_data = file.read()

        # Decode the base64-encoded data and parse it as JSON
        decoded_data = json.loads(base64.b64decode(base64_encoded_data).decode('utf-8'))
        return decoded_data
    except Exception as e:
        log(f"Error retrieving secret {secret_name}: {e}")
    return None

if __name__ == "__main__":
    log(f"vault-unseal.py VERSION {VERSION}")

    if debug_is_enabled():
        debug("Dumping environment block:")
        pprint(dict(os.environ))

    # Retrieve secrets securely
    secret_data = get_k8s_secret("vault-tokens.json")

    if not secret_data:
        log("Error: Failed to retrieve vault-unseal-secret1 from Kubernetes.")
        sys.exit(1)

    # Ensure that secret_data is a dictionary before accessing its keys
    if not isinstance(secret_data, dict):
        log("Error: Failed to parse secret data as JSON.")
        sys.exit(1)

    # Retrieve the necessary configuration parameters
    time_interval_seconds = int(secret_data.get("TIME_INTERVAL_SECONDS", "0"))
    address_urls = []
    unseal_keys = {}

    # Retrieve address URLs and unseal keys
    for i in range(1, 4):  # Assuming 3 address URLs
        url_key = f"ADDRESS_URL_{i}"
        key_key = f"UNSEAL_KEY_{i}"

        if url_key in secret_data:
            address_urls.append(secret_data[url_key])

        if key_key in secret_data:
            unseal_keys[key_key] = secret_data[key_key]

    # Ensure all required parameters are present
    if time_interval_seconds <= 0 or not address_urls or not unseal_keys:
        log("Error: Not all required parameters are available in vault-tokens.json.")
        sys.exit(1)

    log(f"TIME_INTERVAL_SECONDS = {time_interval_seconds}")
    log("Number of unseal keys: " + str(len(unseal_keys)))
    debug("UNSEAL_KEYS:")
    for key in unseal_keys:
        debug(f"- {key}")

    while True:
        try:
            for address_url in address_urls:
                log(address_url)
                r = requests.get(f"{address_url}/v1/sys/seal-status", verify=False).json()
                debug(f"status:{r}")
                if r.get("sealed", None):
                    log("Detected sealed vault. Unsealing...")
                    for key in unseal_keys.values():
                        debug(f"key:{key}")
                        r = requests.put(f"{address_url}/v1/sys/unseal", verify=False, json={"key": key}).json()
                        debug(f"unseal:{r}")
                    if r["sealed"]:
                        log("Something went wrong, failed to unseal. Check the keys.")
                        log(r)
                        sys.exit(2)
                    else:
                        log("Unsealed successfully")
                else:
                    log("Error: Cannot find 'sealed' in returned JSON.")
                    pprint(r)
        except Exception as e:
            log(f"Exception: {e}")
            log(type(e))
            pprint(vars(e))
            sys.exit(1)
        time.sleep(time_interval_seconds)
