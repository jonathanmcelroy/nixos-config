# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ../../modules/system.nix
      
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jmcelroy-remote";
  systemd.network = {
    enable = true;
    networks."10-lan" = {
      matchConfig.name = "enp1s0";
      address = [
        "192.168.0.101/24"
      ];
      routes = [
        { Gateway = "192.168.0.1"; }
      ];
      linkConfig.RequiredForOnline = "routable";
      # networkConfig.DHCP = "ipv4";
    };
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # services.github-runners.runner1 = {
  #   enable = true;
  #   url = "https://github.com/jonathanmcelroy/nixos-config";
  #   user = "github-runner";
  #   group = "github-runner";
  #   tokenFile = "/etc/github-runner/token";
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
