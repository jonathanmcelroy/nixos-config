# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  catalog,
  ...
}:
with lib; {
  imports = [
    ../common.nix

    ../users/jmcelroy
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  solar-system = {
    networking = {
      enable = true;
      automatic = false;
    };
    gnome.enable = true;
    sound.enable = true;
  };

  networking = {
    useDHCP = false;
    useNetworkd = false;

    networkmanager = {
      enable = true;

      ensureProfiles.profiles = {
        "direct-profile" = {
          connection = {
            type = "ethernet";
            id = "direct";
            autoconnect = true;
          };
          vlan = {
            parent = "enp30s0";
            id = 1;
          };
          ipv4 = {
            method = "manual";
            address1 = "192.168.10.10/24,192.168.10.1";
            dns = "192.168.10.1";
          };
          ipv6 = {
            method = "disabled";
          };
        };
        "vpn-profile" = {
          connection = {
            # type = "ethernet";
            id = "vpn";
            type = "vlan";
            autoconnect = false;
          };
          vlan = {
            parent = "enp30s0";
            id = 11;
          };
          ipv4 = {
            method = "manual";
            address1 = "192.168.11.10/24,192.168.11.1";
            dns = "192.168.11.1";
          };
          ipv6 = {
            method = "disabled";
          };
        };
        # "protonvpn" = {
        #   connection = {
        #     id = "protonvpn-automatic";
        #     type = "wireguard";
        #     autoconnect = false;
        #     interface-name="protonvpn";
        #   };
        #   wireguard = {
        #     # SECURITY: The private key is stored in cleartext.
        #     # private-key = builtins.readFile config.sops.secrets.proton_vpn_usco50_private_key.path;
        #     private-key-flags = "1";
        #   };
        #   wireguard-peer = {
        #     endpoint = "212.102.44.166:51820";

        #   };
        #   ipv4 = {
        #     address1 = "10.2.0.2/32,10.2.0.1";
        #     method = "manual";
        #   };
        #   ipv6 = {
        #     method = "disabled";
        #   };
        # };
      };
    };
  };

  programs.ssh.knownHosts = {
    mars = {
      publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDwbpBj+lFY1TsvON0+UGireqnVQyfBr9+9+cxGVkGdvyYq0kLaC5zgf708H5UziwMEbrtxgPCLztyllui8QN23Sy7Xu6Pd9pVVHaZkppUHrrGho+5VQlYPou0INbDyXxmt9Ijv/GqIjoAqaTZOL37XOpdrs6mV0DfRFi3dWIyUVwWhGjEySjG8/BdNW0xfy9bHpx5wQAInc6mz8JQsY64lVZj4aBjHM9dRvF2IYULKQKtK/Vhg8cYs74SYsY/2FaiJ9ggHJe4o6IFx7oMIm00S/uobl7kr8RSJtH0ZL+QKGy2fmfzAV7u2wf9Lub+jC+cGbQsusO9zQzniKpqevlSlhF9qFZIkYqA7ZJX08pTAICkW3Z4uAF+Xan0H9TyQCLAUXl/L5GyWq8RIxAnh89Ll11wnjfZkqZ2k1yn7mDw2cP2EbN9u1ilcuKUqHAvPVAiU9kJmewHkbI+wG8msyS5tTbb7OtOwnUH2k4iGpf9BsirA/Ysro5Vn9jP05AFO/d8vcojcSmnxWeLJmYI077TgjNIeiAYK9sJlb9Hj3qBlrYdgEc3EuShGWWu3X9hdkS01BgawAzSHw4rUzPLT8vpJjN38lqArRuboVFPSuZvKFn/jIMtfIAdWIf44NDWzCoUw8sd4ifxJdnAIglE5vFbTBNLT1/8f0WXOXYmHygFblw== root@nixos";
    };
    earth = {
      publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDuPHgVpUdndTHI2nvc9Bqc8M/7I6qwhasKsAENCBHpiXDWggIy7CIYNCVUqFiHBaL0IrjBTfe/ZciiygIofb9aLHmWgReWj4OOPp3TwvvdJTCVlHz1Hz/RzovQWNFr+L6XrSqhWY7h4yuYim29qv4/++7vEztS+5lXdQwSK7eTm0jXxWvcV5q8uXomjpJapZIsxR7GmS9S7bnukDpxfjoK/mnC6vUdh8qfF9/CubijbUT1n22Z9tWr0EPzoByq3ZV1vL5gwGX1zbpmuSgnS/HstRU1dwLl7mzJ8LAqwJCom0UmmjHF7DBnp3h3r1YBddUpC3y0xE0mnKqri+TzDFadEDk0Cc1req1oaFPN3HckeDKVtfxL2HrLzGaChzX8KhIa2fjTY5N3Ve3QoSMBAE1saIIzJW1ZYk3gHJ/vfGmiOD8J6pvVIJMvLAdnNzQkqtL4P3CLOO1FiKvpJikc5HWzycgdWOu/lFuXu6vOORuiCP95apb+MtT53v4AUyO/MHwOO8FqHXqAgr1EA9l2X5jNfI7Xk1nALYMtuVLW9IIRoM8zdhc/j5B68fBP0n82PnZTgZpOXydOxEjtPRz7YAgqS8G0w4PN0i4gfJvwEovEZ5iK62OBE1oi0qyFC1tfVSr6qXK8CAQhzsSXpY5eNcNJ66Bg5hQll6uND+J3nAmCqQ== root@jmcelroy-home";
    };
  };

  # Enable CUPS for printing
  services.printing.enable = true;

  # Only allow nixos-deploy to remote in
  services.openssh.settings.AllowUsers = ["nixos-deploy"];

  # Install Steam
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
