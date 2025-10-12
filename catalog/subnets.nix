let
  net = import ../util/net.nix {};

  base_zones = {
    trusted = {
      canAccess = ["guest" "dmz_private" "dmz_public" "wan" "protonvpn"];
    };
    guest = {
      canAccess = ["dmz_private" "dmz_public" "wan" "protonvpn"];
    };
    dmz_private = {
      canAccess = ["dmz_public" "wan" "protonvpn"];
    };
    dmz_public = {
      canAccess = ["wan" "protonvpn"];
    };
    wan = {
      egress = true;
      canAccess = [];
    };
    protonvpn = {
      extra_networks = ["protonvpn"];
      egress = true;
      canAccess = [];
    };
  };
  base_networks = {
    trusted = {
      description = "Workstations, laptops, NAS's, admin devices, etc";
      cidr = "192.168.10.0/24";
      vlanId = 10;
      vlan_tagged = false;
      gatewayPolicy = "wan";
      zone = "trusted";
    };
    wan = {
      description = "WAN network for internet access";
      vlanId = 2;
      gatewayPolicy = "uplink";
      zone = "wan";
    };
    trusted_vpn = {
      description = "Workstations, laptops, admin devices, etc that need VPN";
      cidr = "192.168.11.0/24";
      vlanId = 11;
      gatewayPolicy = "vpn";
      zone = "trusted";
    };
    guest = {
      description = "Guest network for visitors, IoT devices, etc";
      cidr = "192.168.20.0/24";
      vlanId = 20;
      gatewayPolicy = "wan";
      zone = "guest";
    };
    guest_vpn = {
      description = "Guest network for visitors, IoT devices, etc that need VPN";
      cidr = "192.168.21.0/24";
      vlanId = 21;
      gatewayPolicy = "vpn";
      zone = "guest";
    };
    dmz_pub = {
      description = "Public services, like web servers, mail servers, etc";
      cidr = "192.168.30.0/24";
      vlanId = 30;
      gatewayPolicy = "wan";
      zone = "dmz_public";
    };
    dmz_priv = {
      description = "Private services, like databases, internal services, etc";
      cidr = "192.168.31.0/24";
      vlanId = 31;
      gatewayPolicy = "wan";
      zone = "dmz_private";
    };
    dmz_priv_vpn = {
      description = "Private services that need outgoing via the VPN";
      cidr = "192.168.32.0/24";
      vlanId = 32;
      gatewayPolicy = "vpn";
      zone = "dmz_private";
    };
    wan_out = {
      description = "Hosts that only need to access the internet, like smart devices";
      cidr = "192.168.40.0/24";
      vlanId = 40;
      gatewayPolicy = "wan";
      zone = "guest";
    };

    # vpn_in = {
    #   description = "Incoming VPN hosts that need access to the internal network";
    #   cidr = "10.8.0.0/24";
    # };
  };

  decorate_zone = name: zone:
    assert (
      builtins.all (x: builtins.hasAttr x zones) zone.canAccess
    );
      zone
      // {
        inherit name;
      };
  zones = builtins.mapAttrs decorate_zone base_zones;

  decorate_network = name: network: let
    # The gateway for each network is always the first IP in the network
    gateway =
      if builtins.hasAttr "cidr" network
      then net.lib.net.cidr.host 1 network.cidr
      else null;
  in
    assert (
      builtins.stringLength name <= 12
    );
    assert (
      builtins.hasAttr network.zone zones
    );
      network
      // {
        inherit name gateway;
        gatewayCidr =
          if !(builtins.isNull gateway)
          then gateway + "/24"
          else null;
      };

  networks = builtins.mapAttrs decorate_network base_networks;
in
  # Assert that all zones only reference other zones
  assert (
    builtins.all (z: builtins.all (x: builtins.hasAttr x zones) z.canAccess) (builtins.attrValues zones)
  ); {
    inherit networks zones;

    forwarding_rules =
      builtins.concatMap
      (zone:
        map (dest: {
          inherit dest;
          src = zone.name;
        })
        zone.canAccess)
      (builtins.attrValues zones);
  }
