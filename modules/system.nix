{ inputs, config, pkgs, username, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" ];
  };
  nix.settings.trusted-users = [username];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

}