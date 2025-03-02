{ pkgs, ... }@inputs:
let
  catalog = import ../catalog;
in pkgs.testers.runNixOSTest ({
  name = "boot-test";

  testScript = { nodes, ... }:
  let
    jmcelroy_home_ip = (pkgs.lib.head nodes.earth.networking.interfaces.eth1.ipv4.addresses).address;
    server1_ip = (pkgs.lib.head nodes.server1.networking.interfaces.eth1.ipv4.addresses).address;
  in ''
    jmcelroy_home.start()
    server1.start()

    jmcelroy_home.wait_for_unit("default.target")
    server1.wait_for_unit("default.target")

    jmcelroy_home.succeed("ping -c 1 ${server1_ip}")
    server1.succeed("ping -c 1 ${jmcelroy_home_ip}")
  '';
} // import ./base-test.nix inputs catalog)
