# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, catalog, ... }:

{
  imports = [ ../common.nix ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  solar-system = {
    networking = {
      enable = true;
      interface = "enp1s0";
    };

    adguardhome.enable = true;
    github-runner.enable = true;
  };

  services.dashy = {
    enable = true;
    virtualHost = {
      enableNginx = true;
      domain = "mars";
    };

    settings = {
      pageInfo = {
        title = "Solar System";
        description = "Dashboard for all the services in the solar system";
        navLinks = [
          {
            title = "Documentation";
            path = "https://dashy.to/docs";
          }
        ];
      };
      appConfig = {
        theme = "colorful";
        statusCheck = true;
        disableConfiguration = true;
        hideComponents = {
          hideSettings = true;
        };
      };
      sections = [
        {
          name = "Networking";
          items = [
            {
              title = "AdGuard";
              description = "AdGuard Ad Blocker";
              url = "http://${catalog.services.adguard.host.hostName}:${toString catalog.services.adguard.port}";
            }
          ];
        }
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 ];
}
