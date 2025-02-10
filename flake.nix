{
  description = "Jonathan's Nixos config flake";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # We use the unstable nixpkgs repo for some packages.
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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
  }: let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.${system}.deploy = pkgs.writeShellScriptBin "deploy" ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail

      # Ensure that the host is provided
      if [ "$#" -ne 1 ]; then
        echo "Usage: deploy <host>"
        exit 1
      fi

      host=$1

      nixos-rebuild switch --flake "${self}#$host" --target-host "nixos-deploy@$host" --use-remote-sudo --show-trace --print-build-logs --verbose
    '';

    nixosConfigurations = {
      jmcelroy-home = let 
        usernames = [
          "jmcelroy"
          "jmcelroy-dev"
        ];
        specialArgs = {inherit usernames;};
      in nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          home-manager.nixosModules.home-manager 
          ./hosts/jmcelroy-home/configuration.nix
          ./hosts/jmcelroy-home/hardware-configuration.nix
        ];
      };
      server1 = let
        usernames = [
          "jmcelroy-remote"
          "jmcelroy-dev"
          "nixos-deploy"
        ];
        specialArgs = {inherit usernames;};
      in nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/server1/configuration.nix
          ./hosts/server1/hardware-configuration.nix
        ];
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
            nixpkgs.hostPlatform = nixpkgs.lib.mkDefault "x86_64-linux";
          }
        ];
      };
    };

    checks.x86_64-linux.server1Test = import ./tests/server1-test.nix { inherit pkgs home-manager; };
    checks.x86_64-linux.homeTest = import ./tests/home-test.nix { inherit pkgs home-manager; };
  };
}
