{ pkgs, ... }@inputs:
let
  catalog = import ../catalog;
in pkgs.testers.runNixOSTest ({
  name = "boot-test";

  testScript = { nodes, ... }:
  let
    earth_ip = (pkgs.lib.head nodes.earth.networking.interfaces.eth1.ipv4.addresses).address;
    server1_ip = (pkgs.lib.head nodes.server1.networking.interfaces.eth1.ipv4.addresses).address;
  in ''
    earth.start()
    server1.start()

    earth.wait_for_unit("default.target")
    server1.wait_for_unit("default.target")

    earth.succeed("ping -c 1 ${server1_ip}")
    server1.succeed("ping -c 1 ${earth_ip}")
  '';
} // import ./base-test.nix inputs catalog)
