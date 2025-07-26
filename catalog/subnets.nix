let
  net = import ../util/net.nix {} ;

  base_networks = {
    trusted = {
      description = "Workstations, laptops, NAS's, admin devices, etc";
      cidr = "192.168.1.0/24";
      vlanId = 1;
      vlan_tagged = false;
      gatewayPolicy = "wan";
      allowOutboundTo = ["any"];
    };
    # wan = {
    #   description = "WAN network for internet access";
    #   vlanId = 2;
    #   gatewayPolicy = "uplink";
    # };
    trusted_vpn = {
      description = "Workstations, laptops, admin devices, etc that need VPN";
      cidr = "192.168.5.0/24";
      vlanId = 5;
      gatewayPolicy = "vpn";
      allowOutboundTo = ["any"];
    };
    guest = {
      description = "Guest network for visitors, IoT devices, etc";
      cidr = "192.168.20.0/24";
      vlanId = 20;
      gatewayPolicy = "wan";
      allowOutboundTo = ["dmz_public" "dmz_private" "dmz_private_vpn"];
    };
    guest_vpn = {
      description = "Guest network for visitors, IoT devices, etc that need VPN";
      cidr = "192.168.21.0/24";
      vlanId = 21;
      gatewayPolicy = "vpn";
      allowOutboundTo = ["dms_public" "dmz_private" "dmz_private_vpn"];
    };
    dmz_public = {
      description = "Public services, like web servers, mail servers, etc";
      cidr = "192.168.30.0/24";
      vlanId = 30;
      gatewayPolicy = "wan";
      allowOutboundTo = [];
    };
    dmz_private = {
      description = "Private services, like databases, internal services, etc";
      cidr = "192.168.31.0/24";
      vlanId = 31;
      gatewayPolicy = "wan";
      allowOutboundTo = ["dmz_public" "dmz_private_vpn"];
    };
    dmz_private_vpn = {
      description = "Private services that need outgoing via the VPN";
      cidr = "192.168.32.0/24";
      vlanId = 32;
      gatewayPolicy = "vpn";
      allowOutboundTo = ["dmz_public" "dmz_private"];
    };
    wan_out = {
      description = "Hosts that only need to access the internet, like smart devices";
      cidr = "192.168.40.0/24";
      vlanId = 40;
      gatewayPolicy = "wan";
      allowOutboundTo = [];
    };

    # vpn_in = {
    #   description = "Incoming VPN hosts that need access to the internal network";
    #   cidr = "10.8.0.0/24";
    # };
  };

  decorate_network = name: network:
    network
    // {
      inherit name;

      # The gateway for each network is always the first IP in the network
      gateway = 
        if builtins.hasAttr "cidr" network
        then net.lib.net.cidr.host 1 network.cidr
        else null;
    };

  networks = builtins.mapAttrs decorate_network base_networks;
in {
  inherit networks;
}
