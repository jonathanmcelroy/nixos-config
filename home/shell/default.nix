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
    BROWSER = "firefox";

    # Setting programs.neovim.defaultEditor = true overrides this
    # EDITOR = "vim";
  };

  home.shellAliases = {
    jmc-nixos-rebuild = "sudo nixos-rebuild switch --flake '${config.home.homeDirectory}/nixos#default' --show-trace --print-build-logs --verbose";
    jmc-nixos-test = "sudo nixos-rebuild test --flake '${config.home.homeDirectory}/nixos#default' --show-trace --print-build-logs --verbose";

    # k = "kubectl";
  };
}