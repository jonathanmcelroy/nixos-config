# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, ... }:

{
  imports = [
    ../common.nix

    ../modules/system.nix
    ../modules/gnome.nix
    ../modules/simple_networking.nix

    ../users/jmcelroy/nixos.nix
    ../users/jmcelroy-dev/nixos.nix
    ../users/nixos-deploy/nixos.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  networking = {
    simpleNetworking = {
      enable = true;
      interface = "enp30s0";
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
    settings.AllowUsers = [ "nixos-deploy" ];
  };
}
