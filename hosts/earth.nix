# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, ... }:

{
  imports = [
    ../common.nix

    ../modules/sound.nix
    ../modules/gnome.nix
    ../modules/adguardhome.nix
    ../modules/networking.nix

    ../users/jmcelroy/nixos.nix
    ../users/jmcelroy-dev/nixos.nix
    ../users/nixos-deploy/nixos.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  solar-system = {
    networking = {
      enable = true;
      interface = "enp30s0";
    };
    gnome.enable = true;
    sound.enable = true;
  };

  # Enable CUPS for printing
  services.printing.enable = true;

  # Only allow nixos-deploy to remote in
  services.openssh.settings.AllowUsers = [ "nixos-deploy" ];
}
