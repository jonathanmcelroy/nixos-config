# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, ... }:

{
  imports =
    [ 
      ../../modules/system.nix
      ../../modules/network_access.nix
      
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jmcelroy-remote";
  networking.useNetworkd = true;
  networking.wireless = {
    enable = true;
    secretsFile = "/etc/nix_wireless.conf";
    networks.TP-Link_FA99 = {
      pskRaw = "ext:psk_home_tplink";
    };
  };

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

  # Define the user for deploying nixos configuration
  users.users.github-runner = {
    isSystemUser = true;
    description = "Github runner";
    group = "github-runner";
  };
  users.groups.github-runner = {};
  services.github-runners.runner1 = {
    enable = true;
    url = "https://github.com/jonathanmcelroy/nixos-config";
    user = "github-runner";
    group = "github-runner";
    tokenFile = "/etc/github-runner/token";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
