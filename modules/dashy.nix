# Setup dashy dashboard on a server
{
  config,
  lib,
  catalog,
  ...
}:
with lib;
let
  cfg = config.solar-system.dashy;

  # Group services by section
  grouped_services = builtins.groupBy (service: service.dashy.section) (builtins.attrValues catalog.services);

  # Calculate the dashy sections array
  dashy_sections = builtins.attrValues (builtins.mapAttrs (section: services: {
    name = section;
    items = builtins.map (service: {
      title = service.name;
      description = service.dashy.description;
      icon = service.dashy.icon;
      url = "http://${service.host.hostName}:${toString service.port}";
    }) services;
  }) grouped_services);
in
{
  options = {
    solar-system.dashy = {
      enable = mkEnableOption "Enable Dashy";
      domain = mkOption {
        type = types.str;
        default = config.networking.hostName;
        description = "Domain name for the dashy dashboard";
      };
    };
  };

  config = mkIf cfg.enable {
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
          # disableConfiguration = true;
          hideComponents = {
            hideSettings = true;
          };
        };
        sections = dashy_sections;
      };
    };
    networking.firewall.allowedTCPPorts = [ 80 ];

  };
}
