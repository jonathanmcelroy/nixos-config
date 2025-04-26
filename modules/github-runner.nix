# The service for all github runner related stuff
{
  config,
  lib,
  catalog,
  pkgs,
  ...
}:
with lib; let
  cfg = config.solar-system.github-runner;
in {
  options = {
    solar-system.github-runner = {
      enable = mkEnableOption "Enable Github Runner";
    };
  };

  config = mkIf cfg.enable {
    users.users.github-runner = {
      isSystemUser = true;
      description = "Github runner";
      group = "github-runner";
    };
    users.groups.github-runner = {};

    services.github-runners.nixos-runner = {
      enable = true;
      url = "https://github.com/jonathanmcelroy/nixos-config";
      user = "github-runner";
      group = "github-runner";
      tokenFile = config.sops.secrets.github-runner-token.path;
      extraPackages = with pkgs; [
        nixos-rebuild
        openssh
      ];
      extraLabels = ["nixos"];
    };
  };
}
