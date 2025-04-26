# This file defines the configuration to easily access all the servers in the network
{
  config,
  lib,
  pkgs,
  catalog,
  ...
}:
with lib; let
  cfg = config.solar-system.prometheus;
in {
  options = {
    solar-system.prometheus = {
      enable = mkEnableOption "Enable Prometheus";
    };
  };

  config = mkIf cfg.enable {
    services.prometheus = {
      enable = true;

      listenAddress = catalog.services.prometheus.host.ip;
      port = catalog.services.prometheus.port;

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = map (node: "${node.fqdn}:${toString catalog.services.prometheus.node_exporter_port}") (
                attrValues catalog.nodes
              );
            }
          ];
        }
      ];
    };

    networking.firewall.allowedTCPPorts = [catalog.services.prometheus.port];
  };
}
