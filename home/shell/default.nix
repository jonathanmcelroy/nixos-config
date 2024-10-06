{config, ...}: let
  d = config.xdg.dataHome;
  c = config.xdg.configHome;
  cache = config.xdg.cacheHome;
in {
  imports = [
  #   ./nushell
  #   ./common.nix
  #   ./starship.nix
    ./terminals.nix
  ];

  # add environment variables
  home.sessionVariables = {
    # set default applications
    EDITOR = "vim";
    BROWSER = "firefox";
  };

  # home.shellAliases = {
  #   k = "kubectl";
  # };
}