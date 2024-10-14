{ inputs, config, pkgs, ... }:

{
  ##################################################################################################################
  #
  # NixOS Configuration
  #
  ##################################################################################################################

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  # Install Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}