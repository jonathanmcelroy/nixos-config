{ pkgs, ... }@inputs:
let
  catalog = import ../catalog;
in pkgs.testers.runNixOSTest ({
  name = "boot-test";

  testScript = { nodes, ... }:
  let
    # Function to get the IP address of a node
    getIp = node: (pkgs.lib.head node.networking.interfaces.eth1.ipv4.addresses).address;

    # Collect all IPs into a dictionary
    ips = builtins.mapAttrs (name: node: getIp node) nodes;
  in ''
    earth.start()
    mars.start()

    earth.wait_for_unit("default.target")

    mars.wait_for_unit("default.target")
    mars.wait_for_unit("adguardhome.service")

    earth.succeed("ping -c 1 ${ips.mars}")
    mars.succeed("ping -c 1 ${ips.earth}")

    earth.succeed("curl ${ips.mars}:${toString catalog.services.adguard.port}")
  '';
} // import ./base-test.nix inputs catalog)
