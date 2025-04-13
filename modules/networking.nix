# This file defines the configuration to easily access all the servers in the network
{
  config,
  lib,
  pkgs,
  catalog,
  ...
}:
with lib;
let
  gateway = "192.168.1.1";
  interface_to_config = i: {
    matchConfig.Name = i;
    # address = map (a: "${a}/24") addresses;
    address = [ "${address}/24" ];
    routes = [
      { Gateway = gateway; }
    ];
    dns = [
      catalog.services.adguard.host.ip
    ];
  };

  cfg = config.solar-system.networking;
  interface = cfg.interface;

  hostname = config.networking.hostName;
  address = catalog.nodes.${hostname}.ip;
in
{
  options = {
    solar-system.networking = {
      enable = mkEnableOption "Configure simple networking for this system";
      # interfaces = mkOption {
      #   type = types.listOf types.str;
      #   description = "A list of interfaces to connect the IP addresses to. The interfaces must be the same length as the IP addresses.";
      #   default = [];
      # };
      interface = mkOption {
        type = types.str;
        description = "The interface to connect the IP addresses to";
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = hasAttr hostname catalog.nodes;
        message = ''
          The hostname ${hostname} is not in the catalog: ${attrNames catalog.nodes}.
        '';
      }
      # {
      #   assertion = length addresses == length interfaces;
      #   message = ''
      #     The number of interfaces for ${hostname} (${toString interfaces}) must be the same as the number of IP addresses (${toString addresses}).
      #   '';
      # }
    ];

    # Configure the networking to use systemd-networkd
    networking = {
      networkmanager.enable = false;
      useDHCP = false;
      useNetworkd = true;
    };
    systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
    systemd.network = {
      enable = true;
      # networks = listToAttrs (map (i: {
      #     name = "10-" + i;
      #     value = interface_to_config i;
      #   }) interfaces);
      networks."10-${interface}" = interface_to_config interface;
    };

    # Add all the hosts to the hosts file
    # networking.extraHosts = concatStringsSep "\n" (mapAttrsToList (name: value: "${head value} ${name}") all_addresses);
    networking.extraHosts = concatStringsSep "\n" (
      mapAttrsToList (name: value: "${value.ip} ${name}") catalog.nodes
    );

    programs.ssh.knownHosts = {
      mars = {
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDwbpBj+lFY1TsvON0+UGireqnVQyfBr9+9+cxGVkGdvyYq0kLaC5zgf708H5UziwMEbrtxgPCLztyllui8QN23Sy7Xu6Pd9pVVHaZkppUHrrGho+5VQlYPou0INbDyXxmt9Ijv/GqIjoAqaTZOL37XOpdrs6mV0DfRFi3dWIyUVwWhGjEySjG8/BdNW0xfy9bHpx5wQAInc6mz8JQsY64lVZj4aBjHM9dRvF2IYULKQKtK/Vhg8cYs74SYsY/2FaiJ9ggHJe4o6IFx7oMIm00S/uobl7kr8RSJtH0ZL+QKGy2fmfzAV7u2wf9Lub+jC+cGbQsusO9zQzniKpqevlSlhF9qFZIkYqA7ZJX08pTAICkW3Z4uAF+Xan0H9TyQCLAUXl/L5GyWq8RIxAnh89Ll11wnjfZkqZ2k1yn7mDw2cP2EbN9u1ilcuKUqHAvPVAiU9kJmewHkbI+wG8msyS5tTbb7OtOwnUH2k4iGpf9BsirA/Ysro5Vn9jP05AFO/d8vcojcSmnxWeLJmYI077TgjNIeiAYK9sJlb9Hj3qBlrYdgEc3EuShGWWu3X9hdkS01BgawAzSHw4rUzPLT8vpJjN38lqArRuboVFPSuZvKFn/jIMtfIAdWIf44NDWzCoUw8sd4ifxJdnAIglE5vFbTBNLT1/8f0WXOXYmHygFblw== root@nixos";
      };
      earth = {
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDuPHgVpUdndTHI2nvc9Bqc8M/7I6qwhasKsAENCBHpiXDWggIy7CIYNCVUqFiHBaL0IrjBTfe/ZciiygIofb9aLHmWgReWj4OOPp3TwvvdJTCVlHz1Hz/RzovQWNFr+L6XrSqhWY7h4yuYim29qv4/++7vEztS+5lXdQwSK7eTm0jXxWvcV5q8uXomjpJapZIsxR7GmS9S7bnukDpxfjoK/mnC6vUdh8qfF9/CubijbUT1n22Z9tWr0EPzoByq3ZV1vL5gwGX1zbpmuSgnS/HstRU1dwLl7mzJ8LAqwJCom0UmmjHF7DBnp3h3r1YBddUpC3y0xE0mnKqri+TzDFadEDk0Cc1req1oaFPN3HckeDKVtfxL2HrLzGaChzX8KhIa2fjTY5N3Ve3QoSMBAE1saIIzJW1ZYk3gHJ/vfGmiOD8J6pvVIJMvLAdnNzQkqtL4P3CLOO1FiKvpJikc5HWzycgdWOu/lFuXu6vOORuiCP95apb+MtT53v4AUyO/MHwOO8FqHXqAgr1EA9l2X5jNfI7Xk1nALYMtuVLW9IIRoM8zdhc/j5B68fBP0n82PnZTgZpOXydOxEjtPRz7YAgqS8G0w4PN0i4gfJvwEovEZ5iK62OBE1oi0qyFC1tfVSr6qXK8CAQhzsSXpY5eNcNJ66Bg5hQll6uND+J3nAmCqQ== root@jmcelroy-home";
      };
    };
  };
}
