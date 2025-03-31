# Setup adguard on a server
{
  config,
  lib,
  catalog,
  ...
}:
with lib;
let
  cfg = config.solar-system.jellyfin;
in
{
  options = {
    solar-system.jellyfin = {
      enable = mkEnableOption "Enable Jellyfin Media Server";
    };
  };

  config = mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    systemd.tmpfiles.rules = [
      "d /var/jellyfin/music 0755 jellyfin jellyfin"
    ];
  };
}
