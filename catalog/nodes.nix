{
  earth = {
    ip = "192.168.1.10";
    hw = ../hw/earth.nix;
    config = ../hosts/earth.nix;
    system = "x86_64-linux";
    roles = ["nixos"];
  };
  mars = {
    ip = "192.168.0.11";
    hw = ../hw/mars.nix;
    config = ../hosts/mars.nix;
    system = "x86_64-linux";
    roles = ["critical" "nixos"];
  };

  sun = {
    ips = [
      "192.168.1.1"
      "192.168.0.1"
    ];
    roles = ["router" "openwrt"];
  };
}
