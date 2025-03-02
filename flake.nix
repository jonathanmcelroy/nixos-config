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

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      catalog = import ./catalog;
      nixosConfigurations = import ./util/nixos-configurations.nix inputs catalog "prod";
    in
    {
      inherit nixosConfigurations;

      packages.${system} = {
        test-deploy-local = pkgs.writeShellScriptBin "test-deploy-local" ''
          #!${pkgs.bash}/bin/bash
          set -euo pipefail

          # If host is not provided, get the host from the hostname
          if [ "$#" -ge 2 ]; then
            echo "Usage: test-deploy-local [host]"
          elif [ "$#" -eq 1 ]; then
            host=$1
          else
            host=$(hostname)
          fi

          nixos-rebuild test --flake "${self}#$host" --show-trace --print-build-logs --verbose
        '';

        test-deploy = pkgs.writeShellScriptBin "test-deploy" ''
          #!${pkgs.bash}/bin/bash
          set -euo pipefail

          # Ensure that the host is provided
          if [ "$#" -ne 1 ]; then
            echo "Usage: test_deploy <host>"
            exit 1
          fi

          host=$1

          nixos-rebuild test --flake "${self}#$host" --target-host "nixos-deploy@$host" --use-remote-sudo --show-trace --print-build-logs --verbose
        '';

        test-deploy-all = pkgs.writeShellScriptBin "test-deploy-all" ''
          #!${pkgs.bash}/bin/bash
          set -euo pipefail

          for host in ${builtins.concatStringsSep " " (builtins.attrNames nixosConfigurations)}; do
            echo "Testing deployment to $host"
            nixos-rebuild test --flake "${self}#$host" --target-host "nixos-deploy@$host" --use-remote-sudo --show-trace --print-build-logs --verbose
          done
        '';

        deploy-local = pkgs.writeShellScriptBin "deploy-local" ''
          #!${pkgs.bash}/bin/bash
          set -euo pipefail

          # If host is not provided, get the host from the hostname
          if [ "$#" -ge 2 ]; then
            echo "Usage: deploy-local [host]"
          elif [ "$#" -eq 1 ]; then
            host=$1
          else
            host=$(hostname)
          fi

          nixos-rebuild switch --flake "${self}#$host" --show-trace --print-build-logs --verbose
        '';

        deploy = pkgs.writeShellScriptBin "deploy" ''
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

        deploy-all = pkgs.writeShellScriptBin "test-deploy-all" ''
          #!${pkgs.bash}/bin/bash
          set -euo pipefail

          for host in ${builtins.concatStringsSep " " (builtins.attrNames nixosConfigurations)}; do
            echo "Testing deployment to $host"
            nixos-rebuild switch --flake "${self}#$host" --target-host "nixos-deploy@$host" --use-remote-sudo --show-trace --print-build-logs --verbose
          done
        '';
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;

      # checks.x86_64-linux.marsTest = import ./tests/mars-test.nix { inherit pkgs home-manager; };
      # checks.x86_64-linux.homeTest = import ./tests/home-test.nix { inherit pkgs home-manager; };
      checks.x86_64-linux.homeNetworkTest = import ./tests/home-network-test.nix { inherit nixpkgs pkgs home-manager; };
    };
}
