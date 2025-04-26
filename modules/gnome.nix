{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.solar-system.gnome;
in {
  options = {
    solar-system.gnome = {
      enable = mkEnableOption "Enable GNOME Desktop Environment";
    };
  };

  config = mkIf cfg.enable {
    # Gnome options
    services.xserver = {
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
