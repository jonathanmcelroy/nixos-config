# This file defines the configuration to easily access all the servers in the network
{ pkgs, ... }: {
    networking.extraHosts = 
        ''
            192.168.0.100 jmcelroy-home
            192.168.0.101 jmcelroy-remote
            192.168.0.102 jmcelroy-remote-wifi
        '';
}