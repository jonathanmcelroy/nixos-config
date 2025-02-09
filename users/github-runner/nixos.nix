{ pkgs, ... }: {
  # The user for all github runner related stuff

  users.users.github-runner = {
    isSystemUser = true;
    description = "Github runner";
    group = "github-runner";
  };
  users.groups.github-runner = {};

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

}