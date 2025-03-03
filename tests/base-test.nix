{
  nixpkgs,
  home-manager,
  ...
}:
catalog:
let
  inherit (nixpkgs.lib) mapAttrs nixosSystem;

  authorized_keys = import ../public-keys.nix;

  nodeModule = hostName: node: inputs: {
    networking = {
      inherit hostName;
    };
  };

  mkNode = hostName: node: inputs: {
    imports = [
      (nodeModule hostName node)
      node.config
      home-manager.nixosModules.home-manager
    ];
  };
in
{
  node.pkgsReadOnly = false;

  node.specialArgs = {
    inherit authorized_keys catalog;
    environment = "test";
  };

  nodes = mapAttrs mkNode catalog.nodes;
}
