let
  base_nodes = import ./nodes.nix;
  nodes = builtins.mapAttrs (
    hostName: node:
    node
    // {
      inherit hostName;
      fqdn = "${hostName}.${services.coredns.domain}";
      ip = if builtins.hasAttr "ip" node then node.ip else (if builtins.hasAttr "ips" node then builtins.head node.ips else null);
    }
  ) base_nodes;
  base_services = import ./services.nix {
    inherit nodes;
  };
  services = builtins.mapAttrs (
    name: service:
    service
    // {
      inherit name;
      fqdn = "${name}.${services.coredns.domain}";
    }
  ) base_services;
in
{
  inherit nodes services;
}
