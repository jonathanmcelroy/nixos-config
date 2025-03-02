let 
    nodes = import ./nodes.nix;
    services = import ./services.nix {
        inherit nodes;
    };
in {
    inherit nodes services;
}