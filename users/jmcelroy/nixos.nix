{ inputs, ... }:

{
  ##################################################################################################################
  #
  # NixOS Configuration
  #
  ##################################################################################################################

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jmcelroy = {
    isNormalUser = true;
    description = "Jonathan's Home User";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  home-manager.users.jmcelroy = import ./home.nix;

  # Install Steam
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
