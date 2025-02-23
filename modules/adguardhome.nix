# Setup adguard on a server
{ pkgs, ... }:
{
  services.resolved.enable = false;
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    mutableSettings = false;
    host = "0.0.0.0";
    port = 3000;
    settings = {
      dns = {
        bootstrap_dns = [
          "8.8.8.8"
          "8.8.4.4"
        ];
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
