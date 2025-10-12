let
  decorate_node = hostName: node:
    node
    // {
      inherit hostName;
      fqdn = "${hostName}.${services.coredns.domain}";
      ip =
        if builtins.hasAttr "ip" node
        then node.ip
        else
          (
            if builtins.hasAttr "ips" node
            then builtins.head node.ips
            else null
          );
    };
  decorate_service = name: service:
    service
    // {
      inherit name;
      fqdn = "${name}.${services.coredns.domain}";
    };

  base_nodes = import ./nodes.nix;
  nodes = builtins.mapAttrs decorate_node base_nodes;

  base_services = import ./services.nix {
    inherit nodes;
  };
  services = builtins.mapAttrs decorate_service base_services;
in {
  inherit nodes services;
  subnets = import ./subnets.nix;
}
