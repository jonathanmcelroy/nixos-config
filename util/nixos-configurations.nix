{
    nixpkgs,
    home-manager,
    ...
}: 
catalog:
environment:
let 
    inherit (nixpkgs.lib) mapAttrs nixosSystem;

    authorized_keys = import ../public-keys.nix;

    mkSystem = {
        hostName,
        node,
    }: nixosSystem {
        system = node.system;

        specialArgs = {
            inherit authorized_keys catalog environment hostName;
            self = node;
        };

        modules = [
            (nodeModule node)
            node.config
            node.hw
            home-manager.nixosModules.home-manager
        ];
    };

    nodeModule = node:
        { hostName, ... }:
        {
            networking = { 
                inherit hostName;
            };
        };
in mapAttrs (
    hostName: node:
    mkSystem {
        inherit hostName node;
    }
) catalog.nodes
# {
#     jmcelroy-home = nixpkgs.lib.nixosSystem {
#         modules = [
#         home-manager.nixosModules.home-manager
#         ./hosts/jmcelroy-home/configuration.nix
#         ./hosts/jmcelroy-home/hardware-configuration.nix
#         ];
#     };
#     server1 = nixpkgs.lib.nixosSystem {
#         modules = [
#         home-manager.nixosModules.home-manager
#         ./hosts/server1/configuration.nix
#         ./hosts/server1/hardware-configuration.nix
#         ];
#     };
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