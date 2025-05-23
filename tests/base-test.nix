{
  nixpkgs,
  home-manager,
  sops-nix,
  ...
}: catalog: let
  inherit (nixpkgs.lib) mapAttrs filterAttrs nixosSystem;

  nixosNodes = filterAttrs (name: node: builtins.hasAttr "system" node) catalog.nodes;

  authorized_keys = import ../public-keys.nix;

  specialArgs = {
    inherit authorized_keys catalog;
    environment = "test";
  };

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
      {home-manager.extraSpecialArgs = specialArgs;}
      sops-nix.nixosModules.sops
    ];
  };
in {
  node.pkgsReadOnly = false;

  node.specialArgs = specialArgs;

  nodes = mapAttrs mkNode nixosNodes;
}
