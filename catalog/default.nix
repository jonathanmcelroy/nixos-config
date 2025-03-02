let 
    base_nodes = import ./nodes.nix;
    nodes = builtins.mapAttrs (hostName: node: node // { inherit hostName; }) base_nodes;
    services = import ./services.nix {
        inherit nodes;
    };
in {
    inherit nodes services;
}