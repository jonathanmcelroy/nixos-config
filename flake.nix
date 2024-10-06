{
  description = "Jonathan's Nixos config flake";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Build a custom WSL installer
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/default/configuration.nix
        # inputs.home-manager.nixosModules.default
      ];
    };
  };


  # outputs = inputs @ { 
  #   self,
  #   nixpkgs,
  #   home-manager,
  #   ...
  # }: {
  #   nixosConfigurations = {
  #     default = let
  #       username = "jmcelroy";
  #       specialArgs = {inherit username;};
  #     in nixpkgs.lib.nixosSystem {
  #       inherit specialArgs;
  #       system = "x86_64-linux";

  #       modules = [
  #         ./hosts/default
  #         ./users/${username}/nixos.nix

  #         home-manager.nixosModules.home-manager {
  #           home-manager.extraSpecialArgs = inputs // specialArgs;
  #           home-manager.users.${username} = import ./users/${username}/home.nix;
  #         }
  #       ];
  #     };
  #   };
  # };
}
