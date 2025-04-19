#!/usr/bin/env python3
import json
import subprocess
import os

DIRNAME = os.path.dirname(os.path.abspath(__file__))
CATALOG_PATH = os.path.join(DIRNAME, "..", "..", "catalog", "default.nix")

def get_inventory():
    # Evaluate the Nix expression and get the catalog as JSON
    nix_output = subprocess.check_output(["nix", "eval", "--json", "-f", CATALOG_PATH])
    servers = json.loads(nix_output)

    # Convert the Nix data into an Ansible inventory format
    inventory = {
        "_meta": {
            "hostvars": {}
        },
        "all": {
            "hosts": [],
            "children": []
        }
    }

    for name, props in servers["nodes"].items():
        inventory["_meta"]["hostvars"][name] = {
            "ansible_host": props["ip"],
            "roles": props.get("roles", [])
        }
        inventory["all"]["hosts"].append(name)

        # Add roles as groups
        for role in props.get("roles", []):
            if role not in inventory:
                inventory[role] = {"hosts": []}
            inventory[role]["hosts"].append(name)

    return inventory

if __name__ == "__main__":
    print(json.dumps(get_inventory(), indent=2))