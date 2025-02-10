{ pkgs, home-manager, ... }:
pkgs.testers.runNixOSTest {
  name = "boot-test";

  node.pkgsReadOnly = false;
  node.specialArgs = {
    usernames = [ ];
  };

  nodes.remote = inputs: {
    imports = [
      home-manager.nixosModules.home-manager
      ../hosts/server1/configuration.nix
    ];
  };

  testScript = ''
    user = "jmcelroy-dev";
    machine.wait_for_unit("default.target")
    machine.succeed(f"su -- {user} -c 'which bash'")
  '';
}
