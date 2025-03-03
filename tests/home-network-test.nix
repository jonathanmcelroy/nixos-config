{ pkgs, ... }@inputs:
let
  catalog = import ../catalog;
in
pkgs.testers.runNixOSTest (
  {
    name = "boot-test";

    testScript =
      { nodes, ... }:
      let
        # Function to get the IP address of a node
        get_ip = node: (pkgs.lib.head node.networking.interfaces.eth1.ipv4.addresses).address;

        # Collect all IPs into a dictionary
        ips = builtins.mapAttrs (name: node: get_ip node) nodes;
      in
      ''
        start_all()

        with subtest("Earth boots and its services start"):
          earth.wait_for_unit("default.target")
          earth.wait_for_unit("display-manager.service")

        with subtest("Mars boots and its services start"):
          mars.wait_for_unit("default.target")
          mars.wait_for_unit("adguardhome.service")

        with subtest("Standard users are on all hosts"):
          earth.succeed("getent passwd jmcelroy-dev")
          earth.succeed("getent passwd nixos-deploy")
          mars.succeed("getent passwd jmcelroy-dev")
          mars.succeed("getent passwd nixos-deploy")

        with subtest("Nodes can ping each other"):
          earth.succeed("ping -c 1 ${ips.mars}")
          mars.succeed("ping -c 1 ${ips.earth}")

        with subtest("Earth can access all services"):
          earth.succeed("curl ${ips.mars}:${toString catalog.services.adguard.port}")
      '';
  }
  // import ./base-test.nix inputs catalog
)
