{
  earth = {
    ip = "192.168.10.10";
    ipv6 = "fd::10";
    hw = ../hw/earth.nix;
    config = ../hosts/earth.nix;
    system = "x86_64-linux";
    roles = ["nixos"];
  };
  mars = {
    ip = "192.168.10.11";
    ipv6 = "fd::11";
    hw = ../hw/mars.nix;
    config = ../hosts/mars.nix;
    system = "x86_64-linux";
    roles = ["critical" "nixos"];
  };

  sun = {
    ips = [
      "192.168.1.1"
      "192.168.0.1"
      "192.168.10.1"
      "192.168.20.1"
    ];
    roles = ["router" "openwrt"];
  };
}
