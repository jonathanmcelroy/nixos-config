# This file defines the configuration to easily access all the servers in the network
{ pkgs, ... }: {
    networking.extraHosts = 
        ''
            192.168.0.100 jmcelroy-home
            192.168.0.101 jmcelroy-remote
            192.168.0.102 jmcelroy-remote-wifi
        '';

    programs.ssh.knownHosts = {
        jmcelroy-remote = {
            publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDwbpBj+lFY1TsvON0+UGireqnVQyfBr9+9+cxGVkGdvyYq0kLaC5zgf708H5UziwMEbrtxgPCLztyllui8QN23Sy7Xu6Pd9pVVHaZkppUHrrGho+5VQlYPou0INbDyXxmt9Ijv/GqIjoAqaTZOL37XOpdrs6mV0DfRFi3dWIyUVwWhGjEySjG8/BdNW0xfy9bHpx5wQAInc6mz8JQsY64lVZj4aBjHM9dRvF2IYULKQKtK/Vhg8cYs74SYsY/2FaiJ9ggHJe4o6IFx7oMIm00S/uobl7kr8RSJtH0ZL+QKGy2fmfzAV7u2wf9Lub+jC+cGbQsusO9zQzniKpqevlSlhF9qFZIkYqA7ZJX08pTAICkW3Z4uAF+Xan0H9TyQCLAUXl/L5GyWq8RIxAnh89Ll11wnjfZkqZ2k1yn7mDw2cP2EbN9u1ilcuKUqHAvPVAiU9kJmewHkbI+wG8msyS5tTbb7OtOwnUH2k4iGpf9BsirA/Ysro5Vn9jP05AFO/d8vcojcSmnxWeLJmYI077TgjNIeiAYK9sJlb9Hj3qBlrYdgEc3EuShGWWu3X9hdkS01BgawAzSHw4rUzPLT8vpJjN38lqArRuboVFPSuZvKFn/jIMtfIAdWIf44NDWzCoUw8sd4ifxJdnAIglE5vFbTBNLT1/8f0WXOXYmHygFblw== root@nixos";
        };
    };
}