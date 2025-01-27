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
    jmc-nixos-rebuild = "sudo nixos-rebuild switch --flake '/usr/local/src/nixos-configuration#default' --show-trace --print-build-logs --verbose";
    jmc-nixos-deploy-remote = "nixos-rebuild switch --flake '/usr/local/src/nixos-configuration#remote' --target-host nixos-deploy@jmcelroy-remote --use-remote-sudo --show-trace --print-build-logs --verbose";
    jmc-nixos-test = "sudo nixos-rebuild test --flake '/usr/local/src/nixos-configuration#default' --show-trace --print-build-logs --verbose";
    jmc-nixos-edit = "code /usr/local/src/nixos-configuration";

    # k = "kubectl";
  };

  programs = {
    bash = {
      enable = true;
      shellOptions = [
        "histappend"
        "checkwinsize"
        "extglob"
        "globstar"
        "checkjobs"
      ];
      bashrcExtra = "set -o vi";
    };
    zsh.enable = true;
    fish.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}