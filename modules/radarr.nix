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
      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/radarr/.config/Radarr";
        description = "Directory for Radarr's data storage.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.radarr = {
      enable = true;
      openFirewall = true;
      dataDir = cfg.dataDir;
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 radarr radarr"
    ];
  };
}