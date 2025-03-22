{
  nixpkgs,
  home-manager,
  sops-nix,
  ...
}:
catalog: environment:
let
  inherit (nixpkgs.lib) mapAttrs nixosSystem;

  authorized_keys = import ../public-keys.nix;

  mkSystem =
    {
      hostName,
      node,
    }:
    let
      specialArgs = {
        inherit
          authorized_keys
          catalog
          environment
          hostName
          ;
        self = node;
      };
    in
    nixosSystem {
      inherit specialArgs;

      system = node.system;

      modules = [
        (nodeModule node)
        node.config
        node.hw
        home-manager.nixosModules.home-manager
        { home-manager.extraSpecialArgs = specialArgs; }
        sops-nix.nixosModules.sops
      ];
    };

  nodeModule =
    node:
    { hostName, ... }:
    {
      networking = {
        inherit hostName;
      };
    };
in
mapAttrs (
  hostName: node:
  mkSystem {
    inherit hostName node;
  }
) catalog.nodes
# {
#     work = nixpkgs.lib.nixosSystem {
#         modules = [
#         nixos-wsl.nixosModules.default
#         {
#             system.stateVersion = "24.05";
#             wsl.enable = true;
#             nixpkgs.hostPlatform = nixpkgs.lib.mkDefault "x86_64-linux";
#         }
#         ];
#     };
# };
