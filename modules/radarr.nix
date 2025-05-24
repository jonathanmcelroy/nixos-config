{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.solar-system.radarr;
in {
  options = {
    solar-system.radarr = {
      enable = mkEnableOption "Enable Radarr Movie Manager";
    };
  };

  config = mkIf cfg.enable {
    services.radarr = {
      enable = true;
      openFirewall = true;
      user = "media";
      group = "media";
    };
  };
}
