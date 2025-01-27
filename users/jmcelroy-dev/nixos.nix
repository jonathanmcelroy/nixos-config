{ inputs, config, pkgs, pubKeys, ... }:

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
  users.users.jmcelroy-dev = {
    isNormalUser = true;
    description = "Jonathan's Dev User";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = pubKeys;
  };

}