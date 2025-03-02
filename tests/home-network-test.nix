{ pkgs, ... }@inputs:
let
  catalog = import ../catalog;
in pkgs.testers.runNixOSTest ({
  name = "boot-test";

  testScript = { nodes, ... }:
  let
    earth_ip = (pkgs.lib.head nodes.earth.networking.interfaces.eth1.ipv4.addresses).address;
    mars_ip = (pkgs.lib.head nodes.mars.networking.interfaces.eth1.ipv4.addresses).address;
  in ''
    earth.start()
    mars.start()

    earth.wait_for_unit("default.target")
    mars.wait_for_unit("default.target")

    earth.succeed("ping -c 1 ${mars_ip}")
    mars.succeed("ping -c 1 ${earth_ip}")
  '';
} // import ./base-test.nix inputs catalog)
