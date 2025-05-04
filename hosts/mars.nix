# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  catalog,
  authorized_keys,
  ...
}: {
  imports = [../common.nix];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  solar-system = {
    networking = {
      enable = true;
      interface = "enp1s0";
    };

    github-runner.enable = true;
  };

  services.openssh = {
    enable = true;
    extraConfig = ''
      Match Group media
        ChrootDirectory /var/media
        ForceCommand internal-sftp
        AllowTcpForwarding no
        X11Forwarding no
    '';
  };

  users.users.media = {
    isNormalUser = true;
    description = "Media user";
    shell = "/sbin/nologin";
    extraGroups = ["media"];
    openssh.authorizedKeys.keys = authorized_keys;
  };
  users.groups.media = {};

  systemd.tmpfiles.rules = [
    "d /var/media 0755 root root "
  ];

}
