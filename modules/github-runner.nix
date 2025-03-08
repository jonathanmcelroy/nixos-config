# The service for all github runner related stuff
{
  config,
  lib,
  catalog,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.solar-system.github-runner;
in
{
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
    users.groups.github-runner = { };

    services.github-runners.runner1 = {
      enable = true;
      url = "https://github.com/jonathanmcelroy/nixos-config";
      user = "github-runner";
      group = "github-runner";
      tokenFile = "/etc/github-runner/token";
      extraPackages = with pkgs; [
        nixos-rebuild
        openssh
      ];
      extraLabels = [ "nixos" ];
    };
  };
}
