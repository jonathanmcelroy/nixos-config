## Requirements

1. If a host joins the network via Ethernet with no config, it is trusted and uses the WAN for outgoing traffic.
2. If a host joins the vpn WiFi network, it is put into the guest vlan and uses VPN for outgoing traffic
3. If a host joins the wan WiFi network, it is put into the guest vlan and uses WAN for outgoing traffic
4. The network needs to have a zone for public services that trusted hosts and guests can access
5. The network needs to have a zone for private services that trusted hosts and guests can access

## VLANs

| VLAN | Name           | Purpose                                 |
| ---- | -------------- | --------------------------------------- |
| 00   | Trusted        | Untagged traffic through VPN VLAN       |
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