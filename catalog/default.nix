let
  base_nodes = import ./nodes.nix;
  nodes = builtins.mapAttrs (
    hostName: node:
    node
    // {
      inherit hostName;
      fqdn = "${hostName}.${services.coredns.domain}";
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
