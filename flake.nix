{
  description = "Jonathan's Nixos config flake";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Build a custom WSL installer
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { 
    self,
    nixpkgs,
    home-manager,
    nixos-wsl,
    ...
  }: {
    nixosConfigurations = {
      default = let 
        usernames = [
          "jmcelroy"
          "jmcelroy-dev"
        ];
        specialArgs = {inherit usernames;};
      in nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/default/configuration.nix
          ./users/jmcelroy/nixos.nix
          ./users/jmcelroy-dev/nixos.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = inputs // specialArgs;
            home-manager.users.jmcelroy = import ./users/jmcelroy/home.nix;
            home-manager.users.jmcelroy-dev = import ./users/jmcelroy-dev/home.nix;
          }
        ];
        # modules = [
        #   ./hosts/default/configuration.nix
        # ] ++ builtins.concatMap (username: [
        #   ./users/${username}/nixos.nix
        #   home-manager.nixosModules.home-manager {
        #     home-manager.useGlobalPkgs = true;
        #     home-manager.useUserPackages = true;

        #     home-manager.extraSpecialArgs = inputs // specialArgs // {inherit username; };
        #     home-manager.users.${username} = import ./users/${username}/home.nix;
        #   }
        # ]) usernames;
      };
      work = let
        usernames = [
          "jmcelroy-dev"
        ];
        specialArgs = {inherit usernames;};
      in nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "24.05";
            wsl.enable = true;
          }
        ];
      };
    };
  };
}
