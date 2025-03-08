# Setup adguard on a server
{
  config,
  lib,
  catalog,
  ...
}:
with lib;
let
  cfg = config.solar-system.adguardhome;
in
{
  options = {
    solar-system.adguardhome = {
      enable = mkEnableOption "Enable AdGuard Home";
    };
  };

  config = mkIf cfg.enable {
    services.resolved.enable = false;
    services.adguardhome = {
      enable = true;
      openFirewall = true;
      mutableSettings = false;
      host = "0.0.0.0";
      port = catalog.services.adguard.port;
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
  };
}
