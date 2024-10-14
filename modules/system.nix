{ inputs, config, pkgs, username, ... }: {

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" ];
  };
  nix.settings.trusted-users = [username];

  environment.systemPackages = with pkgs; [
    wget
    gnumake
    unzipNLS
    libgcc

    # General Dev
    vim

    # Rust
    rustc
    cargo
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

}