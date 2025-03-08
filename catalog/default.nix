let
  base_nodes = import ./nodes.nix;
  nodes = builtins.mapAttrs (hostName: node: node // { inherit hostName; }) base_nodes;
  base_services = import ./services.nix {
    inherit nodes;
  };
  services = builtins.mapAttrs (name: service: service // { inherit name; }) base_services;
in
{
  inherit nodes services;
}
