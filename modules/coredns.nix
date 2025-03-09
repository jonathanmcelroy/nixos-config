# Setup core dns on a server
{
  config,
  lib,
  catalog,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.solar-system.coredns;

  coredns_port = catalog.services.coredns.port or 53;
  ttl = 180;

  fileZone = pkgs.writeText "coredns.zone" ''
    $TTL ${toString ttl}
    $ORIGIN ${cfg.domain}.
    @     IN SOA ns.${cfg.domain} nomail (
            20250309    ; Version number of the zone file (YYYYMMDD). Should be updated when the file zone changes
            60          ; Zone refresh interval (seconds)
            30          ; Zone update retry timeout (seconds)
            180         ; Zone TTL (seconds)
            3600        ; Negative response TTL (seconds)
            ) 

    ns    IN A ${catalog.services.coredns.host.ip}

    ; hosts
    ${lib.concatMapStringsSep "\n" (node: "${node.hostName}.${cfg.domain}. ${toString ttl} IN A ${node.ip}") (builtins.attrValues catalog.nodes)}

    ; alias
    '';
in
{
  options = {
    solar-system.coredns = {
      enable = mkEnableOption "Enable CoreDNS";
      domain = mkOption {
        type = types.str;
        default = catalog.services.coredns.domain;
        description = "Domain name for the coredns server";
      };
    };
  };

  config = mkIf cfg.enable {
    services.coredns = {
      enable = true;
      extraArgs = [ "-dns.port=${toString coredns_port}" ];
      config = ''
        ${cfg.domain} {
          file ${fileZone}
          prometheus
          errors
          log
        }
      '';
    };

    networking.firewall.allowedTCPPorts = [ coredns_port ];
    networking.firewall.allowedUDPPorts = [ coredns_port ];
  };
}
