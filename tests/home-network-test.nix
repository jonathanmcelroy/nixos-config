{ pkgs, home-manager, ... }:
pkgs.testers.runNixOSTest {
  name = "boot-test";

  node.pkgsReadOnly = false;

  nodes = {
    jmcelroy_home = inputs: {
      imports = [
        home-manager.nixosModules.home-manager
        ../hosts/jmcelroy-home/configuration.nix
      ];
    };

    server1 = inputs: {
      imports = [
        home-manager.nixosModules.home-manager
        ../hosts/server1/configuration.nix
      ];
    };
  };

  testScript = { nodes, ... }:
  let
    jmcelroy_home_ip = (pkgs.lib.head nodes.jmcelroy_home.networking.interfaces.eth1.ipv4.addresses).address;
    server1_ip = (pkgs.lib.head nodes.server1.networking.interfaces.eth1.ipv4.addresses).address;
  in ''
    jmcelroy_home.start()
    server1.start()

    jmcelroy_home.wait_for_unit("default.target")
    server1.wait_for_unit("default.target")

    jmcelroy_home.succeed("ping -c 1 ${server1_ip}")
    server1.succeed("ping -c 1 ${jmcelroy_home_ip}")
  '';
}
