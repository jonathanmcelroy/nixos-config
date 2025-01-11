{ inputs, config, pkgs, pubKeys, ... }:

{
  ##################################################################################################################
  #
  # NixOS Configuration
  #
  ##################################################################################################################

  # Define the user for deploying nixos configuration
  users.users.nixos-deploy = {
    isNormalUser = true;
    description = "Nixos Deploy User";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = pubKeys;
  };

}