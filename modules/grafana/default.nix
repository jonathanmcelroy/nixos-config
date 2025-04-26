# This file defines the configuration to easily access all the servers in the network
{
  config,
  lib,
  pkgs,
  catalog,
  ...
}:
with lib; let
  cfg = config.solar-system.grafana;

  grafana-dashboards = pkgs.stdenv.mkDerivation {
    name = "grafana-dashboards";
    src = ./.;
    installPhase = ''
      mkdir -p $out
      install -D -m755 $src/dashboards/*.json $out/
    '';
  };
in {
  options = {
    solar-system.grafana = {
      enable = mkEnableOption "Enable Grafana";
      domain = mkOption {
        type = types.str;
        default = catalog.services.grafana.fqdn;
        description = "Domain name for the Grafana server";
      };
      host = mkOption {
        type = types.str;
        description = "The IP address to bind Grafana to";
        default = catalog.services.grafana.host.ip;
      };
      port = mkOption {
        type = types.int;
        description = "The port to bind Grafana to";
        default = catalog.services.grafana.port;
      };
    };
  };

  config = mkIf cfg.enable {
    sops.templates."grafana-contact-points.yaml" = {
      content = ''
        apiVersion: 1
        contactPoints:
          - orgId: 1
            name: Discord
            receivers:
              - uid: ceg1ota03wzr5d
                type: discord
                settings:
                  url: "${config.sops.placeholder.grafana-discord-alert-webhook}"
                  use_discord_username: false
                disableResolveMessage: false
      '';
      owner = "grafana";
    };

    services.grafana = {
      enable = true;
      settings = {
        analytics.reporting_enabled = false;
        server = {
          http_addr = cfg.host;
          http_port = cfg.port;
          domain = cfg.domain;
        };
        # security = {
        #   admin_user = "admin";
        #   admin_password = "admin";
        # };
        # users = {
        #   allow_sign_up = false;
        # };
      };
      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://${catalog.services.prometheus.fqdn}:${toString catalog.services.prometheus.port}";
          }
        ];
        dashboards.settings.providers = [
          {
            name = "default";
            options.path = grafana-dashboards;
          }
        ];
        alerting = {
          contactPoints.path = config.sops.templates."grafana-contact-points.yaml".path;
          rules.path = ./alerts.yaml;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [cfg.port];
  };
}
