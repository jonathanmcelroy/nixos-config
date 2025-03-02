{
    earth = {
        ip = "192.168.0.10";
        hw = ../hw/earth.nix;
        config = ../hosts/earth.nix;
        system = "x86_64-linux";
    };
    server1 = {
        ip = "192.168.0.11";
        hw = ../hw/mars.nix;
        config = ../hosts/mars.nix;
        system = "x86_64-linux";
    };

}