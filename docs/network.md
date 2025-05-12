## Requirements

1. If you join the network via Ethernet, by default you are given an IP and will be using the VPN for public requests
2. You can assign a static IP that will bypass the VPN for public requests
3. If you join one WiFi network, you are given an IP and will be using the VPN for public requests
4. If you join the other WiFi network, you are given an IP and will bypass the VPN for public requests
5. Anyone who joins the network will be able to access the IP of anyone else who joins the network, no isolation.

## VLANs

| VLAN | Name           | Purpose                                 |
| ---- | -------------- | --------------------------------------- |
| 01   | Default        | Untagged traffic through VPN VLAN       |
| 02   | WAN            | The WAN side of the routes              |
| 10   | VPN            | Routes external traffic through VPN     |
| 20   | Direct         | Routes external traffic directly to WAN |

**Note**: All VLANs but WAN have full access to communicate with each other.

## Subnets and IP Ranges

| VLAN | Subnet          | DHCP Range         | Static IP Range | Gateway      |
| ---- | --------------- | ------------------ | --------------- | ------------ |
| 01   | 192.168.1.0/24  | 192.168.1.100-250  | 192.168.1.2-99  | 192.168.1.1  |
| 10   | 192.168.10.0/24 | 192.168.10.100-250 | 192.168.10.2-99 | 192.168.10.1 |
| 20   | 192.168.20.0/24 | 192.168.20.100-250 | 192.168.20.2-99 | 192.168.20.1 |

## WiFi

| SSID         | VLAN | 
| ------------ | ---- | 
| jonathan-vpn | 10   | 
| jonathan     | 20   | 

# Testing

To test the network configuration, you can run these commands:

## Test ping to a gateway

```bash
ping -c 4 -I $INTERFACE $GATEWAY
```

## Test ping to the internet

```bash
ping -c 4 -I $INTERFACE 8.8.8.8
```