{
  pkgs,
  home-manager,
  ...
}:
pkgs.testers.runNixOSTest {
  name = "boot-test";

  node.pkgsReadOnly = false;
  node.specialArgs = {
    usernames = [];
  };

  nodes.remote = inputs: {
    imports = [
      home-manager.nixosModules.home-manager
      ../hosts/earth/configuration.nix
    ];
  };

  testScript = ''
    machine.wait_for_unit("default.target")
    machine.succeed("su -- jmcelroy -c 'which bash'")
  '';
}
