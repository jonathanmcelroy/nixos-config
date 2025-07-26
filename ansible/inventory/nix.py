#!/usr/bin/env python3
import json
import os
import subprocess
import sys

DIRNAME = os.path.dirname(os.path.abspath(__file__))
CATALOG_PATH = os.path.join(DIRNAME, "..", "..", "catalog", "default.nix")

def get_inventory():
    # Evaluate the Nix expression and get the catalog as JSON
    nix_output = subprocess.check_output(["nix", "eval", "--json", "-f", CATALOG_PATH])
    catalog = json.loads(nix_output)

    subnets = catalog.get("subnets", {})
    nodes = catalog.get("nodes", {})

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


    for name, props in nodes.items():
        if "ip" not in props:
            raise ValueError(f"Node '{name}' does not have an IP address.")

        roles = props.get("roles", [])

        hostvars = {
            "ansible_host": props["ip"],
            "roles": roles,
        }

        # Only include networks if the node is a router
        if "router" in roles:
            hostvars["subnets"] = subnets

        inventory["_meta"]["hostvars"][name] = hostvars
        inventory["all"]["hosts"].append(name)

        # Add roles as groups
        for role in roles:
            if role not in inventory:
                inventory[role] = {"hosts": []}
            inventory[role]["hosts"].append(name)

    return inventory

if __name__ == "__main__":
    try:
        print(json.dumps(get_inventory(), indent=2))
    except Exception as e:
        print(f"Error generating inventory: {e}", file=sys.stderr)
        exit(1)