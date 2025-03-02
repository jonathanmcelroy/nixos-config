# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ../common.nix

    ../modules/system.nix
    ../modules/simple_networking.nix
    ../modules/adguardhome.nix

    ../users/jmcelroy-dev/nixos.nix
    ../users/nixos-deploy/nixos.nix
    ../users/github-runner/nixos.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  networking = {
    simpleNetworking = {
      enable = true;
      interfaces = [ "enp1s0" ];
    };

    # wireless = {
    #   enable = true;
    #   secretsFile = "/etc/nix_wireless.conf";
    #   networks.TP-Link_FA99 = {
    #     pskRaw = "ext:psk_home_tplink";
    #   };
    # };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  services.dashy = {
    enable = true;
    virtualHost = {
      enableNginx = true;
      domain = "mars";
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
