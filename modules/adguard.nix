# Setup adguard on a server
{
  config,
  lib,
  catalog,
  ...
}:
with lib;
let
  cfg = config.solar-system.adguard;
in
{
  options = {
    solar-system.adguard = {
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
        # Refer to https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file
        dns = {
          bootstrap_dns = [
            "8.8.8.8"
            "8.8.4.4"
          ];
          upstream_dns = [
            "[/${catalog.services.coredns.domain}/]${catalog.services.coredns.host.ip}:${toString catalog.services.coredns.port}"
            https://dns10.quad9.net/dns-query
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
